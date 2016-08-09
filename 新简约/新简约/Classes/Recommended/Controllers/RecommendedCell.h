//
//  RecommendedCell.h
//  新闻1
//
//  Created by qingyun on 16/7/15.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelItem.h"

@interface RecommendedCell : UITableViewCell
/** 利用setmodel方法设置各个属性 */
@property (nonatomic ,strong) ModelItem *model;
+(instancetype)recommendedCellWithTableView:(UITableView *)table;
@end
 