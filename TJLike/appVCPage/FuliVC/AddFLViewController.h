//
//  AddFLViewController.h
//  TJLike
//
//  Created by 123 on 16/9/3.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"
#import "TJBBSCateSubModel.h"
#import "CommonDelegate.h"

@interface AddFLViewController : TJBaseViewController

@property (weak,nonatomic) id<CommonDelegate>  refreshDelegate;
@property(strong ,nonatomic)NSString *fuId;
@property(strong ,nonatomic)NSString *status;
@end
