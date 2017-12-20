//
//  ArchiverCacheHelper.h
//  GPSNavDemo
//
//  Created by 董徐维 on 15/3/11.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//  app文件归档类

#import <Foundation/Foundation.h>

@interface ArchiverCacheHelper : NSObject

/**
 *  以归档方式保存在本地
 *
 *  @param saveObj  要保存的NSMutableArray对象
 *  @param key      key
 *  @param fildPath 保存路径
 */
+(void)saveNSMutableArrayToLoacl:(NSMutableArray *)saveObj key:(NSString *)key filePath:(NSString *)filePath;

/**
 *  以归档方式保存在本地
 *
 *  @param saveObj  要保存的对象
 *  @param key      key
 *  @param fildPath 保存路径
 */
+(void)saveObjectToLoacl:(NSObject *)saveObj key:(NSString *)key filePath:(NSString *)filePath;


/**
 *  以key获取本地缓存
 *
 *  @param key      key description
 *  @param filePath 保存路径
 *
 *  @return return value description
 */
+(id)getLocaldataBykey:(NSString *)key filePath:(NSString *)filePath;

@end
