//
//  NewsRelationListView.m
//  TJLike
//
//  Created by MC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "NewsRelationListView.h"

@implementation NewsRelationListView
{
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *sourceLabel;
    NewsRelationNewsList *mInfo;
}
@synthesize mDelegate,onClick;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, SCREEN_WIDTH-56, 35)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor =[UIColor colorWithRed:93.f/255.f green:93.f/255.f blue:94.f/255.f alpha:1];
        nameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:nameLabel];
        
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 35, SCREEN_WIDTH-56, 12)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor colorWithRed:108.f/255.f green:108.f/255.f blue:108.f/255.f alpha:1];
        timeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:timeLabel];
        
        sourceLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 35, SCREEN_WIDTH-130, 12)];
        sourceLabel.backgroundColor = [UIColor clearColor];
        sourceLabel.textColor = [UIColor colorWithRed:108.f/255.f green:108.f/255.f blue:108.f/255.f alpha:1];
        sourceLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:sourceLabel];
        
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
     //   [self addSubview:lineView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
       // btn.backgroundColor = [ UIColor clearColor];
      //  btn.layer.borderWidth = 1;
       // btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [btn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}
- (void)BtnClick{
    SafePerformSelector([mDelegate performSelector:onClick withObject:mInfo]);
}
- (void)LoadContent:(NewsRelationNewsList *)info{
    mInfo = info;
    nameLabel.text = info.title;
    sourceLabel.text = info.source;
    timeLabel.text = [info.pubtime substringToIndex:10];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
