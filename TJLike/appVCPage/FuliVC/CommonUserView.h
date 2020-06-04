//
//  CommonUserView.h
//  TJLike
//
//  Created by imac-1 on 16/8/24.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonUserView : UIView
@property (nonatomic, assign) id mDelegate;
@property (nonatomic, assign) SEL onGoComment;
@property (nonatomic, assign) SEL OnSendClick;
@property (nonatomic, assign) SEL zanClick;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *zanBtn;
//@property (nonatomic, strong) UILabel *commentNum;
//@property (nonatomic, strong) UILabel *showContent;
@property (nonatomic, assign) int comment;
@end
