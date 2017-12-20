//
//  MenuViewController.m
//  SyncSchedule
//
//  Created by greatstar on 2017/3/28.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGroup];
    
    self.title = @"个人中心";
    [self.mm_drawerController setShowsShadow:YES];

}


- (void)setupGroup
{
    // 1.创建组
    MTCommonGroup *group = [MTCommonGroup group];
    [self.groups addObject:group];
    
    // 设置组的所有行数据
    MTCommonArrowItem *version = [MTCommonArrowItem itemWithTitle:@"设置" icon:@"nil"];
    version.operation = ^{
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"clickItem" object:@"3"];
    };
    
    MTCommonArrowItem *advice = [MTCommonArrowItem itemWithTitle:@"我的消息" icon:@"nil"];
    advice.badgeValue = @"2";
    advice.operation = ^{
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"clickItem" object:@"2"];
    };
    
    MTCommonArrowItem *updata = [MTCommonArrowItem itemWithTitle:@"订阅我的" icon:@"nil"];
    updata.operation = ^{
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"clickItem" object:@"1"];
    };
    group.items = @[updata,advice,version];
}





@end
