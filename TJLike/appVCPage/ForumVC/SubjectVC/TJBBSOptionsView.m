//
//  TJBBSOptionsView.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/25.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBBSOptionsView.h"
#import "TJSubjcetItemButton.h"
#define OptionsTitles @[@"分享",@"楼主",@"举报",@"刷新",@"最新回复",@"删除"]
#define OptionsImages @[@"分享.png",@"楼主.png",@"举报.png",@"刷新.png",@"回复.png",@"删除.png"]

@interface TJBBSOptionsView()
{
    CGRect  myFrame;
    int num;
}
@property (nonatomic, strong) UIView   *contentView;

@end

@implementation TJBBSOptionsView

- (instancetype)initWithFrame:(CGRect)frame Withmode:(BOOL)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isShow = NO;
        myFrame = frame;
       // self.alpha=0.7;
        self.backgroundColor = [UIColor clearColor];
      
        if (model) {
            num=6;
        }
        else
        {
            num=5;
        }
        [self buildUI];
    }
    return self;
}
- (void)buildUI
{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    _contentView.hidden = YES;
    [_contentView setBackgroundColor:[UIColor whiteColor]];

    
    int totalloc=3;
    CGFloat vieww=56;
    CGFloat viewh=62;
    CGFloat margin=(SCREEN_WIDTH-totalloc*vieww)/(totalloc+1);
    for (int i = 0; i<num; i++) {
        int row=i/totalloc;//行号
        int loc=i%totalloc;//列号
        CGFloat appviewx=margin+(margin+vieww)*loc;
        CGFloat appviewy=margin+(margin+viewh)*row;
        
        TJSubjcetItemButton *btn = [[TJSubjcetItemButton alloc ]initWithFrame:CGRectMake(appviewx, appviewy-40, vieww, viewh) andlabName:[OptionsTitles objectAtIndex:i] andImaName:[OptionsImages objectAtIndex:i]];
        
        
        btn.tag = i;
        
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            switch (btn.tag) {
                case 0:
                    [self.delegate shareBBSContent];
                    break;
                case 1:
                    [self.delegate searchLouZhu];
                    break;
                case 2:
                    [self.delegate reportBBSContent];
                    break;
                case 3:
                   [self.delegate refreshBBSContent];
                    break;
                case 4:
                     [self.delegate replycontent];
                    break;
                case 5:
                    [self.delegate delectContent];
                    break;
                default:
                    break;
            }
            [self hideOptionView];
        }];
        [_contentView addSubview:btn];
    }
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0,220, SCREEN_WIDTH, 1)];
    lab.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_contentView addSubview:lab];
    
    UIButton *butt=[UIButton buttonWithType:UIButtonTypeCustom];
    butt.frame=CGRectMake(0, 220, SCREEN_WIDTH, 50);
    butt.backgroundColor=[UIColor clearColor];
    [butt setTitle:@"取消" forState:UIControlStateNormal];
    [butt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [butt addTarget:self action:@selector(hideOptionView) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:butt];
    [self addSubview:_contentView];
    
}


- (void)showOptionView
{//(SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIBAR_HEIGHT)/4 + 40
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.hidden = NO;
        self.frame = CGRectMake(myFrame.origin.x, myFrame.origin.y, myFrame.size.width, SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIBAR_HEIGHT);
        self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT-350, SCREEN_WIDTH,350);
        
    } completion:^(BOOL finished) {
        self.isShow = YES;
    }];
}
- (void)hideOptionView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame =myFrame;
        self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        self.contentView.hidden = YES;
    } completion:^(BOOL finished) {
        self.isShow = NO;
        
    }];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   // [self hideOptionView];
}


@end
