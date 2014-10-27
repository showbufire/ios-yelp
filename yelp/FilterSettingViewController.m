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
@property (assign, nonatomic) NSInteger distanceChoice;
@property (nonatomic) BOOL dealChoice;

@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *sortOptions;
@property (strong, nonatomic) NSArray *distanceOptions;

@property (strong, nonatomic) NSMutableSet *expandedSections;

@end

@implementation FilterSettingViewController

const int MOST_POP_SECTION = 0;
const int DISTANCE_SECTION = 1;
const int SORT_SECTION = 2;
const int CATEGORY_SECTION = 3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.sections = @[@"Most Popular", @"Distance", @"Sort by", @"Categories"];
        self.sortOptions = @[@"best match", @"distance", @"highest rated"];
        self.distanceOptions = @[@"Auto", @"0.3 miles", @"1 mile", @"5 miles", @"20 miles"];
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
    [self.settingTableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil]
        forCellReuseIdentifier:@"SwitchCell"];
    
    self.settingTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
    switch (section) {
        case SORT_SECTION:
            return [self numberOfRowsInSortSection];
            
        case DISTANCE_SECTION:
            return [self numberOfRowsInDistanceSection];
            
        case MOST_POP_SECTION:
            return 1;
            
        default:
            break;
    }

    return 0;
}

- (NSInteger)numberOfRowsInDistanceSection {
    if ([self.expandedSections containsObject:[NSNumber numberWithInt:DISTANCE_SECTION]]) {
        return [self.distanceOptions count];
    }
    return 1;
}

- (NSInteger)numberOfRowsInSortSection {
    if ([self.expandedSections containsObject:[NSNumber numberWithInt:SORT_SECTION]]) {
        return [self.sortOptions count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SORT_SECTION:
            return [self cellForRowForSortSection:tableView indexPath:indexPath];

        case DISTANCE_SECTION:
            return [self cellForRowForDistanceSection:tableView indexPath:indexPath];
            
        case MOST_POP_SECTION:
            return [self cellForRowForMostPopSection:tableView indexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)cellForRowForMostPopSection:(UITableView *)tableView indexPath:(NSIndexPath *) indexPath {
    SwitchCell *cell = [self.settingTableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    cell.titleLabel.text = @"Offering a deal";
    cell.delegate = self;
    [cell setOn:self.dealChoice animated:NO];
    return cell;
}

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    self.dealChoice = value;
}

- (UITableViewCell *)cellForRowForDistanceSection:(UITableView *)tableView indexPath:(NSIndexPath *) indexPath {
    if ([self.expandedSections containsObject:[NSNumber numberWithInt:DISTANCE_SECTION]]) {
        CheckboxCell* cell = [self.settingTableView dequeueReusableCellWithIdentifier:@"CheckboxCell"];
        cell.titleLabel.text = self.distanceOptions[indexPath.row];
        cell.indexPath = indexPath;
        [cell setChecked:(indexPath.row == self.distanceChoice)];
        cell.delegate = self;
        return cell;
    }
    ExpandableCell *cell = [self.settingTableView dequeueReusableCellWithIdentifier:@"ExpandableCell"];
    cell.titleLabel.text = self.distanceOptions[self.distanceChoice];
    cell.section = indexPath.section;
    cell.delegate = self;
    return cell;
}

- (UITableViewCell *) cellForRowForSortSection:(UITableView *)tableView indexPath:(NSIndexPath *) indexPath {
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
    } else if (indexPath.section == DISTANCE_SECTION) {
        [self.expandedSections removeObject:[NSNumber numberWithInteger:indexPath.section]];
        self.distanceChoice = indexPath.row;
    }
    [self.settingTableView reloadData];
}
@end
