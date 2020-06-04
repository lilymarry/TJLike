//
//  TieZiCell.h
//  TJLike
//
//  Created by imac-1 on 16/9/5.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TieZiCell : UITableViewCell
@property(nonatomic,assign) CGFloat cellHeight;
//- (void)bindModel:(id)model;
- (void)bindModel:(id)model withStr:(NSString *)str;
@end
