//
//  GoodsModel.h
//  新闻1
//
//  Created by qingyun on 16/7/14.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelItem : NSObject

/** 缩略图 */
@property (nonatomic ,strong) NSString *strThumbnail;
/** 新闻标题 */
@property (nonatomic ,strong) NSString *strTitle;
/** 新闻来源 */
@property (nonatomic ,strong) NSString *strSource;
/** 新闻发布时间 */
@property (nonatomic ,strong) NSString *strUpdateTime;
/** 评论数 */
@property (nonatomic ,strong) NSString *strCmmentsall;
/** 新闻详情 */
@property (nonatomic ,strong) NSString *strLink;
/** 新闻页面链接 */
@property (nonatomic, strong) NSString *strID;
/** 新闻类型 （文本，图片）*/
@property (nonatomic ,strong) NSString *strType;
/** 推荐页面数据链接 */
@property (nonatomic ,strong) NSString *strHotLink;
/** 推荐频道 */
@property (nonatomic ,strong) NSString *strHotName;
///** 点赞数 */
//@property (nonatomic ,assign) NSInteger likeNum;
/** 自定义构造方法 */
-(instancetype) initWithDictionary:(NSDictionary *)dictData;
+(instancetype) modelWithDictionary:(NSDictionary *)dicData;


@end
