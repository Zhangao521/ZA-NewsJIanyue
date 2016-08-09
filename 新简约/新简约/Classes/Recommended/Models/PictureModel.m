//
//  PictureModel.m
//  新简约
//
//  Created by qingyun on 16/8/8.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "PictureModel.h"
#import "Common.h"

@implementation PictureModel
+(instancetype)modelWithDictionary:(NSDictionary *)dicData{
    return [[self alloc] initWithDictionary:dicData];
}

-(instancetype)initWithDictionary:(NSDictionary *)dictData{
    _strThumbnail = dictData[mdStrThumbnail];
    _strLikeNum = dictData[mdStrLike];
    _strType = dictData[mdStrTpye];
    return self;
}


@end
