//
//  SFBaseServiceDelegate.h
//  duoduo
//
//  Created by Sage on 2015/08/02.
//  Copyright (c) 2015年 benben. All rights reserved.
//
#import "SFNetConsts.h"
@class SFBaseService;


@protocol SFBaseServiceDelegate <NSObject>
/**
 *  请求被取消
 */
//@property(nonatomic,assign) BOOL isCanceled;
@optional

/*!
 @method
 @abstract   接受完传输数据时的调用SFServiceHandle
 @discussion 完成传输数据
 @param      handle 网络请求服务的标识
 @param      userInfo 用于网络请求传递的对象
 */
- (void)netServiceFinished:(NSUInteger)handle userInfo:(NSDictionary *)userInfo;

/*!
 @method
 @abstract   请求错误时的调用
 @discussion 请求接口错误或接口返回错误信息时调用此方法
 @param      handle 网络请求服务的标识
 @param      userInfo 用于网络请求传递的对象
 */
- (void)netServiceError:(NSUInteger)handle errorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage userInfo:(NSDictionary *)userInfo;

/*!
 @method
 @abstract   接受完传输数据时的调用SFBaseService
 @discussion 完成传输数据
 @param      service 网络请求服务
 @param      userInfo 用于网络请求传递的对象
 */
- (void)netServiceDidFinished:(SFBaseService *)service userInfo:(NSDictionary *)userInfo;

/*!
 @method
 @abstract   请求错误时的调用SFBaseService
 @discussion 请求接口错误或接口返回错误信息时调用此方法
 @param      service 网络请求服务的标识
 @param      errorCode 用于网络请求错误码
 */
- (void)netServiceDidError:(SFBaseService *)service errorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage userInfo:(NSDictionary *)userInfo;

/*
 
- (void)netServiceFinished:(SFServiceHandle)handle userInfo:(NSDictionary *)userInfo;
- (void)netServiceError:(SFServiceHandle)handle errorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage userInfo:(NSDictionary *)userInfo;

- (void)netServiceDidFinished:(SFBaseService *)service userInfo:(NSDictionary *)userInfo;
- (void)netServiceDidError:(SFBaseService *)service errorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage userInfo:(NSDictionary *)userInfo;
 */
@end
