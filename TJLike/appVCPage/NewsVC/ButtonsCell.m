//
//  ButtonsCell.m
//  两个滚动视图做界面
//
//  Created by leiyu on 16/6/28.
//  Copyright © 2016年 华康集团. All rights reserved.
//

#import "ButtonsCell.h"

@implementation ButtonsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor=[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
