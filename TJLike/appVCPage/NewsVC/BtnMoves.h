//
//  BtnMoves.h
//  TJLike
//
//  Created by imac-1 on 16/7/15.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BtnMoves;
typedef void (^DisplayComletionBlock)(void);
typedef void (^DisplayCloseBlock)(UIView* displayView,CFTimeInterval duration);
typedef void (^DisplayOpenBlock)(UIView* displayView,CFTimeInterval duration);

@protocol MoveButtonDelegate <NSObject>

- (void) dragButton:(BtnMoves*)button buttons:(NSArray*)buttons;
@end
@interface BtnMoves : UIButton
@property (nonatomic ,strong) id<MoveButtonDelegate> delegate;
//存放需要拖拽的按钮数组
@property (nonatomic ,strong) NSMutableArray* btnArray;
//按钮正在被拖拽移动时的背景颜色
@property (nonatomic ,strong) UIColor* color;
//一排按钮的个数，如果使用openDisplayView方法，lineCount不能为空
@property (nonatomic ,unsafe_unretained) NSUInteger lineCount;
@property (nonatomic ,strong) NSString* btnId;

@end
