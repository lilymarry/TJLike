//
//  TJShowImageView.m
//  TJLike
//
//  Created by IPTV_MAC on 15/5/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJShowImageView.h"
#import "UIImageView+AFNetworking.h"

@interface TJShowImageView ()<UIScrollViewDelegate,UIActionSheetDelegate>
{
    BOOL      isScreen;
    CGPoint   startPoint;
    CGFloat touchX;
    CGFloat touchY;
    CGFloat scrX;
}
@property (nonatomic, strong) NSArray   *imageLists;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIImageView    *curImageView;
@property (nonatomic, strong) UIActionSheet *saveSheet;

@end

@implementation TJShowImageView

- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageLists = [[NSMutableArray alloc] init];
        
//        [self.imageLists addObject:[images objectAtIndex:0]];
//        [self.imageLists addObject:[images objectAtIndex:0]];
        
        self.imageLists = images;
        self.backgroundColor = [UIColor blackColor];
        _imageArray = [[NSMutableArray alloc] init];
        [self buildUI];
        
    }
    return self;
}

- (void)buildUI
{
    _scrollView = [[UIScrollView alloc] initWithFrame:SCREEN_BOUNDS];
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH *self.imageLists.count, 0)];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.userInteractionEnabled = YES;
    [self addSubview:_scrollView];

    for (int i = 0; i < [self.imageLists count];i++) {

        UIScrollView *subScrView = [[UIScrollView alloc] initWithFrame:CGRectMake(i *SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        subScrView.delegate = self;
        subScrView.userInteractionEnabled = YES;
        subScrView.backgroundColor = [UIColor blackColor];
        subScrView.alpha = 1.0;
        subScrView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
        subScrView.tag = i + 100;
        subScrView.minimumZoomScale = 1.0;
        subScrView.maximumZoomScale = 2.0;
        [_scrollView addSubview:subScrView];
        
        
        UIImageView *largeImageView = [[UIImageView alloc] init];
        [largeImageView setImageWithURL:[NSURL URLWithString:[self.imageLists objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"news_list_default"]];
        CGFloat  imageHeight = 0;
        CGFloat  imageWidth  = 0;
        if (largeImageView.image.size.width >= SCREEN_WIDTH) {
            imageWidth = SCREEN_WIDTH;
        }
        else if (largeImageView.image.size.width <= 300)
        {
              imageWidth = 300;
        }
        else if (largeImageView.image.size.width > 300 && largeImageView.image.size.width <=  SCREEN_WIDTH)
        {
            imageWidth = largeImageView.image.size.width;
        }
        if (largeImageView.image.size.height > SCREEN_HEIGHT)
        {
            imageHeight = SCREEN_HEIGHT;
        }
        else if (largeImageView.image.size.height <= 240)
        {
            imageHeight = 240;
        }
        else if (largeImageView.image.size.height > 240 && largeImageView.image.size.height <=  SCREEN_HEIGHT)
        {
            imageHeight = largeImageView.image.size.height;
        }
    
        [largeImageView setFrame:CGRectMake(0, 0, imageWidth , imageHeight)];
        largeImageView.center = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/2);
        largeImageView.tag = i +100;
        [_imageArray addObject:largeImageView];
        [subScrView addSubview:largeImageView];
    }
    self.curImageView = [_imageArray objectAtIndex:0];
    
    //点击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapCurrentView:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGesture];
    //双击
    UITapGestureRecognizer *tapDoubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapDoubleCurrentView:)];
    tapDoubleGesture.numberOfTapsRequired = 2;
    tapDoubleGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapDoubleGesture];
    [tapGesture requireGestureRecognizerToFail:tapDoubleGesture];
    //长按
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongCurrentView:)];
    longGesture.minimumPressDuration = 1.0f;
    [self addGestureRecognizer:longGesture];
    

}


- (void)showLargeView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    CGSize size = self.scrollView.bounds.size;

    
    
    CGAffineTransform newTransform = CGAffineTransformScale(self.scrollView.transform, 0.01, 0.01);
    [_scrollView setTransform:newTransform];
    _scrollView.center = startPoint;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGAffineTransform newTransform2 =  CGAffineTransformConcat(self.scrollView.transform,  CGAffineTransformInvert(self.scrollView.transform));
        [self.scrollView setTransform:newTransform2];
        self.scrollView.alpha = 1.0;
        self.scrollView.center = CGPointMake(size.width/2, size.height/2);
        
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
    }];
    
}

- (void)hideLargeView
{
    [UIView animateWithDuration:0.25 animations:^{
        
        CGAffineTransform newTransform =  CGAffineTransformScale(self.scrollView.transform, 0.01, 0.01);
        [self.scrollView setTransform:newTransform];
        self.scrollView.center = CGPointMake(startPoint.x, startPoint.y);
        
    } completion:^(BOOL finished) {
        
        [_scrollView removeFromSuperview];
        [self removeFromSuperview];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
}


- (void)handleTapCurrentView:(UITapGestureRecognizer *)tapGesture
{
    [self hideLargeView];
    if (self.tapHideBlock) {
        self.tapHideBlock();
    }
    
}

- (void)handleTapDoubleCurrentView:(UITapGestureRecognizer *)tapGesture
{
//    touchX = [tapGesture locationInView:tapGesture.view].x;
//    touchY = [tapGesture locationInView:tapGesture.view].y;
//    
//    //    @weakify(self);
//    
//    __weak __typeof(self)weakSelf = self;
//    [UIView animateWithDuration:0.3f animations:^{
//        //        @strongify(self);
//        
//        
//        if (isScreen) {
//            _botScrollView.zoomScale = 1;
//            isScreen = NO;
//        }
//        else{
//            
//            _botScrollView.zoomScale = 2.0;
//            
//            [weakSelf.scrollView setContentOffset:CGPointMake(touchX, 0)];
//            
//            isScreen = YES;
//            
//        }
//    } completion:^(BOOL finished) {
//        
//    }];
    
    
}

- (void)handleLongCurrentView:(UILongPressGestureRecognizer *)longfGesture
{
    
    if(UIGestureRecognizerStateBegan == longfGesture.state) {
        // Called on start of gesture, do work here
        _saveSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        _saveSheet.actionSheetStyle = UIBarStyleDefault;
        
        [_saveSheet showInView:self];
    }
    
    if(UIGestureRecognizerStateChanged == longfGesture.state) {
        // Do repeated work here (repeats continuously) while finger is down
    }
    
    if(UIGestureRecognizerStateEnded == longfGesture.state) {
        // Do end work here when finger is lifted
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    scrX = scrollView.contentOffset.x/SCREEN_WIDTH;
    self.curImageView = [_imageArray objectAtIndex:scrX];

}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    if (scrollView.tag -100 == scrX) {
        
        [self.curImageView setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
    }
   
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (scrollView.tag -100 == scrX) {
        if (scale > _scrollView.minimumZoomScale) {
            isScreen = YES;
        }
        else{
            isScreen = NO;
        }
    }
   
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView.tag -100 == scrX) {
        return self.curImageView;
    }
    return nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
        
        
        UIImageWriteToSavedPhotosAlbum(self.curImageView.image, self,selectorToCall, NULL);
    }
}

- (void) imageWasSavedSuccessfully:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError contextInfo:(void *)paramContextInfo{
    if (paramError == nil){
        NSLog(@"Image was saved successfully.");
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
        
    } else {
        NSLog(@"An error happened while saving the image.");
        NSLog(@"Error = %@", paramError);
    }
}


@end
