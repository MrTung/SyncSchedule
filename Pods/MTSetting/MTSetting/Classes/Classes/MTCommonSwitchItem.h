//
//  MTCommonSwitchItem.h
//
//  Created by 董徐维 on 17-3-18.
//  Copyright © 2017年 Mr.Tung. All rights reserved.
//

#import "MTCommonItem.h"

@interface MTCommonSwitchItem : MTCommonItem
/** uiswitch的选中状态 */
@property (nonatomic, assign) BOOL selected;

@property (nonatomic, copy) void (^switchChangeBlock)(UISwitch *switchBtn);

@end
