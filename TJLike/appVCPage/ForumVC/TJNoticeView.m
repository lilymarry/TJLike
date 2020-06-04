//
//  TJNoticeView.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJNoticeView.h"
#import "UIImageView+WebCache.h"

#import "ImageHelper.h"
#define ImageWidth (90 *SCREEN_PHISICAL_SCALE)


@interface TJNoticeView()<UIWebViewDelegate>
{
    UITapGestureRecognizer *tapGesture;
    int  number;
    UILabel   *lblNum;
}

@property (nonatomic, strong) NSString *strImageAssest;
@property (nonatomic, strong) NSArray  *imageLists;

@end

@implementation TJNoticeView

- (instancetype)initWithFrame:(CGRect)frame withObjc:(id)Objc
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.strImageAssest = [NSString stringWithFormat:@"%@",Objc];
        number = [self.imageLists count];
        tapGesture = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tapGesture];
        [[tapGesture rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *tapGes){
            if ([self.delegate respondsToSelector:@selector(tapShowDetaile:)]) {
                [self.delegate tapShowDetaile:_imageLists];
            }
        }];
        [self buildSubView];
    }
    return self;
}

- (void)setStrImageAssest:(NSString *)strImageAssest
{
    _strImageAssest = strImageAssest;
    NSArray *array = [_strImageAssest componentsSeparatedByString:@","];
    _imageLists = array;
}

- (void)buildSubView
{
    lblNum = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - (self.frame.size.width - 90 * 3)/4 - 40,self.frame.size.height -30, 40, 25)];
    [lblNum setBackgroundColor:[UIColor blackColor]];
    [lblNum setTextColor:[UIColor whiteColor]];
    [lblNum setFont:[UIFont systemFontOfSize:12]];
    [lblNum setTextAlignment:NSTextAlignmentCenter];
    lblNum.alpha = 0.5;
    [self addSubview:lblNum];
    lblNum.hidden = YES;
    
    
    BOOL isContainStr;
    if (IS_IOS8_OR_LATER) {
        isContainStr = [_strImageAssest containsString:@"<span"];
    }
    else{

        if ([_strImageAssest rangeOfString:@"<span"].location !=NSNotFound) {
            isContainStr = YES;
        }
        else{
            isContainStr = NO;
        }
    }
    
    
    if (self.imageLists.count == 1 && isContainStr) {
       UIWebView * mWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH -20, 90)];
        mWebView.scalesPageToFit =NO;
        mWebView.delegate =self;
        mWebView.scrollView.scrollEnabled = NO;
        mWebView.dataDetectorTypes = UIDataDetectorTypeAll;
         [mWebView loadHTMLString:_strImageAssest baseURL:nil];
        [self addSubview:mWebView];
        
    }
    else{
        for (int i= 0; i <(number<3?number:3); i++) {
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(((i +1)*(self.frame.size.width - ImageWidth * 3)/4 +ImageWidth *i),5,ImageWidth,90)];
            [self addSubview:imageV];
            
            
            NSURL *iurl=[NSURL URLWithString:[self.imageLists objectAtIndex:i]];
            
            [imageV   sd_setImageWithURL:iurl                                placeholderImage:[UIImage imageNamed:@"news_list_default"]
                                options:0
                              completed:^(UIImage *image,
                                          NSError *error,
                                          SDImageCacheType cacheType,
                                          NSURL *imageURL){
                                  imageV.image=[ImageHelper imageScaleWithImage:image];
                              }];
            
            //            [ image sd_setImageWithURL:iurl completed:^(UIImage *sdimage, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //              //  NSLog(@"1  %f-%f",sdimage.size.height,sdimage.size.width);
            //             //   image.image=[UIImage imageNamed:@"news_list_default"];
            //                image.image=[ImageHelper imageScaleWithImage:sdimage];
            //                //  NSLog(@"2  %f-%f",image.image.size.height,image.image.size.width);
            //            }];
            //
            
            //   [image sd_setImageWithURL:[NSURL URLWithString:[self.imageLists objectAtIndex:i]] placeholderImage:ImageCache(@"news_list_default") options:SDWebImageLowPriority | SDWebImageRetryFailed];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            //            [image addGestureRecognizer:tap];
            [[tap rac_gestureSignal] subscribeNext:^(id x) {
                
                if ([self.delegate respondsToSelector:@selector(tapShowDetaile:)]) {
                    [self.delegate tapShowDetaile:_imageLists];
                }
            }];
            if (i==2) {
                lblNum.hidden = NO;
                [lblNum setText:[NSString stringWithFormat:@"共%d张",number]];
                [self bringSubviewToFront:lblNum];
            }
        }
    }
}





@end
