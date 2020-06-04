//
//  FuLiDetailViewController.h
//  TJLike
//
//  Created by imac-1 on 16/8/23.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"
#import "TJFuliModel.h"
@interface FuLiDetailViewController : TJBaseViewController
@property(nonatomic,strong)NSString *fuliId;
@property(nonatomic,strong)NSString *urlStr;//福利与活动的flag
@property(nonatomic,strong)NSString *state;//评价栏的隐藏--0 隐藏 1 显示
@end
