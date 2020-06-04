//
//  HuFuTittleViewCell.m
//  TJLike
//
//  Created by imac-1 on 16/8/24.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "HuFuTittleViewCell.h"

@implementation HuFuTittleViewCell

- (void)awakeFromNib {
    // Initialization code
      [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)changSegment:(id)sender {
    if (_segMent.selectedSegmentIndex==0) {
        _lab_huifu.textColor=[UIColor redColor];
        _lab_canyu.textColor=[UIColor lightGrayColor];

    }
   else {
        _lab_huifu.textColor=[UIColor lightGrayColor];
        _lab_canyu.textColor=[UIColor redColor];
        
    }
    SafePerformSelector([_mDelegate performSelector:_changState withObject:self]);

}
@end
