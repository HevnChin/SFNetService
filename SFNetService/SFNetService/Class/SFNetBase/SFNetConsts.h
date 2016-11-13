//
//  SFNetConsts.h
//  duoduo
//
//  Created by Sage on 2015/08/02.
//  Copyright (c) 2015年 benben. All rights reserved.
//

#ifndef duoduo_SFNetConsts_h
#define duoduo_SFNetConsts_h

#import "NSString+CustumExtends.h"
#import "NSDictionary+CustomExtends.h"
#import "SFNotificationMacros.h"


typedef NS_ENUM(NSInteger, NetLoad) {
    ///不展示模式
    NetLoad_None                                     = 0,
    //普通加载框
    ///加载框_开始(展示)_结束(关闭)
    NetLoad_Common_ReqShow_ResCose,
    ///加载框_开始(展示)_结束(展示)
    NetLoad_Common_ReqShow_ResShow,
    
    //模式对话框
    ///模式框_开始(展示)_结束(移除)
    NetLoad_Model_ReqShow_ResClose,
    ///模式框_开始(展示)_结束(展示)
    NetLoad_Model_ReqShow_ResShow,
};
///netServiceFinished成功数据后的回调
typedef void (^netServiceFinished)();
///netServiceDidError失败数据后的回调
typedef void (^netServiceDidError)(NSInteger errorCode, NSString *errorMessage);


//页码
#define Key_ServicePage @"Key_ServicePage"
//推送
#define Key_ServicePush @"Key_ServicePush"

#ifndef Key_ReturnCode
    #define Key_ReturnCode       @"code"
#endif

#ifndef Key_ReturnData
    #define Key_ReturnData       @"data"
#endif

#ifndef Key_ReturnMsg
    #define Key_ReturnMsg       @"msg"
#endif

#ifndef Key_ReturnResult
    #define Key_ReturnResult       @"result"
#endif

#ifndef Key_DataOKValue
    #define Key_DataOKValue       0
#endif

///cacheLimitied :限制20页
#ifndef KCacheLimitiedPage
    #define KCacheLimitiedPage      20
#endif


#endif
