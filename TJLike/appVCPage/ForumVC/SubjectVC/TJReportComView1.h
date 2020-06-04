//
//  TJReportComView1.h
//  TJLike
//
//  Created by 123 on 16/9/3.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef NS_ENUM(NSInteger, OpenOrCloseStatus){
//    
//    Report_Status_Close,
//    Report_Status_Open
//    
//};

@protocol TJReportComViewDelegate1 <NSObject>
- (void)reportEvent;
- (void)commentEvent;

@end

@interface TJReportComView1 : UIView
@property (nonatomic, weak) id<TJReportComViewDelegate1> delegate;
//@property (nonatomic, assign) OpenOrCloseStatus rStatus;
+ (instancetype)instalReportView;
- (void)showReportView;
//- (void)dissmisReportView:(CGRect)frame;
@end
