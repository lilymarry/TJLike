//
//  TJSubjectViewCell.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/16.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJSubjectViewCell.h"
#import "TJBBSContentModel.h"
#import "UIImageView+WebCache.h"

@interface TJSubjectViewCell()<UIWebViewDelegate>

@property (nonatomic, strong)UIView       *backView;
@property (nonatomic, strong)UIImageView  *headImageVIew;
@property (nonatomic, strong)UILabel      *lblNick;
@property (nonatomic, strong)UILabel      *lblTime;
@property (nonatomic, strong)UIImageView  *landlordImgView;
@property (nonatomic, strong)UIButton     *btnDelete;
@property (nonatomic, strong)UILabel      *lblTitle;
@property (nonatomic, strong)UILabel      *lblContent;

@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic, strong) NSArray  *imageLists;

@end

@implementation TJSubjectViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageArray = [[NSMutableArray alloc] init];
        [self buildUI];
    }
    return self;
}
- (void)buildUI
{
    _backView = [[UIView alloc] init];
    [_backView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:_backView];
    
    _headImageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
    [_headImageVIew setImage:[UIImage imageNamed:@"news_list_default"]];
    [_headImageVIew.layer setMasksToBounds:YES];
    _headImageVIew.layer.cornerRadius =10;
    [_backView addSubview:_headImageVIew];
    
    _lblNick = [[UILabel alloc] initWithFrame:CGRectMake(_headImageVIew.frame.size.width + _headImageVIew.frame.origin.x +10, 20,50 *SCREEN_PHISICAL_SCALE, 21)];
    [_lblNick setText:@"昵称"];
    [_lblNick setTextAlignment:NSTextAlignmentLeft];
    [_backView addSubview:_lblNick];
    
    UIImage *image = [UIImage imageNamed:@"louzhu_"];
    _landlordImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_lblNick.frame.origin.x + _lblNick.frame.size.width, 30, image.size.width, image.size.height)];
    [_landlordImgView setImage:image];
    [_backView addSubview:_landlordImgView];
    
//    _btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_btnDelete setFrame:CGRectMake(SCREEN_WIDTH - 20 - 50 , 20, 50, 25)];
//    [_btnDelete setTitle:@"删除" forState:UIControlStateNormal];
//    [_btnDelete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_btnDelete.layer setMasksToBounds:YES];
//    _btnDelete.layer.borderColor = [UIColor blackColor].CGColor;
//    _btnDelete.layer.cornerRadius = 6;
//    _btnDelete.layer.borderWidth = 1;
//    [_backView addSubview:_btnDelete];
//    @weakify(self)
//    [[_btnDelete rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self)
//        [self.delegate deleteBBsData];
//    }];

    
    _lblTime = [[UILabel alloc] initWithFrame:CGRectMake(_lblNick.frame.origin.x, _lblNick.frame.origin.y + _lblNick.frame.size.height +3, SCREEN_WIDTH - _lblNick.frame.origin.x, 21)];
    [_lblTime setTextColor:[UIColor grayColor]];
    [_lblTime setFont:[UIFont systemFontOfSize:12]];
    [_lblTime setText:@"2015-04-03 21:05:04"];
    [_backView addSubview:_lblTime];
    
    _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, _headImageVIew.frame.origin.y +_headImageVIew.frame.size.height +10, SCREEN_WIDTH - 40, 21)];
    [_lblTitle setText:@"标题"];
    [_lblTitle setTextAlignment:NSTextAlignmentLeft];
    [_lblTitle setTextColor:[UIColor blackColor]];
    [_backView addSubview:_lblTitle];
    
    _lblContent = [[UILabel alloc] initWithFrame:CGRectMake(20, _lblTitle.frame.size.height + _lblTitle.frame.origin.y +4, SCREEN_WIDTH -40, 21)];
    [_lblContent setText:@"内容"];
    [_lblContent setTextAlignment:NSTextAlignmentLeft];
    [_lblContent setTextColor:[UIColor grayColor]];
    [_lblContent setNumberOfLines:0];
    [_backView addSubview:_lblContent];
    
    
    
}


- (void)awakeFromNib {
    // Initialization code
      [super awakeFromNib];
}

- (void)bindModel:(id)model
{
    TJBBSContentModel *item = (TJBBSContentModel *)model;
    [self.lblNick setText:StringEqual(item.nickname, @"")?item.username:item.nickname];
    CGSize size = [UIUtil textToSize:StringEqual(item.nickname, @"")?item.username:item.nickname fontSize:17 withHeight:21];
    
    [self.lblNick setFrame:CGRectMake(self.lblNick.frame.origin.x, self.lblNick.frame.origin.y,size.width, 21)];
    [_landlordImgView setFrame:CGRectMake(_lblNick.frame.origin.x + _lblNick.frame.size.width +10, 20, _landlordImgView.frame.size.width, _landlordImgView.frame.size.height)];
    
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
////    [formatter setDateStyle:NSDateFormatterMediumStyle];
////    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
//    NSDate *date = [formatter dateFromString:item.time];
//    NSString *nowtimeStr = [formatter stringFromDate:date];
    [self.lblTime setText:[self dateFromDate:item.time]];
    
   // [self.headImageVIew sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:ImageCache(@"news_list_default") options:SDWebImageLowPriority | SDWebImageRetryFailed];
    NSURL *iurl=[NSURL URLWithString:item.icon];
    
    [self.headImageVIew   sd_setImageWithURL:iurl                                placeholderImage:[UIImage imageNamed:@"news_list_default"]
                        options:0
                      completed:^(UIImage *image,
                                  NSError *error,
                                  SDImageCacheType cacheType,
                                  NSURL *imageURL){}];

    
    CGSize sizeT = [UIUtil textToSize:item.title fontSize:20];
    CGSize sizeF = [UIUtil textToSize:item.font fontSize:14];
    [_lblTitle removeFromSuperview];
    [_lblTitle setFrame:CGRectMake(_lblTitle.frame.origin.x, _lblTitle.frame.origin.y, _lblTitle.frame.size.width, sizeT.height)];
    [_lblTitle setText:item.title];
    [_lblTitle sizeToFit];
    [_backView addSubview:_lblTitle];
    
    [_lblContent removeFromSuperview];
    [_lblContent setFrame:CGRectMake(_lblContent.frame.origin.x, _lblContent.frame.origin.y, _lblContent.frame.size.width, sizeF.height>=150?(sizeF.height +100):sizeF.height)];
    [_lblContent setText:item.font];
    [_lblContent sizeToFit];
    [_backView addSubview:_lblContent];
  
   
    //TLog(@"%@",NSStringFromCGRect(_lblContent.frame));
    
 

    if (!StringEqual(item.imgs, @"")) {
        NSArray *array = [item.imgs componentsSeparatedByString:@","];
        _imageLists = array;
        if (_imageLists.count == 1 && ([item.imgs rangeOfString:@"<span"].location !=NSNotFound)) {
            UIWebView * mWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, (_lblContent.frame.size.height + _lblContent.frame.origin.y) + 10, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40)*5/4)];
            mWebView.scalesPageToFit =NO;
            mWebView.delegate =self;
            mWebView.scrollView.scrollEnabled = NO;
            mWebView.dataDetectorTypes = UIDataDetectorTypeAll;
            [mWebView loadHTMLString:item.imgs baseURL:nil];
            [self addSubview:mWebView];
            [_backView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, mWebView.frame.origin.y + mWebView.frame.size.height +20)];
            self.frame = _backView.frame;
          //  _cellHeight=_backView.frame.;
          
            
            
        }
        else{
            for (int i = 0; i<_imageLists.count; i++) {
                
                UIImageView *imageView = [[UIImageView alloc] init];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageLists objectAtIndex:i]]];
             //   NSLog(@"%@",NSStringFromCGSize(imageView.image.size));
            
                
                UIImageView *contentImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, (_lblContent.frame.size.height + _lblContent.frame.origin.y) +(i * 10 + i *(SCREEN_WIDTH - 40)*5/4)+ 10, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40)*5/4)];
                 contentImage.tag = i +100;
             //   [contentImage sd_setImageWithURL:[NSURL URLWithString:[self.imageLists objectAtIndex:i]] placeholderImage:ImageCache(@"news_list_default") options:SDWebImageLowPriority | SDWebImageRetryFailed];
                
                NSURL *iurl=[NSURL URLWithString:[self.imageLists objectAtIndex:i]];
                
                [contentImage  sd_setImageWithURL:iurl                                placeholderImage:[UIImage imageNamed:@"news_list_default"]
                                                 options:0
                                               completed:^(UIImage *image,
                                                           NSError *error,
                                                           SDImageCacheType cacheType,
                                                           NSURL *imageURL){}];
                

                [_backView addSubview:contentImage];
                [_imageArray addObject:contentImage];
                
                [contentImage setUserInteractionEnabled:YES];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
                [contentImage addGestureRecognizer:tap];
                [[tap rac_gestureSignal] subscribeNext:^(id x) {
                   
                    if ([self.delegate respondsToSelector:@selector(showAllImages:)]) {
                        [self.delegate showAllImages:_imageLists];
                    }
                    
                }];
                
                
            }
            UIImageView *imageView = (UIImageView *)[_imageArray lastObject];
            [_backView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, imageView.frame.origin.y + imageView.frame.size.height +20)];
            self.frame = _backView.frame;
        }
        
       
    }
    else{
        [_backView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _lblContent.frame.origin.y + _lblContent.frame.size.height +20)];
        self.frame = _backView.frame;
    }
    
  
}
-(NSString *)dateFromDate:(NSString *)str

{   if(str.length!=0)
{
 //   NSTimeInterval time=[str doubleValue]+8*60*60;//因为时差问题要加8小时 == 28800 sec
     NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}
    return @"";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
