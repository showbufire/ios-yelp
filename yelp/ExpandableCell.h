//
//  ExpandableCell.h
//  yelp
//
//  Created by Xiao Jiang on 10/26/14.
//  Copyright (c) 2014 Xiao Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExpandableCell;

@protocol ExpandabaleCellDelegate <NSObject>

- (void)extandableCell:(ExpandableCell *)cell sectionExpanded:(NSInteger)section;

@end

@interface ExpandableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) NSInteger section;
@property (weak, nonatomic) id<ExpandabaleCellDelegate> delegate;

@end
