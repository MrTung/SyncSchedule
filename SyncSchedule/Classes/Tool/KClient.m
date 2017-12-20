//
//  KClient.m
//  MyClient
//
//  Created by Kevin on 13-5-15.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "KClient.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

@implementation KClient

// 读取数据
static void readStream(CFReadStreamRef stream, CFStreamEventType eventType, void *clientCallBackInfo) {
    UInt8 buff[255];
    int ret = CFReadStreamRead(stream, buff, 255);
    KClient* context = (KClient*)CFBridgingRelease(clientCallBackInfo);

//    KAppDelegate* d= context.delegate;
//    [d ShowLog:[NSString stringWithFormat:@"recv: %s, count: %d", buff, ret]];
}

// socket回调函数的格式：
static void TCPServerConnectCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    if (data != NULL) {
        // 当socket为kCFSocketConnectCallBack时，失败时回调失败会返回一个错误代码指针，其他情况返回NULL
        NSLog(@"连接失败");
        return;
    }
    
    KClient *client = (KClient *)CFBridgingRelease(info);
    
    CFReadStreamRef iStream;
    
    CFSocketNativeHandle h = CFSocketGetNative(socket);
    CFStreamCreatePairWithSocket(kCFAllocatorDefault, h, &iStream, nil);
    //   CFStreamCreatePairWithSocket(kCFAllocatorDefault, socket, &iStream, nil);
    if (iStream) {
        CFStreamClientContext streamContext = {0, NULL, NULL, NULL};
        if (!CFReadStreamSetClient(iStream, kCFStreamEventHasBytesAvailable |
                                   kCFStreamEventErrorOccurred | kCFStreamEventEndEncountered,
                                   readStream, // 回调函数，当有可读的数据时调用
                                   &streamContext)){
            exit(1);
        }
        
        CFReadStreamScheduleWithRunLoop(iStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
  //      CFReadStreamOpen(iStream);
        
        //       size_t sent = send(CFSocketGetNative(socket), "client sent", 11, 0);
        
        char buf[100] = {0};
        //    recv(CFSocketGetNative(socket), buf, 100, 0);
        
        printf("recv: %s", buf);
    }

    
}

-(void) CreateSocketClient: (NSString*) serverIP PORT: (in_port_t) port
{
    CFSocketContext sockContext = {0, // 结构体的版本，必须为0
        CFBridgingRetain(self),  // 一个任意指针的数据，可以用在创建时CFSocket对象相关联。这个指针被传递给所有的上下文中定义的回调。
        NULL, // 一个定义在上面指针中的retain的回调， 可以为NULL
        NULL, NULL};
    
    _client = CFSocketCreate(
                   kCFAllocatorDefault,
                   PF_INET,        // The protocol family for the socket
                   SOCK_STREAM,    // The socket type to create
                   IPPROTO_TCP,    // The protocol for the socket. TCP vs UDP.
                   kCFSocketConnectCallBack,  // New connections will be automatically accepted and the callback is called with the data argument being a pointer to a CFSocketNativeHandle of the child socket.
                   (CFSocketCallBack)&TCPServerConnectCallBack,
                   &sockContext );
    
    
    if (_client != nil) {
        int existingValue = 1;
        
        // Make sure that same listening socket address gets reused after every connection
        setsockopt( CFSocketGetNative(_client),
                   SOL_SOCKET, SO_REUSEADDR, (void *)&existingValue,
                   sizeof(existingValue));

        
        struct sockaddr_in addr4;   // IPV4
        memset(&addr4, 0, sizeof(addr4));
        addr4.sin_len = sizeof(addr4);
        addr4.sin_family = AF_INET;
        addr4.sin_port = htons(port);
        addr4.sin_addr.s_addr = inet_addr([serverIP UTF8String]);  // 把字符串的地址转换为机器可识别的网络地址
        
        // 把sockaddr_in结构体中的地址转换为Data
        CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr4, sizeof(addr4));
        CFSocketConnectToAddress(_client, // 连接的socket
                                 address, // CFDataRef类型的包含上面socket的远程地址的对象
                                 -1  // 连接超时时间，如果为负，则不尝试连接，而是把连接放在后台进行，如果_socket消息类型为kCFSocketConnectCallBack，将会在连接成功或失败的时候在后台触发回调函数
                                 );
        
        CFRunLoopRef cRunRef = CFRunLoopGetCurrent();    // 获取当前线程的循环
        // 创建一个循环，但并没有真正加如到循环中，需要调用CFRunLoopAddSource
        CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _client, 0);
        CFRunLoopAddSource(cRunRef, // 运行循环
                           sourceRef,  // 增加的运行循环源, 它会被retain一次
                           kCFRunLoopCommonModes  // 增加的运行循环源的模式
                           );
        CFRelease(sourceRef);
        
                

    }
    
   
}
    
@end
