//
//  TJNewsNormalDetailController.h
//  TJLike
//
//  Created by MC on 15-3-31.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"


@interface TJNewsNormalDetailController : TJBaseViewController<UIWebViewDelegate,UIScrollViewDelegate>


@property (nonatomic, strong)NSString *nid;
@property (nonatomic, strong)NSString *mlbTitle;
@property (nonatomic, strong)NSString *sharePicUrl;

@end
