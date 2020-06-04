//
//  TextLabel.h
//  UILabrlCoreText
//
//  Created by IPTV_MAC on 15/4/16.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextLabel : UILabel

- (instancetype)initWithFrame:(CGRect)frame withStr:(NSString *)str withLength:(NSUInteger)length withLandlord:(BOOL)isLandlord;
@end
