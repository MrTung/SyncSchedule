//
//  UserModel.h
//  SyncSchedule
//
//  Created by greatstar on 2017/4/7.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, copy) NSString *responseMsg;

@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *userName;
@end
