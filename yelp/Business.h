//
//  Business.h
//  yelp
//
//  Created by Xiao Jiang on 3/9/15.
//  Copyright (c) 2015 Xiao Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *ratingURL;
@property NSInteger reviewCount;
@property (strong, nonatomic) NSString *addr;
@property float distance;
@property (strong, nonatomic) NSArray *categories;

- (Business *) initFromDictionary:(NSDictionary *)dict;

@end
