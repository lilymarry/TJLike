//
//  CommentListView.h
//  TJLike
//
//  Created by MC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentBottom.h"

@protocol CommentListDelegate <NSObject>
@optional
- (void)showUserNewsView:(NSString *)usid;


@end
@interface CommentListView : UIView<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong)CommentBottom *commentBottomView;
@property (nonatomic, strong)NSString *mlTitle;
@property (nonatomic, strong)NSDictionary  *dataDict;
@property (nonatomic, weak)id<CommentListDelegate> delegate;

- (id)initWithFrame:(CGRect)frame WithNid:(id) nid;

- (void)GetData;

@end
