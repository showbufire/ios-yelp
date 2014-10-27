//
//  CheckboxCell.h
//  yelp
//
//  Created by Xiao Jiang on 10/26/14.
//  Copyright (c) 2014 Xiao Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckboxCell;

@protocol CheckboxCellDelegate <NSObject>

-(void)checkboxCell:(CheckboxCell *)cell cellChecked:(NSIndexPath *)indexPath;

@end

@interface CheckboxCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSIndexPath *indexPath;

-(void) setChecked:(BOOL)checked;
@property (nonatomic) BOOL checked;

@property (nonatomic, weak) id<CheckboxCellDelegate> delegate;

@end
