//
//  TJBBSOptionsView.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/25.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TJBBSOptionsViewDelegate <NSObject>

- (void)shareBBSContent;
-(void)searchLouZhu;
- (void)reportBBSContent;
-(void)replycontent;
- (void)refreshBBSContent;
-(void)delectContent;

@end


@interface TJBBSOptionsView : UIView

@property (nonatomic, weak) id<TJBBSOptionsViewDelegate> delegate;
@property (nonatomic, assign) BOOL isShow;
- (instancetype)initWithFrame:(CGRect)frame Withmode:(BOOL)model;
- (void)showOptionView;
- (void)hideOptionView;

@end
