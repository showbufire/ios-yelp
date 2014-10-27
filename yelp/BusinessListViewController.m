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
#import "FilterSettingViewController.h"

NSString * const kYelpConsumerKey = @"OZ4PEz83dNdt3gfER3K8Ww";
NSString * const kYelpConsumerSecret = @"DayH1uFEXU08sUtltMRDBLq08ko";
NSString * const kYelpToken = @"6qJDUrDMKcU_CfyAyqrEWHaRvT6QkpPU";
NSString * const kYelpTokenSecret = @"oTa8o5dbjk5jS4CK08Ptz6flbpE"; 


@interface BusinessListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *businesses;

@end

@implementation BusinessListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpTableView];
    [self customizeNavigationBar];
        
    [self makeAPIRequest];
}

- (void) setUpTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void) customizeNavigationBar {
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(goToFilterSettingPage)];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
                              
    self.navigationItem.leftBarButtonItem = filterButton;
    self.navigationItem.titleView = searchBar;
    
    self.navigationController.navigationBar.barTintColor = (UIColorFromRGB(0xc41200));
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    

//    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}

- (void) goToFilterSettingPage {
    FilterSettingViewController *fsvc = [[FilterSettingViewController alloc] init];
    fsvc.delegate = self; 
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:fsvc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void) makeAPIRequest {
    YelpClient *client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
    [client searchWithTerm:@"" success:^(AFHTTPRequestOperation *operation, id response) {

        self.businesses = [response objectForKey:@"businesses"];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (NSArray *)getBusinessesToShow {
    return self.businesses;
}

- (NSDictionary *)getBusinessToShowAtIndex:(NSInteger) idx {
    return [self getBusinessesToShow][idx];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self getBusinessesToShow] count];
}

- (UITableViewCell *)tableView:(UITableViewCell *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *business = [self getBusinessToShowAtIndex:indexPath.row];
    BusinessCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    [cell updateBusiness:business];
    return cell;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // don't know why, but the view is messed up switching between views
    [self.tableView reloadData];
}

- (void)filterSettingViewController:(FilterSettingViewController *) filterSettingViewController didChangeFilters: (NSDictionary *) filters {
    NSLog(@"%@", filters);
}

@end
