//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"

@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (void)search:(NSString *)term parameters:(NSDictionary *)parameters onComplete:(void (^)(NSArray *, NSError *))onComplete {
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSString *safeTerm = @"";
    if (term != nil) {
        safeTerm = term;
    }
    NSDictionary *defaultParameters = @{@"term": safeTerm, @"ll" : @"37.774866,-122.394556", @"limit": [NSNumber numberWithInt:10]};
    NSMutableDictionary *allParameters = [defaultParameters mutableCopy];
    if (parameters) {
        [allParameters addEntriesFromDictionary:parameters];
    }
    [self GET:@"search" parameters:allParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *businessDictionaries = [responseObject objectForKey:@"businesses"];
        NSMutableArray *businesses = [[NSMutableArray alloc] init];
        for (NSDictionary *businessDict in businessDictionaries) {
            Business *business = [[Business alloc] initFromDictionary:businessDict];
            [businesses addObject:business];
        }
        onComplete(businesses, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        onComplete(nil, error);
    }];
}

@end
