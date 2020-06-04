//
//  TJSubjectViewCell.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/16.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJSubjectViewCellDelegate <NSObject>

- (void)deleteBBsData;

- (void)showAllImages:(NSArray *)images;

@end

@interface TJSubjectViewCell : UITableViewCell

@property (nonatomic, strong) id<TJSubjectViewCellDelegate> delegate;
@property (nonatomic, assign) BOOL isDelete;
@property(nonatomic,assign) CGFloat cellHeight;
- (void)bindModel:(id)model;

@end
