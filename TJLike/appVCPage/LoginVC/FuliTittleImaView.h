//
//  FuliTittleImaView.h
//  TJLike
//
//  Created by imac-1 on 2016/10/19.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJFuliModel.h"
@interface FuliTittleImaView : UIView
@property(nonatomic, assign)id delegate;
@property(nonatomic, assign)SEL OnClick;
@property(nonatomic, strong)TJFuliModel *mInfo;

- (void)LoadContent:(TJFuliModel *)info;
@end
