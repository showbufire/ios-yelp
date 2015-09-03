//
//  SettingsForm.h
//  yelp
//
//  Created by Xiao Jiang on 9/1/15.
//  Copyright (c) 2015 Xiao Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface SettingsForm : NSObject <FXForm>

@property (nonatomic, assign) BOOL offerDeal;
@property (assign, assign) NSInteger distance;
@property (nonatomic, assign) NSInteger sortBy;
@property (nonatomic, strong) NSArray *categories;

@end
