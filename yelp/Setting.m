//
//  Setting.m
//  yelp
//
//  Created by Xiao Jiang on 9/4/15.
//  Copyright (c) 2015 Xiao Jiang. All rights reserved.
//

#import "Setting.h"
#import "common.h"

@implementation Setting

- (NSDictionary *)toFilter {
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    filters[@"deals_filter"] = [NSNumber numberWithBool:self.offerDeal];
    filters[@"sort"] = [NSNumber numberWithInteger:self.sortBy];
    if (self.distance > 0) {
        filters[@"radius_filter"] = [NSNumber numberWithDouble:[self distanceInMeters:self.distance]];
    }
    if ([self.categories count] > 0) {
        filters[@"category_filters"] = [self.categories componentsJoinedByString:@", "];
    }
    return filters;
}

- (double)distanceInMeters:(NSInteger)idx {
    double ret = 0;
    switch (idx) {
        case 1:
            ret = 0.3 * METERS_PER_MILE;
            break;
        case 2:
            ret = METERS_PER_MILE;
            break;
        case 3:
            ret = 5 * METERS_PER_MILE;
            break;
        case 4:
            ret = 20 * METERS_PER_MILE;
            break;
    }
    return ret;
}

@end
