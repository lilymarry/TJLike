//
//  FuLiTittleImaCell.h
//  TJLike
//
//  Created by imac-1 on 2016/10/19.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPagingView.h"
#import "TJBaseViewController.h"
@interface FuLiTittleImaCell : UITableViewCell<GCPagingViewDelegate>
@property (nonatomic, assign) TJBaseViewController *mRootCtrl;

- (void)LoadContent:(NSMutableArray *)mArray;

@end
