//
//  BusinessListViewController.m
//  yelp
//
//  Created by Xiao Jiang on 10/21/14.
//  Copyright (c) 2014 Xiao Jiang. All rights reserved.
//

#import "BusinessListViewController.h"
#import "common.h"
#import "BusinessCell.h"
#import "YelpClient.h"
#import "SVProgressHUD.h"
#import "SettingsViewController.h"
#import "SettingsForm.h"

NSString * const kYelpConsumerKey = @"OZ4PEz83dNdt3gfER3K8Ww";
NSString * const kYelpConsumerSecret = @"DayH1uFEXU08sUtltMRDBLq08ko";
NSString * const kYelpToken = @"6qJDUrDMKcU_CfyAyqrEWHaRvT6QkpPU";
NSString * const kYelpTokenSecret = @"oTa8o5dbjk5jS4CK08Ptz6flbpE"; 


@interface BusinessListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *businesses;
@property (strong, nonatomic) NSDictionary *filters;

@end

@implementation BusinessListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpTableView];
    [self customizeNavigationBar];
    
    [self makeAPIRequest:nil term:@""];
}

- (void) setUpTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) customizeNavigationBar {
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(goToFilterSettingPage)];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
                              
    self.navigationItem.leftBarButtonItem = filterButton;
    self.navigationItem.titleView = searchBar;
    searchBar.delegate = self;
    
    self.navigationController.navigationBar.barTintColor = (UIColorFromRGB(0xc41200));
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    

//    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *term = searchBar.text;
    [self makeAPIRequest:self.filters term:term];
}

- (void) goToFilterSettingPage {
    SettingsViewController *vc = [[SettingsViewController alloc] init];
    vc.formController.form = [[SettingsForm alloc] init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];

}

- (void) makeAPIRequest:(NSDictionary *) filters term:(NSString *)term {
    [SVProgressHUD show];
    YelpClient *client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    [client search:term parameters:filters onComplete:^(NSArray *businesses, NSError *error) {
        if (error) {
            NSLog(@"error: %@", [error description]);
            [SVProgressHUD dismiss];
        } else {
            self.businesses = businesses;
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.businesses count];
}

- (UITableViewCell *)tableView:(UITableViewCell *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Business *business = self.businesses[indexPath.row];
    BusinessCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    [cell updateBusiness:business];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static BusinessCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    });
    [sizingCell updateBusiness:self.businesses[indexPath.row]];
    return [self calculateCellHeight:sizingCell];
}

- (CGFloat)calculateCellHeight:(BusinessCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Change the selected background view of the cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)settingsViewController:(SettingsViewController *)filterSettingViewController didChangeFilters: (NSDictionary *) filters {
    self.filters = filters;
    [self makeAPIRequest:filters term:@""];
}

@end
