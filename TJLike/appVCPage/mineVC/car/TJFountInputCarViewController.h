//
//  TJFountInputCarViewController.h
//  TJLike
//
//  Created by MC on 15/4/13.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"
typedef void (^AddFinish)();

@interface TJFountInputCarViewController : TJBaseViewController

@property (nonatomic, copy)AddFinish mBlock;
@end
