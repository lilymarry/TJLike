//
//  TJStartView.h
//  TJLike
//
//  Created by IPTV_MAC on 15/5/16.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapEvent)(void);
@interface TJStartView : UIView
@property (nonatomic, copy) TapEvent  tapHidden;
@end
