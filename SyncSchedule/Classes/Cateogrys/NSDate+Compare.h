//
//  NSDate+Compare.h
//  SyncSchedule
//
//  Created by greatstar on 2017/5/18.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Compare)
+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
@end
