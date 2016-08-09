//
//  NewsCell.h
//  新简约
//
//  Created by qingyun on 16/8/1.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelItem.h"

@interface NewsCell : UITableViewCell
/** 利用setmodel方法设置各个属性 */
@property (nonatomic ,strong) ModelItem *model;

+ (instancetype)newsCellWithTableView:(UITableView *)table;
@end
