//
//  FilterSettingViewController.h
//  yelp
//
//  Created by Xiao Jiang on 10/26/14.
//  Copyright (c) 2014 Xiao Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandableCell.h"
#import "CheckboxCell.h"
#import "SwitchCell.h"

@class FilterSettingViewController;

@protocol FilterSettingViewControllerDelegate <NSObject>

- (void)filterSettingViewController:(FilterSettingViewController *) filterSettingViewController didChangeFilters: (NSDictionary *) filters;

@end

@interface FilterSettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ExpandabaleCellDelegate, CheckboxCellDelegate, SwitchCellDelegate>

@property (nonatomic, weak) id<FilterSettingViewControllerDelegate> delegate;

@end
