//
//  NSString+MD5Encrypt.h
//  Smile
//
//  Created by 董徐维 on 15-07-22.
//  Copyright (c) 2015年 BOX. All rights reserved.
//

#import "NSString+MD5.h"

@implementation NSString (MD5)

- (NSString *)md5Encrypt {
    //    const char *original_str = [self UTF8String];
    //    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //    CC_MD5(original_str, strlen(original_str), result);
    //    NSMutableString *hash = [NSMutableString string];
    //    for (int i = 0; i < 16; i++)
    //        [hash appendFormat:@"%02X", result[i]];
    //    return [hash lowercaseString];
    
    //    const char *cStr = [self UTF8String];
    //    unsigned char result[32];
    //    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    //    return [NSString stringWithFormat:
    //            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
    //            result[0], result[1], result[2], result[3],
    //            result[4], result[5], result[6], result[7],
    //            result[8], result[9], result[10], result[11],
    //            result[12], result[13], result[14], result[15]
    //            ];
    
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    
    NSString *str = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                     result[0], result[1], result[2], result[3],
                     result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11],
                     result[12], result[13], result[14], result[15]
                     ];
    return  [str lowercaseString];
    
}

@end
