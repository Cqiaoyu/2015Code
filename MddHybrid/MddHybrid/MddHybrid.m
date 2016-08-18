//
//  MddHybrid.m
//  MddHybrid
//
//  Created by Kenway on 16/8/18.
//  Copyright © 2016年 Kenway. All rights reserved.
//

#import "MddHybrid.h"
#import <SSZipArchive/SSZipArchive.h>

#define HTML_SOURCE_DIRECTORY_NAME @"HtmlSource"

@implementation MddHybrid

+ (instancetype)shareInstance{
    static dispatch_once_t token;
    static MddHybrid *instance = nil;
    dispatch_once(&token, ^{
        instance = [[MddHybrid alloc]init];
    });
    return instance;
}

- (NSString *)path4UnarchiveZipFileDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths firstObject];
    NSString *htmlSourceDocumentPath = [documentPath stringByAppendingPathComponent:HTML_SOURCE_DIRECTORY_NAME];
    [[NSFileManager defaultManager] createDirectoryAtPath:htmlSourceDocumentPath withIntermediateDirectories:YES attributes:nil error:nil];
    return htmlSourceDocumentPath;
}

- (BOOL)unarchiveZipInPath:(NSString *)zipFilePath{
    NSString *htmlSourceDirectoryPath = [self path4UnarchiveZipFileDirectory];
    if ([SSZipArchive unzipFileAtPath:zipFilePath toDestination:htmlSourceDirectoryPath]) {
        NSLog(@"zip解压成功:%@",htmlSourceDirectoryPath);
        return YES;
    }
    NSLog(@"解压失败");
    return NO;
}

- (BOOL)unarchiveZipFromBundleWithZipFile:(NSString *)zipFile{
    NSString *zipPath = nil;
    if ([zipFile hasSuffix:@"zip"]) {
        NSArray *fileNameComponts = [zipFile componentsSeparatedByString:@"."];
        NSString *fileName = [fileNameComponts firstObject];
        NSString *fileType = [fileNameComponts lastObject];
        zipPath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    }else{
        zipPath = [[NSBundle mainBundle] pathForResource:zipFile ofType:@"zip"];
    }
    return [self unarchiveZipInPath:zipPath];
}

- (NSString *)path4FileInZipFileDirectory:(NSString *)fileName{
    NSString *htmlSourceDirPath = [self path4UnarchiveZipFileDirectory];
    NSArray *subDirPathArr = [[NSFileManager defaultManager] subpathsAtPath:htmlSourceDirPath];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"self endswith %@",fileName];
    NSArray *preArr = [subDirPathArr filteredArrayUsingPredicate:pre];
    NSString *filePath = nil;
    if (preArr.count == 2) {
        filePath = [htmlSourceDirPath stringByAppendingPathComponent:[preArr lastObject]];
    }else{
        filePath = [htmlSourceDirPath stringByAppendingPathComponent:[preArr firstObject]];
    }
    return filePath;
}

- (void)h52OCWithWebView:(UIWebView *)webView request:(NSURLRequest *)request{
    NSString *scheme = request.URL.scheme;
    if ([scheme isEqualToString:@"back"]) {//返回
        
    }else if ([scheme isEqualToString:@"close"]){//关闭
        
    }else if ([scheme isEqualToString:@"exit"]){//退出app
        
    }else if ([scheme isEqualToString:@"scan"]){//扫描
        
    }else if ([scheme isEqualToString:@"picture"]){//照片
        
    }else if ([scheme isEqualToString:@"call"]){//打电话
        
    }
    
    
}



@end
