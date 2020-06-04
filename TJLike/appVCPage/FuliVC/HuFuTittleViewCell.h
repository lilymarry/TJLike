//
//  HuFuTittleViewCell.h
//  TJLike
//
//  Created by imac-1 on 16/8/24.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HuFuTittleViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISegmentedControl *segMent;
@property (nonatomic, assign) id mDelegate;
@property (nonatomic, assign) SEL changState;
- (IBAction)changSegment:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lab_huifu;
@property (weak, nonatomic) IBOutlet UILabel *lab_canyu;

@end
