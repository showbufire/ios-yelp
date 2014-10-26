//
//  BusinessCell.m
//  yelp
//
//  Created by Xiao Jiang on 10/21/14.
//  Copyright (c) 2014 Xiao Jiang. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+AFNetworking.h"

@interface BusinessCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starRatingView;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (strong, nonatomic) NSDictionary *business;

@end

@implementation BusinessCell

- (void)awakeFromNib {
    // Initialization code
}

- (void) updateViewAttributes {
    self.nameLabel.text = self.business[@"name"];
    [self.photoView setImageWithURL:[NSURL URLWithString:self.business[@"image_url"]]];
    [self.starRatingView setImageWithURL:[NSURL URLWithString:self.business[@"rating_img_url"]]];
    self.reviewCountLabel.text = [NSString stringWithFormat:@"%@ Reviews", self.business[@"review_count"]];
    self.addrLabel.text = [self.business valueForKeyPath:@"location.display_address"][0];
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", [self.business[@"distance"] floatValue]];
    
    [self updateCategoryLabel];
}

- (void) updateCategoryLabel {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSArray *cat in self.business[@"categories"]) {
        [arr addObject:cat[0]];
    }
    self.categoryLabel.text = [arr componentsJoinedByString:@", "];
}

- (void) updateBusiness:(NSDictionary *)business {
    self.business = business;
    [self updateViewAttributes];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
