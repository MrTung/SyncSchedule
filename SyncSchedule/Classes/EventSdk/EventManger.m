//
//  EventManger.m
//  CalendarEventSdk
//
//  Created by Clement on 15/1/5.
//  Copyright (c) 2015年 Clement. All rights reserved.
//

#import "EventManger.h"

#define kSecondOfOneDay 24*60*60

typedef enum : NSUInteger {
    DateNameToday = 0,
    DateNameTomorrow,
    DateNameThisWeekSunday,
    DateNameNextWeekSunday,
    DateNameThisMonday,
    DateNameNextMonday,
    DateNameThisMonthOne,
    DateNameNextMonthOne,
    DateNameFifteenDaysAgo,
    DateNameFifteendaysLater
} DateName;

@interface EventManger ()

@property (nonatomic , retain) EKEventStore *store;



@end

static EventManger *manger = nil;

@implementation EventManger

+(instancetype)shareInstance{
   EventManger *man = [EventManger defaltInstance];
    if (man.store == nil) {
        [man requestEKEventStore];
        [man creatSharedCalendar];
    }
    return man;
}

+(instancetype)defaltInstance
{
    if (manger == nil) {
        manger = [[EventManger alloc]init];
    }
    return manger;
}

-(void)requestEKEventStore
{
    self.store = [[EKEventStore alloc]init];
    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
    }];
}

-(NSArray *)getTodayEvent
{
    NSDate *startDate = [self dateConversionFromDate:[self dateWithName:DateNameToday]];
    NSDate *endDate = [self dateConversionFromDate:[self dateWithName:DateNameTomorrow]];
    NSPredicate *pre = [self.store predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
    NSArray *events = [self.store eventsMatchingPredicate:pre];
    events = [events sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
    
    return [self filterArr:events];
}

-(NSArray *)getThisWeekEventFromSunday
{
    NSDate *sDate = [self dateConversionFromDate:[self dateWithName:DateNameThisWeekSunday]];
    NSDate *eDate = [self dateConversionFromDate:[self dateWithName:DateNameNextWeekSunday]];
    NSPredicate *pre = [self.store predicateForEventsWithStartDate:sDate endDate:eDate calendars:nil];
    NSArray *events = [self.store eventsMatchingPredicate:pre];
    events = [events sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
    
    return [self filterArr:events];
}

-(NSArray *)getThisWeekEventFromMonday
{
    NSDate *sDate = [self dateConversionFromDate:[self dateWithName:DateNameThisMonday]];
    NSDate *eDate = [self dateConversionFromDate:[self dateWithName:DateNameNextMonday]];
    NSPredicate *pre = [self.store predicateForEventsWithStartDate:sDate endDate:eDate calendars:nil];
    NSArray *events = [self.store eventsMatchingPredicate:pre];
    events = [events sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
    return [self filterArr:events];
}

-(NSArray *)getThisMonthFromFirstDay
{
    NSDate *sDate = [self dateConversionFromDate:[self dateWithName:DateNameThisMonthOne]];
    NSDate *eDate = [self dateConversionFromDate:[self dateWithName:DateNameNextMonthOne]];
    NSPredicate *pre = [self.store predicateForEventsWithStartDate:sDate endDate:eDate calendars:nil];
    NSArray *events = [self.store eventsMatchingPredicate:pre];
    events = [events sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
    return [self filterArr:events];
}

-(NSArray *)getThisMonthFromFifteenDaysAgo
{
    NSDate *sDate = [self dateConversionFromDate:[self dateWithName:DateNameToday]];
    NSDate *eDate = [self dateConversionFromDate:[self dateWithName:DateNameFifteendaysLater]];
    NSPredicate *pre = [self.store predicateForEventsWithStartDate:[NSDate date] endDate:eDate calendars:nil];
    NSArray *events = [self.store eventsMatchingPredicate:pre];
    events = [events sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
    return [self filterArr:events];
}

-(BOOL)deleteEvent:(EKEvent *)event
{
    NSError *err;
    BOOL isSuccess = NO;
    [event setCalendar:[self.store defaultCalendarForNewEvents]];
    [self.store removeEvent:event span:EKSpanThisEvent commit:YES error:&err];
    if (err == nil) {
        isSuccess = YES;
    }
    return isSuccess;
}

-(NSDate *)dateWithName:(DateName)dateName
{
    NSDate *tempDate;
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHH"];
    NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:[NSDate date]];
    
    switch (dateName) {
        case DateNameToday:
            tempDate = [NSDate date];
            break;
        case DateNameTomorrow:
            tempDate = [[NSDate date] dateByAddingTimeInterval:kSecondOfOneDay];
            break;
        case DateNameThisWeekSunday:
        {
            NSInteger offset = [component weekday];
            tempDate = [today dateByAddingTimeInterval:-(offset - 1) * kSecondOfOneDay];
        }
            break;
        case DateNameNextWeekSunday:
        {
            NSInteger offset = [component weekday];
            tempDate = [today dateByAddingTimeInterval:-(offset - 1 - 7)*kSecondOfOneDay];
        }
            break;
        case DateNameThisMonday:
        {
            NSInteger offset = [component weekday];
            tempDate = [today dateByAddingTimeInterval:-(offset - 2) * kSecondOfOneDay];
        }
            break;
        case DateNameNextMonday:
        {
            NSInteger offset = [component weekday];
            tempDate = [today dateByAddingTimeInterval:-(offset - 2 - 7)*kSecondOfOneDay];
        }
            break;
        case DateNameThisMonthOne:
        {
            NSInteger offset = [component day];
            tempDate = [today dateByAddingTimeInterval:-(offset - 1)*kSecondOfOneDay];
        }
            break;
        case DateNameNextMonthOne:
        {
            NSInteger dateInt = [[formatter stringFromDate:today] integerValue];
            NSInteger year = dateInt/1e6 ;
            NSInteger month = (dateInt - year*(1e6))/1e4;
            if (month == 12) {
                year ++;
                month = 0;
            }
            month++;
            
            dateInt = year*1e6 + month*1e4 + 100 ;
            tempDate = [formatter dateFromString:[NSString stringWithFormat:@"%ld",(long)dateInt]];
            
        }
            break;
        case DateNameFifteenDaysAgo:
        {
            tempDate = [today dateByAddingTimeInterval:-kSecondOfOneDay*15];
        }
            break;
        case DateNameFifteendaysLater:
            tempDate = [today dateByAddingTimeInterval:kSecondOfOneDay*15];
            break;
        default:
            tempDate = [NSDate dateWithTimeIntervalSince1970:0];
            break;
    }
    
    return tempDate;
}



-(NSDate *)dateConversionFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHH"];
    NSInteger dateInt = [[formatter stringFromDate:date] integerValue];
    dateInt -= dateInt%100;
    date = [formatter dateFromString:[NSString stringWithFormat:@"%ld",(long)dateInt]];
    return date;
}


-(BOOL)createEvent:(EKEvent *)event
{
    NSError *err;
    
    EKSource *localSource = nil;
    for (EKSource *source in self.store.sources)
    {
        if (source.sourceType == EKSourceTypeCalDAV && [source.title isEqualToString:@"iCloud"])
        {
            localSource = source;
            break;
        }
    }
    if (localSource == nil)
    {
        for (EKSource *source in self.store.sources) {
            if (source.sourceType == EKSourceTypeLocal)
            {
                localSource = source;
                break;
            }
        }
    }
    
    EKCalendar *target;
    NSSet<EKCalendar *> * set= [localSource calendarsForEntityType:EKEntityTypeEvent];
    for (EKCalendar *calendar in set) {
        if ([calendar.title isEqualToString:kAttentionType ]) {
            target = calendar;
        }
    }
    
    if (!target) {
        target = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:self.store];
        target.source = localSource;
        target.title = kAttentionType;//自定义日历标题
        target.CGColor = [UIColor redColor].CGColor;//自定义日历颜色
        NSError* error;
        [self.store saveCalendar:target commit:YES error:&error];
    }
    
    [event setCalendar:target];
    
    [self.store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
    if (err == nil) {
        MT_Log(@"日程成功写入本地");
        return YES;
    }
    else
    {
        NSLog(@"%@",err);
        return NO;
    }
}

-(BOOL)saveEvent:(EKEvent *)event
{
    NSError *err;
    [self.store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
    NSLog(@"%@",err);
    if (err == nil) {
        return YES;
    }
    else
    {
        return NO;
    }
}


/**
 过滤需要上传的日历类别
 @return 经过过滤的日历
 */
-(NSArray *)filterArr:(NSArray *)arr
{
 
    NSMutableArray *filterArr = [[NSMutableArray alloc] init];
    
    for (EKEvent *event in arr) {
        
        if ([event.calendar.title isEqualToString:[SharedAppUtil defaultCommonUtil].filterType])
            [filterArr addObject:event];
    }
    
    return [filterArr copy];
}

/**
 本地创建需要共享的日志类别
 */
-(void)creatSharedCalendar
{
    EKSource *localSource = nil;
    for (EKSource *source in self.store.sources)
    {
        if (source.sourceType == EKSourceTypeCalDAV && [source.title isEqualToString:@"iCloud"])
        {
            localSource = source;
            break;
        }
    }
    if (localSource == nil)
    {
        for (EKSource *source in self.store.sources) {
            if (source.sourceType == EKSourceTypeLocal)
            {
                localSource = source;
                break;
            }
        }
    }
    
    EKCalendar *target;
    NSSet<EKCalendar *> * set= [localSource calendarsForEntityType:EKEntityTypeEvent];
    for (EKCalendar *calendar in set) {
        if ([calendar.title isEqualToString:kSharedType ]) {
            target = calendar;
        }
    }
    
    if (!target) {
        target = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:self.store];
        target.source = localSource;
        target.title = kSharedType;//自定义日历标题
        target.CGColor = [UIColor greenColor].CGColor;//自定义日历颜色
        NSError* error;
        [self.store saveCalendar:target commit:YES error:&error];
    }
    MT_Log(@"创建共享的日志分类成功");
    
}


#pragma mark 获取本地订阅的日志

-(NSArray *)getThisMonthFromFifteenDaysAgoLocal
{
    NSDate *sDate = [self dateConversionFromDate:[self dateWithName:DateNameToday]];
    NSDate *eDate = [self dateConversionFromDate:[self dateWithName:DateNameFifteendaysLater]];
    NSPredicate *pre = [self.store predicateForEventsWithStartDate:[NSDate date] endDate:eDate calendars:nil];
    NSArray *events = [self.store eventsMatchingPredicate:pre];
    events = [events sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
    return [self filterdownloadedArr:events];
}

/**
 过滤本地下载过的日历类别
 @return 经过过滤的日历
 */
-(NSArray *)filterdownloadedArr:(NSArray *)arr
{
    
    NSMutableArray *filterArr = [[NSMutableArray alloc] init];
    
    for (EKEvent *event in arr) {
        
        if ([event.calendar.title  isEqual: kAttentionType])
            [filterArr addObject:event];
    }
    
    return [filterArr copy];
}

@end
