//
//  ScanQRCodeVC.m
//  MDD
//
//  Created by Kenway on 16/1/25.
//  Copyright © 2016年 滴滴 美. All rights reserved.
//

#import "CKHScanQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>

#define ORIGIN_Y_OFFSET 20

@interface CKHScanQRCodeVC ()<
    AVCaptureMetadataOutputObjectsDelegate,
    UIAlertViewDelegate
>{
    NSTimer *_timer;
    scanResult _resultBlock;
}

@property (nonatomic, strong) UIView *scanRectView;

@property (strong, nonatomic) AVCaptureDevice            *device;
@property (strong, nonatomic) AVCaptureDeviceInput       *input;
@property (strong, nonatomic) AVCaptureMetadataOutput    *output;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

@end

@implementation CKHScanQRCodeVC

- (instancetype)initWithBlock:(scanResult)resultBlock
{
    self = [super init];
    if (self) {
        _resultBlock = resultBlock;
    }
    return self;
}

+ (instancetype)scanQRCodeVCWithMiddleYOffset:(CGFloat)offsetY scanResult:(scanResult)resultBlock{
    CKHScanQRCodeVC *scanVC = [[CKHScanQRCodeVC alloc]initWithBlock:resultBlock];
    return scanVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self navBarLayoutInit];
    
    
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    CGSize scanSize = CGSizeMake(windowSize.width*3/4, windowSize.width*3/4);
    CGRect scanRect = CGRectMake((windowSize.width-scanSize.width)/2, (windowSize.height-scanSize.height)/2, scanSize.width, scanSize.height);
    
    scanRect = CGRectMake(scanRect.origin.y/windowSize.height, scanRect.origin.x/windowSize.width, scanRect.size.height/windowSize.height,scanRect.size.width/windowSize.width);
    
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    if (_input == nil) {
        NSLog(@"相机不可用");
        [self performSelector:@selector(popController) withObject:nil afterDelay:2.0];
        return;
    }
    
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:([UIScreen mainScreen].bounds.size.height<500)?AVCaptureSessionPreset640x480:AVCaptureSessionPresetHigh];
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    self.output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code];
    self.output.rectOfInterest = scanRect;
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    //计算rectOfInterest 注意x,y交换位置
    if (_scanFrameMinddleY_offset == 0.0) {
        _scanFrameMinddleY_offset = ORIGIN_Y_OFFSET;
    }
    _scanRectView = [UIView new];
    [self.view addSubview:_scanRectView];
    _scanRectView.frame = CGRectMake(0, 0, scanSize.width, scanSize.height);
    _scanRectView.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds) - _scanFrameMinddleY_offset);
    
    //四个角
    UIImageView *leftTopIV = [[UIImageView alloc]init];
    UIImageView *leftBottomIV = [[UIImageView alloc]init];
    UIImageView *rightTopIV = [[UIImageView alloc]init];
    UIImageView *rightBottomIV = [[UIImageView alloc]init];
    CGSize angleSize = CGSizeMake(25, 25);
    leftTopIV.frame = CGRectMake(0, 0, angleSize.width, angleSize.height);
    leftBottomIV.frame = CGRectMake(0, _scanRectView.frame.size.height - angleSize.height, angleSize.width, angleSize.height);
    rightTopIV.frame = CGRectMake(_scanRectView.frame.size.width - angleSize.width, 0, angleSize.width, angleSize.height);
    rightBottomIV.frame = CGRectMake(_scanRectView.frame.size.width - angleSize.width, _scanRectView.frame.size.height - angleSize.height, angleSize.width, angleSize.height);
    leftTopIV.image = [UIImage imageNamed:@"scanTopLeft"];
    leftBottomIV.image = [UIImage imageNamed:@"scanBottomLeft"];
    rightTopIV.image = [UIImage imageNamed:@"scanTopRight"];
    rightBottomIV.image = [UIImage imageNamed:@"scanBottomRight"];
    [_scanRectView addSubview:leftTopIV];
    [_scanRectView addSubview:leftBottomIV];
    [_scanRectView addSubview:rightTopIV];
    [_scanRectView addSubview:rightBottomIV];
    //扫描线
    UIImageView *scanLineIV = [[UIImageView alloc]init];
    scanLineIV.frame = CGRectMake(2, 2, _scanRectView.frame.size.width - 4, 3);
    scanLineIV.image = [UIImage imageNamed:@"scanLine"];
    [_scanRectView addSubview:scanLineIV];
    [self scanLineAnimate:scanLineIV];
    
    //文字
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, _scanRectView.frame.size.height + 10, scanSize.width, 21)];
    [_scanRectView addSubview:label];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"将二维码/条形码放入框内";
    
    //开始捕获
    [self.session startRunning];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    [_timer invalidate];
    _timer = nil;
    if ( (metadataObjects.count==0) )
    {
        return;
    }
    
    if (metadataObjects.count>0) {
        
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        //输出扫描字符串
        
        [self.session startRunning];
        
        if ([_delegate respondsToSelector:@selector(scanQRCodeSucc:)]) {
            [_delegate scanQRCodeSucc:metadataObject.stringValue];
            
        }
        if (_resultBlock) {
            _resultBlock(metadataObject.stringValue);
        }
        [self dismissControllerAction];
        
        
    }
}

#pragma mark - private methods -
- (void)scanLineAnimate:(UIView *)scanLine{
    //第一次
    [UIView animateWithDuration:3.0 animations:^{
        scanLine.frame = CGRectMake(2, _scanRectView.frame.size.height - 5, _scanRectView.frame.size.width - 4, 3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.6 animations:^{
            scanLine.frame = CGRectMake(2, 2, _scanRectView.frame.size.width - 4, 3);
        }];
    }];
    //以后的每一次
    _timer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(scanLineAnimationAction:) userInfo:@{@"view":scanLine} repeats:YES];
}

- (UIImage *)colorImage:(UIColor *)color{
    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)navBarLayoutInit{
    self.title = @"扫一扫";
    [self.navigationController.navigationBar setBackgroundImage:[self colorImage:[[UIColor whiteColor] colorWithAlphaComponent:0.01]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[self colorImage:[[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.01]]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 40, 40);
    btnBack.imageEdgeInsets = UIEdgeInsetsMake(-5, -20, -5, 20);
    [btnBack setTitle:@"取消" forState:UIControlStateNormal];
    [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(dismissControllerAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = backItem;
}
- (void)dismissControllerAction{
    if ([UIApplication sharedApplication].keyWindow.rootViewController.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark  - event response -

- (void)popController{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scanLineAnimationAction:(NSTimer *)timer{
    UIView *scanLine = (UIView *)timer.userInfo[@"view"];
    [UIView animateWithDuration:3.0 animations:^{
        scanLine.frame = CGRectMake(2, _scanRectView.frame.size.height - 5, _scanRectView.frame.size.width - 4, 3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:3.0 animations:^{
            scanLine.frame = CGRectMake(2, 2, _scanRectView.frame.size.width - 4, 3);
        }];
    }];
}

@end
