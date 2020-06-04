//
//  TJReportComView.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/16.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OpenOrCloseStatus){
    
    Report_Status_Close,
    Report_Status_Open
    
};

@protocol TJReportComViewDelegate <NSObject>



- (void)reportEvent;
- (void)commentEvent;

@end

@interface TJReportComView : UIView

@property (nonatomic, weak) id<TJReportComViewDelegate> delegate;
@property (nonatomic, assign) OpenOrCloseStatus rStatus;
+ (instancetype)instalReportView;
- (void)showReportView;
- (void)dissmisReportView:(CGRect)frame;
@end
