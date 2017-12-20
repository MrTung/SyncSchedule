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
#import "SettingViewController.h"
#import "ScheduleModel.h"

#import "ScheduleModel.h"
#import "EventManger.h"

#import "DebugTableViewController.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    // 获取日历app中所有的日程（ScheduleModel数组）
    NSArray *localScheduleArr;
    
    // 下载日程（ScheduleModel数组）
    NSArray *downloadScheduleArr;
    
    // 获取本地订阅的日志
    NSArray *localAttentionEventArr;
    
    NSMutableArray *dataProvider;
    
    NSInteger pageNum;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self setupLeftMenuButton];
    
    [self initTableView];
    
    dataProvider = [[NSMutableArray alloc] init];
    
    //[SharedAppUtil defaultCommonUtil].filterType = [[NSUserDefaults standardUserDefaults] valueForKey:Fiflter_Key];
    
    [SharedAppUtil defaultCommonUtil].filterType = kSharedType;
    
//    [self starmonitor];
}

-(void)synchroSchedule
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timestr = [formatter stringFromDate:[NSDate date]];
    [[ScheduleDBHelper shareScheduleDBHelper] debug_save:@"尝试访问方法" time:timestr];
    
    if (![SharedAppUtil defaultCommonUtil].usermodel)
        return;
    
    [self getLocalSchedules];
    
    [self dowmLoadSchedules];
    
    [self recordSuccess];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    pageNum = 1;
    
    [self getLocalSchedules];
    
    [self getUserDataProvider];
    
    [self dowmLoadSchedules];
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
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [self getUserDataProvider];
        [dataProvider removeAllObjects];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self getUserDataProvider];
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
    
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"订阅" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self addAttentionWithUserId:model.userId];
    }];
    editRowAction.backgroundColor = MTNavgationBackgroundColor;
    
    return @[editRowAction];
}

#pragma mark 网络访问

-(void)recordSuccess
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timestr = [formatter stringFromDate:[NSDate date]];
    [[ScheduleDBHelper shareScheduleDBHelper] debug_save:@"尝试上传激活记录" time:timestr];
    //收到激活信息之后需要调用后台接口确认激活成功
    if ([SharedAppUtil defaultCommonUtil].commonDeviceToke) {
        [CommonRemoteHelper RemoteWithUrl:URL_recordSuccess
                               parameters: @{@"deviceToken" : [SharedAppUtil defaultCommonUtil].commonDeviceToke}
                                     type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"URL_recordSuccess 访问失败");
                                     }];
    }
}

-(void)getUserDataProvider
{
    [CommonRemoteHelper RemoteWithUrl:URL_GetAttentionList
                           parameters: @{@"userId" : [SharedAppUtil defaultCommonUtil].usermodel.userId,
                                         @"type" :@1,
                                         @"pageNum":@(pageNum),
                                         @"accessToken" : [SharedAppUtil defaultCommonUtil].usermodel.accessToken}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     
                                     if ([[dict valueForKey:@"code"] integerValue] != 200)
                                         return [NoticeHelper AlertShow:[dict valueForKey:@"attentionList"]];
                                     
                                     if (pageNum == 1) {
                                         dataProvider = [UserModel mj_objectArrayWithKeyValuesArray:[dict valueForKey:@"attentionList"]];
                                     }
                                     else {
                                         [dataProvider addObjectsFromArray:[UserModel mj_objectArrayWithKeyValuesArray:[dict valueForKey:@"attentionList"]]];
                                     }
                                     
                                     pageNum ++;
                                     
                                     [_tableView.mj_header endRefreshing];
                                     [_tableView.mj_footer endRefreshing];
                                     
                                     [_tableView reloadData];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     [_tableView.mj_header endRefreshing];
                                     [_tableView.mj_footer endRefreshing];
                                 }];
}

/**
 添加订阅
 */
-(void)addAttentionWithUserId:(NSString *)userId
{
    [CommonRemoteHelper RemoteWithUrl:URL_AddAttention
                           parameters: @{@"userId" : [SharedAppUtil defaultCommonUtil].usermodel.userId,
                                         @"attentionUserId" : userId,
                                         @"accessToken" : [SharedAppUtil defaultCommonUtil].usermodel.accessToken}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     
                                     [NoticeHelper AlertShow:@"订阅消息已经发送给对方"];
                                     
                                     if ([[dict valueForKey:@"code"] integerValue] != 200) {
                                         return [NoticeHelper AlertShow:[dict valueForKey:@"attentionList"]];
                                     }
                                     [_tableView reloadData];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     
                                 }];
}

/**
 上传日程
 */
-(void)uploadScheduleWithArray:(NSArray *)array
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timestr = [formatter stringFromDate:[NSDate date]];
    [[ScheduleDBHelper shareScheduleDBHelper] debug_save:@"尝试上传本地日程" time:timestr];
    
    NSDictionary *dict = @{@"userId" : [SharedAppUtil defaultCommonUtil].usermodel.userId,
                           @"accessToken" : [SharedAppUtil defaultCommonUtil].usermodel.accessToken,
                           @"scheduleList": array};
    NSString *str = [self dictionaryToJson:dict];
    [CommonRemoteHelper RemoteWithUrl:URL_Upload
                           parameters: @{@"info" : str}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     if ([[dict valueForKey:@"code"] integerValue] != 200) {
                                         return [NoticeHelper AlertShow:[dict valueForKey:@"attentionList"]];
                                     }
                                     MT_Log(@"%@", [NSString stringWithFormat:@"本地日程信息--%lu条",(unsigned long)localScheduleArr.count]);
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     
                                     [NoticeHelper AlertShow:@"本地日程信息上传失败"];
                                     
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

#pragma mark 获取本地日程数据

/**获取日历app中所有的日程*/
-(void)getLocalSchedules
{
    localScheduleArr = [ScheduleModel scheduleArrWithEvent:[[EventManger shareInstance] getThisMonthFromFifteenDaysAgo]];
    
    //    NSArray *arr = [[ScheduleDBHelper shareScheduleDBHelper] searchScheduleByStartDate:@"2017-05-11 00:00:00"];
    
    if ([localScheduleArr count] == 0)
        MT_Log(@"没有需要上传的日程");
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    
    for (ScheduleModel *model in localScheduleArr) {
        
        //本地DB保存日程
        [[ScheduleDBHelper shareScheduleDBHelper] saveScheduleModel:model];
        
        NSDictionary *dict = @{@"title" : model.title,
                               @"beginTime" : model.beginTime,
                               @"endTime" : model.endTime,
                               @"notes" : model.notes,
                               @"calendarType" : model.calendarType,
                               @"contentDigest" : model.contentDigest};
        
        [tempArr addObject:dict];
    }
    [self uploadScheduleWithArray:[tempArr copy]];
}

//词典转换为字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**下载日程*/
-(void)dowmLoadSchedules
{
    if (![SharedAppUtil defaultCommonUtil].usermodel)
        return;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timestr = [formatter stringFromDate:[NSDate date]];
    [[ScheduleDBHelper shareScheduleDBHelper] debug_save:@"尝试下载服务器日程" time:timestr];
    
    [CommonRemoteHelper RemoteWithUrl:URL_Download
                           parameters: @{@"userId" : [SharedAppUtil defaultCommonUtil].usermodel.userId,
                                         @"accessToken" : [SharedAppUtil defaultCommonUtil].usermodel.accessToken}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     if ([[dict valueForKey:@"code"] integerValue] == 404) {
                                         return MT_Log(@"没有日程信息需要更新");
                                     }
                                     else if ([[dict valueForKey:@"code"] integerValue] != 200) {
                                         return [NoticeHelper AlertShow:[dict valueForKey:@"attentionList"]];
                                     }
                                     
                                     downloadScheduleArr = [ScheduleModel mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"scheduleList"]];
                                     
                                     MT_Log(@"%@", [NSString stringWithFormat:@"服务器日程信息下载成功--%lu条",(unsigned long)downloadScheduleArr.count]);
                                     
                                     NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                                     [formatter setTimeStyle:NSDateFormatterShortStyle];
                                     [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                     NSString *timestr = [formatter stringFromDate:[NSDate date]];
                                     
                                     [[ScheduleDBHelper shareScheduleDBHelper] debug_save:[NSString stringWithFormat:@"服务器日程信息下载成功--%lu条",(unsigned long)downloadScheduleArr.count] time:timestr];
                                     
                                     [self getUploadedSchedules];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     
                                     [NoticeHelper AlertShow:@"服务器日程信息下载失败"];
                                     
                                 }];
    
}
/**获取本地需要删除的日程*/
-(void)getUploadedSchedules
{
    //EKEvent数组
    localAttentionEventArr = [[EventManger shareInstance] getThisMonthFromFifteenDaysAgoLocal];
    
    //对比查找需要删除的日程
    [self matchNeedDeleteEvent];
    
    for (ScheduleModel *model in downloadScheduleArr) {
        [self saveEventWithModel:model];
    }
}

-(void)saveEventWithModel:(ScheduleModel *)model
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    EKRecurrenceRule *rule;
    
    rule = nil;
    EKAlarm *alarm;
    alarm = [EKAlarm alarmWithRelativeOffset:0];
    EKEvent *newEvent = [EKEvent eventWithEventStore:[[EventManger shareInstance] store]];
    [newEvent setTitle:[NSString stringWithFormat:@"%@(%@)",model.title,model.ownerName]];
    [newEvent setStartDate:[date dateFromString:model.beginTime]];
    [newEvent setEndDate:[date dateFromString:model.endTime]];
    [newEvent setNotes:model.notes];
    
    if (rule != nil) {
        [newEvent setRecurrenceRules:@[rule]];
    }
    if (alarm != nil) {
        [newEvent setAlarms:@[alarm]];
    }
    
    [[EventManger shareInstance] createEvent:newEvent];
}

/**
 对比查找需要删除的日程并删除
 */
-(void)matchNeedDeleteEvent
{
    for (EKEvent *eventItem  in localAttentionEventArr) {
        
        for (ScheduleModel *uploadedItem in downloadScheduleArr)
        {
            
            if ([uploadedItem.contentDigest isEqualToString:[SecurityUtil encryptMD5String:[NSString stringWithFormat:@"%@(%@)",eventItem.title,[SharedAppUtil defaultCommonUtil].usermodel.userId]]])
            {
                [[EventManger shareInstance] deleteEvent:eventItem];
            }
        }
        [[EventManger shareInstance] deleteEvent:eventItem];
    }
    
    //    for (EKEvent *eventItem in localAttentionEventArr)
    //    {
    //        for (ScheduleModel *uploadedItem in downloadScheduleArr)
    //        {
    //            NSString *str = [NSString stringWithFormat:@"%@(%@)",uploadedItem.title,uploadedItem.ownerName];
    //            if ([str isEqualToString:eventItem.title])
    //            {
    //                [[EventManger shareInstance] deleteEvent:eventItem];
    //            }
    //        }
    //    }
}

-(void)starmonitor
{
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
    singleTap.numberOfTapsRequired = 3;
    
    [self.navigationController.navigationBar addGestureRecognizer:singleTap];
}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    DebugTableViewController *vc = [[DebugTableViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
