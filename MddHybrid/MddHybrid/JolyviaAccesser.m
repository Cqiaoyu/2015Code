//
//  Accesser.m
//  Jolyvia
//
//  Created by Kenway on 15/11/2.
//  Copyright © 2015年 Kenway. All rights reserved.
//

#import "JolyviaAccesser.h"
#import <AFNetworking/AFNetworking.h>
#import "NSString+Jolyvia.h"


@implementation JolyviaAccesser
static JolyviaAccesser *accesser = nil;
static dispatch_once_t onceToken;
+ (JolyviaAccesser *)accesser{
    if (accesser == nil) {
        dispatch_once(&onceToken, ^{
            accesser = [[JolyviaAccesser alloc]init];
        });
    }
    return accesser;
}

+ (void)getDataBaseURL:(NSString *)url withRequestMethod:(NSString *)requestMethod parmars:(NSDictionary *)parameters completeBlock:(void (^)(id receviceData))completeBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",@"application/x-www-form-urlencoded",nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    [self setupHttpHeader4Manager:manager];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([NSJSONSerialization isValidJSONObject:responseObject]) {
            completeBlock(responseObject);
            NSLog(@"请求参数:%@",parameters);
            NSLog(@"请求成功:url=%@\n请求结果:%@",url,responseObject);
        }else{
            NSDictionary *errorDict = @{@"respCode":@"3840",@"error":(responseObject==nil?@"3840":responseObject)};
            NSData *data = [NSJSONSerialization dataWithJSONObject:errorDict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonResult = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            completeBlock(jsonResult);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error码:%@",error);
        NSLog(@"请求失败:url=%@",url);
        NSDictionary *jsonDic = @{@"respCode":@"10001",@"error":@"网络连接错误"};
        NSData *data = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonResult = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        completeBlock(jsonResult);
    }];
    
}

+ (void)getDataBaseURL:(NSString *)url withRequestMethod:(NSString *)requestMethod parmars:(NSDictionary *)parameters identifier:(NSString *)identifier{
    
}

+ (void)downloadFileWithURLString:(NSString *)urlString filePath:(void (^)(NSString *))completeBlock{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        if (completeBlock) {
            NSString *path = filePath.absoluteString;
            NSString *scheme = [NSString stringWithFormat:@"%@://",filePath.scheme];
            NSRange schemeRange = [path rangeOfString:scheme];
            NSString *tempPath = [path substringFromIndex:schemeRange.length];
            completeBlock(tempPath);
        }
    }];
    [downloadTask resume];
}

/**
 *  设置请求头
 *
 *  @param manager AFHTTPRequestOperationManager请求管理对象
 */
+ (void)setupHttpHeader4Manager:(AFHTTPSessionManager *)manager{
    UIDevice *deveice = [UIDevice currentDevice];
    NSString *customName = deveice.name;
    NSString *systemPhoneName = deveice.model;
    NSString *systemVersion = deveice.systemVersion;
    NSString *systemName = deveice.systemName;
    NSUUID *identifer = deveice.identifierForVendor;
    NSString *uuid = identifer.UUIDString;
    NSString *networkStatus = [NSString networkingStatusFromStatebar];
    NSString *carrierName = [NSString carrierName];
    NSString *ratio = [NSString resolutionRatio];
    NSDictionary *loginDict = [NSDictionary dictionaryWithContentsOfFile:[NSString fileName:@""]];
    NSString *mobile = loginDict[@"mobile"];
    NSString *pwdMD5 = [NSString stringWithContentsOfFile:[NSString fileName:@""] encoding:NSUTF8StringEncoding error:nil];
    NSString *uid = loginDict[@"uid"];
    if (uid == nil) {
        uid = @"";
    }
    
    [manager.requestSerializer setValue:customName forHTTPHeaderField:@"userPhoneName"];
    [manager.requestSerializer setValue:systemPhoneName forHTTPHeaderField:@"phoneName"];
    [manager.requestSerializer setValue:systemVersion forHTTPHeaderField:@"systemVersion"];
    [manager.requestSerializer setValue:systemName forHTTPHeaderField:@"systemName"];
    [manager.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    [manager.requestSerializer setValue:networkStatus forHTTPHeaderField:@"networkStatus"];
    [manager.requestSerializer setValue:carrierName forHTTPHeaderField:@"carrierName"];
    [manager.requestSerializer setValue:ratio forHTTPHeaderField:@"ratio"];
    [manager.requestSerializer setValue:mobile forHTTPHeaderField:@"mobile"];
    [manager.requestSerializer setValue:pwdMD5 forHTTPHeaderField:@"password"];
    [manager.requestSerializer setValue:uid forHTTPHeaderField:@"uid"];
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"deviceFlag"];
}


@end
