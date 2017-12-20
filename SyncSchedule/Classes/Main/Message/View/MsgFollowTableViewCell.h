//
//  MsgFollowTableViewCell.h
//  SyncSchedule
//
//  Created by greatstar on 2017/3/29.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgModel.h"

@interface MsgFollowTableViewCell : UITableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView;

@property (nonatomic, copy) void (^dealClick)(NSInteger dealType);

@property (nonatomic, retain) MsgModel *item;

@end
