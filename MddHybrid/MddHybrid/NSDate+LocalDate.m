//
//  NSDate+LocalDate.m
//  Jolyvia
//
//  Created by Kenway on 15/11/19.
//  Copyright © 2015年 Kenway. All rights reserved.
//

#import "NSDate+LocalDate.h"

@implementation NSDate (LocalDate)
+ (NSDate *)beiJingDate{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *nowDate = [date  dateByAddingTimeInterval: interval];
    return nowDate;
}

+ (NSDate *)stampToNSDate:(double)doubleDate {
    NSDate *stampDate = [NSDate dateWithTimeIntervalSince1970:doubleDate];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:stampDate];
    NSDate *resultDate = [stampDate dateByAddingTimeInterval:interval];
    return resultDate;
}


@end
