//
//  MainViewController.m
//  SyncSchedule
//
//  Created by greatstar on 2017/3/28.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import "MainViewController.h"

#import "FollowerViewController.h"
#import "MsgViewController.h"


#import "EventManger.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [self setupLeftMenuButton];
    
    [self initTableView];
    
    MTAddObsver(clickhandler, @"clickItem");
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
    cell.textLabel.text = @"张三";
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
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"calshow:"]];
    // 如果要选择特定的某一天的话（默认是当前日期），calshow:后面加时间戳格式，也就是NSTimeInterval
    // 注意这里计算时间戳调用的方法是-NSTimeInterval nowTimestamp = [[NSDate date] timeIntervalSinceReferenceDate];
    // timeIntervalSinceReferenceDate的参考时间是2000年1月1日，[NSDate date]是你希望跳到的日期。
    // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"calshow:"]];
    
    // DetailViewController *detailView = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    // detailView.eventArray = eventsArray;
    // [self presentViewController:detailView animated:YES completion:nil];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"订阅" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"订阅" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }];
    editRowAction.backgroundColor = MTNavgationBackgroundColor;//可以定义RowAction的颜色
    return @[editRowAction];
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

#pragma mark --- notification
- (void)clickhandler:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        if ([object integerValue] == 1) {
            FollowerViewController *follow = [[FollowerViewController alloc] init];
            follow.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:follow animated:YES];
        }
        else if ([object integerValue] == 2){
            MsgViewController *msg = [[MsgViewController alloc] init];
            msg.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:msg animated:YES];
        }
        
    }
}


/** 控制器销毁 */
- (void)dealloc
{
    // 移除监听
    MTRemoveObsver;
}
@end
