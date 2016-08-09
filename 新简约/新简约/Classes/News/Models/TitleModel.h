//
//  TitleModel.h
//  新简约
//
//  Created by qingyun on 16/8/1.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TitleModel : NSObject
/** 本地plist文件内部头部视图数组 */
@property (nonatomic, copy) NSString *species;
/** webView页面详情链接 */
@property (nonatomic, copy) NSString *url;
+(instancetype)modelWithDictionary:(NSDictionary *)dict;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
