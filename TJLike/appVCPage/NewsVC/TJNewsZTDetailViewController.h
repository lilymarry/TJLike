//
//  TJNewsZTDetailViewController.h
//  TJLike
//
//  Created by MC on 15/4/10.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"
#import "NewsListInfo.h"

@interface TJNewsZTDetailViewController : TJBaseViewController
<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)NewsListInfo *mlInfo;

@end
