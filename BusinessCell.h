//
//  BusinessCell.h
//  yelp
//
//  Created by Xiao Jiang on 10/21/14.
//  Copyright (c) 2014 Xiao Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLableView;

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starRatingView;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;


@end
