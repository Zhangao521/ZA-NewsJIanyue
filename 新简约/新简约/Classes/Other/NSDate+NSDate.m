//
//  NSDate+NSDate.m
//  YoNaoNews
//
//  Created by qingyun on 16/7/13.
//  Copyright © 2016年 Mage. All rights reserved.
//

#import "NSDate+NSDate.h"

@implementation NSDate (SSDate)

+ (instancetype)dateWithString:(NSString *)strDate {
    
    /*!
     *      2016/07/13 10:42:50
     */
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"ss_CN"];
    return [formatter dateFromString:strDate];
    
}


@end
