//
//  TJSubSubjectViewCell.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/16.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJBBSContentModel.h"


@protocol TJSubSubjectViewCellDelegate;

@interface TJSubSubjectViewCell : UITableViewCell

@property (nonatomic, weak)  id<TJSubSubjectViewCellDelegate> delegate;
@property (nonatomic, strong) TJBBSContentModel  *contentItem;
@property (nonatomic, assign) NSInteger          cellTag;

- (void)bindModel:(id)model andFloor:(NSInteger)florr;
//- (void)hidenReportVIew;
@end
@protocol TJSubSubjectViewCellDelegate <NSObject>
@optional
- (void)pressReport:(TJSubSubjectViewCell *)showCell;
- (void)reportCellEvent:(id)model;
- (void)commentCellEvent:(id)model andFloor:(NSInteger)florr;
- (void)showFloorVC:(id)model withCommentModel:(id)mainModel andFloor:(NSInteger)florr;
- (void)showSubAllImages:(NSArray *)images;


@end
