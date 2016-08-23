//
//  NSString+Secret.m
//  Jolyvia
//
//  Created by Kenway on 15/11/2.
//  Copyright © 2015年 Kenway. All rights reserved.
//

#import "NSString+Jolyvia.h"
#import "NSDate+LocalDate.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
//ip
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation NSString (Secret)

- (NSString *)md5Encryption{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, self.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

@end

@implementation NSString (FilePath)

+ (NSString *)fileName:(NSString *)name{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@保存路径:%@",name,[path stringByAppendingPathComponent:name]);
    return [path stringByAppendingPathComponent:name];
}

+ (NSString *)fileName:(NSString *)name withDirName:(NSString *)dirName{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    if (dirName.length > 0 || dirName != nil) {
        path = [path stringByAppendingPathComponent:dirName];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"创建文件夹:\n%@",path);
    }
    NSLog(@"%@保存路径:%@",name,[path stringByAppendingPathComponent:name]);
    return [path stringByAppendingPathComponent:name];
}

+ (NSString *)bundleFileName:(NSString *)name type:(NSString *)type{
    return [[NSBundle mainBundle] pathForResource:name ofType:type];
}

+ (NSString *)bundleImagePathWithName:(NSString *)imageName{
    return [[NSBundle mainBundle] pathForResource:imageName ofType:@"png" inDirectory:@"images"];
}

@end

@implementation NSString (DateString)

+ (NSString *)todayWithFormatCharacter:(NSString *)character{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc]init];
    NSString *dateFormat = nil;
    if (character == nil || [character isEqualToString:@""]) {
        dateFormat = @"yyyyMMdd";
    }else{
        dateFormat = [NSString stringWithFormat:@"yyyy'%@'MM'%@'dd",character,character];
    }
    dateFomatter.dateFormat = dateFormat;
    NSString *today = [dateFomatter stringFromDate:date];
    return today;
}

+ (NSString *)tomorrowWithFormatCharacter:(NSString *)character{
    NSDate *today = [NSDate date];
    NSDate *tomorrow = [today dateByAddingTimeInterval:24*60*60];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc]init];
    NSString *dateFormat = nil;
    if (character == nil || [character isEqualToString:@""]) {
        dateFormat = @"yyyyMMdd";
    }else{
        dateFormat = [NSString stringWithFormat:@"yyyy'%@'MM'%@'dd",character,character];
    }
    dateFomatter.dateFormat = dateFormat;
    
    return [dateFomatter stringFromDate:tomorrow];
}
+ (NSString *)afterTomorrowWithFormatCharacter:(NSString *)character{
    NSDate *today = [NSDate date];
    NSDate *tomorrow = [today dateByAddingTimeInterval:24*60*60];
    NSDate *afterTomorrow = [tomorrow dateByAddingTimeInterval:24*60*60];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc]init];
    NSString *dateFormat = nil;
    if (character == nil || [character isEqualToString:@""]) {
        dateFormat = @"yyyyMMdd";
    }else{
        dateFormat = [NSString stringWithFormat:@"yyyy'%@'MM'%@'dd",character,character];
    }
    dateFomatter.dateFormat = dateFormat;
    
    return [dateFomatter stringFromDate:afterTomorrow];
}

- (NSDictionary *)stampToDate{
    NSDateFormatter *stampFomatter = [[NSDateFormatter alloc]init];
    NSDate *stampDate = [NSDate dateWithTimeIntervalSince1970:[self intValue]];
    stampFomatter.dateFormat = @"yyyy-MM-dd";
//    stampFomatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    NSString *dateStr = [stampFomatter stringFromDate:stampDate];
    stampFomatter.dateFormat = @"HH:mm";
    NSString *timeStr = [stampFomatter stringFromDate:stampDate];
    return @{@"date":dateStr,@"time":timeStr};
}

- (NSDictionary *)stampToDateWithCharacter:(NSString *)character{
    NSDateFormatter *stampFomatter = [[NSDateFormatter alloc]init];
    NSDate *stampDate = [NSDate dateWithTimeIntervalSince1970:[self intValue]];
    stampFomatter.dateFormat = [NSString stringWithFormat:@"yyyy'%@'MM'%@'dd",character,character];
    stampFomatter.timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
    NSString *dateStr = [stampFomatter stringFromDate:stampDate];
    stampFomatter.dateFormat = @"HH:mm";
    NSString *timeStr = [stampFomatter stringFromDate:stampDate];
    return @{@"date":dateStr,@"time":timeStr};
}

- (NSDate *)stampToNSDate {
    NSDate *stampDate = [NSDate dateWithTimeIntervalSince1970:[self intValue]];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:stampDate];
    NSDate *resultDate = [stampDate dateByAddingTimeInterval:interval];
    return resultDate;
}

+ (NSString *)nowDateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    return [formatter stringFromDate:[NSDate beiJingDate]];
}

+ (NSString *)nowDateStrWithSec:(BOOL)withSec{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    if (withSec) {
        formatter.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    }else{
        formatter.dateFormat = @"yyyy.MM.dd HH:mm";
    }
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    return [formatter stringFromDate:[NSDate beiJingDate]];
}

+ (NSString *)nowTimeStrWithSec:(BOOL)withSec{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    if (withSec) {
        formatter.dateFormat = @"HH:mm:ss";
    }else{
        formatter.dateFormat = @"HH:mm";
    }
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    return [formatter stringFromDate:[NSDate beiJingDate]];
}
+ (NSString *)stringWithDate:(NSDate *)date charcater:(NSString *)character withTime:(BOOL)withTime{
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc]init];
    NSString *dateFormat = nil;
    if (withTime) {
        if (character == nil || [character isEqualToString:@""]) {
            dateFormat = @"yyyyMMdd HH:mm:ss";
        }else{
            dateFormat = [NSString stringWithFormat:@"yyyy'%@'MM'%@'dd HH:mm:ss",character,character];
        }
    }else{
        if (character == nil || [character isEqualToString:@""]) {
            dateFormat = @"yyyyMMdd";
        }else{
            dateFormat = [NSString stringWithFormat:@"yyyy'%@'MM'%@'dd",character,character];
        }
    }
    dateFomatter.dateFormat = dateFormat;
    
    return [dateFomatter stringFromDate:date];
}

+ (NSString *)stringSinceTimeWithStamp:(NSString *)stamp{
    return nil;
}

- (NSDate *)dateFormWithDateStr{
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc]init];
    dateFomatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [dateFomatter dateFromString:self];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *beijingDate = [date  dateByAddingTimeInterval: interval];
    return beijingDate;
}

- (NSDate *)dateStrToBeijingDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:self];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *beijingDate = [date  dateByAddingTimeInterval: interval];
    return beijingDate;
}

@end

@implementation NSString (Regular)

- (BOOL)regularPhone{
    if ([self regularLandPhone] || [self regularMOPhone] || [self regularHKPhone]) {
        return YES;
    }
    return NO;
}
/**
 *  大陆手机号正则式判断
 *
 *  @return yes:匹配；no：不匹配
 */
- (BOOL)regularLandPhone{
    NSString *reg = @"^(1[345678][0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"self matches %@",reg];
    if ([pre evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}
/**
 *  澳门手机号正则式判断
 *
 *  @return yes:匹配；no：不匹配
 */
- (BOOL)regularMOPhone{
    NSString *reg = @"(^008536\\d{7}$)|(^8536\\d{7}$)";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"self matches %@",reg];
    if ([pre evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}
/**
 *  香港手机号正则式判断
 *
 *  @return yes:匹配；no：不匹配
 */
- (BOOL)regularHKPhone{
    NSString *reg = @"(^00852(6|9)\\d{7}$)|(^852(6|9)\\d{7}$)";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"self matches %@",reg];
    if ([pre evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

/**
 *  正整数正则式
 *
 *  @return YES：是 NO：不是
 */
- (BOOL)regularInteger{
    NSString *reg = @"^[1-9]\\d*$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"self matches %@",reg];
    if ([pre evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}
/**
 *  两位小数的正浮点数
 *
 *  @return yes : 是 no: 不是
 */
- (BOOL)regular2Decimal{
    NSString *reg = @"^[1-9]\\d*\\.\\d{1,2}|0\\.\\d{1,2}$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"self matches %@",reg];
    if ([pre evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

@end

@implementation NSString (Pay)

-(NSString *) utf8ToUnicode{
    NSUInteger length = [self length];
    NSMutableString *resultString = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++){
        unichar _char = [self characterAtIndex:i];
        //判断是否为英文和数字
        if (_char <= '9' && _char >='0'){
            [resultString appendFormat:@"%@",[self substringWithRange:NSMakeRange(i,1)]];
        }else if(_char >='a' && _char <= 'z'){
            [resultString appendFormat:@"%@",[self substringWithRange:NSMakeRange(i,1)]];
        }else if(_char >='A' && _char <= 'Z'){
            [resultString appendFormat:@"%@",[self substringWithRange:NSMakeRange(i,1)]];
        }else{
            [resultString appendFormat:@"\\u%x",[self characterAtIndex:i]];
        }
    }
    
    return [resultString uppercaseString];
    
}

/**
 *  获取IP
 *
 *  @param preferIPv4 是否为IPv4
 *
 *  @return ip
 */
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [[self class] getIPAddresses];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}
+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue;
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                char addrBuf[INET6_ADDRSTRLEN];
                if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

/**
 *  生成随机数字字符的字符串
 *
 *  @return 随机数
 */
+ (NSString *)createRandomChar{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < 32; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 'A';
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

@end


@implementation NSString (JsonString)

+ (NSString *)jsonStringFromObj:(id)obj{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    if (error == nil) {
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"%@转成Json:%@",obj,jsonString);
        return jsonString;
    }else{
        return nil;
    }
}

@end


@implementation NSString (CommonString)

+ (NSString *)numberString:(id)number{
    if ([number isKindOfClass:[NSNumber class]]) {
        return [number stringValue];
    }else{
        return number;
    }
}



@end


@implementation NSString (HexColorString)

-(UIColor *)hexToColor{
    NSString *hexNum = self;
    if ([self hasPrefix:@"#"]) {
        hexNum = [self substringFromIndex:1];
    }
    
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[hexNum substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexNum substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexNum substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:1.0f];
}

@end


@implementation NSString (NetworkStatus)
/**
 *  从状态栏获取网络状态:状态栏不能隐藏
 *
 *  @return 网络状态字符串
 */
+ (NSString *)networkingStatusFromStatebar{
    // 状态栏是由当前app控制的，首先获取当前app
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    NSString *stateString = @"WIFI";
    switch (type) {
        case 0:{
            stateString = @"无网络";
        }break;
        case 1:{
            stateString = @"2G";
        }break;
        case 2:{
            stateString = @"3G";
        }break;
        case 3:{
            stateString = @"4G";
        }break;
        case 4:{
            stateString = @"LTE";
        }break;
        case 5:{
            stateString = @"WIFI";
        }break;
        default:{
            
        }break;
    }
    
    return stateString;
}

/**
 *  运营商名称
 *
 *  @return 运营商名称
 */
+(NSString *)carrierName{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCarrier =[carrier carrierName];
    if ([currentCarrier isEqualToString:@"中国联通"]) {
        currentCarrier = @"China Unicom";
    }else if ([currentCarrier isEqualToString:@"中国移动"]){
        currentCarrier = @"China Mobile";
    }else if ([currentCarrier isEqualToString:@"中国电信"]){
        currentCarrier = @"China Telecom";
    }
    return currentCarrier;
}

@end


@implementation NSString (DeviceInfo)
/**
 *  获取设备分辨率
 *
 *  @return 设备分辨率
 */
+ (NSString *)resolutionRatio{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *ratio = [NSString stringWithFormat:@"%.0f*%.0f",size.width * scale,size.height * scale];
    return ratio;
}

@end







