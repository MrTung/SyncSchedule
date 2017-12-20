//
//  ScheduleModel.m
//  SyncSchedule
//
//  Created by greatstar on 2017/3/31.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import "ScheduleModel.h"

@implementation ScheduleModel


+(NSArray <ScheduleModel *> *)scheduleArrWithEvent:(NSArray <EKEvent *>*)eventArr
{
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    
    for (EKEvent *event in eventArr)
    {
        ScheduleModel *model = [[ScheduleModel alloc] init];
        model.contentDigest = @"我是摘要";
        model.title = event.title;
        model.startDate = event.startDate;
        model.ownerId = @"00001";
        model.ownerName = @"admin";
        model.calendarType = event.calendar.title;
        model.endDate = event.endDate;
        model.notes = event.notes && event.notes.length > 0 ? event.notes : @"";
//        model.alarms = event.alarms;
//        model.url= [NSString stringWithFormat:@"%@",event.URL];
        [tempArr addObject:model];
    }
    return tempArr;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    unsigned int count = 0;
    // 利用runtime获取实例变量的列表
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i ++) {
        // 取出i位置对应的实例变量
        Ivar ivar = ivars[i];
        // 查看实例变量的名字
        const char *name = ivar_getName(ivar);
        // C语言字符串转化为NSString
        NSString *nameStr = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        // 利用KVC取出属性对应的值
        id value = [self valueForKey:nameStr];
        // 归档
        [encoder encodeObject:value forKey:nameStr];
    }
    // 记住C语言中copy出来的要进行释放
    free(ivars);
}
//解档
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i ++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            //
            NSString *key = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            id value = [decoder decodeObjectForKey:key];
            // 设置到成员变量身上
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}

//-(id)copyWithZone:(NSZone *)zone
//{
//    ScheduleModel *vo = [[[self class] allocWithZone:zone] init];
//    vo.member_id = [self.member_id copyWithZone:zone];
//    vo.key = [self.key copyWithZone:zone];
//    vo.old_id = [self.old_id copyWithZone:zone];
//    vo.member_mobile = [self.member_mobile copyWithZone:zone];
//    vo.logintype = [self.logintype copyWithZone:zone];
//    vo.pwd = [self.pwd copyWithZone:zone];
//    return vo;
//}

@end
