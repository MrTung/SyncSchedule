//
//  Networking.h
//  NetworkingCraft
//
//  Created by YouXianMing on 15/6/11.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//
//  https://en.wikipedia.org/wiki/List_of_HTTP_header_fields
//  https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol
//
//  = HTTP请求格式 =
//  ------------------------------
//  * 请求方法 (GET、POST等)       *
//  * 请求头   (HttpHeaderFields) *
//  * 请求正文 (数据)              *
//  ------------------------------
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@class Networking;


typedef void(^ConstructingBodyBlock)(id<AFMultipartFormData> formData);


typedef enum : NSUInteger {
    
    GET_METHOD,                  // GET请求
    POST_METHOD,                 // POST请求
    UPLOAD_DATA,                 // 上传文件的请求(POST请求)
    
} AFNetworkingRequestMethod;


typedef enum : NSUInteger {
    
    HTTPRequestType = 0x11,      // 二进制格式 (不设置的话为默认格式)
    JSONRequestType,             // JSON方式
    PlistRequestType,            // 集合文件方式
    
} AFNetworkingRequestType;


typedef enum : NSUInteger {
    
    HTTPResponseType = 0x22,     // 二进制格式 (不设置的话为默认格式)
    JSONResponseType,            // JSON方式
    PlistResponseType,           // 集合文件方式
    ImageResponseType,           // 图片方式
    CompoundResponseType,        // 组合方式
    
} AFNetworkingResponseType;


@protocol NetworkingDelegate <NSObject>
@optional
/**
 *  请求成功
 *
 *  @param networking Networking实例对象
 *  @param data       数据
 */
- (void)requestSucess:(Networking *)networking data:(id)data;

/**
 *  请求失败
 *
 *  @param networking Networking实例对象
 *  @param error      错误信息
 */
- (void)requestFailed:(Networking *)networking error:(NSError *)error;

/**
 *  用户取消请求
 *
 *  @param networking Networking实例对象
 *  @param error      错误信息
 */
- (void)userCanceledFailed:(Networking *)networking error:(NSError *)error;

@end

@interface Networking : NSObject

/**
 *  代理
 */
@property (nonatomic, weak)  id <NetworkingDelegate>  delegate;

/**
 *  标识符
 */
@property (nonatomic, strong) NSString               *flag;

/**
 *  超时时间间隔(设置了才能生效,不设置,使用的是AFNetworking自身的超时时间间隔)
 */
@property (nonatomic, strong) NSNumber               *timeoutInterval;

/**
 *  请求的类型
 */
@property (nonatomic) AFNetworkingRequestType         requestType;

/**
 *  回复的类型
 */
@property (nonatomic) AFNetworkingResponseType        responseType;

/**
 *  请求的方法类型
 */
@property (nonatomic) AFNetworkingRequestMethod       RequestMethod;

/**
 *  网络请求地址
 */
@property (nonatomic, strong) NSString               *urlString;

/**
 *  作为请求用字典
 */
@property (nonatomic, strong) NSDictionary           *requestDictionary;

/**
 *  构造数据用block(用于UPLOAD_DATA方法)
 */
@property (nonatomic, copy)   ConstructingBodyBlock   constructingBodyBlock;

/**
 *
 *  -====== 此方法由继承的子类来重载实现 ======-
 *
 *  转换请求字典
 *
 *  @return 转换后的字典
 */
- (NSDictionary *)transformRequestDictionary;

/**
 *
 *  -====== 此方法由继承的子类来重载实现 ======-
 *
 *  对返回的结果进行转换
 *
 *  @return 转换后的结果
 */
- (id)transformRequestData:(id)data;

/**
 *  开始请求
 */
- (void)startRequest;

/**
 *  取消请求
 */
- (void)cancelRequest;

#pragma mark - 便利构造器方法

/**
 *  便利构造器方法
 *
 *  @param urlString         请求地址
 *  @param requestDictionary 请求参数
 *  @param delegate          代理
 *  @param timeoutInterval   超时时间
 *  @param flag              标签
 *  @param requestMethod     请求方法
 *  @param requestType       请求类型
 *  @param responseType      回复数据类型
 *
 *  @return 实例对象
 */
+ (instancetype)networkingWithUrlString:(NSString *)urlString
                      requestDictionary:(NSDictionary *)requestDictionary
                               delegate:(id)delegate
                        timeoutInterval:(NSNumber *)timeoutInterval
                                   flag:(NSString *)flag
                          requestMethod:(AFNetworkingRequestMethod)requestMethod
                            requestType:(AFNetworkingRequestType)requestType
                           responseType:(AFNetworkingResponseType)responseType;

#pragma mark - block的形式请求

/**
 *  AFNetworking的GET请求
 *
 *  @param URLString    请求网址
 *  @param parameters   网址参数
 *  @param timeInterval 超时时间(可以设置为nil)
 *  @param requestType  请求类型
 *  @param responseType 返回结果类型
 *  @param success      成功时调用的block
 *  @param failure      失败时调用的block
 *
 *  @return 网络操作句柄
 */
+ (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                timeoutInterval:(NSNumber *)timeInterval
                    requestType:(AFNetworkingRequestType)requestType
                   responseType:(AFNetworkingResponseType)responseType
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  AFNetworking的POST请求
 *
 *  @param URLString    请求网址
 *  @param parameters   网址参数
 *  @param timeInterval 超时时间(可以设置为nil)
 *  @param requestType  请求类型
 *  @param responseType 返回结果类型
 *  @param success      成功时调用的block
 *  @param failure      失败时调用的block
 *
 *  @return 网络操作句柄
 */
+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                 timeoutInterval:(NSNumber *)timeInterval
                     requestType:(AFNetworkingRequestType)requestType
                    responseType:(AFNetworkingResponseType)responseType
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  上传文件(POST请求)
 *
 *  @param URLString    请求地址
 *  @param parameters   网址参数
 *  @param timeInterval 超时时间(可以设置为nil)
 *  @param requestType  请求类型
 *  @param responseType 返回结果类型
 *  @param block        构造上传数据
 *  @param success      成功时调用的block
 *  @param failure      失败时调用的block
 *
 *  @return 网络操作句柄
 */
+ (AFHTTPRequestOperation *)UploadDataWithUrlString:(NSString *)URLString
                                         parameters:(id)parameters
                                    timeoutInterval:(NSNumber *)timeInterval
                                        requestType:(AFNetworkingRequestType)requestType
                                       responseType:(AFNetworkingResponseType)responseType
                          constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
