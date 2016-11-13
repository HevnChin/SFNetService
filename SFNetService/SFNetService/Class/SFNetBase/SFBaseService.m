//
//  SFBaseService.m
//  duoduo
//
//  Created by Sage on 2015/08/02.
//  Copyright (c) 2015年 benben. All rights reserved.
//
#import "SFNetEngine.h"
#import "SFBaseService.h"

@interface SFBaseService()
@property (nonatomic, strong) NSDictionary *requestDict;
@property (nonatomic, assign) BOOL isPost;
@property (nonatomic,assign) BOOL isLoading;
@end

@implementation SFBaseService
+(id)getCheckedDictionary:(NSDictionary *)parameters{
    NSMutableDictionary *dictParm = [NSMutableDictionary dictionary];
    NSEnumerator *enumerator = [parameters keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        id value = [parameters objectForKey:key];
        NSDictionary *dict = @{key:value};
        if([value isKindOfClass:[NSString class]]){
            NSString *json = value;
            if(json.isJson){
                [dictParm addEntriesFromDictionary:dict];
                continue;
            }
        }
        NSString *jsonString = [NSString JSONValueFromObj:dict];
        NSDictionary *jsonDict = [jsonString JSONValue];
        [dictParm addEntriesFromDictionary:jsonDict];
    }
    return dictParm;
}
+(id)jsonValueFromRequestOperation:(NSDictionary *)dict{

    if(nil != dict && [dict isKindOfClass:[NSDictionary class]]){
        NSDictionary *dictCT = [NSDictionary changeType:dict];
        NSDictionary *dictParm = [self getCheckedDictionary:dictCT];
        return dictParm;
    }
    return @{Key_ReturnCode:@(-1),Key_ReturnData:@{}};
}

#pragma mark -
#pragma mark -

+(void)serviceRequest:(SFBaseService *)service{
    [self serviceRequest:service delegate:nil];
}
+(void)serviceRequestArray:(NSArray *)serviceArray delegate:(id)delegate{
    if(serviceArray.count>0){
        for (SFBaseService *service in serviceArray) {
            if([service isKindOfClass:[SFBaseService class]]){
                [self serviceRequest:service delegate:delegate];
            }
        }
    }
}
///回调: netServiceFinished Or netServiceDidFinished | netServiceError Or netServiceDidError
+(void)serviceRequest:(SFBaseService *)service delegate:(id)delegate{
    if(nil == service){ return; }
    
    [service requestStartSucceed:^{
        if(nil != delegate){
            if([delegate respondsToSelector:@selector(netServiceFinished:userInfo:)]){
                [delegate netServiceFinished:service.handle userInfo:service.userInfo];
            }
            if([delegate respondsToSelector:@selector(netServiceDidFinished:userInfo:)]){
                [delegate netServiceDidFinished:service userInfo:service.userInfo];
            }
        }
    } error:^(NSInteger errorCode, NSString *errorMessage) {
        if(nil != delegate){
            if([delegate respondsToSelector:@selector(netServiceError:errorCode:errorMessage:userInfo:)]){
                [delegate netServiceError:service.handle errorCode:errorCode errorMessage:errorMessage userInfo:service.userInfo];
            }
            if(delegate && [delegate respondsToSelector:@selector(netServiceDidError:errorCode:errorMessage:userInfo:)]){
                [delegate netServiceDidError:service errorCode:errorCode errorMessage:errorMessage userInfo:service.userInfo];
            }
        }
    }];
}
-(NSString *)getDataCacheKeyStringByPage:(NSInteger)page{
    NSString *string = [NSString stringWithArray:@[self.requestURL,@"_SFService_",_userId,_identifierId,@(_handle),@"_Page_",@(page)]];
    return string;
}

-(NSString *)getDataCacheByPage:(NSInteger)page{
//    if(!_isNeedCacheData || (page<=-1 || page> _cacheLimitiedPage)){
//        return @"";
//    }
//    NSMutableDictionary *cachDict = (NSMutableDictionary *)[[EGOCache globalCache] objectForKey:self.requestURL];
//    NSString * data = [cachDict objectForKey:[self getDataCacheKeyStringByPage:page]];
//    if(data.length>0){
//        return data;
//    }
    return @"";
}
-(BOOL)setDataCacheByPage:(NSInteger)page cacheData:(NSString *)dataString isByNet:(BOOL)isByNet{
//    if(!_isNeedCacheData || !isByNet || page<=-1 || page> _cacheLimitiedPage){
//        return NO;
//    }
//    NSMutableDictionary *cachDict = (NSMutableDictionary *)[[EGOCache globalCache] objectForKey:self.requestURL];
//    if(nil == cachDict || (1 == _page && isByNet) ){
//        cachDict = [NSMutableDictionary dictionary];
//    }
//    [cachDict setObject:dataString forKey:[self getDataCacheKeyStringByPage:page]];
//    [[EGOCache globalCache] setObject:cachDict forKey:self.requestURL];
    return YES;
}
-(BOOL)parseDataByCachWithSucceed:(netServiceFinished)succeedBlock error:(netServiceDidError)errorBlock{
    if(!_isNeedCacheData){
        return NO;
    }
    NSString * cachData = @"";
    if(_page>=1 && _page<=KCacheLimitiedPage)
    {
        cachData = [self getDataCacheByPage:_page];
        if(cachData.length>0)
        {
            [self parseDataByResponseString:cachData isByNet:NO succeed:succeedBlock error:errorBlock];
            return YES;
        }
    }
    return NO;
}
#pragma mark
#pragma mark - LifeCyle

-(id)initWithDelegate:(id<SFBaseServiceDelegate>)deleagte{
    self = [self init];
    if(self){
        _delegate = deleagte;
    }
    return self;
}
+(instancetype)service{
    return [self serviceWithDelegate:nil];
}
+(instancetype)serviceWithDelegate:(id<SFBaseServiceDelegate>)delegate{
    SFBaseService *s = [[self alloc] init];
    s.delegate = delegate;
    return s;
}
+(instancetype)serviceWithIdentifierId:(NSString *)identifierId{
    SFBaseService *s = [self serviceWithDelegate:nil];
    s.identifierId = identifierId;
    return s;
}
-(void)requestStart{
    [self requestStartSucceed:nil error:nil];
}

-(void)requestStartSucceed:(netServiceFinished)succeed error:(netServiceDidError)errorBlock{
    _isLoading = YES;
}

- (BOOL)isResCodeSuccess:(NSDictionary *)responseDict{
    if(self.page <= 1){
        [self.dataArray removeAllObjects];
    }
    if(nil == responseDict || ![responseDict isKindOfClass:[NSDictionary class]] || (responseDict.count<=0)) return NO;
    NSInteger resCode = [[responseDict objectForKey:Key_ReturnCode] integerValue];
    
    return (Key_DataOKValue == resCode);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = -1;
        _isShowNoNetAlertMsg = YES;
        _isNeedCacheData = YES;
        self.dataArray = [NSMutableArray array];
        _cacheLimitiedPage = KCacheLimitiedPage;
        self.userInfo = [NSMutableDictionary dictionaryWithDictionary:@{Key_ServicePage:@(_page)}];
        self.handeFaileNotificationArray = [NSMutableArray array];
        self.handeSuccessNotificationArray = [NSMutableArray array];
        _isPost = YES;
        _isSucceed = NO;
    }
    return self;
}

//处理:push失败消息
-(void)handeFaileNotifications{
    if([_handeFaileNotificationArray count] > 0){
        for (NSString *f in _handeFaileNotificationArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Notification_PostName(f);
            });
        }
    }
}
//处理:push成功消息
-(void)handeSuccessNotifications{
    if([_handeSuccessNotificationArray count] > 0){
        for (NSString *s in _handeSuccessNotificationArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Notification_PostName(s);
            });
            
        }
    }
}


-(BOOL)parseJSON:(NSDictionary *)strJSON{
    return YES;
}
+(NSString *)getErrorMsgByError:(NSError *)error{
    NSString * errorMsg = @"";
    if([error.domain isEqualToString:NSURLErrorDomain]) {
        errorMsg = error.localizedDescription;
    }
    else{
        errorMsg = error.localizedFailureReason;
    }
    return errorMsg;
}
-(void)setHandle:(NSUInteger)handle{
    _handle = handle;
}


-(void)getDataByURL:(NSString*)requestURL loadingType:(NetLoad)type loadingText:(NSString *)loadingText succeed:(netServiceFinished)succeedBlock error:(netServiceDidError)errorBlock{
    if(_isLoading)return;
    
    _isPost = NO;
    [self getDataByURL:requestURL parameter:nil loadingType:type loadingText:loadingText succeed:succeedBlock error:errorBlock];
}
-(void)getDataByURL:(NSString*)requestURL parameter:(NSDictionary *)paraDic loadingType:(NetLoad)type loadingText:(NSString *)loadingText succeed:(netServiceFinished)succeedBlock error:(netServiceDidError)errorBlock{
    if(_isLoading)return;
    
    _isPost = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_userInfo setObject:@(_page) forKey:Key_ServicePage];
        if(_page==1){
            [self parseDataByCachWithSucceed:succeedBlock error:errorBlock];
        }
        self.requestDict = paraDic;
        
        [[SFNetEngine shardInstance] GET:requestURL param:paraDic uploadProgress:^(NSProgress *uploadProgress){} downloadProgress:^(NSProgress *downloadProgress) {} loadingType:type loadingText:loadingText success:^(id responseObject) {
            NSString *jsonString = [NSString JSONValueFromObj:responseObject];
            [self parseDataByResponseString:jsonString isByNet:YES succeed:succeedBlock error:errorBlock];
        } failure:^(NSError *error) {
            [self parseDataError:error error:errorBlock];
        }];
    });
}

- (void)sendPostByURL:(NSString *)requestURL parameter:(NSDictionary *)paraDic loadingType:(NetLoad)type loadingText:(NSString *)loadingText succeed:(netServiceFinished)succeedBlock error:(netServiceDidError)errorBlock{
    if(_isLoading)return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_userInfo setObject:@(_page) forKey:Key_ServicePage];
        if(_page==1){
            [self parseDataByCachWithSucceed:succeedBlock error:errorBlock];
        }
        self.requestDict = paraDic;
        [[SFNetEngine shardInstance] POST:requestURL param:paraDic uploadProgress:^(NSProgress *uploadProgress){} downloadProgress:^(NSProgress *downloadProgress) {} loadingType:type loadingText:loadingText success:^(id responseObject) {
            NSString *jsonString = [NSString JSONValueFromObj:responseObject];
            [self parseDataByResponseString:jsonString isByNet:YES succeed:succeedBlock error:errorBlock];
        } failure:^(NSError *error) {
            [self parseDataError:error error:errorBlock];
        }];
    });
}

#pragma mark -
#pragma mark - parseData
///网络返回数据
-(void)parseDataError:(NSError *)error error:(netServiceDidError)errorBlock{
    
    NSInteger errorCode = (int)error.code;
    BOOL isNetNone = (NSURLErrorNotConnectedToInternet == errorCode || NSURLErrorCannotFindHost == errorCode ||
                      NSURLErrorCannotConnectToHost == errorCode    || NSURLErrorNetworkConnectionLost == errorCode);
    NSString * errorMsg = [[self class] getErrorMsgByError:error];
    if(isNetNone){
        errorMsg = @"服务器无法连接，请重试";
    }
    errorMsg = isNetNone?(_isShowNoNetAlertMsg?errorMsg:@""):errorMsg;
    
    if(nil != errorBlock){
        dispatch_async(dispatch_get_main_queue(), ^{
            errorBlock(errorCode, errorMsg);
        });
    }
    //失败通知
    [self handeFaileNotifications];
    
    ///联网失败
    if(isNetNone){
        if(_page>=2 && _page<=_cacheLimitiedPage){
            ///获取缓存数据
            if(![self parseDataByCachWithSucceed:nil error:errorBlock ]){
                //[MBProgressHUD showMessage:@"网络连接不可用，请检查"];
            }
        }
    }
}
-(void)parseDataByResponseString:(NSString *)strJSON isByNet:(BOOL)isByNet succeed:(netServiceFinished)succeedBlock error:(netServiceDidError)errorBlock{
    if(nil == strJSON){
        strJSON = @"";
    }
    NSString *methodType = @"GET";
    if(_isPost){
        methodType = @"POST";
    }
    NSLog(@"\n[%@ [%@] \n>------>---------------------------------------------------------\nAPI = %@ \n  request:\n%@\n response = %@ \n ---------------------------------------------------------<------<]\n",NSStringFromClass([self class]),methodType,self.requestURL,self.requestDict,strJSON);
    //这一段是解析可能错误的网络返回

    NSDictionary *dict = [[self class] jsonValueFromRequestOperation:[strJSON JSONValue]];
    //解析数据
    NSInteger code = [[dict objectForKey:Key_ReturnCode] intValue];
    NSString * errorMsg = [dict objectForKey:Key_ReturnMsg];
    if(errorMsg.length<=0) errorMsg = @"抱歉,获取内容出错!";
    
    if([self parseJSON:dict]){
        //本地数据加载
        [self setDataCacheByPage:_page cacheData:strJSON isByNet:isByNet];
        
        if(Key_DataOKValue == code){
            if(nil != succeedBlock){
                dispatch_async(dispatch_get_main_queue(), ^{
                    succeedBlock();
                });
            }
            if(isByNet){
                [self handeSuccessNotifications];
            }
        }else
        {
            if(isByNet){
                if(nil != errorBlock){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        errorBlock(code, errorMsg);
                    });
                }
                [self handeFaileNotifications];
            }
        }
    }else{
        if(isByNet){
            if(nil != errorBlock){
                dispatch_async(dispatch_get_main_queue(), ^{
                    errorBlock(code, errorMsg);
                });
            }
            [self handeFaileNotifications];
        }
    }
    _isLoading = NO;
}

@end
