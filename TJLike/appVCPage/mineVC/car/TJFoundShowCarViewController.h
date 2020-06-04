//
//  TJFoundShowCarViewController.h
//  TJLike
//
//  Created by MC on 15/4/18.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"

typedef void (^AddFinish)();

@interface TJFoundShowCarViewController : TJBaseViewController

@property (nonatomic, copy)AddFinish mBlock;
@property (nonatomic, strong)NSString *CarId;
@property (nonatomic, strong)NSString *CarModel;

@end
