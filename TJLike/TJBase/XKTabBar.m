//
//  XKTabBar.m
//  百思
//
//  Created by 优仕汇 on 2017/3/27.
//  Copyright © 2017年 Fukui. All rights reserved.
//

#import "XKTabBar.h"
#import "UIView+XKExtented.h"
#import "View1.h"

@interface XKTabBar ()

@property (nonatomic, weak)UIButton *addBtn; // 加号按钮

@end

@implementation XKTabBar

- (instancetype)init{
    if (self = [super init]) {
        
        // 添加中间加号按钮
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[UIImage imageNamed:@"tabBar_publish_icon@2x"] forState:UIControlStateNormal];
        [addBtn setImage:[UIImage imageNamed:@"tabBar_publish_icon@2x"] forState:UIControlStateHighlighted];
        [addBtn addTarget:self action:@selector(addpress) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
        self.addBtn = addBtn;
        
    }
    return self;
}
-(void)addpress
{

    NSLog(@"vhfvkvjv");
   // ViewController *view1=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    
    View1 *v1=[[View1 alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
   
    [[self viewController] .view addSubview:v1];
    
    
}
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
#pragma mark - 重新布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
 
    
    CGFloat itemY = 0;
    
    // 添加 UIView+XKExtented 可以直接拿到宽度
//    CGFloat itemW = self.frame.size.width / 5.0;
//    CGFloat itemH = self.frame.size.height;

    CGFloat itemW = self.width / 5.0;
    CGFloat itemH = self.height;
    NSInteger index = 0; // 设置一个简单的索引

    // 中间加号位置
    self.addBtn.frame = CGRectMake(0, 0, self.addBtn.currentImage.size.width, self.addBtn.currentImage.size.height);
    // 不是self.center, 因为self.center 的Y方向位置特别大
    self.addBtn.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    
    for (UIView *button in self.subviews) {
        if (button == self.addBtn || ![button isKindOfClass:[UIControl class]]) {
            // 如果不是UITabBarButton 就跳过
            continue;
        }
        
        // 重新布局 UITabBarButton
        CGFloat itemX = itemW * (index  > 1? (index + 1) : index);
        button.frame = CGRectMake(itemX, itemY+6, itemW, itemH);
        
        index++;
    }

}

@end
