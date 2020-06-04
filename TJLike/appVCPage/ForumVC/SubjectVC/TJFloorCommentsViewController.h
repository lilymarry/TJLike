//
//  TJFloorCommentsViewController.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/23.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"
#import "TJBBSContentModel.h"
#import "CommonDelegate.h"
@interface TJFloorCommentsViewController : TJBaseViewController

@property (nonatomic, strong) TJBBSContentModel  *contentItem;
@property (weak,nonatomic) id<CommonDelegate>  refreshDelegate;

- (instancetype)initWIthObjc:(id)mainModel withSubObjc:(id)subModel withFloor:(NSInteger)indexFloor;

@end
