//
//  KJDetailView.m
//  TJLike
//
//  Created by imac-1 on 16/9/5.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "KJDetailView.h"
#import "UIImageView+WebCache.h"
@implementation KJDetailView

-(KJDetailView *)instanceChooseViewHidChooseViewWithModel:(TJMyKjModel *)model
{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"KJDetailView" owner:nil options:nil];
     _view= [nibView lastObject];
    
    [_view setFrame:CGRectMake( 20,SCREEN_HEIGHT,  SCREEN_WIDTH-40, 376)];
     _view.lab_tittle.text=model.title;
   //  _view.fuid=model.kjID;
    
    [_view.ima_back    sd_setImageWithURL:[NSURL URLWithString:model.focus] placeholderImage:[UIImage imageNamed:@"news_list_default"]];
    
    _view.btn_use.layer.borderWidth = 0.3;
    _view.btn_use.tag=[model.kjID intValue];
    _view.btn_use.layer.cornerRadius = 3.0;
    NSString *str=[NSString stringWithFormat:@"%@",model.is_use];
    if ([str  isEqualToString:@"0"]) {
        [_view.btn_use setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:83.0/255.0 blue:90.0/255.0 alpha:1.0]];
          _view.btn_use.layer.borderColor = [UIColor colorWithRed:243.0/255.0 green:83.0/255.0 blue:90.0/255.0 alpha:1.0].CGColor;
            [_view.btn_use setTitle:@"使用" forState:UIControlStateNormal];
    }
    else
    {
      [_view.btn_use setBackgroundColor:[UIColor lightGrayColor]];
      _view.btn_use.layer.borderColor = [UIColor lightGrayColor].CGColor;
      _view.btn_use.enabled=NO;
        [_view.btn_use setTitle:@"已使用" forState:UIControlStateNormal];
    }

    
    [UIView animateWithDuration:0.2 animations:^(){
        [_view setFrame:CGRectMake(20, 100, SCREEN_WIDTH-40, 376)];
    }completion:^(BOOL finished){
    } ];
    return _view;
}

-(void)checkSeletedView:(int)tag{
    
//    if(self.caiwuView.tag==tag){
//        self.caiwuView.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    }else if (self.renshiView.tag==tag){
//        self.renshiView.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    }else if (self.xingzhengView.tag==tag){
//        self.xingzhengView.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    }else if (self.yewuView.tag==tag){
//        self.yewuView.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    }else if (self.shengchanView.tag==tag){
//        self.shengchanView.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    }else if (self.quanbuView.tag==tag){
//        self.quanbuView.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    }
    
}


- (IBAction)detailPress:(id)sender {
    
    NSLog(@"sdasd___ %ld", self.btn_use.tag);
    [self.delegate tapDetailWithKjID:[NSString stringWithFormat:@"%ld",self.btn_use.tag]];
    
}

- (IBAction)okPress:(id)sender {
//   self.btn_use.enabled=NO;
    [self.delegate useKjWithKjID:[NSString stringWithFormat:@"%ld",self.btn_use.tag]];
}
@end
