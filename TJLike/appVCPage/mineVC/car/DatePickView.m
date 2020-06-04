//
//  DatePickView.m
//  TJLike
//
//  Created by MC on 15/4/25.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "DatePickView.h"

@implementation DatePickView
{
    UIDatePicker *pickView;
}
@synthesize mDelegate,okClick;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, 250)];
        back.backgroundColor = [UIColor whiteColor];
        [self addSubview:back];
        
        pickView  = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
//        pickView.minimumDate = [NSDate date];
        pickView.datePickerMode = UIDatePickerModeDate;
        [back addSubview:pickView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        [back addSubview:lineView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 200, SCREEN_WIDTH, 50);
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
        [back addSubview:btn];
    }
    return self;
}
- (void)BtnClick{
    SafePerformSelector([mDelegate performSelector:okClick withObject:pickView.date]);
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
