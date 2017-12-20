//
//  AppDelegate.m
//  SyncSchedule
//
//  Created by greatstar on 2017/3/28.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "MTControllerChooseTool.h"


#import <UserNotifications/UserNotifications.h>

#import "MainViewController.h"

#import <PushKit/PushKit.h>

#import "JPUSHService.h"

#import "MsgViewController.h"

@interface AppDelegate ()<JPUSHRegisterDelegate,PKPushRegistryDelegate>
{
    
    UIBackgroundTaskIdentifier _bgTaskId;
    
    NSString *_tokenStr;
}

@property (assign, nonatomic) UIBackgroundTaskIdentifier bgTask;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [MTControllerChooseTool chooseRootViewController];
    
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
    UIUserNotificationType types = (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
    
    UIUserNotificationSettings * notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication]registerUserNotificationSettings:notificationSettings];
    
    //注册用户的apns服务
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"5a3505910df37911a4c7a77d" channel:@"" apsForProduction:YES];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
    }];
    
    return YES;
}

#pragma mark -- JPush相关

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    
    NSString *deviceTokenStr = [[NSString stringWithFormat:@"%@",deviceToken] substringWithRange:NSMakeRange(1,[NSString stringWithFormat:@"%@",deviceToken].length - 2)];
    [SharedAppUtil defaultCommonUtil].commonDeviceToke = deviceTokenStr;
    NSLog(@"------一般推送: %@",deviceTokenStr);
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"--------------deviceToken获取失败--------------------");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler
{
    
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    
}

/**
 *  接收到推送消息
 *
 *  @param application       application description
 *  @param userInfo          userInfo description
 *  @param completionHandler completionHandler description
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog ( @ "Receive remote notification : %@",userInfo );
    NSDictionary *alertStr = [userInfo objectForKey:@"aps"];
    //具体的内容
    NSString *pushStr = [alertStr objectForKey:@"alert"];
    
    //开始的日期
    NSString *date = [userInfo objectForKey:@"data"];
    
    NSTimeInterval ind = [[NSDate dateWithTimeIntervalSince1970:[date integerValue]/1000] timeIntervalSinceReferenceDate];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"calshow:%f",ind]]];

    
    if (application.applicationState == UIApplicationStateActive)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息提示" message:pushStr delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
//        MsgViewController *msgvc = [[MsgViewController alloc] init];
//        [[self topViewController].navigationController pushViewController:msgvc animated:YES];
//        
        //当用户点击通知栏的消息进入app
        [JPUSHService setBadge:0];
        application.applicationIconBadgeNumber = 0;
        
        [JPUSHService handleRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

-(NSString *)getDaySince1970:(NSString *)timeStr dateformat:(NSString *)dateformat
{
    if ([timeStr doubleValue] < 1 )
        return @"";
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    if (dateformat)
        [formatter setDateFormat:dateformat];
    else
        [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:confromTimesp];
}



#pragma mark VOIP PUSH

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type
{
    NSString *str = [NSString stringWithFormat:@"%@",credentials.token];
    _tokenStr = [[[str stringByReplacingOccurrencesOfString:@"<" withString:@""]
                  stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"----voip%@",_tokenStr);
    [SharedAppUtil defaultCommonUtil].silentDeviceToken = _tokenStr;
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

//收到推送后所走的方法，注意PushKit不会自己弹出推送框，如果需要自己写本地推送即可
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type
{
    //在这里就可以做一些操作，比如使用CallKit唤起系统通话界面
    UILocalNotification *backgroudMsg = [[UILocalNotification alloc] init];
    if (backgroudMsg)
    {
        backgroudMsg.timeZone = [NSTimeZone defaultTimeZone];
        backgroudMsg.alertBody = @"VoIP来电";
        backgroudMsg.alertAction = @"查看";
        NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"name" forKey:@"key"];;
        backgroudMsg.userInfo = infoDic;
        //        [[UIApplication sharedApplication] presentLocalNotificationNow:backgroudMsg];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *timestr = [formatter stringFromDate:[NSDate date]];
        [[ScheduleDBHelper shareScheduleDBHelper] debug_save:@"收到VOIP通知" time:timestr];
    }
    
    MainViewController *main = [[MainViewController alloc] init];
    [main synchroSchedule];
}

- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(PKPushType)type
{
    
}


// 获取当前处于activity状态的view controller
- (UIViewController *)topViewController
{
    UIViewController *resultVC;
    
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    
    while (resultVC.presentedViewController)
    {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UINavigationController class]])
    {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    }
    else if ([vc isKindOfClass:[UITabBarController class]])
    {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    }
    else
    {
        return vc;
    }
    return nil;
}


//#pragma mark
//-(void)initRequestMonitorView
//{
//    UIButton *debugbtn = [[UIButton alloc] initWithFrame:CGRectMake(MTScreenW - 40, MTScreenH - 80, 40, 40)];
//    debugbtn.backgroundColor = [UIColor brownColor];
//    [debugbtn setTitle:@"调试Log" forState:UIControlStateNormal];
//    [debugbtn.titleLabel setFont:[UIFont systemFontOfSize:9]];
//    debugbtn.layer.cornerRadius = 20;
//    debugbtn.alpha = 0.8;
//    [debugbtn addTarget:self action:@selector(buttonClickHandler) forControlEvents:UIControlEventTouchUpInside];
//    [[UIApplication sharedApplication].keyWindow addSubview:debugbtn];
//}
//
//-(void)buttonClickHandler
//{
//    NSArray * arr = [[ScheduleDBHelper shareScheduleDBHelper] debug_search];
//    NSLog(@"%@",arr);
//}
@end
