//
//  AddverViewController.m
//  TJLike
//
//  Created by imac-1 on 2016/12/5.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "AddverViewController.h"
#import "CommentBottom.h"
#import "CommentListView.h"
#import "SendCommentView.h"
#import "NewsRelationNewsList.h"
#import "NewsRelationListView.h"
//#import "NewsRelationDetailViewController.h"
#import "ShareSDK.h"
#import "TJNewsYuanWenViewController.h"
#import "AutoAlertView.h"
#import "TJUserNewsViewController.h"
#import "AlertHelper.h"
#import <CDChatManager.h>
@interface AddverViewController ()<UIWebViewDelegate,UIScrollViewDelegate,CommentListDelegate>
{
    UIWebView *mWebView;
    NSMutableArray *relationArray;
    float webHeight;
    NSString *urlString;
    UILabel *mTilteLabel;
    UILabel *mDesLabel;
    NSDictionary *dataDict;
    int commentNum;
}
@property (nonatomic, strong)UIScrollView *mScrollView;

@property (nonatomic, strong)CommentListView *commentListView;

@property (nonatomic, assign)int mPage;

@property (nonatomic, strong)CommentBottom *bottomView;

@end

@implementation AddverViewController


- (UIButton *)GetRightBtn{
    //news_top_4_
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setImage:[UIImage imageNamed:@"gengduo.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(RightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return rightBtn;
}
- (UIButton *)GetLeftBtn{
    //news_top_4_
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setImage:[UIImage imageNamed:Navi_LeftBut_Back_Image] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return rightBtn;
}
- (void)leftBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)RightBtnClick{
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    //构造分享内容
    id<ISSCAttachment>image;
    if (self.sharePicUrl.length != 0) {
        image = [ShareSDK imageWithUrl:self.sharePicUrl];
    }
    NSString *title = [self.mlbTitle stringByAppendingString:urlString];
    id<ISSContent> publishContent = [ShareSDK content:title
                                       defaultContent:self.mlbTitle
                                                image:image
                                                title:self.mlbTitle
                                                  url:urlString
                                          description:@"奏耐天津"
                                            mediaType:SSPublishContentMediaTypeNews];
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
                                    NSLog(@"--%@",[error errorDescription]);
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    [AutoAlertView ShowMessage:@"分享失败"];
                                }
                            }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"资讯中心"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarLeftBtn:[self GetLeftBtn]];
    [self.naviController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.naviController setNaviBarRightBtn:[self GetRightBtn]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self.naviController setNaviBarTitle:@"资讯新闻"];
    //    [self.naviController setNavigationBarHidden:NO];
    //    [self.naviController setNaviBarDefaultLeftBut_Back];
    dataDict = [NSDictionary dictionary];
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    self.mScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.mScrollView.showsHorizontalScrollIndicator = NO;
    self.mScrollView.delegate = self;
    self.mScrollView.pagingEnabled = YES;
    self.mScrollView.bounces = NO;
    self.mScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
    self.mScrollView.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    [self.view addSubview:self.mScrollView];
    
    mWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-108)];
    mWebView.scalesPageToFit =NO;
    mWebView.delegate =self;
    mWebView.scrollView.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    mWebView.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    mWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.mScrollView addSubview:mWebView];
    
    
    mWebView.scrollView.contentInset = UIEdgeInsetsMake(70, 0, 0, 0);
    [mWebView.scrollView setContentOffset:CGPointMake(0, -70)];
    
    //title
    
    mTilteLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, -70, SCREEN_WIDTH-40, 40)];
    mTilteLabel.textColor = [UIColor blackColor];
    mTilteLabel.font = [UIFont systemFontOfSize:20];
    mTilteLabel.backgroundColor = [UIColor clearColor];
    [mWebView.scrollView addSubview:mTilteLabel];
    
    mDesLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, -30, SCREEN_WIDTH-40, 30)];
    mDesLabel.textColor = [UIColor lightGrayColor];
    mDesLabel.font = [UIFont systemFontOfSize:12];
    mDesLabel.backgroundColor = [UIColor clearColor];
    [mWebView.scrollView addSubview:mDesLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:220/250.f green:220/250.f blue:220/250.f alpha:1];
    
    [mWebView.scrollView addSubview:lineView];
    [self requestRegionsInfo];
    
    _commentListView = [[CommentListView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-108) WithNid:self.nid];
    _commentListView.mlTitle = self.mlbTitle;
    _commentListView.delegate=self;
    [_mScrollView addSubview:_commentListView];
    
    _bottomView = [[CommentBottom alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    //  _bottomView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    _bottomView.backgroundColor = [UIColor colorWithRed:220/250.f green:220/250.f blue:220/250.f alpha:1];
    _bottomView.mDelegate = self;
    _bottomView.onGoComment = @selector(ShowCommentView:);
    _bottomView.OnSendClick = @selector(SendCommentClick);
    [self.view addSubview:_bottomView];
    
    _commentListView.commentBottomView = _bottomView;
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
    SendCommentView *commentView = [[SendCommentView alloc] initWithFrame:window.bounds];
    commentView.nid = self.nid;
    commentView.mBlock = ^{
        [_commentListView GetData];
        commentNum ++;
        mDesLabel.text = [NSString stringWithFormat:@"%@ %@ %d评论",dataDict[@"source"],dataDict[@"pubtime"],commentNum];
    };
    [window addSubview:commentView];
}


- (void)requestRelationNews {
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/RelationNews"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.nid forKey:@"nid"];
   [HttpClient request:dict URL:urlStr success:^(NSDictionary *info) {
        relationArray = [[NSMutableArray alloc]initWithCapacity:10];
        NSLog(@"相关新闻----%@",info);
        NSArray *arr=info[@"data"];
        for (int i = 0; i<arr.count; i++) {
            NSDictionary *dict = info[@"data"][i];
            NewsRelationNewsList *info = [NewsRelationNewsList CreateWithDict:dict];
            [relationArray addObject:info];
        }
        
        [self AddRelationNews];
        
   } fail:^{
       [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
   }];
}
- (void)AddRelationNews{
    //TLog(@"---------->%f",webHeight);
    // TLog(@"---------->%f",mWebView.scrollView .contentSize.height);
    webHeight = mWebView.scrollView.contentSize.height;
    //mWebView.scrollView.frame = CGRectMake(0, 100, mWebView.scrollView.frame.size.width, mWebView.scrollView.frame.size.height);
    mWebView.scrollView .contentSize = CGSizeMake(0, webHeight+relationArray.count*60+150);
    //分享朋友圈
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(SCREEN_WIDTH/2-90, webHeight-10,180, 50);
    //[bt setTitle:@"分享到朋友圈" forState:UIControlStateNormal];
    bt .backgroundColor=[UIColor clearColor];
    bt.layer.borderWidth =1;
    bt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bt.layer.cornerRadius = 20;
    bt.layer.masksToBounds = YES;
    [bt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(simplyShare) forControlEvents:UIControlEventTouchUpInside];
    [mWebView.scrollView addSubview:bt];
    
    UIImageView *mImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 8, 34, 34)];
    mImageView1.image = [UIImage imageNamed:@"pengyouquan.png"];
    [bt addSubview:mImageView1];
    
    UILabel *mLabe = [[UILabel alloc]initWithFrame:CGRectMake(57, 2, 100, 50)];
    mLabe.backgroundColor = [UIColor clearColor];
    mLabe.text = @"分享到朋友圈";
    mLabe.font = [UIFont systemFontOfSize:15];
    mLabe.textColor = [UIColor colorWithRed:81.f/255.f green:81.f/255.f blue:83.f/255.f alpha:1];
    [bt addSubview:mLabe];
    
    
    //阅读原文
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(18, webHeight+20+40, 80, 30);
    
    [btn setTitle:@"查看原文" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:17];
    [btn setTitleColor:[UIColor colorWithRed:211.0/255.0 green:62/255.0 blue:62/255.0 alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(ReadTheOriginal) forControlEvents:UIControlEventTouchUpInside];
    [mWebView.scrollView addSubview:btn];
    
    
    
    
    
    //相关
    UIImageView *mImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, webHeight+50+40, SCREEN_WIDTH, 34)];
    mImageView.backgroundColor = [UIColor colorWithRed:227.f/255.f green:227.f/255.f blue:227.f/255.f alpha:1];
    [mWebView.scrollView addSubview:mImageView];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 8, 18, 18)];
    icon.image = [UIImage imageNamed:@"news_bottom_17_@2x.png"];
    [mImageView addSubview:icon];
    
    UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH-20, 34)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.text = @"相关新闻";
    mLabel.font = [UIFont systemFontOfSize:17];
    mLabel.textColor = [UIColor colorWithRed:81.f/255.f green:81.f/255.f blue:83.f/255.f alpha:1];
    [mImageView addSubview:mLabel];
    
    for (int i = 0; i<relationArray.count; i++) {
        NewsRelationListView *view = [[NewsRelationListView alloc]initWithFrame:CGRectMake(20, webHeight+94+i*60+40, SCREEN_WIDTH-40, 60)];
        [view LoadContent:relationArray[i]];
        view.mDelegate = self;
        view.onClick = @selector(RelationNewsClick:);
        [mWebView.scrollView addSubview:view];
    }
}
///**
// *  简单分享
// */
- (void)simplyShare
{
    //1、构造分享内容
    //1.1、要分享的图片（以下分别是网络图片和本地图片的生成方式的示例）
    id<ISSCAttachment>image;
    if (self.sharePicUrl.length != 0) {
        image = [ShareSDK imageWithUrl:self.sharePicUrl];
    }
    NSString *title = [self.mlbTitle stringByAppendingString:urlString];
    id<ISSContent> publishContent = [ShareSDK content:title
                                       defaultContent:self.mlbTitle
                                                image:image
                                                title:self.mlbTitle
                                                  url:urlString
                                          description:@"奏耐天津"
                                            mediaType:SSPublishContentMediaTypeNews];
    //直接分享接口
    [ShareSDK shareContent:publishContent
                      type:ShareTypeWeixiTimeline
               authOptions:nil
              shareOptions:nil
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        NSLog(@"=== response state :%zi ",state);
                        
                        //可以根据回调提示用户。
                        if (state == SSResponseStateSuccess)
                        {
                            [AutoAlertView ShowMessage:@"分享成功"];
                        }
                        else if (state == SSResponseStateFail)
                        {
                            [AutoAlertView ShowMessage:@"分享失败"];
                        }
                    }];
}




- (void)ReadTheOriginal{
    if (urlString.length==0) {
        [AutoAlertView ShowMessage:@"暂无原文链接"];
        return;
    }else{
        TJNewsYuanWenViewController *ctrl = [[TJNewsYuanWenViewController alloc]init];
        ctrl.urlString = urlString;
        [self.naviController pushViewController:ctrl animated:YES];
    }
}
- (void)RelationNewsClick:(NewsRelationNewsList *)info{
    AddverViewController *ctrl = [[AddverViewController alloc]init];
    ctrl.nid =[NSString stringWithFormat:@"%d",info.nid];
    ctrl.mlbTitle = info.title;
    [self.naviController pushViewController:ctrl animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==self.mScrollView) {
    //    NSLog(@"self.mPage---->%d",self.mPage);
        _bottomView.showContent.hidden = self.mPage==0;
        _bottomView.commentNum.hidden = !(self.mPage==0);
        [self.naviController setNaviBarTitle:self.mPage==0?@"资讯中心":@"热门评论"];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.mScrollView){
        self.mPage = (scrollView.contentOffset.x/scrollView.frame.size.width);
    }
}

- (void)ShowCommentView:(UIButton *)sender{
    _bottomView.showContent.hidden = !_bottomView.showContent.hidden;
    _bottomView.commentNum.hidden = !_bottomView.commentNum.hidden;
    if (self.mScrollView.contentOffset.x==0) {
        [self.mScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, self.mScrollView.contentOffset.y) animated:YES];
        [self.naviController setNaviBarTitle:@"热门评论"];
    }else if(self.mScrollView.contentOffset.x>SCREEN_WIDTH*0.7){
        [self.mScrollView setContentOffset:CGPointMake(0, self.mScrollView.contentOffset.y) animated:YES];
        [self.naviController setNaviBarTitle:@"资讯中心"];
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //     NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.offsetHeight"];
    //    webHeight = [currentURL floatValue];
    
    //    [webView stringByEvaluatingJavaScriptFromString:
    //     @"var tagHead =document.documentElement.firstChild;"
    //     "var tagMeta = document.createElement(\"meta\");"
    //     "tagMeta.setAttribute(\"http-equiv\", \"Content-Type\");"
    //     "tagMeta.setAttribute(\"content\", \"text/html; charset=utf-8\");"
    //     "var tagHeadAdd = tagHead.appendChild(tagMeta);"];
    //
    //    [webView stringByEvaluatingJavaScriptFromString:
    //     @"var tagHead =document.documentElement.firstChild;"
    //     "var tagStyle = document.createElement(\"style\");"
    //     "tagStyle.setAttribute(\"type\", \"text/css\");"
    //     "tagStyle.appendChild(document.createTextNode(\"BODY{padding: 20pt 15pt}\"));"
    //     "var tagHeadAdd = tagHead.appendChild(tagStyle);"];
    
    
    [self requestRelationNews];
    
    //拦截网页图片  并修改图片大小
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = 300.0;" // UIWebView中显示的图片宽度
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"
     "document.body.style.backgroundColor = '#f6f6f6';"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    // 一般获取网页高度会在这个方法里获取
    // 但这里获取的高度未必就是web页面的真实高度，因为web中图片未加载完有可能导致web界面不真实，或长或短
    // 你能可能用到下面的js方法去获取，但其实都没用
    /**
     1、document.documentElement.offsetHeight;
     2、document.body.clientHeight;
     3、document.documentElement.scrollHeight
     4、
     CGRect frame = webView.frame;
     CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
     frame.size = fittingSize;
     webView.frame = frame;
     5、getBodyHeight() // 网页用js实现好的方法
     6、CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.clientHeight"] floatValue];
     */
    // 所以必须要找到能完全确定web加载，才能确定web高度
    // 在网上找了个工具 NJKWebViewProgress
    
    
}

/*
 #pragma mark - NJKWebViewProgressDelegate
 }*/
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error---->%@",error);
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    TLog(@"%@",request.URL);
    return YES;
}

- (void)requestRegionsInfo {
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/Aview"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.nid forKey:@"nid"];
   [HttpClient request:dict URL:urlStr success:^(NSDictionary *info) {
      //  NSLog(@"1111info--------%@",info);
        dataDict = info[@"data"];
        _commentListView.dataDict = info[@"data"];
        mTilteLabel.text = dataDict[@"title"];
        self.mlbTitle= mTilteLabel.text;
        mDesLabel.text = [NSString stringWithFormat:@"%@ %@ %@评论",dataDict[@"source"],dataDict[@"pubtime"],dataDict[@"comment"]];
        commentNum = [dataDict[@"comment"] intValue];
        NSString *string = [NSString stringWithFormat:@"%@",info[@"data"][@"show"]];
        urlString = string;
        NSMutableString *str = [NSMutableString stringWithFormat:@"%@",info[@"data"][@"description"]];
        NSString *cutStr = @"alt=";
        //NSString *centerStr = @"<img";
        NSRange  rang = [str rangeOfString:cutStr];
        //NSRange  rangC = [str rangeOfString:centerStr];
        if (rang.location != NSNotFound) {
            int location = rang.location;
            NSString *strFrame = [NSString stringWithFormat:@"width=\"%f\" height=\"%f\" margin=\"%f\" style=\"text-align: center\" ", SCREEN_WIDTH - 20,SCREEN_WIDTH/2,20.0];
            //NSString *strCFrame = [NSString stringWithFormat:@"<p style=\"text-align:center\">"];
            [str insertString:strFrame atIndex:location];
            
            //int locationCenter = rangC.location;
            //[str insertString:strCFrame atIndex:locationCenter];
            
        }
        
       // NSLog(@"AAA____ %@",str );
        
        [mWebView loadHTMLString:str baseURL:nil];
        
   } fail:^{
       [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
   }];
    
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
