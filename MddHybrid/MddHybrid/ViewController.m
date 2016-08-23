//
//  ViewController.m
//  MddHybrid
//
//  Created by Kenway on 16/8/17.
//  Copyright © 2016年 Kenway. All rights reserved.
//

#import "ViewController.h"
#import "MddHybridAPI.h"
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>

#import "CKHScanQRCodeVC.h"

#define STATUSBARHEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIWebViewDelegate,CKHScanQRCodeVCDelegate>{
    WebViewJavascriptBridge *_bridge;
}
@property (strong, nonatomic)UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MddHybridAPI *mddHybrid = [MddHybridAPI shareInstance];
    [mddHybrid bridge4WebView:self.webView target:self];
    
    [self.view addSubview:self.webView];
    
    if (![mddHybrid unarchiveZipFromBundleWithZipFile:@"appHeadStore.zip"]) return;
//    NSString *htmlPath = [mddHybrid path4FileInZipFileDirectory:@"login.html"];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSURL *noConnectionURL = [NSURL URLWithString:htmlPath];
    NSURLRequest *noConnectionRequest = [NSURLRequest requestWithURL:noConnectionURL];
    [_webView loadRequest:noConnectionRequest];
    
//    [mddHybrid downloadFileFromURLString:@"http://tios.meididi88.com/office.php/v1/Test/download"];
    
    [mddHybrid handleJavascriptForHandleName:@"oc_call_js" data:@{@"test":@"美滴滴"} calllback:^(id responseData) {
        NSLog(@"oc_call_js => in oc：%@",responseData);
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)scanQRCodeSucc:(id)object{
    
}

#pragma mark - getter -
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, STATUSBARHEIGHT, SCREENWIDTH, SCREENHEIGHT)];
        _webView.delegate = self;
    }
    return _webView;
}


@end
