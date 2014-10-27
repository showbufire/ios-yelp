//
//  ExpandableCell.m
//  yelp
//
//  Created by Xiao Jiang on 10/26/14.
//  Copyright (c) 2014 Xiao Jiang. All rights reserved.
//

#import "ExpandableCell.h"

@interface ExpandableCell ()
- (IBAction)onTouchUpInside:(id)sender;

@end

@implementation ExpandableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onTouchUpInside:(id)sender {
    NSLog(@"section expanded %ld", self.section);
    [self.delegate extandableCell:self sectionExpanded:self.section];
}
@end
