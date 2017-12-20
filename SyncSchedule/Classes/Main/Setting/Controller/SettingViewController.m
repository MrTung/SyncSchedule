//
//  SettingViewController.m
//  SyncSchedule
//
//  Created by greatstar on 2017/3/30.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import "SettingViewController.h"
#import "ScheduleSettingViewController.h"
#import "GuideViewController.h"
#import "RemindViewController.h"

@interface SettingViewController ()<UIActionSheetDelegate>
{
    UIButton *logout;
}


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"系统设置";
    
    [self setupFooter];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupGroup];
}


- (void)setupGroup
{
    MTCommonGroup *group = [MTCommonGroup group];
    [self.groups addObject:group];
    
    MTCommonArrowItem *item0 = [MTCommonArrowItem itemWithTitle:@"同步设置" icon:@"nil"];
    item0.destVcClass = [ScheduleSettingViewController class];
    
    MTCommonArrowItem *item1 = [MTCommonArrowItem itemWithTitle:@"提醒设置" icon:@"nil"];
    item1.destVcClass = [RemindViewController class];
    
    MTCommonArrowItem *item2 = [MTCommonArrowItem itemWithTitle:@"如何使用" icon:@"nil"];
    item2.destVcClass = [GuideViewController class];
    
    group.items = @[item1,item2];
}

- (void)setupFooter
{
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 70)];
    bgview.backgroundColor = [UIColor clearColor];
    
    logout = [[UIButton alloc] init];
    logout.frame = CGRectMake(20, 15, MTScreenW - 40, 45);
    logout.titleLabel.font = [UIFont systemFontOfSize:16];
    [logout setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logout setBackgroundColor:[UIColor orangeColor]];
    logout.layer.cornerRadius = 6.0f;
    [logout addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:logout];
    
    self.tableView.tableFooterView = bgview;
}

#pragma  mark - 退出当前账号
-(void)loginOut
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定退出当前账号？"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [CommonRemoteHelper RemoteWithUrl:URL_Loginout
                               parameters: @{@"userId" : [SharedAppUtil defaultCommonUtil].usermodel.userId,
                                             @"token" : [SharedAppUtil defaultCommonUtil].commonDeviceToke}
                                     type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                         
                                         if ([[dict valueForKey:@"code"] integerValue] != 200) {
                                             return [NoticeHelper AlertShow:@"注销失败,请重试"];
                                         }
                                         [SharedAppUtil defaultCommonUtil].usermodel = nil;
                                         [ArchiverCacheHelper saveObjectToLoacl:[SharedAppUtil defaultCommonUtil].usermodel key:User_Archiver_Key filePath:User_Archiver_Path];
                                         [MTControllerChooseTool setLoginViewController];
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         
                                     }];
        
      
    }
}


@end
