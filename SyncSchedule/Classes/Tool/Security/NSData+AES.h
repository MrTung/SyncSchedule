//
//  NSData+AES.h
//  Smile
//
//  Created by 董徐维 on 15-07-22.
//  Copyright (c) 2015年 BOX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

@end
