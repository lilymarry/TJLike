//
//  PutInCarNameView.m
//  TJLike
//
//  Created by MC on 15/4/25.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "PutInCarNameView.h"
#import "AutoAlertView.h"

@implementation PutInCarNameView
{
    UITextField *mField;
}

@synthesize mDelegate,OKClick;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        UIView *back = [[UIView alloc]initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH-40, 150)];
        back.backgroundColor = [UIColor whiteColor];
        [self addSubview:back];
        
        UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-60, 50)];
        mLabel.textColor = [UIColor blueColor];
        mLabel.text = @"请添加您的爱车昵称";
        [back addSubview:mLabel];
        
        mField = [[UITextField alloc]initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-60, 45)];
        mField.placeholder = @"请输入您的车牌号";
        mField.inputAccessoryView = [self GetInputAccessoryView];
        mField.font = [UIFont systemFontOfSize:15];
        mField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [back addSubview:mField];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH-40, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [back addSubview:lineView];
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 95, SCREEN_WIDTH-40, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [back addSubview:lineView];
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH-40, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [back addSubview:lineView];
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0.5*(SCREEN_WIDTH-40), 110, 0.5, 40)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [back addSubview:lineView];
        
        for (int i = 0; i<2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*0.5*(SCREEN_WIDTH-40), 110, 0.5*(SCREEN_WIDTH-40), 40);
            [btn setTitle:i==0?@"确认":@"取消" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.tag = 100+i;
            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [back addSubview:btn];
        }
    }
    return self;
}
- (void)BtnClick:(UIButton *)sender{
    if (sender.tag==101) {
        
    }
    else{
        if (mField.text.length==0) {
            [AutoAlertView ShowMessage:@"请输入爱车名称"];
            return;
        }
        SafePerformSelector([mDelegate performSelector:OKClick withObject:mField.text]);
    }
    [self removeFromSuperview];
}

- (UIView *)GetInputAccessoryView
{
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    inputView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(inputView.frame.size.width-50, 0, 50, inputView.frame.size.height);
    [btn setTitle:@"隐藏" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(OnHideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:btn];
    
    return inputView;
}
- (void)OnHideKeyboard {
    [self endEditing:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
