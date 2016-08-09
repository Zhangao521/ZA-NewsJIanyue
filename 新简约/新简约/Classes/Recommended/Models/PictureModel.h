//
//  PictureModel.h
//  新简约
//
//  Created by qingyun on 16/8/8.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureModel : NSObject
/** 缩略图 */
@property (nonatomic ,strong) NSString *strThumbnail;
/** 点赞数 */
@property (nonatomic ,strong) NSString *strLikeNum;
/** 新闻类型 （文本，图片）*/
@property (nonatomic ,strong) NSString *strType;

-(instancetype) initWithDictionary:(NSDictionary *)dictData;
+(instancetype) modelWithDictionary:(NSDictionary *)dicData;
@end
