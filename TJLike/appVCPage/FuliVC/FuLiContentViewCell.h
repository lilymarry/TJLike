//
//  FuLiContentViewCell.h
//  TJLike
//
//  Created by imac-1 on 16/8/23.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FuLiContentViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab_tittle;
@property (weak, nonatomic) IBOutlet UILabel *lab_content;
@property (weak, nonatomic) IBOutlet UIButton *btn_all;
@property (weak, nonatomic) IBOutlet UIImageView *ima_state;
@property (weak, nonatomic) IBOutlet UIWebView *web_content;

@end
