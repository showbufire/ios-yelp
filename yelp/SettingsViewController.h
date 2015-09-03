//
//  SettingsViewController.h
//  yelp
//
//  Created by Xiao Jiang on 9/1/15.
//  Copyright (c) 2015 Xiao Jiang. All rights reserved.
//

#import "FXForms.h"

@class SettingsViewController;

@protocol SettingsViewControllerDelegate <NSObject>

- (void)settingsViewController:(SettingsViewController *) filterSettingViewController didChangeFilters: (NSDictionary *) filters;

@end

@interface SettingsViewController : FXFormViewController

@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;

@end
