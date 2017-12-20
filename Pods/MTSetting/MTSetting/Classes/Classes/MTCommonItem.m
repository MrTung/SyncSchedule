//
//  MTCommonItem.m
//
//  Created by 董徐维 on 17-3-18.
//  Copyright © 2017年 Mr.Tung. All rights reserved.
//

#import "MTCommonItem.h"


@implementation MTCommonItem

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon
{
    MTCommonItem *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title
{
    return [self itemWithTitle:title icon:nil];
}

@end
