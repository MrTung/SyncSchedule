//
//  UIBarButtonItem+Extension.h
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"
#import "UIImage+Extension.h"

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;
@end
