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

- (SettingsViewController *)initWithSetting:(Setting *)setting {
    self = [super init];
    if (self) {
        SettingsForm *form = [[SettingsForm alloc] initWithSetting:setting];
        self.formController.form = form;        
    }
    return self;
}

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
    [self.delegate settingsViewController:self didChangeFilters:[self getSetting]];
}

- (Setting *)getSetting {
    Setting *setting = [[Setting alloc] init];
    SettingsForm *settingsForm = self.formController.form;
    setting.sortBy = settingsForm.sortBy;
    setting.offerDeal = settingsForm.offerDeal;
    setting.distance = settingsForm.distance;
    setting.categories = settingsForm.categories;
    return setting;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
