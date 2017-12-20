//
//  MTCommonCheckItem.h
//  MTCommonSetingTableViewController
//
//  Created by 董徐维 on 2017/3/18.
//  Copyright © 2017年 Mr.Tung. All rights reserved.
//

#import "MTCommonItem.h"

@interface MTCommonCheckItem : MTCommonItem

@property (nonatomic, getter=isChecked) Boolean checked;

/**
 右边的checkview
 */
@property (nonatomic, retain) UIButton *checkView;

@property (nonatomic, copy) void (^checkClickBlock)(UIButton *btn);

@end
