//
//  CheckboxCell.m
//  yelp
//
//  Created by Xiao Jiang on 10/26/14.
//  Copyright (c) 2014 Xiao Jiang. All rights reserved.
//

#import "CheckboxCell.h"

@interface CheckboxCell ()
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;

- (IBAction)onChecked:(id)sender;

@end

@implementation CheckboxCell

- (void)awakeFromNib {
    // Initialization code
}

- (void) setChecked:(BOOL)checked {
    _checked = checked;
    if (_checked) {
      UIImage *btnImage = [UIImage imageNamed:@"checked-checkbox"];
      [self.checkBoxButton setImage:btnImage forState:UIControlStateNormal];
    } else {
      UIImage *btnImage = [UIImage imageNamed:@"unchecked-checkbox"];
      [self.checkBoxButton setImage:btnImage forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onChecked:(id)sender {
    _checked = YES;
    [self.delegate checkboxCell:self cellChecked:self.indexPath];
    [self.checkBoxButton setTitle:@"checked" forState:UIControlStateNormal];
}
@end
