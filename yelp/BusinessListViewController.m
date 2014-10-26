//
//  BusinessListViewController.m
//  yelp
//
//  Created by Xiao Jiang on 10/21/14.
//  Copyright (c) 2014 Xiao Jiang. All rights reserved.
//

#import "BusinessListViewController.h"
#import "BusinessCell.h"
#import "YelpClient.h"

NSString * const kYelpConsumerKey = @"OZ4PEz83dNdt3gfER3K8Ww";
NSString * const kYelpConsumerSecret = @"DayH1uFEXU08sUtltMRDBLq08ko";
NSString * const kYelpToken = @"6qJDUrDMKcU_CfyAyqrEWHaRvT6QkpPU";
NSString * const kYelpTokenSecret = @"oTa8o5dbjk5jS4CK08Ptz6flbpE"; 


@interface BusinessListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *businesses;

@end

@implementation BusinessListViewController

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

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
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
                              
    self.navigationItem.leftBarButtonItem = filterButton;
    self.navigationItem.titleView = searchBar;
    
    self.navigationController.navigationBar.barTintColor = (UIColorFromRGB(0xc41200));
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    

//    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
