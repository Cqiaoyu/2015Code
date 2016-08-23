//
//  ViewController.m
//  MddJavaScriptBridge
//
//  Created by Kenway on 16/8/22.
//  Copyright © 2016年 Kenway. All rights reserved.
//

#import "ViewController.h"

#define STATUSBARHEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController (){
    WebViewJavascriptBridge *_bridge;
}
@property (strong, nonatomic)UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, STATUSBARHEIGHT, SCREENWIDTH, SCREENHEIGHT)];
        _webView.delegate = self;
        _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"%@",data);
        }];
    }
    return _webView;
}


@end
