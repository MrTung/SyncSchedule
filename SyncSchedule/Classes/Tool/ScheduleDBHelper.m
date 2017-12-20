//
//  ScheduleDBHelper.m
//  SyncSchedule
//
//  Created by greatstar on 2017/3/31.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import "ScheduleDBHelper.h"

@interface ScheduleDBHelper ()
{
    BOOL isSuccess;
}
@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) FMDatabaseQueue *queue;

@end
@implementation ScheduleDBHelper

+(ScheduleDBHelper *)shareScheduleDBHelper
{
    static ScheduleDBHelper *shareScheduleDBHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareScheduleDBHelper = [[ScheduleDBHelper alloc]init];
        
        [shareScheduleDBHelper creatDataBase];
    });
    return shareScheduleDBHelper;
}


#pragma mark - 创建数据库

- (void)creatDataBase {
    
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"db.sqlite"];
    
    NSLog(@"%@", dbPath);
    
    self.db = [FMDatabase databaseWithPath:dbPath];
    self.queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    
    [self.db open];
    
    // 创建 text 列表
    [self creatTable];
    
    [self debug_creatTable];
}

#pragma mark - Schedule

/***
 *  创建 Schedule 列表
 */
- (void)creatTable {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        isSuccess = [self.db executeUpdate:@"create table if not exists Schedule(id integer primary key autoincrement,contentDigest text, title text, startDate number, endDate number, notes text, calendarType text)"];
        
        NSLog(@"%@", isSuccess ? @"Schedule 表格创建成功":@"Schedule 表格创建失败");
        
    }];
}

/***
 *  创建 Schedule 保存接口
 */
- (void)saveScheduleModel:(ScheduleModel *)model {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [self.db executeQuery:@"select *from Schedule where contentDigest = ?", model.contentDigest];
        if ([set next]) {
            
            NSString *valueStr = [set stringForColumn:@"contentDigest"];
            
            if ([valueStr isEqualToString:model.contentDigest])
            {
                NSString *sql1 = [NSString stringWithFormat:@"update Schedule set startDate = '%@' where contentDigest = '%@'", model.beginTime, valueStr];
                
                NSString *sql2 = [NSString stringWithFormat:@"update Schedule set endDate = '%@' where contentDigest = '%@'", model.endTime, valueStr];
                
                NSString *sql3 = [NSString stringWithFormat:@"update Schedule set notes = '%@' where contentDigest = '%@'", model.notes, valueStr];

                NSString *sql4 = [NSString stringWithFormat:@"update Schedule set calendarType = '%@' where contentDigest = '%@'", model.calendarType, valueStr];

                if ([self.db executeUpdate:sql1] && [self.db executeUpdate:sql2] && [self.db executeUpdate:sql3] && [self.db executeUpdate:sql4]) {
                    NSLog(@"修改日程成功!");
                }else{
                    NSLog(@"修改日程失败!");
                }
            }
        }
        else
        {
            NSString *sql0 = [NSString stringWithFormat:@"insert into Schedule (contentDigest, title, startDate, endDate, notes, calendarType) values ('%@', '%@', %@, %@, '%@', '%@')",
                              model.contentDigest, model.title, model.beginTime,model.endTime, model.notes, model.calendarType];

            isSuccess = [self.db executeUpdate:sql0];
            
             NSLog(@"%@", isSuccess ? @"Schedule保存成功":@"Schedule保存失败");
        }
    }];
    
}

/***
 *  根据 startDate 查找 Schedule数据
 */
- (NSArray *)searchScheduleByStartDate:(NSString *)startDate
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    FMResultSet *set = [self.db executeQuery:@"select *from Schedule where startDate > ?", startDate];
    
    while ([set next]) {
        
        ScheduleModel *model = [[ScheduleModel alloc] init];
        
        NSString *contentDigest = [set stringForColumn:@"contentDigest"];
        NSString *title = [set stringForColumn:@"title"];
        NSString *startDateStr = [set stringForColumn:@"startDate"];
        NSString *endDateStr = [set stringForColumn:@"endDate"];
        NSString *notes = [set stringForColumn:@"notes"];
        NSString *calendarType = [set stringForColumn:@"calendarType"];

        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
//        NSDate *beginTime = [formatter dateFromString:startDateStr];
//        NSDate *endTime = [formatter dateFromString:endDateStr];

        model.contentDigest = contentDigest;
        model.title = title;
        model.beginTime = startDateStr;
        model.endTime = endDateStr;
        model.notes = notes;
        model.calendarType = calendarType;

        [arr addObject:model];
    }
    
    return [arr copy];
}




#pragma mark - Schedule

- (void)debug_creatTable{
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        isSuccess = [self.db executeUpdate:@"create table if not exists Debug(id integer primary key autoincrement,content text, time text)"];
        
        NSLog(@"%@", isSuccess ? @"Schedule 表格创建成功":@"Schedule 表格创建失败");
        
    }];
}


- (void)debug_save:(NSString *)str time:(NSString *)time{
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
            NSString *sql = [NSString stringWithFormat:@"insert into Debug (content, time) values ('%@', '%@')", str, time];
            
            isSuccess = [self.db executeUpdate:sql];
            
            NSLog(@"%@", isSuccess ? @"Debug保存成功":@"Debug保存失败");
    }];
    
}

- (NSArray *)debug_search
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    FMResultSet *set = [self.db executeQuery:@"select *from Debug order by id desc"];
    
    while ([set next]) {
        
        NSString *content = [set stringForColumn:@"content"];
        NSString *time = [set stringForColumn:@"time"];
 
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:content forKey:@"content"];
        [dict setObject:time forKey:@"time"];

        [arr addObject:dict];
    }
    
    return [arr copy];
}


@end
