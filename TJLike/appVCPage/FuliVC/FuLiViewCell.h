//
//  FuLiViewCell.h
//  TJLike
//
//  Created by imac-1 on 16/8/22.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FuLiViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ima_back;
@property (weak, nonatomic) IBOutlet UILabel *lab_price;
@property (weak, nonatomic) IBOutlet UILabel *lab_endTime;
@property (weak, nonatomic) IBOutlet UILabel *lab_tittle;
@property (weak, nonatomic) IBOutlet UILabel *lab_num;
@property (weak, nonatomic) IBOutlet UILabel *btn_state;

@end
