//
//  AccountTableViewCell.h
//  SyncSchedule
//
//  Created by greatstar on 2017/4/7.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconimg;
@property (weak, nonatomic) IBOutlet UILabel *namelab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

+ (instancetype)createCellWithTableView:(UITableView *)tableView;
@end
