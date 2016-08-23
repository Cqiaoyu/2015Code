//
//  NSString+Secret.h
//  Jolyvia
//
//  Created by Kenway on 15/11/2.
//  Copyright © 2015年 Kenway. All rights reserved.
//  NSString分类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CoreLocation/CoreLocation.h>


/**
 *  加解密
 */
@interface NSString (Secret)

/**
 *  将字符串本身进行MD5加密
 *
 *  @return 加密后的字符串
 */
- (NSString *)md5Encryption;

@end
/**
 *  路径
 */
@interface NSString (FilePath)

/**
 *  Document文件路径
 *
 *  @param name 文件名
 *
 *  @return 文件所在Document路径
 */
+ (NSString *)fileName:(NSString *)name;

+ (NSString *)fileName:(NSString *)name withDirName:(NSString *)dirName;
/**
 *  Bunlde文件路径
 *
 *  @param name 文件名
 *  @param type 文件格式
 *
 *  @return 文件所在Bundle路径
 */
+ (NSString *)bundleFileName:(NSString *)name type:(NSString *)type;
/**
 *  Bundle图片路径
 *
 *  @param imageName 图片名
 *
 *  @return 图片所在Bundle路径
 */
+ (NSString *)bundleImagePathWithName:(NSString *)imageName;
@end

/**
 *  日期的字符处理
 */
@interface NSString (DateString)
/**
 *  今天日期
 *
 *  @param character 分隔符
 *
 *  @return 今天日期字符串
 */
+ (NSString *)todayWithFormatCharacter:(NSString *) character;
/**
 *  明天日期
 *
 *  @param character 分隔符
 *
 *  @return 明天日期字符串
 */
+ (NSString *)tomorrowWithFormatCharacter:(NSString *)character;
/**
 *  后天日期
 *
 *  @param character 分隔符
 *
 *  @return 后天日期字符串
 */
+ (NSString *)afterTomorrowWithFormatCharacter:(NSString *)character;
/**
 *  时间戳转日期格式,以「-」为分隔符
 *
 *  @return 转换后的字典:@{@"date":<日期>,@"time":<时间>}
 */
- (NSDictionary *)stampToDate;
/**
 *  时间戳转日期格式,可随意添加分隔符
 *
 *  @param character 分隔符
 *
 *  @return 转换后的字典:@{@"date":<日期>,@"time":<时间>}
 */
- (NSDictionary *)stampToDateWithCharacter:(NSString *)character;

- (NSDate *)stampToNSDate;

/**
 *  现在当下的日期时间，以「.」为分隔符
 *
 *  @return 当下日期时间的字符串
 */
+ (NSString *)nowDateStr;
/**
 *  现在当下的日期时间,以[.]为分隔符
 *
 *  @param withSec 是否带秒YES带NO不带
 *
 *  @return 日期时间字符串
 */
+ (NSString *)nowDateStrWithSec:(BOOL)withSec;

/**
 *  当前时间（北京）
 *
 *  @param withSec 是否带秒
 *
 *  @return 当前时间字符串
 */
+ (NSString *)nowTimeStrWithSec:(BOOL)withSec;
/**
 *  获取指定日期的字符串
 *
 *  @param date      日期
 *  @param character 分隔符
 *  @param withTime  是否带时间
 *
 *  @return 日期字符串
 */
+ (NSString *)stringWithDate:(NSDate *)date charcater:(NSString *)character withTime:(BOOL)withTime;

/**
 *  几天前、几分钟前
 *
 *  @param stamp 传入的时间戳
 *
 *  @return 几天前、几分钟前
 */
+ (NSString *)stringSinceTimeWithStamp:(NSString *)stamp;


- (NSDate *)dateFormWithDateStr;

- (NSDate *)dateStrToBeijingDate;

@end

/**
 *  正则表达式
 */
@interface NSString (Regular)
/**
 *  判断是否未手机号
 *
 *  @param phoneStr 数字字符串
 *
 *  @return YES:是手机号;NO:不是手机号
 */
- (BOOL)regularPhone;

/**
 *  正整数正则式
 *
 *  @return yes: 是 no : 不是
 */
- (BOOL)regularInteger;
/**
 *  两位小数正浮点数正则式
 *
 *  @return yes : 是 no : 不是
 */
- (BOOL)regular2Decimal;

@end


@interface NSString (Pay)

/**
 *  utf8编码
 *
 *  @return 编号后的值
 */
-(NSString *) utf8ToUnicode;
/**
 *  获取本地IP
 *
 *  @param preferIPv4 YES:ipv4
 *
 *  @return ip字符串
 */
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

/**
 *  生成随机数:带字符的
 *
 *  @return 随机数
 */
+ (NSString *)createRandomChar;
@end


@interface NSString (JsonString)
+ (NSString *)jsonStringFromObj:(id)obj;
@end

/**
 *  其他的常用字符串
 */
@interface NSString (CommonString)


/**
 *  数字字符串转为字符串,不管原来是不是字符串,只要是数字的一律用此来确保不是NSNumber类型
 *
 *  @return 字符串
 */
+ (NSString *)numberString:(id)number;

@end


@interface NSString (HexColorString)

-(UIColor *)hexToColor;

@end

@interface NSString (NetworkStatus)
/**
 *  从状态栏获取网络状态:状态栏不能隐藏
 *
 *  @return 网络状态字符串
 */
+ (NSString *)networkingStatusFromStatebar;

/**
 *  获取运营商
 *
 *  @return 运营商名
 */
+(NSString *)carrierName;


@end

@interface NSString (DeviceInfo)
/**
 *  获取设备的分辨率
 *
 *  @return 设备分辨率
 */
+ (NSString *)resolutionRatio;

@end




