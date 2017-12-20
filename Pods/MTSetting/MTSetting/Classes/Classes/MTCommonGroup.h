//
//  MTCommonGroup.h
//
//  Created by 董徐维 on 17-3-18.
//  Copyright © 2017年 Mr.Tung. All rights reserved.
//  用一个MTCommonGroup模型来描述每组的信息：组头、组尾、这组的所有行模型

#import <Foundation/Foundation.h>

@interface MTCommonGroup : NSObject
/** 组头 */
@property (nonatomic, copy) NSString *header;
/** 组尾 */
@property (nonatomic, copy) NSString *footer;
/** 这组的所有行模型(数组中存放的都是MTCommonItem模型) */
@property (nonatomic, strong) NSArray *items;

+ (instancetype)group;
@end
