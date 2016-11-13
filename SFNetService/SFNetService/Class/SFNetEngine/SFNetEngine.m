//
//  SFNetEngine.m
//  duoduo
//
//  Created by Frank on 15/5/26.
//  Copyright (c) 2015年 benben. All rights reserved.
//

#import "SFNetEngine.h"
#import "SFBaseService.h"

#define SERVERURL @"www.baidu.com"

@interface SFNetEngine()
@end

typedef NS_ENUM(NSInteger,RequestType) {
    RequestType_GET = 0,
    RequestType_POST,
    RequestType_PUT,
    RequestType_HEAD,
    RequestType_PATCH,
    RequestType_DELETE,
};

///3.0切换 2.X废弃
@implementation SFNetEngine

+ (SFNetEngine*)shardInstance
{
    static dispatch_once_t onceToken;
    static SFNetEngine * _engine;
    dispatch_once(&onceToken,^{
        
        _engine = [[self alloc] initWithBaseURL:[NSURL URLWithString: SERVERURL]];
        //_engine.securityPolicy = [self getAFSecurityPolicy];//**设置Https策略
        _engine.networkStatus = AFNetworkReachabilityStatusReachableViaWiFi;//AFNetworkReachabilityStatusUnknow;
    });
    
    [_engine addBascDataToHeader];
    
    return _engine;
}
+(AFSecurityPolicy *)getAFSecurityPolicy{
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"crt"];
    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 是否允许,NO-- 不允许无效的证书
    [securityPolicy setAllowInvalidCertificates:YES];
    // 设置证书
    [securityPolicy setPinnedCertificates:[NSSet setWithObject:certData]];
    
    return securityPolicy;
}
#pragma mark -
#pragma mark - BusinessLogic
-(void)loadingStart:(NetLoad)type loadingText:(NSString *)loadingText{
    if(NetLoad_None==type){
        return;
    }
    BOOL isModel = YES;
    BOOL isNeedShow = YES;
    
    switch (type) {
        case NetLoad_Common_ReqShow_ResCose:{
            isModel = NO;
        }break;
        case NetLoad_Common_ReqShow_ResShow:{
            isModel = NO;
        }break;
        case NetLoad_None:{
            isModel = NO;
            isNeedShow = NO;
        }break;
        default:
            break;
    }
    if(isNeedShow){
        dispatch_async(dispatch_get_main_queue(), ^{
            //[[GiFHUD instance] showModel:isModel loadingText:loadingText];
        });
    }
}
-(void)loadingFinishsh:(NetLoad)type{
    if(NetLoad_None==type){
        return;
    }
    BOOL isNeedHidden = YES;
    
    switch (type) {
        case NetLoad_Common_ReqShow_ResShow:{
            isNeedHidden = NO;
        }break;
        case NetLoad_Model_ReqShow_ResShow:{
            isNeedHidden = NO;
        }break;
        default: break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if(isNeedHidden){
            //[[GiFHUD instance] dismiss];
        }
    });
    
}

#pragma mark -
#pragma mark - Extends
-(NSURLSessionDataTask *)requestType:(RequestType)typeR URLString:(NSString *)URLString
                               param:(id)parameters
                      uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadBlock
                    downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadBlock
                         loadingType:(NetLoad)type
                         loadingText:(NSString *)loadingText
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure{
    
    NSString * requestType = @"GET";
    switch (typeR) {
        case RequestType_POST:{
            requestType = @"POST";
        }break;
        case RequestType_PUT:{
            requestType = @"PUT";
        }break;
        case RequestType_DELETE:{
            requestType = @"DELETE";
        }break;
        case RequestType_HEAD:{
            requestType = @"HEAD";
        }break;
        case RequestType_PATCH:{
            requestType = @"PATCH";
        }break;
        case RequestType_GET:{
            requestType = @"GET";
        }break;
        default: break;
    }
    
    //NSArray *exceptArray = @[@"\a",@"\b" ,@"\f" ,@"\n" ,@"\r" ,@"\t" ,@"\v" ,@"\\",@"\'" ,@"\""  ,@"\?" ,@"\0"  ,@"\\ddd" ,@"\\xhh"];
    NSDictionary *dictParm = [SFBaseService getCheckedDictionary:parameters];
    
    [self loadingStart:type loadingText:loadingText];
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:requestType URLString:URLString parameters:dictParm
    uploadProgress:^(NSProgress *uploadProgress) {
        if(uploadBlock)uploadBlock(uploadProgress);
    }downloadProgress:^(NSProgress * downloadProgress) {
        if(downloadBlock)downloadBlock(downloadProgress);
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self loadingFinishsh:type];
        if(success)success(responseObject);
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self loadingFinishsh:type];
        if(failure)failure(error);
    }];
    [dataTask resume];
    return dataTask;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                        param:(id)parameters
               uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadBlock
             downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadBlock
                  loadingType:(NetLoad)type
                  loadingText:(NSString *)loadingText
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure{
    return [self requestType:(RequestType_GET) URLString:URLString param:parameters uploadProgress:uploadBlock downloadProgress:downloadBlock loadingType:type loadingText:loadingText success:success failure:failure];
}

- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                         param:(id)parameters
                uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadBlock
              downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadBlock
                   loadingType:(NetLoad)type
                   loadingText:(NSString *)loadingText
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure{
    return [self requestType:(RequestType_HEAD) URLString:URLString param:parameters uploadProgress:uploadBlock downloadProgress:downloadBlock loadingType:type loadingText:loadingText success:success failure:failure];
}

- (void)POST:(NSString *)URLString
       param:(id)parameters
 loadingType:(NetLoad)type
 loadingText:(NSString *)loadingText
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure{
    [self requestType:(RequestType_POST) URLString:URLString param:parameters uploadProgress:nil downloadProgress:nil loadingType:type loadingText:loadingText success:success failure:failure];
}
- (void)GET:(NSString *)URLString
      param:(id)parameters
loadingType:(NetLoad)type
loadingText:(NSString *)loadingText
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure{
    [self requestType:(RequestType_GET) URLString:URLString param:parameters uploadProgress:nil downloadProgress:nil loadingType:type loadingText:loadingText success:success failure:failure];
}
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                         param:(id)parameters
                uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadBlock
              downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadBlock
                   loadingType:(NetLoad)type
                   loadingText:(NSString *)loadingText
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure{
    return [self requestType:(RequestType_POST) URLString:URLString param:parameters uploadProgress:uploadBlock downloadProgress:downloadBlock loadingType:type loadingText:loadingText success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                         param:(id)parameters
                uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadBlock
                   loadingType:(NetLoad)type
                   loadingText:(NSString *)loadingText
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure{
    [self loadingStart:type loadingText:loadingText];
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:block progress:^(NSProgress *downloadProgress) {
        if(uploadBlock)uploadBlock(downloadProgress);
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        [self loadingFinishsh:type];
        if(success)success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self loadingFinishsh:type];
        if(failure)failure(error);
    }];
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                        param:(id)parameters
               uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadBlock
             downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadBlock
                  loadingType:(NetLoad)type
                  loadingText:(NSString *)loadingText
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure{
    return [self requestType:(RequestType_PUT) URLString:URLString param:parameters uploadProgress:uploadBlock downloadProgress:downloadBlock loadingType:type loadingText:loadingText success:success failure:failure];
}
///PATCH
- (NSURLSessionDataTask *)PATCH:(NSString *)URLString
                          param:(id)parameters
                 uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadBlock
               downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadBlock
                    loadingType:(NetLoad)type
                    loadingText:(NSString *)loadingText
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure{
    return [self requestType:(RequestType_PATCH) URLString:URLString param:parameters uploadProgress:uploadBlock downloadProgress:downloadBlock loadingType:type loadingText:loadingText success:success failure:failure];
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                           param:(id)parameters
                  uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadBlock
                downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadBlock
                     loadingType:(NetLoad)type
                     loadingText:(NSString *)loadingText
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure{
    return [self requestType:(RequestType_DELETE) URLString:URLString param:parameters uploadProgress:uploadBlock downloadProgress:downloadBlock loadingType:type loadingText:loadingText success:success failure:failure];
}
#pragma mark -
#pragma mark - LifeCyle

- (void)addBascDataToHeader{
    //Header中包括的基础数据
//    NSString * deviceUDID = [UIDevice deviceUDID];
//    //UIDevice *device = [UIDevice currentDevice];
//    
//    //NSString * dToken = config.deviceToken?config.deviceToken:@"0";
//    [self.requestSerializer setValue:[config appVersion] forHTTPHeaderField:@"appversion"];
//    [self.requestSerializer setValue:[UIDevice deviceSystemName] forHTTPHeaderField:@"osname"];
//    [self.requestSerializer setValue:[UIDevice deviceSystemVersion] forHTTPHeaderField:@"osversion"];
//    [self.requestSerializer setValue:[UIDevice deviceName] forHTTPHeaderField:@"devicename"];
//    
//    [self.requestSerializer setValue:deviceUDID forHTTPHeaderField:@"deviceid"];
//    [self.requestSerializer setValue:deviceUDID forHTTPHeaderField:@"devicetoken"];
//    [self.requestSerializer setValue:@"App" forHTTPHeaderField:@"User-Agent"];
}

+ (void)load{
    AFNetworkReachabilityManager *sharedManager = [AFNetworkReachabilityManager sharedManager];
    [sharedManager startMonitoring];
    [sharedManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        //设置网络处理
        [self shardInstance].networkStatus = status;
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                NSLog(@"当前网络状况未知");
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"当前无网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"当前是3/4/5G网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"当前是WIFI网络");
                break;
            }
        }
    }];
}
@end
