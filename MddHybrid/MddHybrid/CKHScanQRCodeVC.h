//
//  ScanQRCodeVC.h
//  MDD
//
//  Created by Kenway on 16/1/25.
//  Copyright © 2016年 滴滴 美. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CKHScanQRCodeVC;


typedef void (^scanResult)(NSString *result);


@protocol CKHScanQRCodeVCDelegate <NSObject>

- (void)scanQRCodeSucc:(id)object;

@end

/**
 *  扫码二维码
 */
@interface CKHScanQRCodeVC : UIViewController
@property (weak, nonatomic) id<CKHScanQRCodeVCDelegate>delegate;
@property (assign, nonatomic) CGFloat scanFrameMinddleY_offset;

+ (instancetype)scanQRCodeVCWithMiddleYOffset:(CGFloat)offsetY scanResult:(scanResult)resultBlock;

@end
