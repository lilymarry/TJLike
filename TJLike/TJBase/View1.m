//
//  View1.m
//  TJLike
//
//  Created by imac-1 on 2017/6/13.
//  Copyright © 2017年 IPTV_MAC. All rights reserved.
//

#import "View1.h"

@implementation View1

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor lightGrayColor];
        
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(80, 100, 80, 100);
        but.backgroundColor = [UIColor redColor];
        [but setTitle:@"shds" forState:UIControlStateNormal];
        [but addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:but];
    }
    return self;
}
-(void)Click
{
    [self removeFromSuperview];
}
@end
