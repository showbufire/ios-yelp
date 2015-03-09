//
//  Business.m
//  yelp
//
//  Created by Xiao Jiang on 3/9/15.
//  Copyright (c) 2015 Xiao Jiang. All rights reserved.
//

#import "Business.h"

@implementation Business

- (Business *)initFromDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.name = dict[@"name"];
        self.imageURL = dict[@"image_url"];
        self.ratingURL = dict[@"rating_img_url"];
        self.reviewCount = [dict[@"review_count"] integerValue];
        self.addr = [dict valueForKeyPath:@"location.display_address"][0];
        self.distance = [dict[@"distance"] floatValue];
        
        NSMutableArray *categories = [[NSMutableArray alloc] init];
        for (NSArray *cat in dict[@"categories"]) {
            [categories addObject:cat[0]];
        }
    }
    return self;
}

@end
