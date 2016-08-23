//
//  MddHybridAPI.m
//  MddHybridAPI
//
//  Created by Kenway on 16/8/18.
//  Copyright © 2016年 Kenway. All rights reserved.
//

#import "MddHybridAPI.h"
#import <SSZipArchive/SSZipArchive.h>
#import "CKHScanQRCodeVC.h"
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import "JolyviaAccesser.h"
#import "MddHybridAPIDefinition.h"

#define HTML_SOURCE_DIRECTORY_NAME @"HtmlSource"

@interface MddHybridAPI ()<CKHScanQRCodeVCDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    WebViewJavascriptBridge *_bridge;
    UIWebView *_webView;
    WVJBResponseCallback _takePictureBlock;     //选择照片的回调
}

@end

@implementation MddHybridAPI


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


+ (instancetype)shareInstance{
    static dispatch_once_t token;
    static MddHybridAPI *instance = nil;
    dispatch_once(&token, ^{
        instance = [[MddHybridAPI alloc]init];
    });
    return instance;
}

- (void)bridge4WebView:(UIWebView *)webView target:(id)target{
    _webView = webView;
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge  setWebViewDelegate:target];
    
    //注册功能交互
    [self registerScanQR];
    [self registerPhoneCall];
    [self registerGoBack];
    [self registerClose];
    [self registerExit];
    [self registerTakePicture];
    
    //注册数据接口交互
    [self registerRequestData];
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

- (BOOL)copyFileAtPath:(NSString *)sourcePath toPath:(NSString *)destPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if ([fileManager copyItemAtPath:sourcePath toPath:destPath error:&error]) {
        NSLog(@"复制文件成功");
        return YES;
    }else{
        NSLog(@"复制文件失败:%@",error.localizedDescription);
        return NO;
    }
}

- (void)addTarget:(id)target h52NativeWithWebView:(UIWebView *)webView request:(NSURLRequest *)request{
    
    NSString *scheme = request.URL.scheme;
    if ([scheme isEqualToString:goBack]) {//返回
        [webView stringByEvaluatingJavaScriptFromString:@"history.back();"];
    }else if ([scheme isEqualToString:close]){//关闭
        exit(0);
    }else if ([scheme isEqualToString:exitApp]){//退出app
        exit(0);
    }else if ([scheme isEqualToString:scanQR]){//扫描
        CKHScanQRCodeVC *scanQRVC = [[CKHScanQRCodeVC alloc]init];
        scanQRVC.scanFrameMinddleY_offset = 20.0;
        scanQRVC.delegate = self;
        if ([UIApplication sharedApplication].keyWindow.rootViewController.navigationController) {
            [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController pushViewController:scanQRVC animated:YES];
        }else{
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:scanQRVC];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        }
    }else if ([scheme isEqualToString:takePicture]){//照片
        
    }else if ([scheme isEqualToString:phoneCall]){//打电话
        NSArray *componentArr = [request.URL.absoluteString componentsSeparatedByString:@"call://"];
        if (componentArr.count > 1) {
            NSString *mobile = [NSString stringWithFormat:@"tel://%@",[componentArr lastObject]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobile]];
        }
    }
}

- (void)takePictureChoose{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择照片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //拍照
        [self takePictureActionWithType:@"camera"];
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //相册
        [self takePictureActionWithType:@"album"];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消
    }];
    [alert addAction:takePhotoAction];
    [alert addAction:albumAction];
    [alert addAction:cancelAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)takePictureActionWithType:(NSString *)type{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if ([type isEqualToString:@"album"]) {//相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }else{//相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
}


#pragma mark - register Objective-C handle for Javascript -
/**
 *  注册扫描二维码/条形码的交互
 */
- (void)registerScanQR{
    [_bridge registerHandler:scanQR handler:^(id data, WVJBResponseCallback responseCallback) {
        CKHScanQRCodeVC *scanQRVC = [CKHScanQRCodeVC scanQRCodeVCWithMiddleYOffset:20.0 scanResult:^(NSString *result) {
            if (responseCallback) {
                responseCallback(@{scanQRResult:result});
            }
        }];
        if ([UIApplication sharedApplication].keyWindow.rootViewController.navigationController) {
            [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController pushViewController:scanQRVC animated:YES];
        }else{
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:scanQRVC];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        }
    }];
}
/**
 *  注册选择 照片 （拍照 、 相册）照片信息转成 base64 返回给h5
 */
- (void)registerTakePicture{
    __weak typeof(self)wself = self;
    [_bridge registerHandler:takePicture handler:^(id data, WVJBResponseCallback responseCallback) {
        [wself takePictureChoose];
        _takePictureBlock = responseCallback;
    }];
}

/**
 *  注册拨打电话的交互
 */
- (void)registerPhoneCall{
    [_bridge registerHandler:phoneCall handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSString *mobile = [NSString stringWithFormat:@"tel://%@",data[mobileNumber]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobile]];
        }
    }];
}
/**
 *  注册返回
 */
- (void)registerGoBack{
    [_bridge registerHandler:goBack handler:^(id data, WVJBResponseCallback responseCallback) {
        [_webView stringByEvaluatingJavaScriptFromString:@"history.back();"];
    }];
}
/**
 *  注册关闭
 */
- (void)registerClose{
    [_bridge registerHandler:close handler:^(id data, WVJBResponseCallback responseCallback) {
        exit(0);
    }];
    
}

/**
 *  注册退出
 */
- (void)registerExit{
    [_bridge registerHandler:exitApp handler:^(id data, WVJBResponseCallback responseCallback) {
        exit(0);
    }];
}


#pragma mark - handle Javascript in Objective-C -
/**
 *  Objective-C - javascript 的处理方法
 *
 *  @param handleName 处理对象名
 *  @param data       传递给h5的数据
 *  @param callback   当js处理完后的回调
 */
- (void)handleJavascriptForHandleName:(NSString *)handleName data:(id)data calllback:(void (^)(id responseData))callback{
    [_bridge callHandler:handleName data:data responseCallback:^(id responseData) {
        if (callback) {
            callback(responseData);
        }
    }];
}

#pragma mark - data accesser -
/**
 *  注册请求数据的接口
 */
- (void)registerRequestData{
    [_bridge registerHandler:requestData handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSString *url = data[requestURL];
            NSString *json = data[requestParameters];
            NSLog(@"url:%@,parameter:%@",url,json);
            NSError *error;
            if ([json length] == 0 || json == nil) {
                [JolyviaAccesser getDataBaseURL:url withRequestMethod:@"POST" parmars:nil completeBlock:^(id receiveData) {
                    if (responseCallback) {
                        responseCallback(receiveData);
                    }
                }];
            }else{
                NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
                if (!error) {
                    NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                    if (!error) {
                        [JolyviaAccesser getDataBaseURL:url withRequestMethod:@"POST" parmars:parameters completeBlock:^(id receiveData) {
                            if (responseCallback) {
                                responseCallback(receiveData);
                            }
                        }];
                    }
                    
                }
            }
        }
    }];
}

- (void)downloadFileFromURLString:(NSString *)urlString{
    __weak typeof(self)wself = self;
    [JolyviaAccesser downloadFileWithURLString:urlString filePath:^(NSString *filePath) {
        [wself unarchiveZipInPath:filePath];
    }];
}

#pragma mark - UIImagePickerControllerDelegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *img = info[UIImagePickerControllerEditedImage];
    NSString *imgBase64 = [UIImageJPEGRepresentation(img, 0.3) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (_takePictureBlock) {
        NSDictionary *dataDic = @{picBase64:imgBase64};
        _takePictureBlock(dataDic);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CKHScanQRCodeVCDelegate -
- (void)scanQRCodeSucc:(id)object{
    if ([_delegate respondsToSelector:@selector(didScanQRCodeSuccess:)]) {
        [_delegate didScanQRCodeSuccess:object];
    }
}


@end
