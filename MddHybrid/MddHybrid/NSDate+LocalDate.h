//
//  NSDate+LocalDate.h
//  Jolyvia
//
//  Created by Kenway on 15/11/19.
//  Copyright © 2015年 Kenway. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LocalDate)

/**
 *  现在的北京时间(日期加时间)
 *
 *  @return 现在的的北京时间NSDate
 */
+ (NSDate *)beiJingDate;

+ (NSDate *)stampToNSDate:(double)doubleDate;
@end
