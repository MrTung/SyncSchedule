//
//  MsgModel.h
//  SyncSchedule
//
//  Created by greatstar on 2017/4/7.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgModel : NSObject


/**消息ID*/
@property (nonatomic, copy) NSString *msgId;

/**消息内容*/
@property (nonatomic, copy) NSString *msgContent;

/**消息状态，0:未处理，1：同意，2：拒绝*/
@property (nonatomic, copy) NSString *state;

/**消息发送方用户ID*/
@property (nonatomic, copy) NSString *msgSenderId;

@end
