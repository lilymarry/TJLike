//
//  HuoDongDetailViewController.m
//  TJLike
//
//  Created by imac-1 on 16/8/31.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "HuoDongDetailViewController.h"
#import "WebApi.h"
#import "COMMON.h"
//#import "FuliTittleViewCell.h"
#import "FuLiContentViewCell.h"
#import "ZhongJiangViewCell.h"
#import "HuFuTittleViewCell.h"

#import "FuLiContentViewCell1.h"
#import "FuLiContentViewCell2.h"
#import "UserHuiFuViewCell.h"
#import "UserModel.h"
#import "CommonUserView.h"
#import "HuFuTittleViewCell.h"
#import "UserPrizeViewController.h"
#import "SeeMoreViewController.h"
#import "UIImageView+WebCache.h"
#import "AddFLViewController.h"
#import "AlertHelper.h"
#import "HuoDongTittleViewCell.h"
#import "ShareSDK.h"
@interface HuoDongDetailViewController ()<UITableViewDataSource,UITableViewDelegate,CommonDelegate>
{
    UITableView *_tableView ;
    NSDictionary *infoDic;
    NSMutableArray *huifuArr;
    NSMutableArray *canyuArr;
    
    NSArray *tittleArr;
    
    UIView *bgView ; //遮罩层
    //  MyCanYuView *  Mview ;
    int selectInt;
    int canyupageint;
    int commpageint;
    
}


@end

@implementation HuoDongDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     [self setUI];
    huifuArr=[NSMutableArray array];
    
    canyuArr=[NSMutableArray array];
    tittleArr=[NSArray arrayWithObjects:@"活动时间",@"福利详情",@"领取方式",@"活动规则", nil];
    selectInt=0;
    canyupageint=0;
    commpageint=0;
    [self getFULiCanYUData];
    [self getFULiCommetData];
    
     [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
    [[WebApi sharedRequest ]GetFuliDetailWithId:_fuliId URLStr:_urlStr
                                            Success:^(NSDictionary *dic){
                                                 [AlertHelper hideAllHUDsForView:self.view];
                                                  if ([[dic objectForKey:@"code"] integerValue] == 200) {
                                                      @try {
                                                          NSArray *arr=dic[@"data"];
                                                          if ([arr count]==0) {
                                                              [AlertHelper singleMBHUDShow:@"无数据"ForView:self.view AndDelayHid:1];
                                                          }
                                                          else
                                                          {
                                                              infoDic=dic[@"data"];
                                                          }
                                                          
                                                      } @catch (NSException *exception) {
                                                          // [AlertHelper singleMBHUDShow:@"无数据" ForView:self.view AndDelayHid:1];
                                                      } @finally {
                                                          [_tableView reloadData];
                                                      }
                                                  }
                                                
                                                  else if ([[dic objectForKey:@"code"] integerValue] == 500){
                                                      [AlertHelper singleMBHUDShow:[dic objectForKey:@"msg"] ForView:self.view AndDelayHid:1];
                                                      
                                                  }
                                                  else
                                                      
                                                  {
                                                      
                                                      [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
                                                      
                                                      
                                                      
                                                  }
                                                
                                                
                                                
                                                
                                            } fail:^(){
                                                
                                                [AlertHelper hideAllHUDsForView:self.view];
                                                
                                                [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
                                                
                                            }];
    

    
    
}
-(void)getFULiCommetData
{
    //评论
    NSString *pageStr=[NSString stringWithFormat:@"%d",commpageint];
    [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
    [[WebApi sharedRequest]GetHdCommetListWithId:_fuliId status:@"0"   page:pageStr Success:^(NSDictionary *dic){
      //  NSLog(@"AAAAAA %@",dic);
        [AlertHelper hideAllHUDsForView:self.view];
        if ([[dic objectForKey:@"code"] integerValue] == 200) {
            NSArray *arr=dic[@"data"];
            if ([arr count]==0) {
                  [AlertHelper singleMBHUDShow:@"无数据"ForView:self.view AndDelayHid:1];
            }
            else
            {
                if ([pageStr isEqualToString:@"0"]) {
                    [huifuArr removeAllObjects];
                }

            for (NSDictionary *dicc in dic[@"data"] ) {
                UserModel *model=[[UserModel alloc]initWithDic:dicc];
                [huifuArr addObject:model];
            }
            }
         
            [_tableView reloadData];
        }
        
        
        else if ([[dic objectForKey:@"code"] integerValue] == 500){
            [AlertHelper singleMBHUDShow:[dic objectForKey:@"msg"] ForView:self.view AndDelayHid:1];
            
        }
        
        else
            
        {
            
            [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
            
            
            
        }
        
        
        
        
    } fail:^(){
        
        [AlertHelper hideAllHUDsForView:self.view];
        
        [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
        
    }];
    
}
-(void)getFULiCanYUData
{
    NSString *pageStr=[NSString stringWithFormat:@"%d",canyupageint];
    //参与
    [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
    [[WebApi sharedRequest]GetHdCommetListWithId:_fuliId status:@"1"   page:pageStr Success:^(NSDictionary *dic){
        //  NSLog(@"AAAAAA %@",dic);
        [AlertHelper hideAllHUDsForView:self.view];
        if ([[dic objectForKey:@"code"] integerValue] == 200) {
            NSArray *arr=dic[@"data"];
            if ([arr count]==0) {
                [AlertHelper singleMBHUDShow:@"无数据"ForView:self.view AndDelayHid:1];
            }
            else
            {
                if ([pageStr isEqualToString:@"0"]) {
                    [canyuArr removeAllObjects];
                }

            for (NSDictionary *dicc in dic[@"data"] ) {
                UserModel *model=[[UserModel alloc]initWithDic:dicc];
                [canyuArr addObject:model];
                }
             [_tableView reloadData];
            }
        }
        
        
        else if ([[dic objectForKey:@"code"] integerValue] == 500){
            [AlertHelper singleMBHUDShow:[dic objectForKey:@"msg"] ForView:self.view AndDelayHid:1];
            
        }
        
        else
        {
            [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
        }

    } fail:^(){
        
        [AlertHelper hideAllHUDsForView:self.view];
        
        [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
        
    }];
    
    
    
}
-(void)setUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.separatorStyle=UITableViewCellAccessoryNone;
    //   NSLog(@"%@",NSStringFromCGRect(_tableView.frame));
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor=UIColorFromRGB(0xe5e5e5);
    [self.view addSubview:_tableView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"活动详情"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
    [self.naviController setNaviBarRightBtn:[self GetRightBtn]];
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
    
    id<ISSCAttachment>image;
    if (infoDic[@"focus"]) {
        image = [ShareSDK imageWithUrl:infoDic[@"hd"]];
    }
    NSString *title = [NSString stringWithFormat:@"%@",infoDic[@"title"]];
    NSString *mlbTitle = [NSString stringWithFormat:@"%@",infoDic[@"category"]];
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:title
                                                image:image
                                                title:title
                                                  url:@"http://www.mob.com"
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
                                    [AlertHelper singleMBHUDShow:@"分享成功" ForView:self.view AndDelayHid:1];
                                    
                                    
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    // NSLog(@"--%@",[error errorDescription]);
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    [AlertHelper singleMBHUDShow:@"分享失败" ForView:self.view AndDelayHid:1];
                                }
                            }];
}
//撤销背景蒙板
-(void)morePress:(id)sender
{
    UIButton *but =(UIButton *)sender;
    NSString *str=nil;
    if (but.tag==1002) {
        str =  infoDic[@"content"];
    }
    else
    {
        str= infoDic[@"actrules"];
        
    }
    SeeMoreViewController *more=[[SeeMoreViewController alloc]init];
    more.moreStr=str;
    [self.naviController pushViewController:more animated:YES];
    
    
}
- (void)SendCommentClick{
    
    if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            NSLog(@"成功");
        }andFaile:^{
            NSLog(@"失败");
        }];
    }else{
        
        AddFLViewController *sendVC = [[AddFLViewController alloc] init];
        sendVC.hidesBottomBarWhenPushed=YES;
        sendVC.fuId=_fuliId;
        sendVC.status=huoDong_KEY;
         sendVC.refreshDelegate=self;
        [self.naviController pushViewController:sendVC animated:YES];

    }

    
}
- (void)ShowCommentView:(UIButton *)sender{
    if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            NSLog(@"成功");
                 }andFaile:^{
            NSLog(@"失败");
        }];
    }else{
        
      
    [AlertHelper MBHUDShow:@"提交中..." ForView:self.view AndDelayHid:30];

    [[WebApi  sharedRequest]AddUserCollectionWithUserId:UserManager.userInfor.userId  aid:_fuliId type:huoDong_KEY Success:^(NSDictionary *dic){
        [AlertHelper hideAllHUDsForView:self.view];
        
        if ([[dic objectForKey:@"code"] integerValue] == 200) {
            [AlertHelper singleMBHUDShow:@"收藏成功" ForView:self.view AndDelayHid:1];
        }
        else if ([[dic objectForKey:@"code"] integerValue] == 502){
            [AlertHelper singleMBHUDShow:@"已存在" ForView:self.view AndDelayHid:1];
            
        }
        else
        {
            [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
            
        }
        
    } fail:^(){
        [AlertHelper hideAllHUDsForView:self.view];
        
        [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
        
    }];
    }
    
}
-(void)sendZan
{
    
    if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            NSLog(@"成功");
                 }andFaile:^{
            NSLog(@"失败");
        }];
    }else{
        
        
    
    NSLog(@"3");
     [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
    [[WebApi  sharedRequest] AddHFCommentWithId:UserManager.userInfor.userId type:@"0" status:@"1" aid:_fuliId reply:@"0" font:@"我要参与" imgs:nil Success:^(NSDictionary *dic){
        [AlertHelper hideAllHUDsForView:self.view];
        
        if ([[dic objectForKey:@"code"] integerValue] == 200) {
            [AlertHelper singleMBHUDShow:@"参与成功" ForView:self.view AndDelayHid:1];
            canyupageint=0;
            selectInt=1;
            [self getFULiCanYUData];
        }
        else if ([[dic objectForKey:@"code"] integerValue] == 502){
            [AlertHelper singleMBHUDShow:@"已存在" ForView:self.view AndDelayHid:1];
            
        }
        else
        {
            [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
            
        }
        
    } fail:^(){
        [AlertHelper hideAllHUDsForView:self.view];
        
        [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
        
    }];
    
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDisk];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==7) {
        
        if (selectInt==0) {
            return huifuArr.count;
        }
        else
        {
            return canyuArr.count;
        }
        
    }
    
    else
    {
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // return 250;
    switch (indexPath.section) {
        case 0:
            return 237;
            break;
      
        case 2:
            return 143;
            break;
        case 3:
            return 89;
            break;
    
        case 7:
        {
            
            UserHuiFuViewCell *cell = (UserHuiFuViewCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.cellHeight+1;
            
        }
            
            break;
            
        default:
            return 44;
            break;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            
            return 0;
            break;
        case 1:
        case 2:
        case 3:
        case 4:
            return 56;
            break;
        case 5:
            //  case 6:
            return 12;
            
            break;
            
        default:
            return 0;
            break;
    }
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return nil;
            break;
        case 1:
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)];
            view.backgroundColor = UIColorFromRGB(0xf0f0f0);
            
            UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 11, SCREEN_WIDTH, 44)];
            view1.backgroundColor = [UIColor whiteColor];
            [view addSubview:view1];
            
            UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,8, SCREEN_WIDTH -10, 28)];
            [lblTitle setTextAlignment:NSTextAlignmentLeft];
            [lblTitle setTextColor:UIColorFromRGB(0x1d1c1c)];
            [lblTitle setFont:[UIFont systemFontOfSize:15.0f]];
            lblTitle.backgroundColor=[UIColor clearColor];
            [lblTitle setText:[tittleArr objectAtIndex:section-1]];
            [view1 addSubview:lblTitle];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
            lbl.backgroundColor=UIColorFromRGB(0xe5e5e5);
            [view1 addSubview:lbl];
            
            return view;
            
        }
            break;
        case 2:
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)];
            view.backgroundColor = UIColorFromRGB(0xf0f0f0);
            
            UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 11, SCREEN_WIDTH, 44)];
            view1.backgroundColor = [UIColor whiteColor];
            [view addSubview:view1];
            
            UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,8, SCREEN_WIDTH -10, 28)];
            [lblTitle setTextAlignment:NSTextAlignmentLeft];
            [lblTitle setTextColor:UIColorFromRGB(0x1d1c1c)];
            [lblTitle setFont:[UIFont systemFontOfSize:15.0f]];
            lblTitle.backgroundColor=[UIColor clearColor];
            [lblTitle setText:[tittleArr objectAtIndex:section-1]];
            [view1 addSubview:lblTitle];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
            lbl.backgroundColor=UIColorFromRGB(0xe5e5e5);
            [view1 addSubview:lbl];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            // button.backgroundColor=[UIColor redColor];
            button.tag=1000+section;
            [button setFrame:CGRectMake(SCREEN_WIDTH -110, 8,100, 28)];
            [button setTitle:@"查看更多" forState:UIControlStateNormal];
            button.tintColor=UIColorFromRGB(0x9c9c9c);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [ button.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
            
            [button addTarget:self action:@selector(morePress:) forControlEvents:UIControlEventTouchUpInside];
            [view1 addSubview:button];
            
            
            UIImageView *iamg=[[UIImageView alloc ]initWithFrame:CGRectMake(84, 6, 16, 16)];
            iamg.image=[UIImage imageNamed:@"1.png"];
            [button addSubview:iamg];
            
            
            
            return view;
            
        }
            break;
        case 3:
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)];
            view.backgroundColor = UIColorFromRGB(0xf0f0f0);
            
            UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 11, SCREEN_WIDTH, 44)];
            view1.backgroundColor = [UIColor whiteColor];
            [view addSubview:view1];
            
            UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,8, SCREEN_WIDTH -10, 28)];
            [lblTitle setTextAlignment:NSTextAlignmentLeft];
            [lblTitle setTextColor:UIColorFromRGB(0x1d1c1c)];
            [lblTitle setFont:[UIFont systemFontOfSize:15.0f]];
            lblTitle.backgroundColor=[UIColor clearColor];
            [lblTitle setText:[tittleArr objectAtIndex:section-1]];
            [view1 addSubview:lblTitle];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
            lbl.backgroundColor=UIColorFromRGB(0xe5e5e5);
            [view1 addSubview:lbl];
            return view;
            
        }
            break;
        case 4:
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)];
            view.backgroundColor = UIColorFromRGB(0xf0f0f0);
            
            UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 11, SCREEN_WIDTH, 44)];
            view1.backgroundColor = [UIColor whiteColor];
            [view addSubview:view1];
            
            UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,8, SCREEN_WIDTH -10, 28)];
            [lblTitle setTextAlignment:NSTextAlignmentLeft];
            [lblTitle setTextColor:UIColorFromRGB(0x1d1c1c)];
            [lblTitle setFont:[UIFont systemFontOfSize:15.0f]];
            lblTitle.backgroundColor=[UIColor clearColor];
            [lblTitle setText:[tittleArr objectAtIndex:section-1]];
            [view1 addSubview:lblTitle];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
            lbl.backgroundColor=UIColorFromRGB(0xe5e5e5);
            [view1 addSubview:lbl];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            // button.backgroundColor=[UIColor redColor];
            button.tag=1000+section;
            [button setFrame:CGRectMake(SCREEN_WIDTH -110, 8,100, 28)];
            [button setTitle:@"查看更多" forState:UIControlStateNormal];
            button.tintColor=UIColorFromRGB(0x9c9c9c);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [ button.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
            
            [button addTarget:self action:@selector(morePress:) forControlEvents:UIControlEventTouchUpInside];
            [view1 addSubview:button];
            
            
            UIImageView *iamg=[[UIImageView alloc ]initWithFrame:CGRectMake(84, 6, 16, 16)];
            iamg.image=[UIImage imageNamed:@"1.png"];
            [button addSubview:iamg];
            
            
            return view;
            
        }
            break;
            
            
        case 5:
            // case 6:
        {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
            view.backgroundColor = UIColorFromRGB(0xf0f0f0);
            return view;
            
        }
            
            break;
            
        default:
            return nil;
            break;
    }
    
    
    
    
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 8:{
            if ([_state isEqualToString:@"1"]) {
                return 46;
            }
            return 0;
        }
            
            break;
            
        default:
            return 0;
            break;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 8:
        {
            if ([_state isEqualToString:@"1"]) {
                UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46)];
                footerView.backgroundColor = COLOR(246, 246, 246, 1);
                
                
                CommonUserView *bottomView = [[CommonUserView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46)];
                bottomView.backgroundColor = COLOR(219, 219, 219, 1);
                bottomView.mDelegate = self;
                bottomView.onGoComment = @selector(ShowCommentView:);
                bottomView.OnSendClick = @selector(SendCommentClick);
                bottomView.zanClick=@selector(sendZan);
                [bottomView.zanBtn   setTitle:@"报名" forState:UIControlStateNormal];

                [footerView addSubview:bottomView];
                return footerView;
            }
            return nil;
            
        }
            break;
            
        default:
            return nil;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *CustomCellIdentifier = @"Cell1";
        HuoDongTittleViewCell *cell = (HuoDongTittleViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (!cell) {
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HuoDongTittleViewCell" owner:nil options:nil];
            cell= [nibView lastObject];
        }
      
      //  [cell.ima_Focus   sd_setImageWithURL:[NSURL URLWithString:infoDic[@"hb"]] placeholderImage:ImageCache(@"lunbo_default_icon") options:SDWebImageLowPriority | SDWebImageRetryFailed];
        [cell.ima_Focus  sd_setImageWithURL:[NSURL URLWithString:infoDic[@"hb"]]                                placeholderImage:[UIImage imageNamed:@"news_list_default"]
                                    options:0
                                  completed:^(UIImage *image,
                                              NSError *error,
                                              SDImageCacheType cacheType,
                                              NSURL *imageURL){}];
        cell.lab_Title.text=[NSString stringWithFormat:@"%@",infoDic[@"title"]];
        cell.lab_Count.text=[NSString stringWithFormat:@"人数 %@",infoDic[@"nums"]];
        cell.lab_Category.text=[NSString stringWithFormat:@"%@",infoDic[@"category"]];
        cell.lab_Supplier.text=[NSString stringWithFormat:@"%@",infoDic[@"user"]];
        return cell;
    }
    
    else if (indexPath.section == 1)
        
    {
        static NSString *CustomCellIdentifier = @"Cell2";
        FuLiContentViewCell1 *cell = (FuLiContentViewCell1 *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (!cell) {
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FuLiContentViewCell1" owner:nil options:nil];
            cell= [nibView lastObject];
        }
        cell.lab_content.text=[NSString stringWithFormat:@"%@至%@",infoDic[@"startime"],infoDic[@"endtime"]];
        
        return cell;
        
        
        
    }
    
    else if (indexPath.section == 2)
        
    {
        static NSString *CustomCellIdentifier = @"Cell3";
        FuLiContentViewCell *cell = (FuLiContentViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (!cell) {
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FuLiContentViewCell" owner:nil options:nil];
            cell= [nibView lastObject];
        }
        // cell.lab_tittle.text=@"福利详情";
        // cell.lab_content.hidden=YES;
        cell.web_content.scrollView.bounces=NO;
        cell.web_content.scrollView.scrollEnabled=NO;
        [cell.web_content loadHTMLString:infoDic[@"content"] baseURL:nil];
        return cell;
        
        
    }
    
    else if (indexPath.section == 3)
        
    {
        static NSString *CustomCellIdentifier = @"Cell4";
        FuLiContentViewCell2 *cell = (FuLiContentViewCell2 *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (!cell) {
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FuLiContentViewCell2" owner:nil options:nil];
            cell= [nibView lastObject];
        }
        
        cell.lab_tittle.text=[NSString stringWithFormat:@"%@",infoDic[@"address"]];
        cell.lab_subTittle.text=[NSString stringWithFormat:@"联系电话: %@",infoDic[@"telphone"]];
        return cell;
        
        
    }
    else if (indexPath.section == 4)
        
    {
        static NSString *CustomCellIdentifier = @"Cell5";
        FuLiContentViewCell1 *cell = (FuLiContentViewCell1 *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (!cell) {
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FuLiContentViewCell1" owner:nil options:nil];
            cell= [nibView lastObject];
        }
        
        cell.lab_content.text=[NSString stringWithFormat:@"%@",infoDic[@"actrules"]];
        return cell;
        
        
        
    }
    
    else if (indexPath.section == 5)
        
    {
        static NSString *CustomCellIdentifier = @"Cell6";
        ZhongJiangViewCell *cell = (ZhongJiangViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (!cell) {
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ZhongJiangViewCell" owner:nil options:nil];
            cell= [nibView lastObject];
        }
        return cell;
        
        
        
    }
    else if (indexPath.section == 6)
        
    {
        static NSString *CustomCellIdentifier = @"Cell7";
        HuFuTittleViewCell *cell = (HuFuTittleViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (!cell) {
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HuFuTittleViewCell" owner:nil options:nil];
            cell= [nibView lastObject];
        }
        cell.mDelegate=self;
        cell.changState=@selector(changState:);
        if (selectInt==0) {
            cell.segMent.selectedSegmentIndex=0;
            cell.lab_huifu.textColor=[UIColor redColor];
            cell.lab_canyu.textColor=[UIColor lightGrayColor];
        }
        else
        {
            cell.segMent.selectedSegmentIndex=1;
            cell.lab_huifu.textColor=[UIColor lightGrayColor];
            cell.lab_canyu.textColor=[UIColor redColor];
        }

        return cell;
        
        
        
    }
    else if (indexPath.section == 7)
    {
        NSString *CellIdentifier = @"cell8";
        UserHuiFuViewCell *cell = [[UserHuiFuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        // cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (selectInt==0) {
            UserModel *model = (UserModel *)[huifuArr objectAtIndex:indexPath.row];
            [cell bindModel:model];
        }
        else
        {
            UserModel *model = (UserModel *)[canyuArr objectAtIndex:indexPath.row];
            [cell bindModel:model];
        }
        
        
        return cell;
        
    }
    else
        
    {
        static NSString *CustomCellIdentifier = @"Cell9";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (!cell) {
            
            cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CustomCellIdentifier];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [button setFrame:CGRectMake(0, 8,SCREEN_WIDTH, 28)];
            [button setTitle:@"查看更多" forState:UIControlStateNormal];
            button.tintColor=[UIColor lightGrayColor];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
            
            [button addTarget:self action:@selector(reloadMoreData) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            
        }
        
        
        return cell;
        
    }

    return nil;
}
-(void)reloadMoreData
{
    if (selectInt==0) {
        commpageint++;
        [self getFULiCommetData];
    }
    else
    {
        canyupageint++;
        [self getFULiCanYUData];
    }
    
    
    
    
}


-(void)changState:(HuFuTittleViewCell *)cell
{
    if (cell.segMent.selectedSegmentIndex==0) {
        selectInt=0;
        [_tableView reloadData];
    }
    else
    {
        selectInt=1;
        [_tableView reloadData];
        
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5)
        
    {
        
        UserPrizeViewController *user=[[UserPrizeViewController alloc]init];
        if ([infoDic[@"winner"]isEqualToString:@"no"]) {
            user.winnerStr=@"暂无中奖用户";
        }
        else
        {
            user.winnerArr=infoDic[@"winner"];
        }
        [self.naviController pushViewController:user  animated:YES];
        
    }
    
    
    
    
}
-(void)refreshingDataList
{
    commpageint=0;
    [self getFULiCommetData];
    
}

@end
