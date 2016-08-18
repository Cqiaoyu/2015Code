//
//  ViewController.m
//  MddHybrid
//
//  Created by Kenway on 16/8/17.
//  Copyright © 2016年 Kenway. All rights reserved.
//

#import "ViewController.h"
#import "MddHybrid.h"

@interface ViewController ()<UIWebViewDelegate>{
    UIWebView *_webView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MddHybrid *mddHybrid = [MddHybrid shareInstance];
    
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, w, h)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    if (![mddHybrid unarchiveZipFromBundleWithZipFile:@"appHeadStore.zip"]) return;
    NSString *htmlPath = [mddHybrid path4FileInZipFileDirectory:@"login.html"];
    NSURL *noConnectionURL = [NSURL URLWithString:htmlPath];
    NSURLRequest *noConnectionRequest = [NSURLRequest requestWithURL:noConnectionURL];
    [_webView loadRequest:noConnectionRequest];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"#########:%@",request);
    
    return YES;
}

@end
