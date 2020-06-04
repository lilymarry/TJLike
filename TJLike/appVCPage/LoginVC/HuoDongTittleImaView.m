//
//  HuoDongTittleImaView.m
//  TJLike
//
//  Created by imac-1 on 2016/10/19.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "HuoDongTittleImaView.h"
#import "UIImageView+WebCache.h"
@implementation HuoDongTittleImaView
{
    UIImageView *netView;
    UILabel *mlbTitle;
    //  UILabel *iconLabel;
}
@synthesize delegate,OnClick;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor lightGrayColor];
        netView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        netView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:netView];
        
        mlbTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-25, SCREEN_WIDTH, 15.5)];
        mlbTitle.backgroundColor = [UIColor clearColor];
        mlbTitle.textAlignment = NSTextAlignmentCenter;
        mlbTitle.font = [UIFont systemFontOfSize:15.5];
        mlbTitle.textColor = [UIColor whiteColor];
        [self addSubview:mlbTitle];
        
        //        iconLabel = [[UILabel alloc]init];
        //        iconLabel.hidden = YES;
        //        iconLabel.backgroundColor = [UIColor redColor];
        //        iconLabel.layer.masksToBounds = YES;
        //        iconLabel.layer.cornerRadius = 4;
        //        iconLabel.font = [UIFont systemFontOfSize:15.5];
        //        iconLabel.textAlignment = NSTextAlignmentCenter;
        //        iconLabel.textColor = [UIColor whiteColor];
        //        iconLabel.text = @"专题";
        //        [self addSubview:iconLabel];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = netView.bounds;
        but.backgroundColor = [UIColor clearColor];
        [but addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:but];
    }
    return self;
}
- (void)Click{
    NSLog(@"Click");
    if (delegate && OnClick) {
        SafePerformSelector([delegate performSelector:OnClick withObject:self]);
    }
}
- (void)LoadContent:(HuoDongModel *)info{
    self.mInfo = info;
    mlbTitle.text = info.title;
    //[netView sd_setImageWithURL:[NSURL URLWithString:info.focusimg]];
    [netView sd_setImageWithURL:[NSURL URLWithString:info.hb] placeholderImage:[UIImage imageNamed:@"lunbo_default_icon"]];
    
    
    
    //    if ([info.property isEqualToString:@"专题"]) {
    //        CGSize maximumSize =CGSizeMake(SCREEN_WIDTH-40,16);
    //        //CGSize dateStringSize =[mlbTitle.text sizeWithFont:mlbTitle.font constrainedToSize:maximumSize lineBreakMode:mlbTitle.lineBreakMode];
    //        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    //        CGRect dateStringSize = [[[NSAttributedString alloc]initWithString:mlbTitle.text ] boundingRectWithSize:maximumSize options:options context:nil];
    //        iconLabel.frame = CGRectMake(SCREEN_WIDTH*0.5+dateStringSize.size.width*0.5+10, mlbTitle.frame.origin.y, 33, 15.5);
    //
    //        iconLabel.hidden = NO;
    //    }else{
    //        iconLabel.hidden = YES;
    //    }
}
- (void)dealloc{
    self.mInfo = nil;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
