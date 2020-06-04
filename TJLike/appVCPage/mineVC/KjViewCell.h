//
//  KjViewCell.h
//  TJLike
//
//  Created by imac-1 on 16/9/5.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KjViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ima_back;
@property (weak, nonatomic) IBOutlet UILabel *lab_tittle;
@property (weak, nonatomic) IBOutlet UILabel *lab_subTittle;
@property (weak, nonatomic) IBOutlet UILabel *lab_time;

@end
