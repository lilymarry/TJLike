//
//  UserHuiFuViewCell.m
//  TJLike
//
//  Created by imac-1 on 16/8/24.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "UserHuiFuViewCell.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "TJNoticeView.h"
#import "TJShowImageView.h"
#import "ImageHelper.h"
//#import "ScreenHelper.h"
@interface UserHuiFuViewCell()<TJNoticeViewDelegate>
{
    TJShowImageView *showImages;
}
@property (nonatomic, strong) UIView  *infoView;
@property (nonatomic, strong) UIView  *backView;

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel     *lblNick;
@property (nonatomic, strong) UILabel     *lblTime;
//@property (nonatomic, strong) UIImageView *gImageView;
//@property (nonatomic, strong) UIImageView *tImageView;
@property (nonatomic, strong) UILabel     *lblGood;
//@property (nonatomic, strong) UILabel     *lblTall;

//@property (nonatomic, strong) UILabel     *lblTitle;
@property (nonatomic, strong) UILabel     *lbFont;

@property (nonatomic, strong) TJNoticeView  *notImageView;


@end
@implementation UserHuiFuViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 200)];
    [_backView setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    
    _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _backView.frame.size.width, 70)];
    [_infoView setBackgroundColor:[UIColor clearColor]];
    [_backView addSubview:_infoView];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 50, 50)];
    [_headImageView setImage:[UIImage imageNamed:@"news_list_default"]];
  //  [_headImageView.layer setMasksToBounds:YES];
  //  _headImageView.layer.cornerRadius =10;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 50*0.5;
    [_infoView addSubview:_headImageView];
    
    _lblNick = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.frame.size.width + _headImageView.frame.origin.x +10, 10, 150 *SCREEN_PHISICAL_SCALE, 21)];
    [_lblNick setText:@"昵称"];
    [_infoView addSubview:_lblNick];
    
    _lblTime = [[UILabel alloc] initWithFrame:CGRectMake(_lblNick.frame.origin.x, _lblNick.frame.origin.y + _lblNick.frame.size.height +5, SCREEN_WIDTH - _lblNick.frame.origin.x, 21)];
    [_lblTime setTextColor:[UIColor grayColor]];
    [_lblTime setFont:[UIFont systemFontOfSize:12]];
    [_lblTime setText:@"2015-04-03 21:05:04"];
    [_infoView addSubview:_lblTime];
    
 //   UIImage *imageG = [UIImage imageNamed:@"luntan_dianzan_"];
  //  UIImage *imageT = [UIImage imageNamed:@"luntan_pinglun_"];
   // _lblTall = [[UILabel alloc] initWithFrame:CGRectMake(_infoView.frame.size.width - 20 - 25, 10, 25, 21)];
   // [_lblTall setTextAlignment:NSTextAlignmentLeft];
   // [_lblTall setText:@"1000"];
   // [_lblTall setTextColor:[UIColor grayColor]];
  //  [_lblTall setFont:[UIFont systemFontOfSize:12]];
  //  [_infoView addSubview:_lblTall];
    
  //  _tImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_lblTall.frame.origin.x - imageT.size.width/2 -3 , 15, imageT.size.width/2, imageT.size.height/2)];
 //   [_tImageView setImage:imageT];
 //   [_infoView addSubview:_tImageView];
    
    _lblGood = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 55, 10, 40, 21)];
    [_lblGood setTextAlignment:NSTextAlignmentLeft];
    [_lblGood setText:@"回复"];
    [_lblGood setTextColor:[UIColor grayColor]];
    [_lblGood setFont:[UIFont systemFontOfSize:12]];
    [_infoView addSubview:_lblGood];
    
//    _gImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_lblGood.frame.origin.x - imageG.size.width/2 -3 , 15, imageG.size.width/2, imageG.size.height/2)];
//    [_gImageView setImage:imageG];
//    [_infoView addSubview:_gImageView];
    
  //  _backView.backgroundColor=[UIColor yellowColor];
    
    //UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0,  _backView.frame.size.height-1, _backView.frame.size.width , 1)];
         //  [lab setBackgroundColor:[UIColor grayColor]];
   //   [_backView addSubview:lab];
    
    [self.contentView addSubview:_backView];
    
}

- (void)bindModel:(id)model
{
    if (!model) {
        return;
    }
    UserModel *item = (UserModel *)model;
  //  NSLog(@"%@",item.nickname);
    [self.lblNick setText:StringEqual(item.nickname, @"")?item.username:item.nickname];
    [self.lblTime setText:item.datetime];
  //  [self.lblGood setText:item.good];
  //  [self.lblTall setText:item.count];
    
  //  [self.headImageView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:ImageCache(@"news_list_default") options:SDWebImageLowPriority | SDWebImageRetryFailed];
    [self.headImageView  sd_setImageWithURL:[NSURL URLWithString:item.icon]                                 placeholderImage:[UIImage imageNamed:@"news_list_default"]
                              options:0
                            completed:^(UIImage *image,
                                        NSError *error,
                                        SDImageCacheType cacheType,
                                        NSURL *imageURL){
                                
                            }];
   // CGSize sizeT = [UIUtil textToSize:item.title fontSize:20];
    CGSize sizeF = [UIUtil textToSize:item.font fontSize:14];
    
//    _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, _infoView.frame.size.height , _backView.frame.size.width -20, sizeT.height)];
//    [_lblTitle setText:item.title];
//    [_lblTitle setTextAlignment:NSTextAlignmentLeft];
//    [_lblTitle setTextColor:[UIColor blackColor]];
//    [_lblTitle setNumberOfLines:0];
//    [_lblTitle sizeToFit];
//    [_backView addSubview:_lblTitle];
    [_lbFont removeFromSuperview];
    _lbFont = [[UILabel alloc] initWithFrame:CGRectMake(30,  _infoView.frame.size.height, _backView.frame.size.width -20, sizeF.height)];
    [_lbFont setText:item.font];
    [_lbFont setTextAlignment:NSTextAlignmentLeft];
    [_lbFont setTextColor:[UIColor grayColor]];
    [_lbFont setNumberOfLines:0];
    [_lbFont sizeToFit];
    [_backView addSubview:_lbFont];
    
    
    
    
    
    if (StringEqual(item.imgs, @"")) {
        CGRect frame = _backView.frame;
        CGFloat height = _infoView.frame.size.height  + _lbFont.frame.size.height+10 ;
        frame.size.height = height;
       
//        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30,  _backView.frame.size.height-2, _backView.frame.size.width-60 , 1)];
//         [lab setBackgroundColor:[UIColor redColor]];
//        [_backView addSubview:lab];
         _backView.frame = frame;
        _cellHeight=height+2;
        
       
    }
    else{
        [_notImageView removeFromSuperview];
        _notImageView = [[TJNoticeView alloc] initWithFrame:CGRectMake(0, _infoView.frame.size.height  + _lbFont.frame.size.height, _backView.frame.size.width, 100) withObjc:item.imgs];
        _notImageView.delegate = self;
        [_backView addSubview:_notImageView];
        
        CGRect frame = _backView.frame;
        CGFloat height = _infoView.frame.size.height  + _lbFont.frame.size.height + _notImageView.frame.size.height;
        frame.size.height = height;
        
//        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0,  _backView.frame.size.height-2, _backView.frame.size.width-60 , 1)];
//        [lab setBackgroundColor:[UIColor redColor]];
//        [_backView addSubview:lab];
        
        _backView.frame = frame;
        _cellHeight=height+2;
        
    }
    
}
- (void)tapShowImageEvent:(id)sender
{
    TLog(@"tapShowImageEvent");
}
- (void)tapShowDetaile:(NSArray *)images
{
    if (showImages) {
        showImages = nil;
    }
    showImages = [[TJShowImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withImages:images];
    [SHARE_WINDOW addSubview:showImages];
    @weakify(self)
    showImages.tapHideBlock = ^{
        @strongify(self)
        self->showImages = nil;
    };
}



- (void)awakeFromNib {
    // Initialization code
      [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
//-(UIImage*)imageScaleWithImage:(UIImage*)image
//{
//    //设置image的尺寸
//    CGSize imagesize = image.size;
//    
//    //iphone5
//    CGFloat a=(imagesize.height>imagesize.width)?320.0:568;
//    //iphone6
//    if ([ScreenHelper checkWhichIphoneScreen] == iphone6) {
//        a=(imagesize.height>imagesize.width)?375:667;
//    }else if ([ScreenHelper checkWhichIphoneScreen] == iphone6plus){
//        a=(imagesize.height>imagesize.width)?414:736;
//    }
//    
//    float XX=imagesize.width/a;//宽度比
//    float VY=imagesize.height/XX;//在屏幕上的高度
//    
//    imagesize.width = a;//放大倍数100
//    imagesize.height =VY;
//    
//    UIImage *ima = [self imageWithImage:image scaledToSize:imagesize];
//    return ima;
//    
//    
//}
//-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
//{
//    UIGraphicsBeginImageContext(newSize);
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}
//
@end
