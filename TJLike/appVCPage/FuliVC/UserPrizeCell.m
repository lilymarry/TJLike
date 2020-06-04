//
//  UserPrizeCell.m
//  TJLike
//
//  Created by imac-1 on 16/8/31.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "UserPrizeCell.h"

@implementation UserPrizeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        [_userIMA setImage:[UIImage imageNamed:@"news_list_default"]];
        [_userIMA.layer setMasksToBounds:YES];
        _userIMA.layer.cornerRadius =72.5*0.5;
        
        
   
        [_time setTextColor:[UIColor grayColor]];
        [_time setFont:[UIFont systemFontOfSize:12]];
        [_time setText:@"2015-04-03 21:05:04"];
       

    }
    return self;
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
