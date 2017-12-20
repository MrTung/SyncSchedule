//
//  MenuViewController.m
//  SyncSchedule
//
//  Created by greatstar on 2017/3/28.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import "MenuViewController.h"
#import "AccountTableViewCell.h"

#import "FollowerViewController.h"
#import "MsgViewController.h"
#import "SettingViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    
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
        SettingViewController *setting = [[SettingViewController alloc] init];
        setting.hidesBottomBarWhenPushed = YES;
        [[SharedAppUtil defaultCommonUtil].activeNavgation pushViewController:setting animated:YES];
    };
    
    MTCommonArrowItem *advice = [MTCommonArrowItem itemWithTitle:@"我的消息" icon:@"nil"];
    advice.operation = ^{
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        MsgViewController *msg = [[MsgViewController alloc] init];
        msg.hidesBottomBarWhenPushed = YES;
        [[SharedAppUtil defaultCommonUtil].activeNavgation pushViewController:msg animated:YES];
    };
    
    MTCommonArrowItem *updata = [MTCommonArrowItem itemWithTitle:@"订阅我的" icon:@"nil"];
    updata.operation = ^{
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        FollowerViewController *follow = [[FollowerViewController alloc] init];
        follow.hidesBottomBarWhenPushed = YES;
        [[SharedAppUtil defaultCommonUtil].activeNavgation pushViewController:follow animated:YES];
    };
    
    MTCommonItem *temp = [MTCommonItem itemWithTitle:@"" icon:@"nil"];
    
    group.items = @[temp,updata,advice,version];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
        return 80;
    else
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountTableViewCell *cell;
    
    if (cell == nil) {
        cell = [AccountTableViewCell createCellWithTableView:tableView];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0)
        return cell;
    else
    {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}


@end
