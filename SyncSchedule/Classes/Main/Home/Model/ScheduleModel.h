//
//  ScheduleModel.h
//  SyncSchedule
//
//  Created by greatstar on 2017/3/31.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface ScheduleModel : NSObject


/**日程创建人ID*/
@property (nonatomic, copy) NSString *ownerId;

/**日程创建人*/
@property (nonatomic, copy) NSString *ownerName;

/**日程摘要*/
@property (nonatomic, copy) NSString *contentDigest;

/**标题*/
@property (nonatomic, copy) NSString *title;

/**开始时间*/
@property (nonatomic, strong) NSDate *startDate;

/**结束时间*/
@property (nonatomic, strong) NSDate *endDate;

/**备注*/
@property (nonatomic, copy) NSString *notes;

/**日历类别*/
@property (nonatomic, copy) NSString *calendarType;

/**url*/
//@property (nonatomic, copy) NSString *url;

/**位置*/
//@property (nonatomic, copy) NSString *location;

/**是否全天*/
//@property (nonatomic, copy) NSString *allDay;

/**闹钟*/
//@property (nonatomic, copy) NSArray *alarms;

/**重复*/
//@property (nonatomic, copy) NSArray *recurrenceRules;


/**
 EKEvent数组转换成自己的ScheduleModel数组

 @param eventArr 系统的EKEvent数组
 @return 自己的ScheduleModel数组
 */
+(NSArray <ScheduleModel *> *)scheduleArrWithEvent:(NSArray <EKEvent *>*)eventArr;


@end
