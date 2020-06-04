//
//  SexPickerView.m
//  TJLike
//
//  Created by Madroid on 15/5/1.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "SexPickerView.h"

@implementation SexPickerView

{
    UIPickerView *pickView;
}
@synthesize mDelegate,okClick;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, 250)];
        back.backgroundColor = [UIColor whiteColor];
        [self addSubview:back];
        
        pickView  = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
        pickView.delegate  =self;
        pickView.dataSource = self;
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
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row==0) {
        return @"女";
    }else{
        return @"男";
    }
}
- (void)BtnClick{
    NSString *sex = @"";
    if ([pickView selectedRowInComponent:0]==0) {
        sex = @"女";
    }
    else{
        sex = @"男";
    }
    
    SafePerformSelector([mDelegate performSelector:okClick withObject:sex]);
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
