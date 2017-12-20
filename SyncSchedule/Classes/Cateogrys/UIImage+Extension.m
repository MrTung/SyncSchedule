//
//  UIImage+Extension.m
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIImage+Extension.h"
#import <Accelerate/Accelerate.h>

// 是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
@implementation UIImage (Extension)
+ (UIImage *)imageWithName:(NSString *)name
{
    UIImage *image = nil;
    if (iOS7) { // 处理iOS7的情况
        NSString *newName = [name stringByAppendingString:@"_os7"];
        image = [UIImage imageNamed:newName];
    }
    
    if (image == nil) {
        image = [UIImage imageNamed:name];
    }
    return image;
}

+ (UIImage *)resizedImage:(NSString *)name
{
    UIImage *image = [UIImage imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(UIImage *)scaleImageToSize:(CGSize)size
{
    CGFloat scaleW = size.width/self.size.width;
    CGFloat scaleH = size.height/self.size.height;
    
    CGFloat finalScale;
    if (scaleW > scaleH) {
        finalScale = scaleW;
    }else{
        finalScale = scaleH;
    }
    
    CGFloat finalW = self.size.width *finalScale;
    CGFloat finalH = self.size.height *finalScale;
    CGRect finalRect;
    if (scaleW < scaleH) {
        finalRect = CGRectMake((size.width - finalW)/2, 0, finalW, finalH);
    }else{
        finalRect = CGRectMake(0, (size.height - finalH)/2, finalW, finalH);
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0f);
    [self drawInRect:finalRect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

// 图片模糊方法
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    //    CGColorSpaceRelease(colorSpace);//**********
    CGImageRelease(imageRef);
    
    return returnImage;
}



// 模糊图片方法
+ (UIImage *)coreBlurImage:(UIImage *)image
            withBlurNumber:(CGFloat)blur {
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage  *inputImage=[CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

- (UIImage *)circleImage
{
    // 开始图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 设置一个范围
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // 根据一个rect创建一个椭圆
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将原照片画到图形上下文
    [self drawInRect:rect];
    
    // 从上下文上获取剪裁后的照片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

//压缩图片至100k以下
+(NSData *)compressImg:(UIImage *)image
{
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    if (data.length>100*1024)
    {
        if (data.length>1024*1024)
        {//1M以及以上
            data=UIImageJPEGRepresentation(image, 0.1);
        }
        else if (data.length>512*1024)
        {//0.5M-1M
            data=UIImageJPEGRepresentation(image, 0.5);
        }
        else if (data.length>200*1024)
        {//0.25M-0.5M
            data=UIImageJPEGRepresentation(image, 0.9);
        }
    }
    return data;
}


@end
