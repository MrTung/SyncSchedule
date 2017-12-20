//
//  DebugTableViewController.m
//  SyncSchedule
//
//  Created by greatstar on 2017/5/13.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import "DebugTableViewController.h"

@interface DebugTableViewController ()
{
    NSArray *arr;
}

@end

@implementation DebugTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arr = [[ScheduleDBHelper shareScheduleDBHelper] debug_search];
    self.title = [NSString stringWithFormat:@"一共%lu条",(unsigned long)arr.count];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
    
    NSMutableDictionary *dict = arr[indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"content"];
    cell.detailTextLabel.text = [dict objectForKey:@"time"];
    return cell;
}



@end
