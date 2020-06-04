//
//  TJFloorViewCell.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/23.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJBBSContentModel.h"
#import "TJSubCommentModel.h"
@protocol TJFloorViewCellDelegate;

@interface TJFloorViewCell : UITableViewCell

@property (nonatomic, weak)  id<TJFloorViewCellDelegate> delegate;
@property (nonatomic, assign) NSInteger          cellTag;
@property (nonatomic, strong) TJBBSContentModel  *contentItem;

- (void)bindModel:(id)model andFloor:(NSInteger)florr;
- (void)hidenReportVIew;

@end

@protocol TJFloorViewCellDelegate <NSObject>
@optional
//- (void)pressReport:(TJSubSubjectViewCell *)showCell;
//- (void)reportCellEvent:(id)model;
- (void)mainCommentCellEvent;
- (void)subCommentCellEvent:(NSString *)str;
//- (void)subCommentCellEventWithModel:(TJSubCommentModel *)model;
- (void)subCommentCellEvent:(NSString *)str withSubItem:(TJSubCommentModel *)model;
@end
