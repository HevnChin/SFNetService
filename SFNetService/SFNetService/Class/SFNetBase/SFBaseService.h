//
//  SFBaseService.h
//  duoduo
//
//  Created by Sage on 2015/08/02.
//  Copyright (c) 2015年 benben. All rights reserved.
//

#import "SFNetConsts.h"
#import "SFBaseServiceDelegate.h"

@interface SFBaseService : NSObject

+(id)getCheckedDictionary:(NSDictionary *)parameters;

/*********************************业务字段***********************************************/

///是否成功(业务字段)
@property (nonatomic,assign) BOOL isSucceed;
///本次标识ID(业务字段)
@property (nonatomic, copy) NSString *identifierId;
///用户ID(用于缓存标识)
@property (nonatomic, copy) NSString *userId;

/*********************************传输数据***********************************************/
@property(nonatomic,copy) netServiceFinished succeedBlock;
@property(nonatomic,copy) netServiceDidError errorBlock;

///获取的数据列表
@property(nonatomic,strong) NSMutableArray * dataArray;

///当前的页码
@property (nonatomic, assign) NSInteger page;
///请求的URL
@property (nonatomic, copy) NSString * requestURL;
///当前的标识
@property (nonatomic, assign)  NSUInteger handle;
///网络传输中的携带数据
@property (nonatomic, strong) NSMutableDictionary * userInfo;

/*********************************通知相关***********************************************/
///网络传输成功的提示[NSNotification]
@property (nonatomic, strong) NSMutableArray * handeSuccessNotificationArray;
///网络传输失败的提示[NSNotification]
@property (nonatomic, strong) NSMutableArray * handeFaileNotificationArray;


/*********************************缓存相关***********************************************/
///是否需要缓存数据
@property (nonatomic, assign) BOOL isNeedCacheData;
///限制缓存的页数
@property (nonatomic, assign)  NSInteger cacheLimitiedPage;
///是否需要展示(读取缓存数据的时候)无网提示
@property (nonatomic, assign) BOOL isShowNoNetAlertMsg;



///对象代理
@property (nonatomic, assign) id<SFBaseServiceDelegate> delegate;

#pragma mark -
#pragma mark - LifeCyle
///初始化
-(id)initWithDelegate:(id<SFBaseServiceDelegate>)deleagte;

+(instancetype)service;

/**
 *  @param delegate 代理
 *  @return SFBaseService
 */
+(instancetype)serviceWithDelegate:(id<SFBaseServiceDelegate>)delegate;

/**
 *  @param identifierId : 标识本次请求的数据Id,主要用于表单提交
 *  @return SFBaseService
 */
+(instancetype)serviceWithIdentifierId:(NSString *)identifierId;

///解析数据
-(BOOL)parseJSON:(NSDictionary *)dictRes;
///获取错误提示
+(NSString *)getErrorMsgByError:(NSError *)error;
///验证正确
- (BOOL)isResCodeSuccess:(NSDictionary *)strJSON;

///批量调用service
+(void)serviceRequestArray:(NSArray *)serviceArray delegate:(id)delegate;


///只请求,不做回调
+(void)serviceRequest:(SFBaseService *)service;

+(void)serviceRequest:(SFBaseService *)service delegate:(id)delegate;

/*!
 @method
 @abstract   发送Net请求:请求数据不进行成功失败的回调用
 */
-(void)requestStart;

/*!
 @method
 @abstract   发送Net请求
 @param     succeedBlock 成功回调
 @param     errorBlock       失败回调
 */
-(void)requestStartSucceed:(netServiceFinished)succeedBlock error:(netServiceDidError)errorBlock;

#pragma mark - GET请求相关方法
/*!
 @method
 @abstract   发送get请求

 @param     requestURL 数据地址
 @param     paraDic 表示为URL的的参数字典
 @param     type 表示为加载框类型
  @param     loadingText 表示为加载框文字
 */
-(void)getDataByURL:(NSString*)requestURL parameter:(NSDictionary *)paraDic loadingType:(NetLoad)type loadingText:(NSString *)loadingText succeed:(netServiceFinished)succeedBlock error:(netServiceDidError)errorBlock;
/*!
 @method
 @abstract   发送get请求

 @param     requestURL 数据地址
 @param     type 表示为加载框类型
 @param     loadingText 表示为加载框文字
 
 */
-(void)getDataByURL:(NSString*)requestURL loadingType:(NetLoad)type loadingText:(NSString *)loadingText succeed:(netServiceFinished)succeedBlock error:(netServiceDidError)errorBlock;

#pragma mark - 发送POST请求的相关方法
/*!
 @method
 @abstract   发送post请求
 @discussion 发送post请求
 @param     postURL 数据地址， paraDic表示为上传的参数字典
 @param     type 表示为加载框类型
 @param     loadingText 表示为加载框文字
 */
- (void)sendPostByURL:(NSString *)postURL parameter:(NSDictionary *)paraDic loadingType:(NetLoad)type loadingText:(NSString *)loadingText succeed:(netServiceFinished)succeedBlock error:(netServiceDidError)errorBlock;

@end
