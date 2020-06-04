//
//  UserHuiFuViewCell.h
//  TJLike
//
//  Created by imac-1 on 16/8/24.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHuiFuViewCell : UITableViewCell
@property(nonatomic,assign) CGFloat cellHeight;
- (void)bindModel:(id)model;
@end
