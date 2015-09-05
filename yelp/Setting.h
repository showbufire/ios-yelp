//
//  Setting.h
//  yelp
//
//  Created by Xiao Jiang on 9/4/15.
//  Copyright (c) 2015 Xiao Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Setting : NSObject

@property (nonatomic, assign) BOOL offerDeal;
@property (assign, assign) NSInteger distance;
@property (nonatomic, assign) NSInteger sortBy;
@property (nonatomic, strong) NSArray *categories;

- (NSDictionary *) toFilter;

@end
