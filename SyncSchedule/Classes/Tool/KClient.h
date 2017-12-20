//
//  KClient.h
//  MyClient
//
//  Created by Kevin on 13-5-15.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KClient : NSObject
{
    CFSocketRef _client;
}

-(void) CreateSocketClient: (NSString*) serverIP PORT: (in_port_t) port;
@property(nonatomic, assign) id delegate;

@end
