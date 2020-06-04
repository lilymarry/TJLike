//
//  TJNewsImageDetailController.m
//  TJLike
//
//  Created by MC on 15-3-31.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJNewsImageDetailController.h"
#import "CommentBottom.h"
#import "UIImageView+WebCache.h"
#import "CommentListView.h"
#import "SendCommentView.h"
#import "ShareSDK.h"
#import "AutoAlertView.h"
#import "TJUserNewsViewController.h"
#import "AlertHelper.h"
#import <CDChatManager.h>
@interface TJNewsImageDetailController ()<CommentListDelegate>

@property (nonatomic, strong)UIScrollView *mScrollView;

//@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UITextView *contentLabel;

@property (nonatomic, strong)NSString *curText;

@property (nonatomic, strong)CommentListView *commentListView;

@property (nonatomic, assign)int mPage;

@property (nonatomic, strong)CommentBottom *bottomView;
@end

@implementation TJNewsImageDetailController
{
    
    NSMutableArray *imageArray;
    NSMutableArray *textArray;
    
    //int shareImageIndex;//分享的第几张图片图片  因为sharesdk 只能分享一张图片
    
    int totalPage;
    
}
- (UIButton *)GetRightBtn{
    //news_top_4_
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setImage:[UIImage imageNamed:@"gengduo.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(RightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return rightBtn;
}

- (void)RightBtnClick{
    //[[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    
    NSString *imagePath = [NSString stringWithFormat:@"%@",self.tuwen[0][@"pic"]];
    NSLog(@"%@",imagePath);
    //构造分享内容
    id<ISSCAttachment>image;
    if (self.tuwen.count != 0) {
        image = [ShareSDK imageWithUrl:self.tuwen[0][@"pic"]];
    }
    
    id<ISSContent> publishContent = [ShareSDK content:self.mlbTitle
                                       defaultContent:self.mlbTitle
                                                image:image
                                                title:self.mlbTitle
                                                  url:nil
                                          description:@"奏耐天津"
                                            mediaType:SSPublishContentMediaTypeImage];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    NSArray *shareList = [ShareSDK customShareListWithType:
                          SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          nil];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                    [AutoAlertView ShowMessage:@"分享成功"];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"---%@",[error errorDescription]);
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    [AutoAlertView ShowMessage:@"分享失败"];
                                }
                            }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"资讯新闻"];
    [self.naviController setNaviBarDefaultLeftBut_Back];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.naviController setNaviBarRightBtn:[self GetRightBtn]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIView *mView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
//    mView1.backgroundColor = [UIColor blackColor];
//    [self.view  addSubview:mView1];
   
//    UIButton *btnReturn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnReturn setFrame:CGRectMake(5, 5, 40, 54)];
//    [btnReturn setImage:[UIImage imageNamed:@"appui_fanhui_"] forState:UIControlStateNormal];
//    [[btnReturn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        
//        [self.naviController popViewControllerAnimated:YES];
//    }];
//    [mView1 addSubview:btnReturn];

    
    self.view.backgroundColor = [UIColor blackColor];
    imageArray = [[NSMutableArray alloc]initWithCapacity:10];
    textArray = [[NSMutableArray alloc]initWithCapacity:10];
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.mScrollView.showsHorizontalScrollIndicator = NO;
    //self.mScrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.mScrollView];
    self.mScrollView.delegate = self;
    self.mScrollView.pagingEnabled = YES;
    self.mScrollView.bounces = NO;
    
   // self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT-100, SCREEN_WIDTH-15, 25)];
    self.contentLabel = [[UITextView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-144, SCREEN_WIDTH, 100)];
    self.contentLabel.backgroundColor=[UIColor blackColor];
    self.contentLabel.alpha=0.7;
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_contentLabel];
    
    [self InitImageArrayAndTextArray];
    
    for (int i = 0; i<imageArray.count; i++) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*i, 0, self.view.frame.size.width, self.view.frame.size.height-120)];
        scrollView.bounces = NO;
        scrollView.delegate = self;
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 2.0;  //放大比例；
        scrollView.zoomScale = 1.0;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-120);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self.mScrollView addSubview:scrollView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 500;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]]];
        imageView.userInteractionEnabled = YES;
        [scrollView addSubview:imageView];
    }
    
    _commentListView = [[CommentListView alloc]initWithFrame:CGRectMake(totalPage*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-105) WithNid:self.nid];
    _commentListView.mlTitle = self.mlbTitle;
    _commentListView.delegate=self;
    [_mScrollView addSubview:_commentListView];
    
    _bottomView = [[CommentBottom alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    _bottomView.backgroundColor = [UIColor colorWithRed:220/250.f green:220/250.f blue:220/250.f alpha:1];;
    _bottomView.mDelegate = self;
    _bottomView.onGoComment = @selector(ShowCommentView:);
    _bottomView.OnSendClick = @selector(SendCommentClick);
    [self.view addSubview:_bottomView];
    
    _commentListView.commentBottomView = _bottomView;
}
- (void)SendCommentClick{
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
    SendCommentView *commentView = [[SendCommentView alloc] initWithFrame:window.bounds];
    commentView.nid = self.nid;
    [window addSubview:commentView];
}
- (void)sendClick:(NSString *)comment{
    
        NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/AddComment"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSString stringWithFormat:@"%@",self.nid] forKey:@"cid"];
        [HttpClient request:dict URL:urlStr success:^(NSDictionary *info) {
    
        } fail:^{
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
        }];
    
}

- (void)InitImageArrayAndTextArray{
    [imageArray removeAllObjects];
    [textArray removeAllObjects];
    NSArray *array = self.tuwen;
    totalPage = array.count;
    for (int i = 0; i<array.count; i++) {
        NSString *pic = array[i][@"pic"];
        [imageArray addObject:pic];
        NSString *description = array[i][@"description"];
        [textArray addObject:description];
    }
    self.mPage = 0;
    [self ChangeText];
    self.mScrollView.contentSize = CGSizeMake(self.view.bounds.size.width*(totalPage+1), 0);


}
- (void)ChangeText{
    if (self.mPage == totalPage) {
       self.contentLabel.hidden = YES;
       [self.naviController setNaviBarTitle:@"热门评论"];
    }
    else{
        self.contentLabel.hidden = NO;
        [self.naviController setNaviBarTitle:@"资讯新闻"];
        self.curText = [NSString stringWithFormat:@"%d/%d %@",self.mPage+1,totalPage,textArray[self.mPage]];
      //  NSLog(@"_curPageText---->%@",self.curText);
        NSMutableAttributedString *butedString = [[NSMutableAttributedString alloc]initWithString:self.curText];
        NSRange range = {0,3};
        [butedString addAttributes:[NSDictionary dictionaryWithObjects:@[[UIFont systemFontOfSize:20],NSForegroundColorAttributeName] forKeys:@[NSFontAttributeName,NSUnderlineStyleAttributeName]] range:range];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:10];
        [butedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, 2)];
        NSString *string = self.curText;
        UIColor *color = [UIColor whiteColor];
        [butedString addAttribute:NSForegroundColorAttributeName value:color range:[string rangeOfString:string]];
           [self.contentLabel setAttributedText:butedString];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==self.mScrollView) {
        [self ChangeText];
        _bottomView.showContent.hidden = self.mPage<totalPage;
        _bottomView.commentNum.hidden = self.mPage==totalPage;
       // [self.naviController setNaviBarTitle:@"资讯新闻"];
    }
  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //根据偏移量计算是哪个图片；
    if (scrollView == self.mScrollView){
        self.mPage = (scrollView.contentOffset.x/scrollView.frame.size.width);
        TLog(@"--------->%d---------->%d",self.mPage,totalPage);
    }
}
- (void)ShowCommentView:(UIButton *)sender{
    _bottomView.showContent.hidden = !_bottomView.showContent.hidden;
    _bottomView.commentNum.hidden = !_bottomView.commentNum.hidden;
    if (self.mScrollView.contentOffset.x<SCREEN_WIDTH*totalPage) {
        [self.mScrollView setContentOffset:CGPointMake(totalPage*SCREEN_WIDTH, self.mScrollView.contentOffset.y) animated:NO];
       // [self.naviController setNaviBarTitle:@"热门评论"];
    }else if(self.mScrollView.contentOffset.x==SCREEN_WIDTH*totalPage){
        [self.mScrollView setContentOffset:CGPointMake(0, self.mScrollView.contentOffset.y) animated:NO];
        self.mPage = 0;
        [self ChangeText];
        // [self.naviController setNaviBarTitle:@"资讯新闻"];
    }
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView !=self.mScrollView){
        UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:500];
        return imageView;
    }
    return nil;
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)showUserNewsView:(NSString *)usid
{
    if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            NSLog(@"成功");
            
        }andFaile:^{
            NSLog(@"失败");
        }];
    }else{
        //登录
        // TJTieBaContentModel *mod = (TJTieBaContentModel *)model;
        NSString *idstr=[NSString stringWithFormat:@"ID#%@",UserManager.userInfor.userId ];
        [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
        [[CDChatManager manager] openWithClientId:idstr  callback:^(BOOL succeeded, NSError *error) {
            [AlertHelper hideAllHUDsForView:self.view];
            if (succeeded) {
                TJUserNewsViewController *user=[[TJUserNewsViewController alloc]init];
                user.uid=usid;
                [self.naviController pushViewController:user animated:YES];
            }
            else
            {
                [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
                
            }
            
        }];
        
    }
    
    
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
