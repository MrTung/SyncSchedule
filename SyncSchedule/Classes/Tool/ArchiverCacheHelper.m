//
//  ArchiverCacheHelper.m
//  本地缓存帮助类
//
//  Created by 董徐维 on 15/3/11.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "ArchiverCacheHelper.h"

@implementation ArchiverCacheHelper

+(void)saveNSMutableArrayToLoacl:(NSMutableArray *)saveObj key:(NSString *)key filePath:(NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    //初始化该对象 用来归档car对象
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //归档一个对象时 会为他提供一个名词  键
    [archiver encodeObject:saveObj forKey:key];
    [archiver finishEncoding];
    
    [data writeToFile:[documentDirectory stringByAppendingPathComponent:filePath] atomically:YES];
    
    NSLog(@"归档成功");
}

+(void)saveObjectToLoacl:(NSObject *)saveObj key:(NSString *)key filePath:(NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileSource = [documentDirectory stringByAppendingPathComponent:filePath];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    //初始化该对象 用来归档car对象
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //归档一个对象时 会为他提供一个名词  键
    [archiver encodeObject:saveObj forKey:key];
    [archiver finishEncoding];
    
    [data writeToFile:fileSource atomically:YES];
    NSLog(@"归档成功");
}

+(id)getLocaldataBykey:(NSString *)key filePath:(NSString *)filePath
{
    id obj;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileSource = [documentDirectory stringByAppendingPathComponent:filePath];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:fileSource])
    {
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:fileSource];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        obj = [unarchiver  decodeObjectForKey:key];
    }
    return obj;
}
@end
