//
//  MddHybrid.h
//  MddHybrid
//
//  Created by Kenway on 16/8/18.
//  Copyright © 2016年 Kenway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MddHybrid : NSObject

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
 *  H5 -> OC 的事件处理
 *
 *  @param webView 所请求的webView
 *  @param request 所请求的request
 */
- (void)h52OCWithWebView:(UIWebView *)webView request:(NSURLRequest *)request;





@end
