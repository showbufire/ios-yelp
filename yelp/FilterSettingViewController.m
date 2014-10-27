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
@property (assign, nonatomic) NSInteger sortFilter;

@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *sortOptions;

@property (strong, nonatomic) NSMutableSet *expandedSections;

@end

@implementation FilterSettingViewController

const int MOST_POP_SECTION = 0;
const int DISTANCE_SECTIOn = 1;
const int SORT_SECTION = 2;
const int CATEGORY_SECTION = 3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.sections = @[@"Most Popular", @"Distance", @"Sort by", @"Categories"];
        self.sortOptions = @[@"best match", @"distance", @"highest rated"];
        self.expandedSections = [NSMutableSet set];
        self.sortFilter = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    [self.settingTableView registerNib:[UINib nibWithNibName:@"ExpandableCell" bundle:nil] forCellReuseIdentifier:@"ExpandableCell"];
    [self.settingTableView registerNib:[UINib nibWithNibName:@"CheckboxCell" bundle:nil] forCellReuseIdentifier:@"CheckboxCell"];
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"Filters";
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
    if (section == SORT_SECTION) {
        return [self numberOfRowsInSortSection];
    }
    return 0;
}

- (NSInteger)numberOfRowsInSortSection {
    if ([self.expandedSections containsObject:[NSNumber numberWithInt:SORT_SECTION]]) {
        return [self.sortOptions count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SORT_SECTION) {
        return [self cellForRowAtRowForSortSection:tableView indexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *) cellForRowAtRowForSortSection:(UITableView *)tableView indexPath:(NSIndexPath *) indexPath {
    if ([self.expandedSections containsObject:[NSNumber numberWithInt:SORT_SECTION]]) {
        CheckboxCell* cell = [self.settingTableView dequeueReusableCellWithIdentifier:@"CheckboxCell"];
        cell.titleLabel.text = self.sortOptions[indexPath.row];
        cell.indexPath = indexPath;
        [cell setChecked:(indexPath.row == self.sortFilter)];
        cell.delegate = self;
        return cell;
    }
    ExpandableCell *cell = [self.settingTableView dequeueReusableCellWithIdentifier:@"ExpandableCell"];
    cell.titleLabel.text = self.sortOptions[self.sortFilter];
    cell.section = indexPath.section;
    cell.delegate = self;
    return cell;
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
    return [self.sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[section];
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

- (void)extandableCell:(ExpandableCell *)cell sectionExpanded:(NSInteger)section {
    [self.expandedSections addObject:[NSNumber numberWithInteger:section]];
    [self.settingTableView reloadData];
}

- (void)checkboxCell:(CheckboxCell *)cell cellChecked:(NSIndexPath *)indexPath {
    if (indexPath.section == SORT_SECTION) {
        [self.expandedSections removeObject:[NSNumber numberWithInteger:indexPath.section]];
        self.sortFilter = indexPath.row;
    }
    [self.settingTableView reloadData];
}
@end
