//
//  SettingsViewController.m
//  yelp
//
//  Created by Xiao Jiang on 9/1/15.
//  Copyright (c) 2015 Xiao Jiang. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsForm.h"
#import "common.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"Filters";
    self.navigationController.navigationBar.barTintColor = (UIColorFromRGB(0xc41200));
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
}

- (void) onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onApplyButton {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate settingsViewController:self didChangeFilters:[self getFilters]];
}

- (NSDictionary *)getFilters {
    SettingsForm *settingsForm = self.formController.form;
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    filters[@"deals_filter"] = [NSNumber numberWithBool:settingsForm.offerDeal];
    filters[@"sort"] = [NSNumber numberWithInteger:settingsForm.sortBy];
    if (settingsForm.distance > 0) {
        filters[@"radius_filter"] = [NSNumber numberWithDouble:[self distanceInMeters:settingsForm.distance]];
    }
    if ([settingsForm.categories count] > 0) {
        filters[@"category_filters"] = [settingsForm.categories componentsJoinedByString:@", "];
    }
    return filters;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
