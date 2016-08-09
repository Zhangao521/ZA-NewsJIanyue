//
//  NewsCell.m
//  新简约
//
//  Created by qingyun on 16/8/1.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "NewsCell.h"
#import "UIImageView+WebCache.h"
@interface NewsCell()
/** 缩略图 */
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
/** 新闻标题 */
@property (weak, nonatomic) IBOutlet UILabel *title;
/** 更新时间 */
@property (weak, nonatomic) IBOutlet UILabel *updatdaTime;
/** 评论数 */
@property (weak, nonatomic) IBOutlet UILabel *comments;
/** 缩略图的宽 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailWidth;

@end

@implementation NewsCell

-(void)setModel:(ModelItem *)model{
    _model = model;
    [_thumbnail sd_setImageWithURL:[NSURL URLWithString:model.strThumbnail] placeholderImage:nil];
    if ([model.strThumbnail isEqualToString:@""]) {
        _thumbnailWidth.constant = 0;
    }
    _title.text = model.strTitle;
    _title.textColor = [UIColor colorWithRed:0.01 green:0.01 blue:0.44 alpha:1];
    if (model.strCmmentsall != 0) {
        _comments.text = model.strCmmentsall;
        _comments.textColor = [UIColor grayColor];
    }
    if (model.strUpdateTime) {
        _updatdaTime.backgroundColor = [UIColor clearColor];
        _updatdaTime.text = model.strUpdateTime;
        _updatdaTime.textColor = [UIColor grayColor];
    }
    _thumbnail.layer.borderWidth = 1;
    _thumbnail.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)newsCellWithTableView:(UITableView *)table {
    static NSString *strID = @"NewsCell";
    
    NewsCell *cell = [table dequeueReusableCellWithIdentifier:strID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:strID owner:nil options:nil] firstObject];
    }
    return cell;
}

@end
