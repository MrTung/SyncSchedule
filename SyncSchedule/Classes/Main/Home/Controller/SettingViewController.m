//
//  SettingViewController.m
//  SyncSchedule
//
//  Created by greatstar on 2017/3/30.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import "SettingViewController.h"
#import <EventKit/EventKit.h>

@interface SettingViewController ()
{
    NSArray<EKCalendar *> *typeArr;
    NSMutableArray *itemArr;
}
@property (nonatomic , retain) EKEventStore *store;


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"同步设置";
    
    [self setTableHeadView];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.store = [[EKEventStore alloc]init];
    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {}];
    typeArr = [self.store calendarsForEntityType:EKEntityTypeEvent];
    
    [self setupGroup];
}

-(void)setTableHeadView
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, MTScreenW, 30)];
    lab.text = @"请选择您要同步的日程分类";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor orangeColor];
    lab.font = [UIFont systemFontOfSize:12];
    self.tableView.tableHeaderView = lab;
}


- (void)setupGroup
{
    itemArr = [[NSMutableArray alloc] init];
    // 1.创建组
    MTCommonGroup *group = [MTCommonGroup group];
    [self.groups addObject:group];
    
    for (EKCalendar *item in typeArr) {
        
        
        if (item.type ==  EKCalendarTypeLocal)
        {
            MTCommonCheckItem *version = [MTCommonCheckItem itemWithTitle:item.title icon:@"nil"];
            
            __weak __typeof(MTCommonCheckItem*)weakItem = version;
            
            if ([item.title isEqualToString:[SharedAppUtil defaultCommonUtil].filterType])
                version.checked = YES;
            
            version.operation = ^(void){
                weakItem.checked = YES;
                
                for (MTCommonCheckItem *checkItem in group.items ) {
                    if (checkItem == version)
                        continue;
                    else
                        checkItem.checked = NO;
                }
                
                [self.tableView reloadData];
                
                [self setFilterKey:weakItem];
            };
            
            [itemArr addObject:version];
        }
    }
    group.items = [itemArr copy];
}

-(void)setFilterKey:(MTCommonCheckItem *)item
{
    [SharedAppUtil defaultCommonUtil].filterType = item.title;
    
    [[NSUserDefaults standardUserDefaults] setObject:item.title forKey:Fiflter_Key];
}


@end
