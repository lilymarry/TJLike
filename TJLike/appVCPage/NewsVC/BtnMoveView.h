//
//  BtnMoveView.h
//  TJLike
//
//  Created by imac-1 on 16/7/15.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BtnMoveView : UIView
@property (nonatomic, strong) NSArray* buttonTitles;
//@property (nonatomic, strong) NSArray* buttonTitles1;
@property (nonatomic, strong) NSMutableArray* allButtons;
//@property (nonatomic, strong) NSMutableArray* allButtons1;
//@property (nonatomic, strong) NSMutableArray* views;
//一个判断是哪个按钮被按下的判断值
@property (nonatomic, unsafe_unretained) NSInteger index;

@property (nonatomic, strong) UIButton* moveButton;

- (void)removeAllButtons;
- (void)createButtons;
- (void)removeAllBtnMoves;
@end
