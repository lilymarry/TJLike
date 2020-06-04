//
//  TJSubSubjectViewCell.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/16.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJSubSubjectViewCell.h"
#import "TJReportComView1.h"
#import "TJSubCommentModel.h"
#import "TJCommentModel.h"
#import "UIImageView+WebCache.h"
#import "TextLabel.h"

@interface TJSubSubjectViewCell()<TJReportComViewDelegate1,UIWebViewDelegate>
{
    UIView *lineView;
    TJReportComView1 *reportView;
 //   TJReportComView1 *preReportView;
    TJCommentModel  *curModel;
    NSInteger       curFloor;
}
@property (nonatomic, strong)UIView       *backView;
@property (nonatomic, strong)UIImageView  *headImageVIew;
@property (nonatomic, strong)UIImageView  *landlordImgView;
@property (nonatomic, strong)UILabel      *lblNick;
@property (nonatomic, strong)UILabel      *lblTime;
@property (nonatomic, strong)UIButton     *btnTall;
@property (nonatomic, strong)UILabel      *lblTitle;
@property (nonatomic, strong)UILabel      *lblFloor;

@property (nonatomic, strong)UIButton     *btnMore;
//@property (nonatomic, strong)NSString     *replyName;
//@property (nonatomic, strong)NSString     *commentName;

@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic, strong) NSArray  *imageLists;

@end

@implementation TJSubSubjectViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self buildUI];
    }
    return self;
}

- (void)setContentItem:(TJBBSContentModel *)contentItem
{
    _contentItem = contentItem;
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
    
    _lblNick = [[UILabel alloc] initWithFrame:CGRectMake(_headImageVIew.frame.size.width + _headImageVIew.frame.origin.x +10, 18,50 *SCREEN_PHISICAL_SCALE, 21)];
    [_lblNick setText:@"昵称"];
    [_lblNick setTextAlignment:NSTextAlignmentLeft];
    [_backView addSubview:_lblNick];
    
    UIImage *image = [UIImage imageNamed:@"louzhu_"];
    _landlordImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_lblNick.frame.origin.x + _lblNick.frame.size.width, 20, image.size.width, image.size.height)];
    [_landlordImgView setImage:image];
    
    [_backView addSubview:_landlordImgView];
    
//    _btnTall = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_btnTall setFrame:CGRectMake(SCREEN_WIDTH - 20 - 50 , 20, 40, 20)];
//    [_btnTall setImage:[UIImage imageNamed:@"luntan_xuanxiang_"] forState:UIControlStateNormal];
    
    
    reportView = [TJReportComView1 instalReportView];
   // [reportView setFrame:CGRectMake(SCREEN_WIDTH-50, 5, 0, reportView.frame.size.height)];
    [reportView showReportView];
    reportView.delegate = self;
    [self.backView addSubview:reportView];
    @weakify(self)
 //   [[_btnTall rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
 //       @strongify(self)
      //  TLog(@"举报,评论");
        
        
//        if (self->reportView.rStatus == Report_Status_Close) {
//            [self->reportView showReportView];
//            
//            [self.delegate pressReport:self];
//        }
//        else if (self->reportView.rStatus == Report_Status_Open){
//            [self->reportView dissmisReportView:CGRectMake(self.btnTall.frame.origin.x, 5, 0, reportView.frame.size.height)];
//        }
///    }];
//    [_backView addSubview:_btnTall];
    
    _lblFloor = [[UILabel alloc] initWithFrame:CGRectMake(_lblNick.frame.origin.x, _lblNick.frame.origin.y + _lblNick.frame.size.height +3, 40, 21)];
    [_lblFloor setTextColor:[UIColor grayColor]];
    [_lblFloor setTextAlignment:NSTextAlignmentCenter];
    [_lblFloor setFont:[UIFont systemFontOfSize:12]];
    [_lblFloor setText:@"第1楼"];
   [_backView addSubview:_lblFloor];
    
    _lblTime = [[UILabel alloc] initWithFrame:CGRectMake(_lblNick.frame.origin.x, _lblNick.frame.origin.y + _lblNick.frame.size.height +3, SCREEN_WIDTH - _lblNick.frame.origin.x - _lblNick.frame.origin.x , 21)];
    [_lblTime setBackgroundColor:[UIColor clearColor]];
    [_lblTime setTextColor:[UIColor grayColor]];
    [_lblTime setFont:[UIFont systemFontOfSize:12]];
    [_lblTime setText:@"2015-04-03 21:05:04"];
    [_backView addSubview:_lblTime];
    
    _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(_headImageVIew.frame.size.width + 20, _headImageVIew.frame.origin.y +_headImageVIew.frame.size.height +10, SCREEN_WIDTH - 60, 21)];
    [_lblTitle setText:@"标题"];
    [_lblTitle setTextAlignment:NSTextAlignmentLeft];
    [_lblTitle setTextColor:[UIColor blackColor]];
    [_lblTitle setNumberOfLines:0];
    [_backView addSubview:_lblTitle];
    
    [_lblTitle setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapContent = [[UITapGestureRecognizer alloc] init];
    [_lblTitle addGestureRecognizer:tapContent];
    [[tapContent rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.delegate commentCellEvent:curModel andFloor:curFloor];
    }];
    
    
    

}

- (void)bindModel:(id)model andFloor:(NSInteger)florr
{
    
    
    TJCommentModel *item = (TJCommentModel *)model;
    curModel = item;
    curFloor = florr;
    reportView.tag = florr + 1;
    [self.lblFloor setText:[NSString stringWithFormat:@"第%ld楼",(long)florr + 1]];
    self.lblFloor.hidden = YES;
     [self.lblTime setText:StringEqual(item.nickname, @"")?@"暂无":item.time];
    [self.lblNick setText:StringEqual(item.nickname, @"")?item.username:item.nickname];
    CGSize size = [UIUtil textToSize:StringEqual(item.nickname, @"")?item.username:item.nickname fontSize:17 withHeight:21];
    
    [self.lblNick setFrame:CGRectMake(self.lblNick.frame.origin.x, self.lblNick.frame.origin.y,size.width, 21)];
    [_landlordImgView setFrame:CGRectMake(_lblNick.frame.origin.x + _lblNick.frame.size.width +10, 15, _landlordImgView.frame.size.width, _landlordImgView.frame.size.height)];
    
    if (StringEqual(self.contentItem.username, item.username)) {
        _landlordImgView.hidden = NO;
    }
    else{
        _landlordImgView.hidden = YES;
    }
    
    
    [self.headImageVIew sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:ImageCache(@"news_list_default") options:SDWebImageLowPriority | SDWebImageRetryFailed];
    
    CGSize sizeT = [UIUtil textToSize:item.content fontSize:20];
    [_lblTitle setText:item.content];
   // [_lblTitle sizeToFit];
    [_lblTitle setFrame:CGRectMake(_lblTitle.frame.origin.x, _lblTitle.frame.origin.y, _lblTitle.frame.size.width, sizeT.height)];
   //  [_backView addSubview:_lblTitle];
    
   
    CGFloat iHeight = 0.0;
    if (!StringEqual(item.image, @"")) {
        NSArray *array = [item.image componentsSeparatedByString:@","];
        _imageLists = array;
//        if (_imageLists.count == 1 && ![item.image containsString:@","]) {
//            NSLog(@"%@",item.image);
//            UIWebView * mWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, (_lblTitle.frame.size.height + _lblTitle.frame.origin.y) + 10, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40)*5/4)];
//            mWebView.scalesPageToFit =NO;
//            mWebView.delegate =self;
//            mWebView.scrollView.scrollEnabled = NO;
//            mWebView.dataDetectorTypes = UIDataDetectorTypeAll;
//            [mWebView loadHTMLString:item.image baseURL:nil];
//            [_backView addSubview:mWebView];
//            [_backView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, mWebView.frame.origin.y + mWebView.frame.size.height +20)];
//            self.frame = _backView.frame;
//        }
//        else{
            for (int i = 0; i<_imageLists.count; i++) {
                UIImageView *contentImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, (_lblTitle.frame.size.height + _lblTitle.frame.origin.y) +(i * 10 + i *(SCREEN_WIDTH - 40)*5/4)+ 10, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40)*5/4)];
                [contentImage sd_setImageWithURL:[NSURL URLWithString:[self.imageLists objectAtIndex:i]] placeholderImage:ImageCache(@"news_list_default") options:SDWebImageLowPriority | SDWebImageRetryFailed];
                [_backView addSubview:contentImage];
                [_imageArray addObject:contentImage];
                
                [contentImage setUserInteractionEnabled:YES];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
                [contentImage addGestureRecognizer:tap];
                [[tap rac_gestureSignal] subscribeNext:^(id x) {
                    
                    if ([self.delegate respondsToSelector:@selector(showSubAllImages:)]) {
                        [self.delegate showSubAllImages:_imageLists];
                    }
                    
                }];
                
                
                
                iHeight = iHeight + contentImage.frame.origin.y + contentImage.frame.size.height +20;
            }
            [_backView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, iHeight)];
            self.frame = _backView.frame;
//        }
    }
    else{
        [_backView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _lblTitle.frame.origin.y + _lblTitle.frame.size.height +20)];
        self.frame = _backView.frame;
        iHeight = _lblTitle.frame.origin.y + _lblTitle.frame.size.height +20;
    }
    if (item.subLists.count == 0) {
        [_backView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, iHeight +20)];
        self.frame = _backView.frame;
    }
    else{
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(_headImageVIew.frame.size.width + 20, iHeight+10, SCREEN_WIDTH - _headImageVIew.frame.size.width-40, 1)];
        [lineView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [_backView addSubview:lineView];
        
        CGFloat lblY = lineView.frame.size.height + lineView.frame.origin.y+10;
        CGFloat lblHight = 0.0;
        
        for (int i = 0; i< (item.subLists.count<2?item.subLists.count:2); i++) {
            
            TJSubCommentModel *subItem = (TJSubCommentModel *)[item.subLists objectAtIndex:i];
            
            NSString     *replyName = [NSString stringWithFormat:@"%@",subItem.replyidnickname];
            NSString     *commentName = [NSString stringWithFormat:@"%@",subItem.commentidnickname];
            
            
            NSString *str = [NSString stringWithFormat:@"%@ 回复:%@ %@",commentName,replyName,subItem.content];
            CGSize size = [UIUtil textToSize:str fontSize:14];
          
         //  TextLabel *lblSubComent = [[TextLabel alloc] initWithFrame:CGRectMake(lineView.frame.origin.x,  10 + lblY + lblHight, SCREEN_WIDTH - lineView.frame.origin.x, size.height) withStr:str withLength:commentName.length withLandlord:NO];
            
            UILabel *lblSubComent= [[UILabel alloc] initWithFrame:CGRectMake(lineView.frame.origin.x,  10 + lblY + lblHight, SCREEN_WIDTH - lineView.frame.origin.x-5, size.height)];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
            
            
            UIColor *color = COLOR(45, 150, 232, 1);
            [attrString addAttribute:NSForegroundColorAttributeName
                               value:color
                               range:[str rangeOfString:commentName]];
            [lblSubComent setAttributedText:attrString];
            
           // lblSubComent.text=str ;
            [lblSubComent sizeToFit];
            [lblSubComent setNumberOfLines:0];
            [lblSubComent setFont:[UIFont systemFontOfSize:14]];
            lblHight = lblHight + size.height;
            lblSubComent.numberOfLines = 0;

            [_backView addSubview:lblSubComent];
            
            [lblSubComent setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            [lblSubComent addGestureRecognizer:tap];
            @weakify(self)
            [[tap rac_gestureSignal] subscribeNext:^(id x) {
                @strongify(self)
                [self.delegate showFloorVC:subItem withCommentModel:curModel andFloor:curFloor];
                
            }];

        }
        
        if (item.subLists.count >2) {
           [_backView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, lblY + lblHight +80 )];
            
            _btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
            [_btnMore setFrame:CGRectMake(lineView.frame.origin.x, _backView.frame.size.height - 25 -20, 200, 25)];
            [_btnMore setTitleColor:COLOR(45, 150, 232, 1) forState:UIControlStateNormal];
            _btnMore .titleLabel.font=[UIFont systemFontOfSize:14];
            [_btnMore setTitle:[NSString stringWithFormat:@"更多%ld条评论---",(long)item.subLists.count -2] forState:UIControlStateNormal];
            [_backView addSubview:_btnMore];
            self.frame = _backView.frame;
            @weakify(self)
            [[_btnMore rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self)
                [self.delegate commentCellEvent:curModel andFloor:curFloor];
            }];
            
        }
        else{
            [_backView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, lblY + lblHight +20 )];
            self.frame = _backView.frame;
        }
        
    }
}

- (void)awakeFromNib {
    // Initialization code
      [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//     [self hidenReportVIew];
//}
//
//- (void)hidenReportVIew
//{
//    if (self->reportView.rStatus == Report_Status_Open){
//        [self->reportView dissmisReportView:CGRectMake(self.btnTall.frame.origin.x, 5, 0, reportView.frame.size.height)];
//    }
//}

- (void)reportEvent
{
     [self.delegate reportCellEvent:curModel];
}
- (void)commentEvent
{
    [self.delegate commentCellEvent:curModel andFloor:curFloor];
}

@end
