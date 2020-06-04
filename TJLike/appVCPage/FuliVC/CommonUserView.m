//
//  CommonUserView.m
//  TJLike
//
//  Created by imac-1 on 16/8/24.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "CommonUserView.h"

@implementation CommonUserView

@synthesize mDelegate,onGoComment,OnSendClick;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UILabel *mlbLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH-169, 32)];
        mlbLabel.userInteractionEnabled = YES;
        mlbLabel.textColor = [UIColor colorWithWhite:0.16 alpha:1];
        mlbLabel.backgroundColor = [UIColor whiteColor];
        mlbLabel.font = [UIFont systemFontOfSize:13];
        mlbLabel.layer.masksToBounds = YES;
        mlbLabel.layer.cornerRadius = 5;
        mlbLabel.text = @"  评论一下";
        [self addSubview:mlbLabel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame  =mlbLabel.bounds;
        btn.backgroundColor = [UIColor clearColor];
        
        [btn addTarget:self action:@selector(CommentClick) forControlEvents:UIControlEventTouchUpInside];
        [mlbLabel addSubview:btn];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(SCREEN_WIDTH-10-64, 8,64 , 32);
        _rightBtn.backgroundColor = COLOR(250, 0, 8, 1);
        // [_rightBtn setBackgroundImage:[UIImage imageNamed:@"news_bottom_15_@2x.png"] forState:UIControlStateNormal];
        // _rightBtn.layer.borderWidth = 0.3;
        // _rightBtn.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
        [_rightBtn setTitle:@"感兴趣" forState:UIControlStateNormal];
        _rightBtn.layer.cornerRadius = 3;
     //   _rightBtn.layer.borderWidth =1;
     //   _rightBtn.layer.borderColor =  COLOR(250, 0, 8, 1).CGColor;
        [_rightBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.selected = NO;
        [self addSubview:_rightBtn];
        
        
        _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _zanBtn.frame =CGRectMake(SCREEN_WIDTH-10-64*2-10, 8,64 , 32);
        _zanBtn.backgroundColor =  COLOR(250, 0, 8, 1);
        // [_rightBtn setBackgroundImage:[UIImage imageNamed:@"news_bottom_15_@2x.png"] forState:UIControlStateNormal];
        // _rightBtn.layer.borderWidth = 0.3;
        // _rightBtn.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
        [_zanBtn setTitle:@"参与" forState:UIControlStateNormal];
        _zanBtn.layer.cornerRadius = 3;
       // _zanBtn.layer.borderWidth =1;
       // _zanBtn.layer.borderColor = COLOR(250, 0, 8, 1).CGColor;
        [_zanBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _zanBtn.selected = NO;
        [self addSubview:_zanBtn];
        
//        _commentNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 115*0.5, 28)];
//        _commentNum.backgroundColor = [UIColor clearColor];
//        _commentNum.textAlignment = NSTextAlignmentCenter;
//        _commentNum.font = [UIFont systemFontOfSize:13];
//        _commentNum.textColor =  [UIColor lightGrayColor];
//        [_rightBtn addSubview:_commentNum];
//        
//        _showContent = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 115*0.5, 28)];
//        _showContent.backgroundColor = [UIColor clearColor];
//        _showContent.textAlignment = NSTextAlignmentCenter;
//        _showContent.font = [UIFont systemFontOfSize:13];
//        _showContent.textColor =  [UIColor lightGrayColor];
//        _showContent.text = @"原文";
//        _showContent.hidden = YES;
//        [_rightBtn addSubview:_showContent];
        
    }
    return self;
}
- (void)setComment:(int)num{
   // _commentNum.text = [NSString stringWithFormat:@"%d评",num];
}

- (void)BtnClick:(UIButton *)sender{
    SafePerformSelector([mDelegate performSelector:onGoComment withObject:sender]);
    
}
- (void)CommentClick{
    SafePerformSelector([mDelegate performSelector:OnSendClick]);
}

-(void)zanBtnClick:(UIButton *)sender{
    SafePerformSelector([mDelegate performSelector:_zanClick withObject:sender]);
    
}



@end
