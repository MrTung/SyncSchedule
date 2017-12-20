//
//  MTCommonCell.h
//
//  Created by 董徐维 on 17-3-18.
//  Copyright © 2017年 Mr.Tung. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTCommonItem;

@interface MTCommonCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows;

/** cell对应的item数据 */
@property (nonatomic, strong) MTCommonItem *item;

/**
 *  右边按钮
 */
@property (strong, nonatomic) UIButton *rightBtn;

/**
 *  输入框
 */
@property (strong, nonatomic) UITextField *rightText;
/**
 *  箭头
 */
@property (strong, nonatomic) UIImageView *rightArrow;
/**
 *  开关
 */
@property (strong, nonatomic) UISwitch *rightSwitch;
/**
 *  标签
 */
@property (strong, nonatomic) UILabel *rightLabel;
/**
 *  复选框
 */
@property (strong, nonatomic) UIButton *checkBtn;


@end
