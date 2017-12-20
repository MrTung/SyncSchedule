//
//  NoticeHelper.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/16.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, NetworkStates) {
    NetworkStatesNone, // 没有网络
    NetworkStates2G, // 2G
    NetworkStates3G, // 3G
    NetworkStates4G, // 4G
    NetworkStatesWIFI // WIFI
};
@interface NoticeHelper : NSObject


/**
 *  显示提示信息（默认1.33秒消失）
 *
 *  @param msg  提示信息文字
 *  @param view 在哪个view上显示
 */
+(void)AlertShow:(NSString *)msg;

///**
// * 获取和当前时间的时间差
// */
+ (NSString *)intervalSinceNow: (NSString *) theDate;

+ (NSString *)intervalSinceNowByyear: (NSString *) theDate;


/**
 * 根据日期和间隔天数 获得需要的日期
 */
+(NSString *)getDaySinceday:(NSDate *)aDate days:(float)days;
    

/**
 * 根据code 返回错误类型字符串
 */
+(NSString *)getErrorMsgWtihCode:(NSInteger)code;

/**
 *  千米转换成米
 *
 *  @param meter <#meter description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)kilometre2meter:(float)meter;

+ (NetworkStates)getNetworkStates;

@end
