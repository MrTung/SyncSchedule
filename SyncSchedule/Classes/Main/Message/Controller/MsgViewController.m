//
//  MsgViewController.m
//  SyncSchedule
//
//  Created by greatstar on 2017/3/29.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import "MsgViewController.h"
#import "MsgFollowTableViewCell.h"


@interface MsgViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    NSArray *dataProvider;
}

@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的消息";
    
    [self initTableView];
    
    [self getMsgDataProvider];
}

-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = MTGlobalBg;
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
}

#pragma mark 网络访问

-(void)getMsgDataProvider
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [CommonRemoteHelper RemoteWithUrl:URL_GetMsglist
                           parameters: @{@"userId" : [SharedAppUtil defaultCommonUtil].usermodel.userId,
                                         @"accessToken" : [SharedAppUtil defaultCommonUtil].usermodel.accessToken}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     
                                     if ([[dict valueForKey:@"code"] integerValue] != 200) {
                                         return [NoticeHelper AlertShow:[dict valueForKey:@"attentionList"]];
                                     }
                                     
                                     dataProvider = [UserModel mj_objectArrayWithKeyValuesArray:[dict valueForKey:@"attentionList"]];
                                     
                                     [_tableView reloadData];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     
                                 }];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MsgFollowTableViewCell *cell;
    
    if (cell == nil) {
        cell = [MsgFollowTableViewCell createCellWithTableView:tableView];
    }
      cell.ended = indexPath.row%2 == 1;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
