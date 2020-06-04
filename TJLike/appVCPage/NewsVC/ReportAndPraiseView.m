//
//  ReportAndPraiseView.m
//  TJLike
//
//  Created by Madroid on 15/4/30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "ReportAndPraiseView.h"

@implementation ReportAndPraiseView
{

}
@synthesize delegate,report,praise;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius =5 ;
        for (int i = 0; i<2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*60, 0, 60, 30);
            [btn setTitle:i==0?@"举报":@"赞" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.tag = 1000+i;
            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(59, 0, 1, 28)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        
    }
    return self;
}
- (void)BtnClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        SafePerformSelector([delegate performSelector:report withObject:nil]);
    }
    else{
        SafePerformSelector([delegate performSelector:praise withObject:nil]);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
