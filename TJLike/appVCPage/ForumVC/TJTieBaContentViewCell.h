//
//  TJTieBaContentViewCell.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TJTieBaContentViewCellDelegate;
@interface TJTieBaContentViewCell : UITableViewCell
@property(nonatomic,assign) CGFloat cellHeight;
@property(nonatomic,assign) id cellModel;
@property (nonatomic, weak)  id<TJTieBaContentViewCellDelegate> delegate;

- (void)bindModel:(id)model;
@end
@protocol TJTieBaContentViewCellDelegate <NSObject>
@optional
- (void)showUserNews:(id)model;


@end
