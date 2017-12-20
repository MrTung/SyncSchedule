//
//  Networking.m
//  NetworkingCraft
//
//  Created by YouXianMing on 15/6/11.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import "Networking.h"
#import "AFNetworking.h"

typedef enum : NSUInteger {
    
    DEALLOC_CANCEL,  // dealloc取消
    USER_CANCEL,     // 用户取消
    
} ECancelType;

@interface Networking ()

#pragma mark - Private Instance
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) AFHTTPRequestOperation        *httpOperation;
@property (nonatomic)         ECancelType                    cancelType;

#pragma mark - Private Method

/**
 *  默认设置
 */
- (void)defaultConfig;

/**
 *  根据序列化枚举值返回对应的请求策略
 *
 *  @param serializerType 序列化枚举值
 *
 *  @return 序列化策略
 */
+ (AFHTTPRequestSerializer *)requestSerializerWith:(AFNetworkingRequestType)serializerType;

/**
 *  根据序列化枚举值返回对应的回复策略
 *
 *  @param serializerType 序列化枚举值
 *
 *  @return 序列化策略
 */
+ (AFHTTPResponseSerializer *)responseSerializerWith:(AFNetworkingResponseType)serializerType;

@end

@implementation Networking

/**
 *  初始化方法
 *
 *  @return 实例对象
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        
        // 默认设置
        [self defaultConfig];
    }
    return self;
}

- (void)defaultConfig {
    self.manager = [AFHTTPRequestOperationManager manager];
}


- (void)startRequest {
    
    if (self.urlString.length <= 0) {
        return;
    }
    
    // 设置请求类型
    if (self.requestType) {
        self.manager.requestSerializer  = [Networking requestSerializerWith:self.requestType];
    } else {
        self.manager.requestSerializer  = [Networking requestSerializerWith:HTTPRequestType];
    }
    
    // 设置回复类型
    if (self.responseType) {
        self.manager.responseSerializer = [Networking responseSerializerWith:self.responseType];
        self.manager.responseSerializer.acceptableContentTypes = \
        [self.manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    } else {
        self.manager.responseSerializer = [Networking responseSerializerWith:HTTPResponseType];
        self.manager.responseSerializer.acceptableContentTypes = \
        [self.manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    }
    
    // 设置超时时间
    if (self.timeoutInterval && self.timeoutInterval.floatValue > 0) {
        [self.manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        self.manager.requestSerializer.timeoutInterval = self.timeoutInterval.floatValue;
        [self.manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    
    // 开始执行请求
    if (self.RequestMethod == GET_METHOD) {
        
        __weak Networking *weakSelf = self;
        self.httpOperation = [self.manager GET:self.urlString
                                    parameters:[weakSelf transformRequestDictionary]
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSucess:data:)]) {
                                               [weakSelf.delegate requestSucess:weakSelf data:[weakSelf transformRequestData:responseObject]];
                                           }
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           
                                           if (self.cancelType == USER_CANCEL) {
                                               if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userCanceledFailed:error:)]) {
                                                   [weakSelf.delegate userCanceledFailed:weakSelf error:error];
                                                   weakSelf.cancelType = DEALLOC_CANCEL;
                                               }
                                           } else {
                                               if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:error:)]) {
                                                   [weakSelf.delegate requestFailed:weakSelf error:error];
                                               }
                                           }
                                           
                                       }];
        
    } else if (self.RequestMethod == POST_METHOD) {
        
        __weak Networking *weakSelf = self;
        self.httpOperation = [self.manager POST:self.urlString
                                     parameters:[weakSelf transformRequestDictionary]
                                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSucess:data:)]) {
                                                [weakSelf.delegate requestSucess:weakSelf data:[weakSelf transformRequestData:responseObject]];
                                            }
                                            
                                        }
                                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                            if (self.cancelType == USER_CANCEL) {
                                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userCanceledFailed:error:)]) {
                                                    [weakSelf.delegate userCanceledFailed:weakSelf error:error];
                                                    weakSelf.cancelType = DEALLOC_CANCEL;
                                                }
                                            } else {
                                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:error:)]) {
                                                    [weakSelf.delegate requestFailed:weakSelf error:error];
                                                }
                                            }
                                            
                                        }];
        
    } else if (self.RequestMethod == UPLOAD_DATA) {
        
        if (self.constructingBodyBlock) {
            __weak Networking *weakSelf = self;
            self.httpOperation = [self.manager POST:self.urlString
                                         parameters:[weakSelf transformRequestDictionary]
                          constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                              
                              weakSelf.constructingBodyBlock(formData);
                              
                          }
                                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSucess:data:)]) {
                                                    [weakSelf.delegate requestSucess:weakSelf data:[weakSelf transformRequestData:responseObject]];
                                                }
                                                
                                            }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                if (self.cancelType == USER_CANCEL) {
                                                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userCanceledFailed:error:)]) {
                                                        [weakSelf.delegate userCanceledFailed:weakSelf error:error];
                                                        weakSelf.cancelType = DEALLOC_CANCEL;
                                                    }
                                                } else {
                                                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:error:)]) {
                                                        [weakSelf.delegate requestFailed:weakSelf error:error];
                                                    }
                                                }
                                                
                                            }];
        } else {
            
            __weak Networking *weakSelf = self;
            self.httpOperation = [self.manager POST:self.urlString
                                         parameters:[weakSelf transformRequestDictionary]
                          constructingBodyWithBlock:nil
                                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSucess:data:)]) {
                                                    [weakSelf.delegate requestSucess:weakSelf data:[weakSelf transformRequestData:responseObject]];
                                                }
                                                
                                            }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                if (self.cancelType == USER_CANCEL) {
                                                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userCanceledFailed:error:)]) {
                                                        [weakSelf.delegate userCanceledFailed:weakSelf error:error];
                                                        weakSelf.cancelType = DEALLOC_CANCEL;
                                                    }
                                                } else {
                                                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:error:)]) {
                                                        [weakSelf.delegate requestFailed:weakSelf error:error];
                                                    }
                                                }
                                                
                                            }];
        }
        
    }
}

- (void)cancelRequest {
    self.cancelType = USER_CANCEL;
    [self.httpOperation cancel];
}

- (void)dealloc {
    self.cancelType = DEALLOC_CANCEL;
    [self.httpOperation cancel];
}

+ (AFHTTPRequestSerializer *)requestSerializerWith:(AFNetworkingRequestType)serializerType {
    if (serializerType == JSONRequestType) {
        return [AFJSONRequestSerializer serializer];
    } else if (serializerType == HTTPRequestType) {
        return [AFHTTPRequestSerializer serializer];
    } else if (serializerType == PlistRequestType) {
        return [AFPropertyListRequestSerializer serializer];
    } else {
        return nil;
    }
}

+ (AFHTTPResponseSerializer *)responseSerializerWith:(AFNetworkingResponseType)serializerType {
    if (serializerType == JSONResponseType) {
        return [AFJSONResponseSerializer serializer];
    } else if (serializerType == HTTPResponseType) {
        return [AFHTTPResponseSerializer serializer];
    } else if (serializerType == PlistResponseType) {
        return [AFPropertyListResponseSerializer serializer];
    } else if (serializerType == ImageResponseType) {
        return [AFImageResponseSerializer serializer];
    } else if (serializerType == CompoundResponseType) {
        return [AFCompoundResponseSerializer serializer];
    } else {
        return nil;
    }
}

- (NSDictionary *)transformRequestDictionary {
    return self.requestDictionary;
}

- (id)transformRequestData:(id)data {
    return data;
}

+ (instancetype)networkingWithUrlString:(NSString *)urlString
                      requestDictionary:(NSDictionary *)requestDictionary
                               delegate:(id)delegate
                        timeoutInterval:(NSNumber *)timeoutInterval
                                   flag:(NSString *)flag
                          requestMethod:(AFNetworkingRequestMethod)requestMethod
                            requestType:(AFNetworkingRequestType)requestType
                           responseType:(AFNetworkingResponseType)responseType {
    
    Networking *networking       = [[[self class] alloc] init];
    networking.urlString         = urlString;
    networking.requestDictionary = requestDictionary;
    networking.delegate          = delegate;
    networking.timeoutInterval   = timeoutInterval;
    networking.flag              = flag;
    networking.RequestMethod     = requestMethod;
    networking.requestType       = requestType;
    networking.responseType      = responseType;
    
    return networking;
}

+ (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                timeoutInterval:(NSNumber *)timeInterval
                    requestType:(AFNetworkingRequestType)requestType
                   responseType:(AFNetworkingResponseType)responseType
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    
    AFHTTPRequestOperationManager *manager            = [AFHTTPRequestOperationManager manager];
    
    
    // 设置请求类型
    manager.requestSerializer                         = [Networking requestSerializerWith:requestType];
    
    
    // 设置回复类型
    manager.responseSerializer                        = [Networking responseSerializerWith:responseType];
    
    
    // 设置回复内容信息
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
    // 设置超时时间
    if (timeInterval) {
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = timeInterval.floatValue;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    
    
    AFHTTPRequestOperation *httpOperation = [manager GET:URLString
                                              parameters:parameters
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if (success) {
                                                         success(operation, responseObject);
                                                     }
                                                 }
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     if (failure) {
                                                         failure(operation, error);
                                                     }
                                                 }];
    
    
    return httpOperation;
}


+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                 timeoutInterval:(NSNumber *)timeInterval
                     requestType:(AFNetworkingRequestType)requestType
                    responseType:(AFNetworkingResponseType)responseType
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    
    AFHTTPRequestOperationManager *manager            = [AFHTTPRequestOperationManager manager];
    
    
    // 设置请求类型
    manager.requestSerializer                         = [Networking requestSerializerWith:requestType];
    
    
    // 设置回复类型
    manager.responseSerializer                        = [Networking responseSerializerWith:responseType];
    
    
    // 设置回复内容信息
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
    // 设置超时时间
    if (timeInterval) {
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = timeInterval.floatValue;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    
    
    AFHTTPRequestOperation *httpOperation = [manager POST:URLString
                                               parameters:parameters
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      if (success) {
                                                          success(operation, responseObject);
                                                      }
                                                  }
                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      if (failure) {
                                                          failure(operation, error);
                                                      }
                                                  }];
    
    
    return httpOperation;
}


+ (AFHTTPRequestOperation *)UploadDataWithUrlString:(NSString *)URLString
                                         parameters:(id)parameters
                                    timeoutInterval:(NSNumber *)timeInterval
                                        requestType:(AFNetworkingRequestType)requestType
                                       responseType:(AFNetworkingResponseType)responseType
                          constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    
    AFHTTPRequestOperationManager *manager            = [AFHTTPRequestOperationManager manager];
    
    
    // 设置请求类型
    manager.requestSerializer                         = [Networking requestSerializerWith:requestType];
    
    
    // 设置回复类型
    manager.responseSerializer                        = [Networking responseSerializerWith:responseType];
    
    
    // 设置回复内容信息
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
    // 设置超时时间
    if (timeInterval) {
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = timeInterval.floatValue;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    
    
    AFHTTPRequestOperation *httpOperation = [manager POST:URLString
                                               parameters:parameters
                                constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                    if (block) {
                                        block(formData);
                                    }
                                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    if (success) {
                                        success(operation, responseObject);
                                    }
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    if (failure) {
                                        failure(operation, error);
                                    }
                                }];
    
    
    return httpOperation;
}



@end
