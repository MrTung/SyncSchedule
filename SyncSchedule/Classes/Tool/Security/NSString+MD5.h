//
//  NSString+MD5Encrypt.h
//  Smile
//
//  Created by 董徐维 on 15-07-22.
//  Copyright (c) 2015年 BOX. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

- (NSString *)md5Encrypt;

@end
