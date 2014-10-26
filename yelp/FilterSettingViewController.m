//
//  FilterSettingViewController.m
//  yelp
//
//  Created by Xiao Jiang on 10/26/14.
//  Copyright (c) 2014 Xiao Jiang. All rights reserved.
//

#import "FilterSettingViewController.h"
#import "common.h"

@interface FilterSettingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;

@property (weak, readonly) NSDictionary *filters;
@property (strong, nonatomic) NSArray *sortOptions;
@property (assign, nonatomic) NSInteger sortFilter;

@end

@implementation FilterSettingViewController

const int SORT_SECTION = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initSortSections];
    }
    return self;
}

- (void)initSortSections {
    self.sortOptions = @[@"best match", @"distance", @"highest rated"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = (UIColorFromRGB(0xc41200));
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SORT_SECTION: return [self.sortOptions count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SORT_SECTION) {
      UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = self.sortOptions[indexPath.row];
      return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SORT_SECTION: [self onSelectSortSectionRow:indexPath.row];
    }
}
                            
- (void)onSelectSortSectionRow:(NSInteger)row {
    self.sortFilter = row;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Sort";
}

- (void) onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onApplyButton {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate filterSettingViewController:self didChangeFilters:self.filters];
}

- (NSDictionary *)filters {
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    
    if (self.sortFilter) {
        [ret setObject:[NSNumber numberWithInteger:self.sortFilter] forKey:@"sortFilter"];
    }
    
    return ret;
}


@end
