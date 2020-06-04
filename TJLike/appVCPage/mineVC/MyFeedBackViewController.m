//
//  MyFeedBackViewController.m
//  TJLike
//
//  Created by imac-1 on 16/9/6.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "MyFeedBackViewController.h"
#import "FreeBackView.h"
#import "SendFreeBackView.h"
@interface MyFeedBackViewController ()
@property (nonatomic, strong)FreeBackView *bottomView;
@end

@implementation MyFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _bottomView = [[FreeBackView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    //  _bottomView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    _bottomView.backgroundColor = [UIColor colorWithRed:220/250.f green:220/250.f blue:220/250.f alpha:1];
    _bottomView.mDelegate = self;
    _bottomView.onGoComment = @selector(ShowCommentView:);
    _bottomView.OnSendClick = @selector(SendCommentClick);
    [self.view addSubview:_bottomView];

}
- (void)ShowCommentView:(UIButton *)sender{
    _bottomView.showContent.hidden = !_bottomView.showContent.hidden;
    _bottomView.commentNum.hidden = !_bottomView.commentNum.hidden;
//    if (self.mScrollView.contentOffset.x==0) {
//        [self.mScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, self.mScrollView.contentOffset.y) animated:YES];
//        [self.naviController setNaviBarTitle:@"热门评论"];
//    }else if(self.mScrollView.contentOffset.x>SCREEN_WIDTH*0.7){
//        [self.mScrollView setContentOffset:CGPointMake(0, self.mScrollView.contentOffset.y) animated:YES];
//        [self.naviController setNaviBarTitle:@"资讯中心"];
//    }
}
- (void)SendCommentClick{
    NSLog(@"%@",UserManager.userInfor.userId);
    if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            NSLog(@"成功");
            [self ReginstCommentView];
        }andFaile:^{
            NSLog(@"失败");
        }];
    }else{
        [self ReginstCommentView];
    }
}
- (void)ReginstCommentView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    SendFreeBackView *commentView = [[SendFreeBackView alloc] initWithFrame:window.bounds];
  //  commentView.nid = self.nid;
    commentView.mBlock = ^{
    //    [_commentListView GetData];
     //   commentNum ++;
     //   mDesLabel.text = [NSString stringWithFormat:@"%@ %@ %d评论",dataDict[@"source"],dataDict[@"pubtime"],commentNum];
    };
    [window addSubview:commentView];
}


-(void)viewWillAppear:(BOOL)animated
{   [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"用户反馈"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];

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
