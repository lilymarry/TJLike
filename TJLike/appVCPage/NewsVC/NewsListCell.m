//
//  NewsListCell.m
//  TJLike
//
//  Created by MC on 15-3-30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "NewsListCell.h"
#import "UIImageView+WebCache.h"

@implementation NewsListCell{
    UIImageView *mlbImageView;
    UILabel *mlbTitleLabel;
    UILabel *mlbContent;
    UILabel *mlbComment;
    UILabel *mlbCategory;

    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 83.5, SCREEN_WIDTH-20, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:lineView];
        
        mlbImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 11.5, 75, 60)];
        [self.contentView addSubview:mlbImageView];
        
        mlbTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(92.5, 11.5, SCREEN_WIDTH-105, 16)];
        mlbTitleLabel.backgroundColor = [UIColor clearColor];
        mlbTitleLabel.textAlignment = NSTextAlignmentLeft;
        mlbTitleLabel.font = [UIFont systemFontOfSize:15.5];
        mlbTitleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:mlbTitleLabel];
        
        mlbContent = [[UILabel alloc]initWithFrame:CGRectMake(92.5, 27, SCREEN_WIDTH-104, 35)];
        mlbContent.numberOfLines = 2;
        mlbContent.backgroundColor = [UIColor clearColor];
        mlbContent.textAlignment = NSTextAlignmentLeft;
        mlbContent.font = [UIFont systemFontOfSize:11.5];
        mlbContent.textColor = [UIColor grayColor];
        [self.contentView addSubview:mlbContent];
        
        mlbComment = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-135, 59, 100, 13)];
        mlbComment.backgroundColor = [UIColor clearColor];
        mlbComment.textAlignment = NSTextAlignmentRight;
        mlbComment.font = [UIFont systemFontOfSize:13];
        mlbComment.textColor = [UIColor grayColor];
        [self.contentView addSubview:mlbComment];
        
        mlbCategory = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mlbComment.frame)+4, 59, 25, 13)];
        mlbCategory.backgroundColor = [UIColor clearColor];
        mlbCategory.textAlignment = NSTextAlignmentCenter;
        mlbCategory.font = [UIFont systemFontOfSize:10];
        mlbCategory.textColor = [UIColor redColor];
        mlbCategory.layer.borderWidth = 0.3;
        mlbCategory.layer.cornerRadius = 3.0;
        
        mlbCategory.layer.borderColor = [UIColor redColor].CGColor;
        
        
        
        [self.contentView addSubview:mlbCategory];
    }
    return self;
}
- (void)LoadContent:(NewsListInfo *)info{
    [mlbImageView sd_setImageWithURL:[NSURL URLWithString:info.pic] placeholderImage:[UIImage imageNamed:@"lunbo_default_icon"]];
    mlbTitleLabel.text = info.title;
    mlbContent.text = info.brief;
    mlbComment.text = [NSString stringWithFormat:@"%d评",info.comment];
    
    if ([info.property isEqualToString:@"普通"]){
        mlbComment.frame = CGRectMake(SCREEN_WIDTH-110, 59, 100, 13);
        mlbCategory.hidden = YES;
    }else{
        mlbCategory.hidden = NO;
        mlbCategory.text = info.property;
        mlbComment.frame = CGRectMake(SCREEN_WIDTH-138, 59, 100, 13);
    }
}

- (void)awakeFromNib {
    // Initialization code
      [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
