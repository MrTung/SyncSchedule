//
//  NoticeHelper.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/16.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "NoticeHelper.h"
#import <math.h>

@implementation NoticeHelper

+ (void)alert
{
    //创建提示框窗口
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"System Info" message:@"adasd" preferredStyle:UIAlertControllerStyleAlert];
    //实例化取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //点击取消按钮后控制台打印语句。
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    //实例化确定按钮
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
    }];
    //向弹出框中添加按钮和文本框
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         // 可以在这里对textfield进行定制，例如改变背景色等
         //        textField.text = contact.phoneNumber;
     }];
    //将提示框弹出
    //    [self presentViewController:alertController animated:YES completion:nil];
}

+(void)AlertShow:(NSString *)msg
{
    [[UIApplication sharedApplication].keyWindow makeToast:msg duration:1.3 position:CSToastPositionCenter];
}

+ (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        if ([timeString isEqualToString:@"0"]) {
            timeString = @"刚刚";
        }
        else
            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    return timeString;
}

+ (NSString *)intervalSinceNowByyear: (NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        float f = [timeString floatValue] / 365;
        float value = ceilf(f);
        timeString = [NSString stringWithFormat:@"%.00f",value];
    }
    else
    {
        timeString = @"0";
    }
    return timeString;
}


+(NSString *)getDaySinceday:(NSDate *)aDate days:(float)days
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
    [components setDay:([components day]+ days)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"MM月dd日"];
    return [dateday stringFromDate:beginningOfWeek];
}

// 判断网络类型
+ (NetworkStates)getNetworkStates
{
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    // 保存网络状态
    NetworkStates states = NetworkStatesNone;
    for (id child in subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏码
            int networkType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            switch (networkType) {
                case 0:
                    states = NetworkStatesNone;
                    //无网模式
                    break;
                case 1:
                    states = NetworkStates2G;
                    break;
                case 2:
                    states = NetworkStates3G;
                    break;
                case 3:
                    states = NetworkStates4G;
                    break;
                case 5:
                {
                    states = NetworkStatesWIFI;
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return states;
}


+ (NSString *)kilometre2meter:(float)meter
{
    if (meter < 1000)
        return [NSString stringWithFormat:@"%.02f米",meter];
    else
    {
        float km = meter/1000;
        return [NSString stringWithFormat:@"%.02f千米",km];
    }
}


+(NSString *)getErrorMsgWtihCode:(NSInteger)code
{
    switch (code)
    {
        case 10001:
            return @"用户名密码错误";
            break;
        case 10002:
            return @"登录失败";
            break;
        case 11001:
            return @"用户名不能为空";
            break;
        case 11002:
            return @"密码不能为空";
            break;
        case 11003:
            return @"密码与确认密码不相同";
            break;
        case 11004:
            return @"电子邮件格式不正确";
            break;
        case 11005:
            return @"用户名已存在";
            break;
        case 11006:
            return @"邮箱已存在";
            break;
        case 11007:
            return @"注册失败";
            break;
        case 12001:
            return @"参数错误";
            break;
        case 12002:
            return @"无登出权限";
            break;
        case 13001:
            return @"参数错误";
            break;
        case 14001:
            return @"用户未登录";
            break;
        case 20001:
            return @"未输入设备号";
            break;
        case 20002:
            return @"不存在设备";
            break;
        case 20003:
            return @"设备未有所有人绑定";
            break;
        case 20004:
            return @"参数错误";
            break;
        case 20005:
            return @"插入错误";
            break;
        case 20006:
            return @"数据提交格式错误";
            break;
        case 14002:
            return @"修改错误";
            break;
        case 14003:
            return @"性别参数上传数据不合法";
            break;
        case 15001:
            return @"没有上传文件";
            break;
        case 15002:
            return @"上传文件格式不合法";
            break;
        case 15003:
            return @"上传文件失败";
            break;
        case 15004:
            return @"更新头像失败";
            break;
        case 11008:
            return @"手机号码已被注册";
            break;
        case 11009:
            return @"手机验证码错误";
            break;
        case 11010:
            return @"参数错误";
            break;
        case 16001:
            return @"帐号不存在";
            break;
        case 11011:
            return @"请求次数太频繁";
            break;
        case 11012:
            return @"帐号不存在";
            break;
        default:
            break;
    }
    return @"未知消息";
}

@end
