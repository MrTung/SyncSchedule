//
//  AccountTableViewCell.m
//  SyncSchedule
//
//  Created by greatstar on 2017/4/7.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import "AccountTableViewCell.h"

@implementation AccountTableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"AccountTableViewCell";
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AccountTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.namelab.text = [SharedAppUtil defaultCommonUtil].usermodel.userName;
    self.numLab.text = [SharedAppUtil defaultCommonUtil].usermodel.userId;

}



@end
