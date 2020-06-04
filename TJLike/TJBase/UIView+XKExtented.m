//
//  UIView+XKExtented.m
//  百思
//
//  Created by 优仕汇 on 2017/3/29.
//  Copyright © 2017年 Fukui. All rights reserved.
//

#import "UIView+XKExtented.h"

@implementation UIView (XKExtented)

- (void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setX:(CGFloat)X{
    
    CGRect rect = self.frame;
    rect.origin.x = X;
    self.frame = rect;
}

- (CGFloat)X{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)Y{
    CGRect rect = self.frame;
    rect.origin.y = Y;
    self.frame = rect;
}

- (CGFloat)Y{
    return self.frame.origin.y;
}

@end
