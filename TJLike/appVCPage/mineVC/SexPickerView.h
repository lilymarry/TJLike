//
//  SexPickerView.h
//  TJLike
//
//  Created by Madroid on 15/5/1.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SexPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, assign)id mDelegate;
@property (nonatomic, assign)SEL okClick;

@end
