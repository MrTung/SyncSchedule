//
//  SubscribViewController.m
//  SyncSchedule
//
//  Created by greatstar on 2017/3/28.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import "SubscribViewController.h"

#import "FollowerViewController.h"
#import "MsgViewController.h"
#import "SettingViewController.h"
#import "ScheduleModel.h"

#import "ScheduleModel.h"
#import "EventManger.h"

@interface SubscribViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    NSArray *dataProvider;
    
}

@end

@implementation SubscribViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.navigationController.navigationBar.translucent = NO;
    
    [self setupLeftMenuButton];
    
    [self initTableView];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getUserDataProvider];
}

-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.tableFooterView = [UIView new];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = MTGlobalBg;
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getUserDataProvider)];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataProvider.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    UserModel *model  = dataProvider[indexPath.row];
    cell.textLabel.text = model.userName;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *eventsArray;
    switch (indexPath.row) {
        case 0:
            eventsArray = [[EventManger shareInstance] getTodayEvent];
            break;
        case 1:
            eventsArray = [[EventManger shareInstance] getThisWeekEventFromSunday];
            break;
        case 2:
            eventsArray = [[EventManger shareInstance] getThisWeekEventFromMonday];
            break;
        case 3:
            eventsArray = [[EventManger shareInstance] getThisMonthFromFirstDay];
            break;
        default:
            eventsArray = [[EventManger shareInstance] getThisMonthFromFifteenDaysAgo];
            break;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserModel *model  = dataProvider[indexPath.row];
    
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"取消订阅" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定取消订阅" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self cancelAttentionWithUserId:model.userId];
        }]];
        
        
        [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];
        
    }];
    editRowAction.backgroundColor = [UIColor redColor];
    
    return @[editRowAction];
    
    
}

#pragma mark 网络访问

-(void)getUserDataProvider
{
    [CommonRemoteHelper RemoteWithUrl:URL_GetAttentionList
                           parameters: @{@"userId" : [SharedAppUtil defaultCommonUtil].usermodel.userId,
                                         @"type" :  @2,
                                         @"accessToken" : [SharedAppUtil defaultCommonUtil].usermodel.accessToken}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     
                                     if ([[dict valueForKey:@"code"] integerValue] != 200) {
                                         return [NoticeHelper AlertShow:[dict valueForKey:@"attentionList"]];
                                     }
                                     
                                     dataProvider = [UserModel mj_objectArrayWithKeyValuesArray:[dict valueForKey:@"attentionList"]];
                                     
                                     [_tableView.mj_header endRefreshing];
                                     [_tableView reloadData];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     
                                 }];
}

/**
 取消订阅
 */
-(void)cancelAttentionWithUserId:(NSString *)userId
{
    [CommonRemoteHelper RemoteWithUrl:URL_CancelAttention
                           parameters: @{@"userId" : [SharedAppUtil defaultCommonUtil].usermodel.userId,
                                         @"attentionUserId" : userId,
                                         @"accessToken" : [SharedAppUtil defaultCommonUtil].usermodel.accessToken}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     
                                     if ([[dict valueForKey:@"code"] integerValue] != 200) {
                                         return [NoticeHelper AlertShow:[dict valueForKey:@"attentionList"]];
                                     }
                                     
                                     [NoticeHelper AlertShow:@"操作成功"];
                                     
                                     [self getUserDataProvider];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     
                                 }];
    
}


#pragma mark - BarButtonItem

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
