//
//  sharedAppUtil.h 系统缓存
//  GPSNavDemo
//
//  Created by 董徐维 on 15/3/11.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//  单例保存app的全局信息

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface SharedAppUtil : NSObject

+(SharedAppUtil *)defaultCommonUtil;

/**用户设置的想要上传的日历type*/
@property (nonatomic, retain) NSString *filterType;

@property (nonatomic, strong) UserModel *usermodel;

@property (nonatomic, strong) UINavigationController *activeNavgation;

@property (nonatomic, retain) NSString *commonDeviceToke;

@property (nonatomic, retain) NSString *silentDeviceToken;


@end

