//
//  TJNewsYuanWenViewController.m
//  TJLike
//
//  Created by Madroid on 15/5/1.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJNewsYuanWenViewController.h"

@interface TJNewsYuanWenViewController ()
{
    UIWebView *mWebView;
}
@end

@implementation TJNewsYuanWenViewController



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"新闻原文"];
     [self.naviController setNavigationBarHidden:NO];
     [self.naviController setNaviBarDefaultLeftBut_Back];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    mWebView.scalesPageToFit =YES;
    mWebView.scrollView.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    mWebView.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    mWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.view addSubview:mWebView];
    
    [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
