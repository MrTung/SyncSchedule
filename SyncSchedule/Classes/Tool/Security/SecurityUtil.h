//
//  SecurityUtil.h
//  Smile
//
//  Created by 董徐维 on 15-07-22.
//  Copyright (c) 2015年 BOX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityUtil : NSObject 

#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;
+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;

#pragma mark - AES加密
//将string转成带密码的data
+ (NSData*)encryptAESData:(NSString*)string;
//将带密码的data转成string
+ (NSString*)decryptAESData:(NSData*)data;

#pragma mark - MD5加密
/**
 *	@brief	对string进行md5加密
 *
 *	@param 	string 	未加密的字符串
 *
 *	@return	md5加密后的字符串
 */
+ (NSString*)encryptMD5String:(NSString*)string;

@end
