//
//  MTControllerChooseTool.m
//
//
//  Created by 董徐维 on 15/8/14.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//



#import "MTControllerChooseTool.h"
#import "MMDrawerController.h"
#import "MenuViewController.h"
#import "LoginViewController.h"

#import "MainViewController.h"
#import "SubscribViewController.h"

#import "AppDelegate.h"

@interface MTControllerChooseTool ()<UITabBarControllerDelegate>

@end

@implementation MTControllerChooseTool

+(MTControllerChooseTool *)getInstance
{
    static MTControllerChooseTool *util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[MTControllerChooseTool alloc] init];
    });
    return util;
}

+ (void)chooseRootViewController
{
    UserModel *userVO = [ArchiverCacheHelper getLocaldataBykey:User_Archiver_Key filePath:User_Archiver_Path];
    
    [SharedAppUtil defaultCommonUtil].usermodel = userVO;
    
    if (!userVO )
        [MTControllerChooseTool setLoginViewController];
    else
        [MTControllerChooseTool setMainViewController];
}

+ (void)setLoginViewController
{
    AppDelegate *newDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    LoginViewController *login = [[LoginViewController alloc] init];

    newDelegate.window.rootViewController = login;
}

+(void)setMainViewController
{
    
    MainViewController *VC1 = [[MainViewController alloc] init];
    VC1.title = @"未订阅";
    UINavigationController *Nav1 = [[UINavigationController alloc] initWithRootViewController:VC1];
    [SharedAppUtil defaultCommonUtil].activeNavgation = Nav1;

    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRGB:@"999999"];
    [VC1.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = MTColor(103, 203, 115);
    [VC1.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    SubscribViewController *VC2 = [[SubscribViewController alloc] init];
    VC2.title = @"已订阅";
    
    UINavigationController *Nav2 = [[UINavigationController alloc] initWithRootViewController:VC2];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:Nav1, Nav2,nil];
    tabBarController.delegate = [MTControllerChooseTool getInstance];

    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:0];
    tabBar.translucent = NO;
    
    tabBarItem1.title = @"已订阅";
   
    [tabBarItem1 setTitleTextAttributes:selectedTextAttrs forState:UIControlStateNormal];
    [tabBarItem1 setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    tabBarItem1.image = [[UIImage imageNamed:@"second_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"second_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarItem2.title = @"未订阅";
    [tabBarItem2 setTitleTextAttributes:selectedTextAttrs forState:UIControlStateNormal];
    [tabBarItem2 setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];

    tabBarItem2.image = [[UIImage imageNamed:@"second_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.selectedImage = [[UIImage imageNamed:@"second_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UINavigationController *navLeft = [[UINavigationController alloc] initWithRootViewController:[MenuViewController new]];
    
    MMDrawerController *drawerController = [[MMDrawerController alloc]
                                            initWithCenterViewController:tabBarController
                                            leftDrawerViewController:navLeft
                                            rightDrawerViewController:nil];
    [drawerController setShowsShadow:NO];
    [drawerController setRestorationIdentifier:@"MMDrawer"];
    [drawerController setMaximumRightDrawerWidth:200.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    window.rootViewController = drawerController;
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    [SharedAppUtil defaultCommonUtil].activeNavgation = (UINavigationController *)viewController;
    return YES;
}

@end
