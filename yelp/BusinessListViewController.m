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
#import "UIImageView+AFNetworking.h"

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self makeAPIRequest];
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
    cell.nameLabel.text = business[@"name"];
    [cell.photoView setImageWithURL:[NSURL URLWithString:business[@"image_url"]]];
    cell.distanceLabel.text = @"1.27mi";
    [cell.starRatingView setImageWithURL:[NSURL URLWithString:business[@"rating_img_url"]]];
    cell.reviewCountLabel.text = @"253 reviews";
    cell.addrLabel.text = [business valueForKeyPath:@"location.display_address"][0];
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
