//
//  ScheduleDBHelper.h
//  SyncSchedule
//
//  Created by greatstar on 2017/3/31.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduleModel.h"

@interface ScheduleDBHelper : NSObject

/***
 *  创建单例接口
 */
+ (ScheduleDBHelper *)shareScheduleDBHelper;

#pragma mark - text

/***
 *  创建 Schedule 列表
 */
- (void)creatTable;

/***
 *  创建 Schedule 保存接口
 */
- (void)saveScheduleModel:(ScheduleModel *)textModel;

/***
 *  根据 startDate 查找 Schedule
 */
- (NSArray *)searchScheduleByStartDate:(NSString *)startDate;


#pragma mark - 调试的


- (void)debug_creatTable;

- (void)debug_save:(NSString *)str time:(NSString *)time;

- (NSArray *)debug_search;

@end
