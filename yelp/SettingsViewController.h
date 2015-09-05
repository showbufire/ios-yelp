//
//  SettingsViewController.h
//  yelp
//
//  Created by Xiao Jiang on 9/1/15.
//  Copyright (c) 2015 Xiao Jiang. All rights reserved.
//

#import "FXForms.h"
#import "Setting.h"

@class SettingsViewController;

@protocol SettingsViewControllerDelegate <NSObject>

- (void)settingsViewController:(SettingsViewController *) filterSettingViewController didChangeFilters:(Setting *) setting;

@end

@interface SettingsViewController : FXFormViewController

- (SettingsViewController *) initWithSetting:(Setting *)setting;

@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;

@end
