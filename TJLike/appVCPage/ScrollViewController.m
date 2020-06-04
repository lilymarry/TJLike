//
//  ScrollViewController.m
//  炫我音乐
//
//  Created by WeiYL on 5/21/14.
//  Copyright (c) 2014 WeiYL. All rights reserved.
//
#define ImageLists @[@"user_guid_bg_1",@"user_guid_bg_2",@"user_guid_bg_3",@"user_guid_bg_4"]
#import "ScrollViewController.h"
#import "TJMainTabbarControllerViewController.h"
#import "XKTabBarController.h"
@interface ScrollViewController ()


@property (nonatomic, strong) NSTimer      *timer;

@end

@implementation ScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerEvent:)];
    [self.view addGestureRecognizer:tapGesture];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [user setBool:YES forKey:@"cunzai"];
    [user synchronize];
    
    //[self.navigationController setNavigationBarHidden:YES];
    
    self.score=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.score setPagingEnabled:YES];//开启分页功能
    [self.score setShowsHorizontalScrollIndicator:NO];
    [self.score setShowsVerticalScrollIndicator:NO];
    self.score.bounces=NO;
    [self.score setContentSize:CGSizeMake(self.score.frame.size.width*4,  self.view.frame.size.height)];
    self.score.delegate=self;
    
    for (int i=0; i<4; i++) {
        UIImageView *view1=[[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.frame.size.width,0,self.view.frame.size.width,  self.view.frame.size.height)];
        [view1 setImage:[UIImage imageNamed:ImageLists[i]]];
        [self.score addSubview:view1];

    }
    
    
    
    [self.view addSubview: self.score];
    
    
    self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.5-20,  self.view.frame.size.height-50, 40, 40)];
    self.pageControl.numberOfPages=4;
    self.pageControl.currentPage=0;
    [self.pageControl addTarget:self action:@selector(pageChange)  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
    
    
    /// self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timingHidenStartView) userInfo:nil repeats:YES];
    
    
}
- (void)timingHidenStartView
{
//    if (self.tapHidden) {
//        self.tapHidden();
//    }
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
  XKTabBarController *main=  [[XKTabBarController alloc]  init];
    [self presentViewController:main animated:YES completion:nil];
   //  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated
{

    [self.navigationController setNavigationBarHidden:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    
    NSInteger index = (NSInteger)scrollView.contentOffset.x/SCREEN_WIDTH;
    self.pageControl.currentPage=index;

    if (index == ImageLists.count - 1) {
//        if (self.tapHidden) {
//            self.tapHidden();
//        }
        XKTabBarController *main=  [[XKTabBarController alloc]  init];
        [self presentViewController:main animated:YES completion:nil];
    }

    
}

-(void)pageChange
{
    CGRect frame=self.score.frame;
    int page=(int)self.pageControl.currentPage;
    frame.origin.x=frame.size.width*page;
    [self.score scrollRectToVisible:frame animated:YES];
    
    
    
    
}
-(void)buttonpress
{
//    MusicPlayerViewController *play=[[MusicPlayerViewController alloc]initWithNibName:@"MusicPlayerViewController" bundle:nil];
//    
//    [self.navigationController pushViewController:play animated:YES];
//    //[self presentViewController:play animated:YES completion:nil];
//    [play release];
    
 //   [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
