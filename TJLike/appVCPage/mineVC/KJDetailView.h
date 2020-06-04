//
//  KJDetailView.h
//  TJLike
//
//  Created by imac-1 on 16/9/5.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJMyKjModel.h"
@protocol TJMyKjDelegate <NSObject>
-(void)useKjWithKjID:(NSString *)kjID;;
-(void)tapDetailWithKjID:(NSString *)kjID;
@end

@interface KJDetailView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *ima_back;
@property (weak, nonatomic) IBOutlet UILabel *lab_tittle;
@property (weak, nonatomic) IBOutlet UIButton *btn_use;
//@property (strong, nonatomic)  NSString *fuid;
@property (weak,nonatomic) id<TJMyKjDelegate> delegate;
@property(strong ,nonatomic)KJDetailView *view;
- (IBAction)detailPress:(id)sender;
- (IBAction)okPress:(id)sender;
-(KJDetailView *)instanceChooseViewHidChooseViewWithModel:(TJMyKjModel *)model;
@end
