//
//  MsgFollowTableViewCell.h
//  SyncSchedule
//
//  Created by greatstar on 2017/3/29.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgFollowTableViewCell : UITableViewCell

//是否操作完成
@property (nonatomic, getter=isEnded) Boolean ended;

+ (instancetype)createCellWithTableView:(UITableView *)tableView;
@end
