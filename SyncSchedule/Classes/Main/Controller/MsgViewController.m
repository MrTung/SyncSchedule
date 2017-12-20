//
//  MsgViewController.m
//  SyncSchedule
//
//  Created by greatstar on 2017/3/29.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import "MsgViewController.h"

@interface MsgViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}

@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MTGlobalBg;
    
    self.title = @"我的消息";
    
    [self initTableView];
    
}

-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.tableFooterView = [UIView new];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    cell.textLabel.text = @"张三想获取您的日程信息,是否同意？";
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
    UITableViewRowAction *yesRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"同意" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"同意" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }];
    yesRowAction.backgroundColor = [UIColor blueColor];
    
    UITableViewRowAction *refuseRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"拒绝" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"拒绝" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }];
    refuseRowAction.backgroundColor = [UIColor redColor];
    return @[yesRowAction,refuseRowAction];
}


@end
