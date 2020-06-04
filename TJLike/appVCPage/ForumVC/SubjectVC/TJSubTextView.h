//
//  TJSubTextView.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/22.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJSubTextViewDelegate <NSObject>

- (void)tapbtnPraise;
- (void)tapBtnImages;
- (void)sendComments:(NSString *)strComments;
- (void)judgeUserLogin;

@end

@interface TJSubTextView : UIView

@property (nonatomic, weak) id <TJSubTextViewDelegate> delegate;
@property (nonatomic, assign) CGRect                   myFrame;
@property (nonatomic, assign) BOOL                     isShow;
- (instancetype)initWithFrame:(CGRect)frame withisImage:(BOOL)isImage goodNum:(NSString *)num;
- (void)callbackKeyboard;
- (void)callShowKeyboard;
- (void)callMainComments;
- (void)callSubCommits:(NSString *)strTitle;
- (void)handleKeyboard;
-(void)dissPlayImag;
-(void)refreshGoodNum:(NSString*)good;
@end
