//
//  ScrollViewController.h
//  炫我音乐
//
//  Created by WeiYL on 5/21/14.
//  Copyright (c) 2014 WeiYL. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef void(^TapEvent)(void);
@interface ScrollViewController : UIViewController<UIScrollViewDelegate>
@property(nonatomic,retain)UIScrollView *score;
@property(nonatomic,retain)UIPageControl *pageControl;
//@property(nonatomic,retain)UIButton *startButton;
//@property (nonatomic, copy) TapEvent  tapHidden;
@end
