//
//  MTCommonCell.m
//
//  Created by 董徐维 on 17-3-18.
//  Copyright © 2017年 Mr.Tung. All rights reserved.
//

#import "MTSeting.h"
#import "MTCommonCell.h"

@interface MTCommonCell()

/**
 *  提醒数字
 */
@property (strong, nonatomic) MTBadgeView *bageView;
@end

@implementation MTCommonCell

#pragma mark - 懒加载右边的view
- (UIImageView *)rightArrow
{
    if (_rightArrow == nil) {
        self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imagesNamedFromCustomBundle:@"common_icon_arrow"]];
    }
    return _rightArrow;
}

- (UISwitch *)rightSwitch
{
    MTCommonSwitchItem *hItem = (MTCommonSwitchItem *)_item;
    if (_rightSwitch == nil) {
        self.rightSwitch = [[UISwitch alloc] init];
        [self.rightSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    [_rightSwitch setOn:hItem.selected animated:YES];
    return _rightSwitch;
}

- (UILabel *)rightLabel
{
    MTCommonLabelItem *labelItem = (MTCommonLabelItem *)_item;
    if (_rightLabel == nil) {
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.textColor = [UIColor lightGrayColor];
        self.rightLabel.font = [UIFont systemFontOfSize:13];
        self.rightLabel.text = labelItem.textValue;
        self.rightLabel.size = [labelItem.textValue sizeWithAttributes:@{NSFontAttributeName:self.rightLabel.font}];
    }
    return _rightLabel;
}

- (UITextField *)rightText
{
    MTCommonTextfieldItem *hitem = (MTCommonTextfieldItem *)_item;
    if (_rightText == nil) {
        hitem.rightText = [[UITextField alloc] init];
        hitem.rightText.textColor = [UIColor lightGrayColor];
        hitem.rightText.font = [UIFont systemFontOfSize:15];
        hitem.rightText.secureTextEntry = hitem.secureTextEntry;
        hitem.rightText.keyboardType = hitem.keyboardType;
        hitem.rightText.delegate = hitem.delagate;
        hitem.rightText.x = 110;
        hitem.rightText.y = (self.height - 21)/ 2;
        hitem.rightText.width = MTScreenW - 120;
        hitem.rightText.height = 21;
        hitem.rightText.clearButtonMode = UITextFieldViewModeAlways;
        hitem.rightText.adjustsFontSizeToFitWidth = YES;
        hitem.rightText.placeholder = hitem.placeholder;
        self.rightText = hitem.rightText;
    }
    hitem.rightText.text = hitem.textValue;
    return _rightText;
}

- (UIButton *)rightBtn
{
    MTCommonButtonItem *hitem = (MTCommonButtonItem *)_item;
    if (_rightBtn == nil) {
        hitem.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        hitem.btn.width = 80;    hitem.btn.height = 30;
        [hitem.btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        [hitem.btn setTitleColor:MTNavgationBackgroundColor forState:UIControlStateNormal];
        [hitem.btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [hitem.btn setTitle:hitem.btnTitle forState:UIControlStateNormal];
        [hitem.btn.layer setBorderWidth:1];//设置边界的宽度
        [hitem.btn.layer setCornerRadius:10.0];//设置矩形四个圆角半径
        [hitem.btn.layer setBorderColor:[MTNavgationBackgroundColor CGColor]];
        [hitem.btn setTitle:hitem.btnTitle forState:UIControlStateNormal];
        [hitem.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn = hitem.btn;
    }
    return _rightBtn;
}

- (UIButton *)checkBtn
{
    MTCommonCheckItem *hitem = (MTCommonCheckItem *)_item;
    if (_checkBtn == nil) {
        hitem.checkView = [UIButton buttonWithType:UIButtonTypeCustom];
        [hitem.checkView setBackgroundImage:[UIImage resizedImage:@"selected"] forState:UIControlStateSelected];
        [hitem.checkView setBackgroundImage:[UIImage resizedImage:@"unselected"] forState:UIControlStateNormal];
        [hitem.checkView addTarget:self action:@selector(checkHandler:) forControlEvents:UIControlEventTouchUpInside];
        hitem.checkView.size = hitem.checkView.currentBackgroundImage.size;
        _checkBtn = hitem.checkView;
    }
    hitem.checkView.selected = hitem.isChecked;
    return _checkBtn;
}

- (MTBadgeView *)bageView
{
    if (_bageView == nil) {
        self.bageView = [[MTBadgeView alloc] init];
    }
    return _bageView;
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"common";
    MTCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MTCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 设置标题的字体
        self.textLabel.font = [UIFont boldSystemFontOfSize:14];
        self.detailTextLabel.font = [UIFont systemFontOfSize:11];
        
        // 去除cell的默认背景色
        self.backgroundColor = [UIColor clearColor];
        
        // 设置背景view
        self.backgroundView = [[UIImageView alloc] init];
        self.selectedBackgroundView = [[UIImageView alloc] init];
    }
    return self;
}

#pragma mark - 调整子控件的位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.item isKindOfClass:[MTCommonCenterItem class]]) {
        self.textLabel.centerX = self.width * 0.5;
        self.textLabel.centerY = self.height * 0.5;
    } else {
        if (self.item.isSubtitle)
            self.detailTextLabel.x = CGRectGetMaxX(self.textLabel.frame) + 5;
    }
}
#pragma mark - setter
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows
{
    // 1.取出背景view
    UIImageView *bgView = (UIImageView *)self.backgroundView;
    UIImageView *selectedBgView = (UIImageView *)self.selectedBackgroundView;
    
    // 2.设置背景图片
    if (rows == 1) {
        bgView.image = [UIImage resizedImage:@"common_card_background"];
        if (![self.item isKindOfClass:[MTCommonTextfieldItem class]])
            selectedBgView.image = [UIImage resizedImage:@"common_card_background_highlighted"];
    } else if (indexPath.row == 0) { // 首行
        bgView.image = [UIImage resizedImage:@"common_card_top_background"];
        if (![self.item isKindOfClass:[MTCommonTextfieldItem class]])
            selectedBgView.image = [UIImage resizedImage:@"common_card_top_background_highlighted"];
    } else if (indexPath.row == rows - 1) { // 末行
        bgView.image = [UIImage resizedImage:@"common_card_bottom_background"];
        if (![self.item isKindOfClass:[MTCommonTextfieldItem class]])
            selectedBgView.image = [UIImage resizedImage:@"common_card_bottom_background_highlighted"];
    } else { // 中间
        bgView.image = [UIImage resizedImage:@"common_card_middle_background"];
        if (![self.item isKindOfClass:[MTCommonTextfieldItem class]])
            selectedBgView.image = [UIImage resizedImage:@"common_card_middle_background_highlighted"];
    }
    
}

- (void)setItem:(MTCommonItem *)item
{
    _item = item;
    
    // 1.设置基本数据
    if (item.icon.length > 0)
        self.imageView.image = [UIImage imageWithName:item.icon];
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subtitle;
    self.imageView.width = self.imageView.height = 24;
    
    self.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
    // 2.设置右边的内容
    if (item.badgeValue) { // 紧急情况：右边有提醒数字
        self.bageView.badgeValue = item.badgeValue;
        self.accessoryView = self.bageView;
    } else if ([item isKindOfClass:[MTCommonArrowItem class]]) {
        self.accessoryView = self.rightArrow;
    } else if ([item isKindOfClass:[MTCommonTextfieldItem class]]) {
        [self.contentView addSubview:self.rightText];
    } else if ([item isKindOfClass:[MTCommonButtonItem class]]){
        self.accessoryView = self.rightBtn;
    } else if ([item isKindOfClass:[MTCommonSwitchItem class]]) {
        self.accessoryView = self.rightSwitch;}
    else if ([item isKindOfClass:[MTCommonLabelItem class]]) {
        self.accessoryView = self.rightLabel;
    } else if ([item isKindOfClass:[MTCommonCheckItem class]]) {
        self.accessoryView = self.checkBtn;
    } else { // 取消右边的内容
        self.accessoryView = nil;
    }
}

/**
 *  点击switch的回掉函数
 */
-(void)buttonClick:(UIButton *)sender
{
    MTCommonButtonItem *hitem = (MTCommonButtonItem *)_item;
    if (hitem.buttonClickBlock) {
        hitem.buttonClickBlock(sender);
    }
}

/**
 *  点击switch的回掉函数
 */
-(void)switchChanged:(UISwitch *)uiSwitch
{
    MTCommonSwitchItem *hitem = (MTCommonSwitchItem *)_item;
    if (hitem.switchChangeBlock) {
        hitem.switchChangeBlock(uiSwitch);
    }
}

/**
 *  点击checkbtn的回掉函数
 */
-(void)checkHandler:(UIButton *)checkBtn
{
    MTCommonCheckItem *hitem = (MTCommonCheckItem *)_item;
    hitem.checked = !hitem.isChecked;
    self.checkBtn.selected = !self.checkBtn.selected;
    
    if (hitem.checkClickBlock) {
        hitem.checkClickBlock(checkBtn);
    }
}
@end
