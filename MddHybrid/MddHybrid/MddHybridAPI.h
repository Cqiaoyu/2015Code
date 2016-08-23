//
//  MddHybrid.h
//  MddHybrid
//
//  Created by Kenway on 16/8/18.
//  Copyright © 2016年 Kenway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MddHybridAPI;

@protocol MddHybridAPIDelegate <NSObject>
@optional
- (void)didScanQRCodeSuccess:(id)object;

@end




@interface MddHybridAPI : NSObject
@property (weak, nonatomic) id<MddHybridAPIDelegate>delegate;
+ (instancetype)shareInstance;

/**
 *  zip解压所在的目录
 *
 *  @return 目录路径字符串
 */
- (NSString *)path4UnarchiveZipFileDirectory;

/**
 *  解压指定路径下的zip文件
 *
 *  @param zipFilePath zip文件路径
 */
- (BOOL)unarchiveZipInPath:(NSString *)zipFilePath;

/**
 *  解压本地zip文件
 *
 *  @param zipFile 本地zip文件名
 */
- (BOOL)unarchiveZipFromBundleWithZipFile:(NSString *)zipFile;

/**
 *  zip的解压根目录及其子目录下的指定文件的路径(带后缀)
 *
 *  @return 自定文件的路径字符串
 */
- (NSString *)path4FileInZipFileDirectory:(NSString *)fileName;

/**
 *  javascript -> Objective-C 的事件处理(没有使用JavascriptBridge 的 方法)
 *
 *  @param webView 所请求的webView
 *  @param request 所请求的request
 */
- (void)addTarget:(id)target h52NativeWithWebView:(UIWebView *)webView request:(NSURLRequest *)request;

/**
 *  绑定webView 及 delegate 的target 进行 js-oc/oc-js 之间的桥接（使用 JavascriptBridge的方法）必须调用这个方法
 *
 *  @param webView 需要进行 js-Native 交互的webView
 *  @param target  承载webView的Controller（webView 的delegate 实现对象）
 */
- (void)bridge4WebView:(UIWebView *)webView target:(id)target;
/**
 *  Objective-C - javascript 的处理方法
 *
 *  @param handleName 处理对象名
 *  @param data       传递给h5的数据
 *  @param callback   当js处理完后的回调
 */
- (void)handleJavascriptForHandleName:(NSString *)handleName data:(id)data calllback:(void (^)(id responseData))callback;

/**
 *  从指定的URL下载文件
 *
 *  @param urlString 文件所在的URL
 */
- (void)downloadFileFromURLString:(NSString *)urlString;
/**
 *  复制指定路径的文件到目标目录
 *
 *  @param sourcePath 源路径
 *  @param destPath   目标目录路径
 */
- (BOOL)copyFileAtPath:(NSString *)sourcePath toPath:(NSString *)destPath;

@end
