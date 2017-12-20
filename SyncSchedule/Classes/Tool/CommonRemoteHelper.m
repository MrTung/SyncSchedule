//
//  CommonRemoteHelper.m
//  GPSNavDemo
//
//  Created by 董徐维 on 15/3/16.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "CommonRemoteHelper.h"
#import "Networking.h"

@interface CommonRemoteHelper()

@end

@implementation CommonRemoteHelper

+(AFHTTPRequestOperationManager *)sharedInstance
{
    static AFHTTPRequestOperationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        manager.requestSerializer.timeoutInterval = 20;
    });
    return manager;
}

//  = HTTP请求格式 =
//  ------------------------------
//  * 请求方法 (GET、POST等)       *
//  * 请求头   (HttpHeaderFields) *
//  * 请求正文 (数据)              *
//  ------------------------------
+(void)RemoteWithUrl:(NSString *)url  parameters:(id)parameters  type:(CommonRemoteType)type
             success:(void (^)(NSDictionary *dict, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *dict = [(NSDictionary *)parameters mutableCopy];
   
    if (type == CommonRemoteTypePost)
    {
        // 请求的方法
        [[CommonRemoteHelper sharedInstance] POST:url
                                       parameters:dict
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *html = operation.responseString;
                                              NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                                              NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                                              id codeNum = [dict objectForKey:@"code"];
                                              if (dict == nil)
                                              {
                                                  NSLog(@"返回值为空......");
                                                  success(dict,responseObject);
                                              }
                                              else if ([codeNum isKindOfClass:[NSString class]] && [codeNum isEqualToString: @"14001"])
                                              {
                                                  NSLog(@"登录信息过期,请重新登录");
                                                  //取消所有的网络请求
                                                  [[CommonRemoteHelper sharedInstance].operationQueue cancelAllOperations];
                                                  
                                                  success(dict,responseObject);
                                              }
                                              else
                                              {
                                                  success(dict,responseObject);
                                              }
                                          }
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              failure(operation,error);
                                              NSLog(@"出错了......");
                                              if(error.code == NSURLErrorCancelled)  {
                                              }
                                          }];
    }
    else if (type == CommonRemoteTypeGet)
    {
        // 请求的方法
        [[CommonRemoteHelper sharedInstance] GET:url
                                      parameters:dict
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             NSString *html = operation.responseString;
                                             NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                                             NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                                             success(dict,responseObject);
                                             // 请求头部信息(我们执行网络请求的时候给服务器发送的包头信息)
                                             NSLog(@"%@", operation.request.allHTTPHeaderFields);
                                             
                                             // 服务器给我们返回的包得头部信息
                                             NSLog(@"%@", operation.response);
                                             
                                             // 返回的数据
                                             NSLog(@"%@", responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(operation,error);
                                         }];
    }
}

+(void)UploadPicWithUrl:(NSString *)url  parameters:(id)parameters  type:(CommonRemoteType)type
                dataObj:(NSData *)dataObj success:(void (^)(NSDictionary *dict, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [Networking UploadDataWithUrlString:@""
                             parameters:parameters
                        timeoutInterval:nil
                            requestType:HTTPRequestType
                           responseType:JSONResponseType
              constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                  [formData appendPartWithFileData:dataObj name:@"pic" fileName:@"img.png" mimeType:@"image/png"];
              }
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    NSString *html = operation.responseString;
                                    NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                                    NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                                    success(dict,responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failure(operation,error);
                                }];
}


+(void)UploadPicWithUrl:(NSString *)url parameters:(id)parameters  images:(NSArray *)imageArray success:(void (^)(NSDictionary *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [[CommonRemoteHelper sharedInstance] POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         for (NSDictionary *dict in imageArray)
         {
             [formData appendPartWithFileData:dict[@"fileData"] name:dict[@"name"] fileName:dict[@"fileName"] mimeType:dict[@"mimeType"]];
         }
         
     } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
         NSString *html = operation.responseString;
         NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
         success(dict,responseObject);
         
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         failure(operation,error);
     }];
}


@end
