
//
//  MTCommonViewController.m
//
//  Created by 董徐维 on 14-7-3.
//  Copyright © 2017年 Mr.Tung. All rights reserved.
//

#import "MTCommonViewController.h"

@interface MTCommonViewController ()
@property (nonatomic, strong) NSMutableArray *groups;
@end

@implementation MTCommonViewController

- (NSMutableArray *)groups
{
    if (_groups == nil) {
        self.groups = [NSMutableArray array];
    }
    return _groups;
}

/** 屏蔽tableView的样式 */
- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置tableView属性
    self.tableView.backgroundColor = MTGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = MTStatusCellMargin;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(MTStatusCellMargin - 35, 0, 0, 0);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MTCommonGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTCommonCell *cell = [MTCommonCell cellWithTableView:tableView];
    MTCommonGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    if ([cell.item isKindOfClass:[MTCommonTextfieldItem class]]) {
        MTCommonTextfieldItem *hitem = (MTCommonTextfieldItem *)cell.item;
        hitem.rightText = cell.rightText;
    }
    // 设置cell所处的行号 和 所处组的总行数
    [cell setIndexPath:indexPath rowsInSection:[NSNumber numberWithLongLong:group.items.count].intValue];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    MTCommonGroup *group = self.groups[section];
    return group.footer;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MTCommonGroup *group = self.groups[section];
    return group.header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取出这行对应的item模型
    MTCommonGroup *group = self.groups[indexPath.section];
    MTCommonItem *item = group.items[indexPath.row];
    
    // 2.判断有无需要跳转的控制器
    if (item.destVcClass) {
        UIViewController *destVc = [[item.destVcClass alloc] init];
        destVc.title = item.title;
        [self.navigationController pushViewController:destVc animated:YES];
    }
    // 3.判断有无想执行的操作
    if (item.operation) {
        item.operation();
    }
}

@end
