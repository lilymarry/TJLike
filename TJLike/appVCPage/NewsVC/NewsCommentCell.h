//
//  NewsCommentCell.h
//  TJLike
//
//  Created by MC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsCommentInfo.h"
#import "ReportAndPraiseView.h"

@interface NewsCommentCell : UITableViewCell

@property (nonatomic, strong) ReportAndPraiseView *reportView;
@property (nonatomic, strong) UIButton *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *goodView;
@property (nonatomic, strong) UILabel *goodNum;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *sepeLine;
@property (nonatomic, strong) NSString *usid;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL click;

@property (nonatomic, assign) SEL showUserNews;


- (void)hidenReportVIew;
- (void)LoadContent:(NewsCommentInfo *)list;
//- (void)showUserNews:(id)model;
+ (int)HeightOfContent:(NewsCommentInfo *)list;

@end
