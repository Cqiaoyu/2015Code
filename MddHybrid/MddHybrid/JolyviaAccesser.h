//
//  Accesser.h
//  Jolyvia
//
//  Created by Kenway on 15/11/2.
//  Copyright © 2015年 Kenway. All rights reserved.
//  数据访问类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JolyviaHTTPResponseCode) {
    JolyviaHTTPResponseCodeSucceed = 1000,                    /* 成功 */
    JolyviaHTTPResponseCodeUnRegister = 1001,                 /* 手机号未注册 */
    JolyviaHTTPResponseCodeWrongPassword = 1002,              /* 密码错误 */
    JolyviaHTTPResponseCodeNull = 1003,                       /* 返回内容为空 */
    JolyviaHTTPResponseCodeRegistered = 2001,                 /* 手机号码已经注册过 */
    JolyviaHTTPResponseCodeWrongVerifyCode = 2002,            /* 短信验证码错误 */
    JolyviaHTTPResponseCodeConnectTimeOut = 2003,             /* 网络连接超时 */
    JolyviaHTTPResponseCodeOverdueVerifyCode = 2004,          /* 短信验证码过期 */
    JolyviaHTTPResponseCodeNotFound  = 3003,                  /* 无此项目 */
    JolyviaHTTPResponseCodeFaileAddContent = 9009,            /* 新增内容失败 */
    JolyviaHTTPResponseCodeFaileGetContent = 9999,             /* 获取内容失败 */
    JolyviaHTTPResponseCode3840 = 3840,                        /* 不是json */
    JolyviaHTTPResponseCodeConnectionError = 10001             /* 网络连接错误 */
};


@interface JolyviaAccesser : NSObject

+ (JolyviaAccesser *)accesser;


+ (void) getDataBaseURL:(NSString *)url withRequestMethod:(NSString *)requestMethod parmars:(NSDictionary *)parameters completeBlock:(void (^)(id receiveData))completeBlock;

+ (void)downloadFileWithURLString:(NSString *)urlString filePath:(void(^)(NSString *filePath))completeBlock;


@end
