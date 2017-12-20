//
//  sharedAppUtil.m
//  GPSNavDemo
//
//  Created by 董徐维 on 15/3/11.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "SharedAppUtil.h"

@implementation SharedAppUtil

+(SharedAppUtil *)defaultCommonUtil
{
    static SharedAppUtil *util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[SharedAppUtil alloc]init];
    });
    return util;
}


@end
