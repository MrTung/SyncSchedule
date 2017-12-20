//
//  EventManger.h
//  CalendarEventSdk
//
//  Created by Clement on 15/1/5.
//  Copyright (c) 2015年 Clement. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EventManger : NSObject

+(instancetype)shareInstance;

-(NSArray *)getTodayEvent;
-(NSArray *)getThisWeekEventFromSunday;
-(NSArray *)getThisWeekEventFromMonday;
-(NSArray *)getThisMonthFromFirstDay;
-(NSArray *)getThisMonthFromFifteenDaysAgo;


-(NSArray *)getThisMonthFromFifteenDaysAgoLocal;

-(EKEventStore *)store;

-(BOOL)deleteEvent:(EKEvent *)event;
-(BOOL)createEvent:(EKEvent *)event;
-(BOOL)saveEvent:(EKEvent *)event;
-(void)creatSharedCalendar;
@end
