//
//  MsgFollowTableViewCell.m
//  SyncSchedule
//
//  Created by greatstar on 2017/3/29.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import "MsgFollowTableViewCell.h"

@interface MsgFollowTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *subLab;
@end

@implementation MsgFollowTableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"MsgFollowTableViewCell";
    MsgFollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MsgFollowTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

- (IBAction)sureClickHandler:(id)sender
{
    if (self.dealClick)
        self.dealClick(1);
}

- (IBAction)refuseClickHandler:(id)sender
{
    if (self.dealClick)
        self.dealClick(2);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initView];
}

-(void)initView
{
    _bgView.layer.cornerRadius = 8;
    _bgView.layer.masksToBounds = YES;
    
    _sureBtn.backgroundColor = MTColor(81, 169, 56);
    _sureBtn.layer.cornerRadius = 4;
    
    _refuseBtn.backgroundColor = [UIColor redColor];
    _refuseBtn.layer.cornerRadius = 4;

    _timeLab.hidden = YES;
}

-(void)setItem:(MsgModel *)item
{
    _item = item;
    self.contentLab.text = item.msgContent;
    
//    消息状态，0:未处理，1：同意，2：拒绝
    switch ([item.state integerValue])
    {
        case 0:
        {
            self.sureBtn.hidden = self.refuseBtn.hidden = NO;
            self.subLab.hidden = YES;
        }
            break;
        case 1:
        {
            self.sureBtn.hidden = self.refuseBtn.hidden = YES;
            self.subLab.hidden = NO;
            self.subLab.text = @"已同意";

        }
            break;
        case 2:
        {
            self.sureBtn.hidden = self.refuseBtn.hidden = YES;
            self.subLab.hidden = NO;
            self.subLab.text = @"已拒绝";
        }
            break;
        default:
            break;
    }
}



@end
