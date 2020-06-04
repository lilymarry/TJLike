//
//  TJSendTopical ViewController.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"
#import "TJBBSCateSubModel.h"
#import "CommonDelegate.h"
@interface TJSendTopicalViewController : TJBaseViewController
@property (weak,nonatomic) id<CommonDelegate>  refreshDelegate;
- (instancetype)initWithItem:(TJBBSCateSubModel *)item;

@end
