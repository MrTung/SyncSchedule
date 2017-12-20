//
//  FollowerViewController.m
//  SyncSchedule
//
//  Created by greatstar on 2017/3/29.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import "FollowerViewController.h"

@interface FollowerViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    NSArray *dataProvider;

}

@end

@implementation FollowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订阅我的";
    
    [self initTableView];
    
    
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
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getUserDataProvider];
}

#pragma mark 网络访问

-(void)getUserDataProvider
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [CommonRemoteHelper RemoteWithUrl:URL_GetAttentionList
                           parameters: @{@"userId" : [SharedAppUtil defaultCommonUtil].usermodel.userId,
                                         @"type" : @3,
                                         @"accessToken" : [SharedAppUtil defaultCommonUtil].usermodel.accessToken}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     
                                     if ([[dict valueForKey:@"code"] integerValue] != 200) {
                                         return [NoticeHelper AlertShow:[dict valueForKey:@"attentionList"]];
                                     }
                                     
                                     dataProvider = [UserModel mj_objectArrayWithKeyValuesArray:[dict valueForKey:@"attentionList"]];
                                     
                                     if (dataProvider.count == 0)
                                         [NoticeHelper AlertShow:@"暂无数据"];
                                     
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

}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserModel *model  = dataProvider[indexPath.row];

    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"移除订阅" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
      
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定移除订阅" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self cancelAttentionWithUserId:model.userId];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

        [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];

    }];
    editRowAction.backgroundColor = [UIColor redColor];
    return @[editRowAction];
}

/**
 移除订阅
 */
-(void)cancelAttentionWithUserId:(NSString *)userId
{
    [CommonRemoteHelper RemoteWithUrl:URL_CancelAttention
                           parameters: @{@"userId" : userId,
                                         @"attentionUserId" : [SharedAppUtil defaultCommonUtil].usermodel.userId,
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




@end
