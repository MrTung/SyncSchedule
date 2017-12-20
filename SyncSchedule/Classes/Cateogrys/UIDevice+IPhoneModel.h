//
//  UIDevice+IPhoneModel.h
//  QinQingBao
//
//  Created by 董徐维 on 15/12/25.
//  Copyright © 2015年 董徐维. All rights reserved.
//
typedef NS_ENUM(NSInteger, iPhoneModel){//0~3
    iPhone4,//320*480
    iPhone5,//320*568
    iPhone6,//375*667
    iPhone6Plus,//414*736
    UnKnown
};
#import <UIKit/UIKit.h>

@interface UIDevice (IPhoneModel)
+ (iPhoneModel)iPhonesModel;

@end
