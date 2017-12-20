//
//  MTCommonItem.h
//
//  Created by 董徐维 on 17-3-18.
//  Copyright © 2017年 Mr.Tung. All rights reserved.
//  用一个MTCommonItem模型来描述每行的信息：图标、标题、子标题、右边的样式（箭头、文字、数字、开关、打钩）

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MTCommonItem : NSObject

/** subtitle是否显示，显示的话detail就在左边 否则在右边 */
@property (nonatomic, assign) BOOL isSubtitle;
/** 图标 */
@property (nonatomic, copy) NSString *icon;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 子标题 */
@property (nonatomic, copy) NSString *subtitle;
/** 右边显示的数字标记 */
@property (nonatomic, copy) NSString *badgeValue;
/** 点击这行cell，需要调转到哪个控制器 */
@property (nonatomic, assign) Class destVcClass;
/** 封装点击这行cell想做的事情 */
@property (nonatomic, copy) void (^operation)();
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;
+ (instancetype)itemWithTitle:(NSString *)title;

@end
