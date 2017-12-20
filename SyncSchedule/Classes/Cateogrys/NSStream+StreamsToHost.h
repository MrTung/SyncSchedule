//
//  NSStream+StreamsToHost.h
//  SyncSchedule
//
//  Created by greatstar on 2017/4/14.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStream (StreamsToHost)
+ (void)getStreamsToHostNamed:(NSString *)hostName
                         port:(NSInteger)port
                  inputStream:(out NSInputStream **)inputStreamPtr
                 outputStream:(out NSOutputStream **)outputStreamPtr;
@end
