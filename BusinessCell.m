//
//  BusinessCell.m
//  yelp
//
//  Created by Xiao Jiang on 10/21/14.
//  Copyright (c) 2014 Xiao Jiang. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+AFNetworking.h"
#import "common.h"

@interface BusinessCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starRatingView;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (strong, nonatomic) Business *business;

@end

@implementation BusinessCell

- (void)awakeFromNib {
    // Initialization code
//    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updateBusiness:(Business *)business {
    self.business = business;
    self.nameLabel.text = business.name;
    [self.photoView setImageWithURL:[NSURL URLWithString:business.imageURL]];
    [self.starRatingView setImageWithURL:[NSURL URLWithString:business.ratingURL]];
    self.reviewCountLabel.text = [NSString stringWithFormat:@"%@ Reviews", [NSNumber numberWithInteger:business.reviewCount]];
    self.addrLabel.text = self.business.addr;
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", business.distance / METERS_PER_MILE];
    
    [self updateCategoryLabel];
}


- (void) updateCategoryLabel {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSString *cat in self.business.categories) {
        [arr addObject:cat];
    }
    self.categoryLabel.text = [arr componentsJoinedByString:@", "];
}


@end
