//
//  SeeMoreViewController.m
//  TJLike
//
//  Created by imac-1 on 16/8/30.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "SeeMoreViewController.h"

@interface SeeMoreViewController ()
@property (nonatomic, strong)UIWebView *contentLabel;
@end

@implementation SeeMoreViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"查看更多"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
    //  [self.naviController setNaviBarRightBtn:[self GetRightBtn]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentLabel = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20)];
    self.contentLabel.scrollView.bounces=NO;
  //  self.contentLabel.scrollView.scrollEnabled=NO;
    [self.view addSubview:_contentLabel];
    
//    NSMutableAttributedString *butedString = [[NSMutableAttributedString alloc]initWithString:self.moreStr];
//    NSRange range = {0,3};
//    [butedString addAttributes:[NSDictionary dictionaryWithObjects:@[[UIFont systemFontOfSize:20],NSForegroundColorAttributeName] forKeys:@[NSFontAttributeName,NSUnderlineStyleAttributeName]] range:range];
//    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:10];
//    [butedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, 2)];
//    NSString *string = self.moreStr;
//    UIColor *color = [UIColor darkGrayColor];
//    [butedString addAttribute:NSForegroundColorAttributeName value:color range:[string rangeOfString:string]];
//    [self.contentLabel setAttributedText:butedString];
    
    [_contentLabel loadHTMLString:_moreStr baseURL:nil];



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
