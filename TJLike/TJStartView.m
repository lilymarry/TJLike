//
//  TJStartView.m
//  TJLike
//
//  Created by IPTV_MAC on 15/5/16.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJStartView.h"

#define ImageLists @[@"user_guid_bg_1",@"user_guid_bg_2",@"user_guid_bg_3",@"user_guid_bg_4"]

@interface TJStartView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer      *timer;

@end

@implementation TJStartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        [user setBool:YES forKey:@"cunzai"];
        [user synchronize];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerEvent:)];
        [self addGestureRecognizer:tapGesture];
        [self setbackImageView];
        
    }
    return self;
}
- (void)tapGestureRecognizerEvent:(UITapGestureRecognizer *)tap
{
//    if (self.timer) {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
//    if (self.tapHidden) {
//        self.tapHidden();
//    }
   

}

- (void)setbackImageView
{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * ImageLists.count, 0)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    for (int i = 0; i<ImageLists.count; i++) {
        UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(i *SCREEN_WIDTH, 0, self.frame.size.width, self.frame.size.height)];
        [imagView setImage:[UIImage imageNamed:[ImageLists objectAtIndex:i]]];
        [_scrollView addSubview:imagView];
    }
   

    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timingHidenStartView) userInfo:nil repeats:YES];
}

- (void)timingHidenStartView
{
    if (self.tapHidden) {
        self.tapHidden();
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = (NSInteger)scrollView.contentOffset.x/SCREEN_WIDTH;
    if (index == ImageLists.count - 1) {
        if (self.tapHidden) {
            self.tapHidden();
        }
    }
}


- (void)dealloc
{
    NSLog(@"WTVStartView dealloc");
}



@end
