//
//  TJTieBaContentViewCell.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJTieBaContentViewCell.h"
#import "TJTieBaContentModel.h"
#import "UIImageView+WebCache.h"
#import "TJNoticeView.h"
#import "TJShowImageView.h"

@interface TJTieBaContentViewCell()<TJNoticeViewDelegate>
{
    TJShowImageView *showImages;
}

@property (nonatomic, strong) UIView  *infoView;
@property (nonatomic, strong) UIView  *backView;

@property (nonatomic, strong) UIButton *headImageView;
@property (nonatomic, strong) UILabel     *lblNick;
@property (nonatomic, strong) UILabel     *lblTime;
@property (nonatomic, strong) UIImageView *gImageView;
@property (nonatomic, strong) UIImageView *tImageView;
@property (nonatomic, strong) UILabel     *lblGood;
@property (nonatomic, strong) UILabel     *lblTall;

@property (nonatomic, strong) UILabel     *lblTitle;
@property (nonatomic, strong) UILabel     *lbFont;

@property (nonatomic, strong) TJNoticeView  *notImageView;

@end

@implementation TJTieBaContentViewCell

//+(instancetype)cellWithTableView:(UITableView *)tableView{
//    static NSString *ID=@"status";
//    TJTieBaContentViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell==nil) {
//        cell=[[TJTieBaContentViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//      //  [self buildUI];
//
//    }
//    return cell;
//}
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
     _backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 200)];
    [_backView setBackgroundColor:[UIColor whiteColor]];
    
    _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _backView.frame.size.width, 60)];
    [_infoView setBackgroundColor:[UIColor whiteColor]];
    [_backView addSubview:_infoView];
    
    _headImageView=[UIButton buttonWithType:UIButtonTypeCustom];
    _headImageView.frame = CGRectMake(10, 12, 44,44);
    [_headImageView setBackgroundImage:[UIImage imageNamed:@"news_list_default"] forState:UIControlStateNormal];
    [_headImageView.layer setMasksToBounds:YES];
    _headImageView.layer.cornerRadius =10;
    [_infoView addSubview:_headImageView];
    
   
    _lblNick = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.frame.size.width + _headImageView.frame.origin.x +10, 10, 150 *SCREEN_PHISICAL_SCALE, 21)];
    [_lblNick setText:@"昵称"];
    [_infoView addSubview:_lblNick];
    
    _lblTime = [[UILabel alloc] initWithFrame:CGRectMake(_lblNick.frame.origin.x, _lblNick.frame.origin.y + _lblNick.frame.size.height +5, SCREEN_WIDTH - _lblNick.frame.origin.x, 21)];
    [_lblTime setTextColor:[UIColor grayColor]];
    [_lblTime setFont:[UIFont systemFontOfSize:12]];
    [_lblTime setText:@"2015-04-03 21:05:04"];
    [_infoView addSubview:_lblTime];
    
    UIImage *imageG = [UIImage imageNamed:@"赞.png"];
    UIImage *imageT = [UIImage imageNamed:@"评论.png"];
    _lblTall = [[UILabel alloc] initWithFrame:CGRectMake(_infoView.frame.size.width - 20 - 25, 12, 25, 21)];
    [_lblTall setTextAlignment:NSTextAlignmentLeft];
    [_lblTall setText:@"1000"];
    [_lblTall setTextColor:[UIColor grayColor]];
    [_lblTall setFont:[UIFont systemFontOfSize:12]];
    [_infoView addSubview:_lblTall];
    
    _tImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_lblTall.frame.origin.x - imageT.size.width/2 -3 , 15, imageT.size.width/2, imageT.size.height/2)];
    [_tImageView setImage:imageT];
    [_infoView addSubview:_tImageView];
    
    _lblGood = [[UILabel alloc] initWithFrame:CGRectMake(_tImageView.frame.origin.x - 40, 12, 40, 21)];
    [_lblGood setTextAlignment:NSTextAlignmentLeft];
    [_lblGood setText:@"200"];
    [_lblGood setTextColor:[UIColor grayColor]];
    [_lblGood setFont:[UIFont systemFontOfSize:12]];
    [_infoView addSubview:_lblGood];
    
    _gImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_lblGood.frame.origin.x - imageG.size.width/2 -3 , 15, imageG.size.width/2, imageG.size.height/2)];
    [_gImageView setImage:imageG];
    [_infoView addSubview:_gImageView];
    
    [self.contentView addSubview:_backView];
    
}
-(void)UserNews:(id)sender
{
    
    [self.delegate showUserNews:_cellModel];


}
- (void)bindModel:(id)model
{
    if (!model) {
        return;
    }
    
    TJTieBaContentModel *item = (TJTieBaContentModel *)model;
    _cellModel=item;
    [self.lblNick setText:StringEqual(item.nickname, @"")?item.username:item.nickname];
    [self.lblTime setText:item.time];
    [self.lblGood setText:item.good];
    [self.lblTall setText:item.count];
  //  self.headImageView.subviews
    UIImageView *imaView=[[UIImageView alloc]initWithFrame:self.headImageView.bounds];
    [imaView  sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:ImageCache(@"news_list_default") options:SDWebImageLowPriority | SDWebImageRetryFailed];
    [self.headImageView addSubview:imaView];
    [self.headImageView addTarget:self action:@selector(UserNews:) forControlEvents:UIControlEventTouchUpInside];
   

    
    CGSize sizeT = [UIUtil textToSize:item.title fontSize:20];
    CGSize sizeF = [UIUtil textToSize:item.font fontSize:14];
    
    [_lblTitle removeFromSuperview];
    _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, _infoView.frame.size.height , _backView.frame.size.width -20, sizeT.height)];
    [_lblTitle setText:item.title];
    [_lblTitle setTextAlignment:NSTextAlignmentLeft];
    [_lblTitle setTextColor:[UIColor blackColor]];
    [_lblTitle setNumberOfLines:0];
    [_lblTitle sizeToFit];
    [_backView addSubview:_lblTitle];
    
    [_lbFont removeFromSuperview];
    _lbFont = [[UILabel alloc] initWithFrame:CGRectMake(10, _lblTitle.frame.size.height+2 + _infoView.frame.size.height, _backView.frame.size.width -20, sizeF.height)];
    [_lbFont setText:item.font];
    [_lbFont setTextAlignment:NSTextAlignmentLeft];
    [_lbFont setTextColor:[UIColor grayColor]];
    [_lbFont setNumberOfLines:0];
    [_lbFont sizeToFit];
    [_backView addSubview:_lbFont];
    
    
    if (StringEqual(item.imgs, @"")) {
        CGRect frame = _backView.frame;
        CGFloat height = _infoView.frame.size.height + _lblTitle.frame.size.height + _lbFont.frame.size.height + 10;
        frame.size.height = height;
        _cellHeight=height;
        _backView.frame = frame;
    }
    else{
        [_notImageView removeFromSuperview];
        _notImageView = [[TJNoticeView alloc] initWithFrame:CGRectMake(0, _infoView.frame.size.height + _lblTitle.frame.size.height + _lbFont.frame.size.height, _backView.frame.size.width, 100) withObjc:item.imgs];
        _notImageView.delegate = self;
        [_backView addSubview:_notImageView];
        
        CGRect frame = _backView.frame;
        CGFloat height = _infoView.frame.size.height + _lblTitle.frame.size.height + _lbFont.frame.size.height + _notImageView.frame.size.height;
        frame.size.height = height;
        _cellHeight=height;
        _backView.frame = frame;
        
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

@end
