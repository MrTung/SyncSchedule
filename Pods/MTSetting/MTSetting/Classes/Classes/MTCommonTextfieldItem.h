//
//  MTCommonTextfieldItem.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/19.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "MTCommonItem.h"

@interface MTCommonTextfieldItem : MTCommonItem

/** placeholder */
@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, weak) id delagate;

/** 文本输入框 的默认值*/
@property (nonatomic, copy) NSString *textValue;
/** 文本输入框 */
@property (strong, nonatomic) UITextField *rightText;

@property(nonatomic,getter=isSecureTextEntry) BOOL secureTextEntry;       // default is NO

@property(nonatomic) UIKeyboardType keyboardType;                         // default is UIKeyboardTypeDefault
@end
