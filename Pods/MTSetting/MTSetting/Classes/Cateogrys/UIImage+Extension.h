//
//  UIImage+Extension.h
//
//  Created by 董徐维 on 14-7-3.
//  Copyright © 2017年 Mr.Tung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  根据图片名自动加载适配iOS6\7的图片
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 从bundle中获取图片
 */
+ (UIImage *)imagesNamedFromCustomBundle:(NSString *)imgName;
/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  等比例创建缩略图
*/
-(UIImage *)scaleImageToSize:(CGSize)size;

/**
 * 图片模糊方法
 **/

+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

+ (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

/**
 *  圆角图片
 *
 *  @return <#return value description#>
 */
- (UIImage *)circleImage;

/**
 *  将图片压缩到100k左右
 *
 *  @return 图片data数据
 */
+(NSData *)compressImg:(UIImage *)image;

@end


