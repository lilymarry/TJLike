//
//  TJMineViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/29.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJMineViewController.h"
#import "MineCateButton.h"
#import "MainInformationViewController.h"
#import "MainSettingViewController.h"
#import "TJMineFeedbackView.h"
#import "TJUserAuthorManager.h"
#import "UIImageView+WebCache.h"
#import "MainSetViewController.h"
#import "MyCollectViewController.h"
#import "TJFoundSeachViewController.h"
#import "MyTieZiViewController.h"
#import "MyKjViewController.h"
#import "MyFeedBackViewController.h"
#import "MyNewsViewController.h"
#import "ChatListViewController.h"
#import "AlertHelper.h"
#import "MyFLViewController.h"
@interface TJMineViewController ()
{
   // UIImageView *topBack;
    UIImageView *headIcon;
    UILabel *nameLabel;
    UILabel *signLabel;
    UIButton *outBtn;
}
@end

@implementation TJMineViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (UIButton *)GetRightBtn{
    //news_top_4_
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    rightBtn.backgroundColor = [UIColor clearColor];
    UIImageView *imag=[[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 30, 30)];
    imag.image=[UIImage imageNamed:@"信息提示.png"] ;
    [rightBtn addSubview:imag];
    // [rightBtn setImage:[UIImage imageNamed:@"信息提示.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(RightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return rightBtn;
}
- (void)RightBtnClick{
    if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            NSLog(@"成功");
            [self InitUserData];
        }andFaile:^{
            NSLog(@"失败");
        }];
    }else{
       [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
        NSString *idstr=[NSString stringWithFormat:@"ID#%@",UserManager.userInfor.userId ];
        [[CDChatManager manager]openWithClientId:idstr  callback:^(BOOL succeeded, NSError *error) {
            [AlertHelper hideAllHUDsForView:self.view];

            if (succeeded) {
                UIStoryboard *s = [UIStoryboard storyboardWithName:@"Chart" bundle:[NSBundle mainBundle]];
                UINavigationController *my = [s instantiateViewControllerWithIdentifier:@"ChatList"];
                
                my.hidesBottomBarWhenPushed = YES;
                [self presentViewController:my animated:YES completion:nil];
            }
            else
            {
              [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
            
            }
            
            
        }];
        
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"我"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarRightBtn:[self GetRightBtn]];
    [self InitUserData];

}
- (void)InitUserData{
  //  NSLog(@"UserManager.userInfor.nickName---->%@",UserManager.userInfor.nickName);
   // [outBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    
    NSString *strImageUrl = nil;
    if (UserManager.userInfor.icon.length>0) {
         strImageUrl = UserManager.userInfor.icon;
    }
    else
    {
        strImageUrl = UserManager.userInfor.weiboicon;
    }
//    if ([NSData dataWithContentsOfURL:[NSURL URLWithString:UserManager.userInfor.icon]]) {
//        strImageUrl = UserManager.userInfor.icon;
//    }
//    else{
//        strImageUrl = UserManager.userInfor.weiboicon;
//    }
    
    [headIcon sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"news_list_default"]];
    if (UserManager.userInfor.nickName.length==0) {
        nameLabel.text = @"未设置";
    }
    else
    {
        nameLabel.text = UserManager.userInfor.nickName;
        
    }

   // signLabel.text = UserManager.userInfor.signature;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // self.view.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    
//    topBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 180)];
//    topBack.image = [UIImage imageNamed:@"splash_bg"];
//    [self.view addSubview:topBack];
    
    UIScrollView * mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
   // mScrollView.backgroundColor = [UIColor yellowColor];
    mScrollView.bounces=NO;
    [self.view addSubview:mScrollView];
    mScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+40);
    
    
    
    headIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 70, 70)];
    headIcon.layer.masksToBounds = YES;
    headIcon.layer.cornerRadius = 72.5*0.5;
    [mScrollView  addSubview:headIcon];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(94, 20+30, SCREEN_WIDTH-120, 19)];
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = UIColorFromRGB(0x2a2a2a);
    [mScrollView  addSubview:nameLabel];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 20, SCREEN_WIDTH, 80);
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn addTarget:self action:@selector(gotoSetView:) forControlEvents:UIControlEventTouchUpInside];
    [mScrollView  addSubview:rightBtn];

    UIImageView * topBack = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 50, 10, 20)];
    topBack.image = [UIImage imageNamed:@"return.png"];
    [mScrollView addSubview:topBack];
    
    UIView *mView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headIcon.frame)+20, SCREEN_WIDTH, 1)];
    mView.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    [mScrollView  addSubview:mView];
    

    NSArray *tittle=[NSArray arrayWithObjects:@"我的福利",@"我的活动",@"违章查询",nil];
    NSArray *imaArr=[NSArray arrayWithObjects:@"fuli.png",@"hongdong.png",@"weizhang.png",nil];
    
  
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = CGRectMake(i*SCREEN_WIDTH/3, CGRectGetMaxY(headIcon.frame)+30, SCREEN_WIDTH/3, 90);
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [mScrollView addSubview:btn];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*SCREEN_WIDTH/3, CGRectGetMaxY(headIcon.frame)+30, 1,90)];
        lab.backgroundColor =  [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
        [mScrollView addSubview:lab];
        
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 43, 43)];
        image.image = [UIImage imageNamed:imaArr[i]];
        image.center = CGPointMake(SCREEN_WIDTH/6, 30);
        [btn addSubview:image];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH/3, 20)];
        label.text = tittle[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColorFromRGB(0x333333);
        [btn addSubview:label];
        
     

        
    }
    UIView *mView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 220, SCREEN_WIDTH, 10)];
    mView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [mScrollView  addSubview:mView1];
    
    UIView *viewA1  = [self setupTableViewCellSubView:CGRectMake(0, CGRectGetMaxY(mView1.frame)+5, SCREEN_WIDTH, 44) andTitle:@"我的帖子" ima:@"tiezi.png"  WithbutTag:2000];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = viewA1.bounds;
    btn.tag = 2000;
    [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [viewA1 addSubview:btn];
    [mScrollView addSubview:viewA1];
    
    UIView *mView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewA1.frame)+5, SCREEN_WIDTH, 10)];
    mView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [mScrollView  addSubview:mView2];
    
    UIView *viewA2  = [self setupTableViewCellSubView:CGRectMake(0, CGRectGetMaxY(mView2.frame)+5, SCREEN_WIDTH, 44) andTitle:@"我的卡券" ima:@"kaquan.png" WithbutTag:2001 ];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.backgroundColor = [UIColor clearColor];
    btn2.frame = viewA2.bounds;
    btn2.tag = 2001;
    [btn2 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [viewA2 addSubview:btn2];
    [mScrollView addSubview:viewA2];
    
    
    UIView *mView3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewA2.frame)+5, SCREEN_WIDTH, 10)];
    mView3.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [mScrollView  addSubview:mView3];
    
    UIView *viewA3  = [self setupTableViewCellSubView:CGRectMake(0, CGRectGetMaxY(mView3.frame)+5, SCREEN_WIDTH, 44) andTitle:@"用户反馈" ima:@"fankui.png" WithbutTag:2002 ];
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.backgroundColor = [UIColor clearColor];
    btn3.frame = viewA3.bounds;
    btn3.tag = 2002;
    [btn3 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [viewA3 addSubview:btn3];
    [mScrollView addSubview:viewA3];
    
    UIView *mView4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewA3.frame)+5, SCREEN_WIDTH, 10)];
    mView4.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [mScrollView  addSubview:mView4];
    
    UIView *viewA4  = [self setupTableViewCellSubView:CGRectMake(0, CGRectGetMaxY(mView4.frame)+5, SCREEN_WIDTH, 44) andTitle:@"设置" ima:@"set.png" WithbutTag:2003 ];
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.backgroundColor = [UIColor clearColor];
    btn4.frame = viewA4.bounds;
    btn4.tag = 2003;
    [btn4 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [viewA4 addSubview:btn4];
    [mScrollView addSubview:viewA4];
    
    UIView *mView5 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewA4.frame)+5, SCREEN_WIDTH, 10)];
    mView5.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [mScrollView  addSubview:mView5];


}

 - (UIView *)setupTableViewCellSubView:(CGRect)frame andTitle:(NSString *)title ima:(NSString *)ima WithbutTag:(int)butTag
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView * topBack = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 25, 25)];
    topBack.image = [UIImage imageNamed:ima];
    [view addSubview:topBack];

    
    UILabel *label = [[UILabel alloc] init];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setText:title];
    [label  setFont:[UIFont systemFontOfSize:16]];
    [label setTextColor:[UIColor blackColor]];
    CGSize size =  [UIUtil textToSize:title fontSize:16];
    [label setFrame:CGRectMake(50, 0, size.width, frame.size.height)];
    [view addSubview:label];
    
    
    UIImageView * topBack1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 10, 10, 20)];
    topBack1.image = [UIImage imageNamed:@"return.png"];
    [view addSubview:topBack1];
    
    
    
    view.frame =frame;
    
    return view;
    
}

- (void)UserLogin{
    NSLog(@"----");
    if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            NSLog(@"成功");
            [self
             InitUserData];
        }andFaile:^{
            NSLog(@"失败");
        }];
    }else{
        [UserManager quitUserSuccess:^{
            headIcon.image = nil;
            nameLabel.text = @"";
            signLabel.text = @"";
            [outBtn setTitle:@"登录" forState:UIControlStateNormal];
        }];
    }
}
- (void)BtnClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
            [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
                NSLog(@"成功");
                [self InitUserData];
            }andFaile:^{
                NSLog(@"失败");
            }];
        }else{
            
           // MyFLViewController*my=[[MyFLViewController alloc]init];

           MyCollectViewController *my=[[MyCollectViewController alloc]init];
            my.state=fuli_KEY;
            my.hidesBottomBarWhenPushed = YES;
            [self.naviController pushViewController:my animated:YES];
        }

      }
    else if (sender.tag==1001)
    {
        if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
            [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
                NSLog(@"成功");
                [self InitUserData];
            }andFaile:^{
                NSLog(@"失败");
            }];
        }else{
            MyCollectViewController *my=[[MyCollectViewController alloc]init];
            my.state=huoDong_KEY;
            my.hidesBottomBarWhenPushed = YES;
            [self.naviController pushViewController:my animated:YES];
        }

    
    }
    else
    {
        TJFoundSeachViewController *ctrl = [[TJFoundSeachViewController alloc]init];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.naviController pushViewController:ctrl animated:YES];

    
    
    }
}

-(void)gotoSetView:(id)sender
{
    if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            NSLog(@"成功");
            [self InitUserData];
        }andFaile:^{
            NSLog(@"失败");
        }];
    }else{
        
        MainInformationViewController *ctrl = [[MainInformationViewController alloc]init];
        __weak __typeof(self)weakSelf = self;
        ctrl.hidesBottomBarWhenPushed = YES;
        ctrl.mBlock = ^{
            [weakSelf InitUserData];
        };
        [self.naviController pushViewController:ctrl animated:YES];
    }
    
    
}

- (void)selectBtn:(UIButton *)sender
{
   if (sender.tag == 2000) {
       if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
           [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
               NSLog(@"成功");
               [self InitUserData];
           }andFaile:^{
               NSLog(@"失败");
           }];
       }else{
           MyTieZiViewController *my=[[MyTieZiViewController alloc]init];
           my.whoStr=UserManager.userInfor.userId;
           my.hidesBottomBarWhenPushed = YES;
           [self.naviController pushViewController:my animated:YES];
           
       }

   }
    else if (sender.tag == 2001)
    {
    
        if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
            [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
                NSLog(@"成功");
                [self InitUserData];
            }andFaile:^{
                NSLog(@"失败");
            }];
        }else{
            MyKjViewController *my=[[MyKjViewController alloc]init];
            // my.state=fuli_KEY;
            my.hidesBottomBarWhenPushed = YES;
            [self.naviController pushViewController:my animated:YES];
            
        }

    
    }
    else if (sender.tag == 2002)
    {
        if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
            [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
                NSLog(@"成功");
                [self InitUserData];
            }andFaile:^{
                NSLog(@"失败");
            }];
        }else{
  
            MyFeedBackViewController *back=[[MyFeedBackViewController alloc]init];
            back.hidesBottomBarWhenPushed=YES;
            [self.naviController pushViewController:back animated:YES];
        }

    
    }

    else
    {
        UIStoryboard *s = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        MainSetViewController *ctrl = [s instantiateViewControllerWithIdentifier:@"MainSet"];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.naviController pushViewController:ctrl animated:YES];

    
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
