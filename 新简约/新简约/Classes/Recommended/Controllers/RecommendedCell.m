//
//  RecommendedCell.m
//  新闻1
//
//  Created by qingyun on 16/7/15.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RecommendedCell.h"
#import "UIImageView+WebCache.h"

@interface RecommendedCell ()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
/** 来源 */
@property (weak, nonatomic) IBOutlet UILabel *source;
/** 缩略图的宽 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailWidth;


@end

@implementation RecommendedCell
-(void)setModel:(ModelItem *)model{
    _model = model;
    [_thumbnail sd_setImageWithURL:[NSURL URLWithString:model.strThumbnail] placeholderImage:nil];
    if ([model.strThumbnail isEqualToString:@""]) {//只有标题，没有缩略图
        _thumbnailWidth.constant = 0;
    }
    _labelTitle.text = model.strTitle;
    _labelTitle.textColor = [UIColor colorWithRed:0.01 green:0.01 blue:0.44 alpha:1];
    NSString *strSource = model.strHotName;
    if (strSource) {
        _source.text = [NSString stringWithFormat:@" %@ ",strSource];
        _source.textColor = [UIColor colorWithRed:0.01 green:0.01 blue:0.44 alpha:1];
        _source.layer.borderColor = [UIColor grayColor].CGColor;
        _source.layer.borderWidth = 1.0;
        _source.layer.cornerRadius = 7;
    }
    _thumbnail.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)awakeFromNib {
//    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)recommendedCellWithTableView:(UITableView *)table {
    static NSString *strID = @"RecommendedCell";
    
    RecommendedCell *cell = [table dequeueReusableCellWithIdentifier:strID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:strID owner:nil options:nil] firstObject];
    }
    return cell;
}

@end
