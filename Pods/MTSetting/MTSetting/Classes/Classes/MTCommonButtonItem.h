//
//  MTCommonButtonItem.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/24.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "MTCommonItem.h"

@interface MTCommonButtonItem : MTCommonItem

@property (nonatomic, copy) void (^buttonClickBlock)(UIButton *btn);

@property (nonatomic, retain) UIButton *btn;

/** 按钮标题 */
@property (nonatomic, copy) NSString *btnTitle;
@end
