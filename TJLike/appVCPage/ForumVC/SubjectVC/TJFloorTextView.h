//
//  TJFloorTextView.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/29.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJSubCommentModel.h"


@protocol TJFloorTextViewDelegate <NSObject>

- (void)tapbtnPraise;
- (void)tapBtnImages;
- (void)sendComments:(NSString *)strComments;//回复群主
//回复某一人
//- (void)sendCommentsForUser:(TJSubCommentModel *)model withMesg:(NSString *)strComments;
- (void)judgeUserLogin;

@end

@interface TJFloorTextView : UIView

@property (nonatomic, weak) id <TJFloorTextViewDelegate> delegate;
@property (nonatomic, assign) CGRect                   myFrame;
@property (nonatomic, assign) BOOL                     isShow;
- (instancetype)initWithFrame:(CGRect)frame withisImage:(BOOL)isImage  ;
- (void)callbackKeyboard;
- (void)callShowKeyboard;
- (void)callMainComments;
- (void)callSubCommits:(NSString *)strTitle;
///- (void)callSubCommitsModel:(TJSubCommentModel *)model;

- (void)handleKeyboard;
@end
