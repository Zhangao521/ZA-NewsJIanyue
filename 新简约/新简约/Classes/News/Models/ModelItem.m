//
//  GoodsModel.m
//  新闻1
//
//  Created by qingyun on 16/7/14.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ModelItem.h"
#import "Common.h"
#import "NSDate+NSDate.h"

@implementation ModelItem

+(instancetype)modelWithDictionary:(NSDictionary *)dicData{
    return [[self alloc] initWithDictionary:dicData];
}

-(instancetype)initWithDictionary:(NSDictionary *)dictData{
    if (self = [super init]) {
        _strThumbnail = dictData[mdStrThumbnail];
        _strTitle = dictData[mdStrTitle];
        _strID = dictData[mdStrId];
        _strSource = dictData[mdStrSource];
        //发布时间
        NSString *strTime = dictData[mdStrUpdateTime];
        if (strTime) {
            NSDate *date = [NSDate dateWithString:strTime];
             _strUpdateTime = [self dateStringFormDate:date];
        }
        _strCmmentsall = dictData[mdStrCommentsall];
        _strType = dictData[mdStrTpye];
        _strLink = dictData[mdStrLink];
        _strHotLink = dictData[mdStrLink][@"url"];
        _strHotName = dictData[mdStrRecommendChannel][@"name"];
        
    }
    return self;
}

- (NSString *)dateStringFormDate:(NSDate *)date {
    
    NSTimeInterval interval = -[date timeIntervalSinceNow];
    if(interval < 60){
        return @"刚刚";
    } else if (interval < 60 * 10) {// 分
        return [NSString stringWithFormat:@"%d分钟前",(int)(interval / 60)];
    } else if (interval < 60 * 60 * 24) {// 一天内
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        return [formatter stringFromDate:date];
    } else if (interval < 60 * 60 * 24 * 30 && interval >= 60 * 60 * 24) {// 天
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd"];
        return [formatter stringFromDate:date];
    }
    return nil;
}

@end
