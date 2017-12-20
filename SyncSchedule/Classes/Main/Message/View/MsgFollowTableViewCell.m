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
    
}

- (IBAction)refuseClickHandler:(id)sender
{
    
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
    _sureBtn.hidden = self.isEnded;
    
    _refuseBtn.backgroundColor = [UIColor redColor];
    _refuseBtn.layer.cornerRadius = 4;
    _refuseBtn.hidden = self.isEnded;
    
    _subLab.hidden = !self.isEnded;

    _timeLab.hidden = YES;
}

-(void)setEnded:(Boolean)ended
{
    _ended = ended;
    [self initView];
}



@end
