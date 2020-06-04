//
//  TJShowImageView.h
//  TJLike
//
//  Created by IPTV_MAC on 15/5/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TapHideBlock)(void);

@interface TJShowImageView : UIView

@property (nonatomic, copy)TapHideBlock tapHideBlock;

- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)images;

@end
