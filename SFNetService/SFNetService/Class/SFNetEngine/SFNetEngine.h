//
//  SFNetEngine.h
//  duoduo
//
//  Created by Frank on 15/5/26.
//  Copyright (c) 2015年 benben. All rights reserved.
//

#import "SFNetConsts.h"
#import "AFNetworking.h"

@interface SFNetEngine : AFHTTPSessionManager

/**
 *	@brief	网络管理_网络状态
 */
@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;

/**
 *	@brief	网络管理的全局唯一单例
 *
 *	@return	SFNetEngine实例，全局唯一
 */
///记得调用是使用param: 方法,可以做定制处理,否则无效
+ (SFNetEngine*)shardInstance;

///加载类型
-(void)loadingStart:(NetLoad)type loadingText:(NSString *)loadingText;
//加载结束
-(void)loadingFinishsh:(NetLoad)type;
#pragma mark -
#pragma mark - Extends

///GET _RequestAF_3.0
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                        param:(id)parameters
               uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadBlock
             downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadBlock
                  loadingType:(NetLoad)type
                  loadingText:(NSString *)loadingText
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

///HEAD _RequestAF_3.0
- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                         param:(id)parameters
                uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadBlock
              downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadBlock
                   loadingType:(NetLoad)type
                   loadingText:(NSString *)loadingText
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
///POST _RequestAF_3.0
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                         param:(id)parameters
                uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadBlock
              downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadBlock
                   loadingType:(NetLoad)type
                   loadingText:(NSString *)loadingText
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

///POST _RequestAF_3.0[API模拟]
- (void)POST:(NSString *)URLString
       param:(id)parameters
 loadingType:(NetLoad)type
 loadingText:(NSString *)loadingText
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

///GET _RequestAF_3.0[API模拟]
- (void)GET:(NSString *)URLString
       param:(id)parameters
 loadingType:(NetLoad)type
 loadingText:(NSString *)loadingText
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;


///POST constructingBodyWithBlock _RequestAF_3.0
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                         param:(id)parameters
                uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadBlock
                   loadingType:(NetLoad)type
                   loadingText:(NSString *)loadingText
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

///PUT _RequestAF_3.0
- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                        param:(id)parameters
               uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadBlock
             downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadBlock
                  loadingType:(NetLoad)type
                  loadingText:(NSString *)loadingText
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
///PATCH _RequestAF_3.0
- (NSURLSessionDataTask *)PATCH:(NSString *)URLString
                          param:(id)parameters
                 uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadBlock
               downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadBlock
                    loadingType:(NetLoad)type
                    loadingText:(NSString *)loadingText
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
///DELETE _RequestAF_3.0
- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                           param:(id)parameters
                  uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadBlock
                downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadBlock
                     loadingType:(NetLoad)type
                     loadingText:(NSString *)loadingText
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;


///AF已经实现但是没有放出
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:( void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:( void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end
