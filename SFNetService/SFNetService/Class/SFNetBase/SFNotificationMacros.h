//
//  XLNotificationMacros.h
//  UpLive
//
//  Created by Sage on 2016/10/26.
//  Copyright © 2016年 AsiaInnovations. All rights reserved.
//

#ifndef SFNotificationMacros_h
#define SFNotificationMacros_h

//********************************通知处理********************************\\_

#pragma mark -
#pragma mark - NSNotificationCenter

///注册观察者WithObject
#define Notification_AddObserver_Selector_Name_Object(t,s,n,o)         [[NSNotificationCenter defaultCenter] addObserver:(t) selector:(s) name:(n) object:(o)]
///注册观察者:self
#define Notification_Observer_Selector_Name(n,s)                            Notification_AddObserver_Selector_Name(self,s,n)
///注册观察者
#define Notification_AddObserver_Selector_Name(t,s,n)                   Notification_AddObserver_Selector_Name_Object(t,s,n,nil)
///移除观察者
#define Notification_RemoveObserver(s)                                          [[NSNotificationCenter defaultCenter] removeObserver:(s)]
///移除观察者with通知名称
#define Notification_RemoveObserver_Name(t,n)                               [[NSNotificationCenter defaultCenter] removeObserver:(t) name:(n) object:(nil)];
///移除观察者with通知名称 withObject
#define Notification_RemoveObserver_Name_Object(t,n,o)                  [[NSNotificationCenter defaultCenter] removeObserver:(t) name:(n) object:(o)];
//推送

///推送通知携带userInfo
#define Notification_PostName_Object_UserInfo(n,o,u)                    [[NSNotificationCenter defaultCenter] postNotificationName:(n) object:(o) userInfo:(u)]
///推送通知名称_携带对象
#define Notification_PostName_Object(n,o)                                   [[NSNotificationCenter defaultCenter] postNotificationName:(n) object:(o)]
///推送通知名称
#define Notification_PostName(n)                                                Notification_PostName_Object(n,nil)


//********************************系统处理********************************\\_
#if DEBUG
    #define NSLog(...) NSLog(__VA_ARGS__)
#else
    #define NSLog(...) {}
#endif

#endif /* XLNotificationMacros_h */
