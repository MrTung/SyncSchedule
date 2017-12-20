//
//  RemindViewController.m
//  SyncSchedule
//
//  Created by greatstar on 2017/5/17.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import "RemindViewController.h"

@interface RemindViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *pickView;
    
    NSMutableArray *numarr;
    NSArray *unitarr;
    
    NSInteger selectedNum;
    NSString *selectedUnit;
    
    NSString *remindStr1;
    NSString *remindStr2;
    NSString *remindStr3;
    
    
    NSInteger firstNotifyTime;
    NSInteger secondNotifyTime;
    NSInteger ThirdNotifyTime;
    
    BOOL openNotify;
}
@end

@implementation RemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提醒设置";
    
    numarr = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 61; i++) {
        [numarr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    unitarr = @[@"分钟",@"小时"];
    
    remindStr1 = @"无";
    remindStr2 = @"无";
    remindStr3 = @"无";
    
    [self initDataPickView];
    
    [self setupGroup:YES];
    
    [self getRemind];
}

- (void)setupGroup:(BOOL)ison
{
    [self.groups removeAllObjects];
    
    openNotify = ison;
    
    MTCommonGroup *group = [MTCommonGroup group];
    [self.groups addObject:group];
    
    MTCommonSwitchItem *itemswitch = [MTCommonSwitchItem itemWithTitle:@"是否开启" icon:@"nil"];
    itemswitch.selected = ison;
    __weak __typeof(MTCommonSwitchItem *)itemsw = itemswitch;
    itemswitch.switchChangeBlock = ^(UISwitch *switchBtn) {
        itemsw.selected = !itemsw.selected;
        [self setupGroup:itemsw.selected];
        
        [self addRemind];
    };
    
    MTCommonArrowItem *item0 = [MTCommonArrowItem itemWithTitle:@"提醒一" icon:@"nil"];
    item0.subtitle  = remindStr1;
    item0.operation = ^{
        [self showDataPicker:1];
    };
    
    MTCommonArrowItem *item1 = [MTCommonArrowItem itemWithTitle:@"提醒二" icon:@"nil"];
    item1.subtitle  = remindStr2;
    item1.operation = ^{
        [self showDataPicker:2];
    };
    
    MTCommonArrowItem *item2 = [MTCommonArrowItem itemWithTitle:@"提醒三" icon:@"nil"];
    item2.subtitle  = remindStr3;
    item2.operation = ^{
        [self showDataPicker:3];
    };
    
    if (ison) {
        group.items = @[item0,item1,item2];
    }
    else
        group.items = @[itemswitch];
    
    [self.tableView reloadData];
}

#pragma mark --- DatePicker

-(void)showDataPicker:(NSInteger)index
{
    
    __block NSInteger idx = index;
    
    UIAlertController* alertVc = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n"
                                                                     message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        switch (idx) {
            case 1:
            {
                remindStr1 = [NSString stringWithFormat:@"日程开始前%ld%@",(long)selectedNum,selectedUnit];
                if ([selectedUnit isEqualToString:@"分钟"])
                    firstNotifyTime = selectedNum;
                else
                    firstNotifyTime = selectedNum * 60;
            }
                break;
            case 2:
            {
                remindStr2 = [NSString stringWithFormat:@"日程开始前%ld%@",(long)selectedNum,selectedUnit];
                if ([selectedUnit isEqualToString:@"分钟"])
                    secondNotifyTime = selectedNum;
                else
                    secondNotifyTime = selectedNum * 60;
            }
                break;
            case 3:
            {
                remindStr3 = [NSString stringWithFormat:@"日程开始前%ld%@",(long)selectedNum,selectedUnit];
                
                if ([selectedUnit isEqualToString:@"分钟"])
                    ThirdNotifyTime = selectedNum;
                else
                    ThirdNotifyTime = selectedNum * 60;
            }
                break;
            default:
                break;
        }
        [self setupGroup:YES];
        
        [self addRemind];
    }];
    
    UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVc.view addSubview:pickView];
    [alertVc addAction:ok];
    [alertVc addAction:no];
    [self presentViewController:alertVc animated:YES completion:nil];
}

/**
 *   创建、并初始化2个NSArray对象，分别作为2列的数据
 */
-(void)initDataPickView
{
    pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 10, MTScreenW - 30, 200)];
    pickView.dataSource = self;
    pickView.delegate = self;
    
    selectedNum = [numarr[0] integerValue];
    selectedUnit = unitarr[0];
}

#pragma mark UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return 1;
            break;
        case 1:
            return numarr.count;
            break;
        case 2:
            return unitarr.count;
            break;
        default:
            return 0;
            break;
    }
    
    return 10;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return @"开始前";
            break;
        case 1:
            return numarr[row];
            break;
        case 2:
            return unitarr[row];
            break;
        default:
            return nil;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            break;
        }
        case 1:
        {
            selectedNum = [numarr[row] integerValue];
            break;
        }
        case 2:
        {
            selectedUnit = unitarr[row];
            break;
        }
        default:
            break;
    }
}

-(void)addRemind
{
    if (![SharedAppUtil defaultCommonUtil].usermodel)
        return;
    
    
    
    [CommonRemoteHelper RemoteWithUrl:URL_updateNotifitySetting
                           parameters: @{@"userId" : [SharedAppUtil defaultCommonUtil].usermodel.userId,
                                         @"firstNotifyTime" : @(firstNotifyTime),
                                         @"secondNotifyTime" : @(secondNotifyTime),
                                         @"thirdNotifyTime" : @(ThirdNotifyTime),
                                         @"openNotify" : @"1"}

//                                         @"openNotify" : openNotify ? @"1" : @"0"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     if ([[dict valueForKey:@"code"] integerValue] != 200) {
                                         return [NoticeHelper AlertShow:@"设置失败，请重试"];
                                     }
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     
                                 }];
}

-(void)getRemind
{
    if (![SharedAppUtil defaultCommonUtil].usermodel)
        return;
    
    [CommonRemoteHelper RemoteWithUrl:URL_showNotifitySetting
                           parameters: @{@"userId" : [SharedAppUtil defaultCommonUtil].usermodel.userId}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     if ([[dict valueForKey:@"code"] integerValue] != 200)
                                         return MT_Log(@"获取日程提醒信息失败");
                                     NSDictionary *dict1 = [dict objectForKey:@"data"];
                                     firstNotifyTime = [[dict1 objectForKey:@"firstNotifyTime"] integerValue];
                                     secondNotifyTime = [[dict1 objectForKey:@"secondNotifyTime"] integerValue];
                                     ThirdNotifyTime = [[dict1 objectForKey:@"ThirdNotifyTime"] integerValue];
                                     
                                     if (firstNotifyTime > 60)
                                         remindStr1 = [NSString stringWithFormat:@"日程开始前%ld%@",(long)firstNotifyTime/60,@"小时"];
                                     else
                                         remindStr1 = [NSString stringWithFormat:@"日程开始前%ld%@",(long)firstNotifyTime,selectedUnit];
                                     
                                     if (secondNotifyTime > 60)
                                         remindStr2 = [NSString stringWithFormat:@"日程开始前%ld%@",(long)secondNotifyTime/60,@"小时"];
                                     else
                                         remindStr2 = [NSString stringWithFormat:@"日程开始前%ld%@",(long)secondNotifyTime,selectedUnit];

                                     if (ThirdNotifyTime > 60)
                                         remindStr3 = [NSString stringWithFormat:@"日程开始前%ld%@",(long)ThirdNotifyTime/60,@"小时"];
                                     else
                                         remindStr3 = [NSString stringWithFormat:@"日程开始前%ld%@",(long)ThirdNotifyTime,selectedUnit];
                                     
                                     [self setupGroup:[[dict1 objectForKey:@"openNotify"] integerValue] == 0 ? NO : YES];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     
                                     
                                 }];
    
}

@end
