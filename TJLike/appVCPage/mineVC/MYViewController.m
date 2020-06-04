//
//  MYViewController.m
//  TJLike
//
//  Created by 123 on 16/8/1.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "MYViewController.h"
#import "UIImageView+WebCache.h"
#import "MainInformationViewController.h"
#import "MainSettingViewController.h"
#import "TJMineFeedbackView.h"
#import "TJUserAuthorManager.h"
#import "TJFoundSeachViewController.h"
#import "MainSetViewController.h"
#import "MyCollectViewController.h"
#import "MyTieZiViewController.h"
#import "MyKjViewController.h"
#import "MyNewsViewController.h"
#import "MyFeedBackViewController.h"
@interface MYViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell_fankui;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell_set;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell_kj;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell_tieZi;

@end

@implementation MYViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"我"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarRightBtn:[self GetRightBtn]];
    [self InitUserData];


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
        MyNewsViewController *my=[[MyNewsViewController alloc]init];
  
        my.hidesBottomBarWhenPushed = YES;
        [self.naviController pushViewController:my animated:YES];
        
    }
}

- (void)InitUserData{
    NSLog(@"UserManager.userInfor.nickName---->%@",UserManager.userInfor.nickName);
    NSString *strImageUrl = nil;
    if ([NSData dataWithContentsOfURL:[NSURL URLWithString:UserManager.userInfor.icon]]) {
        strImageUrl = UserManager.userInfor.icon;
    }
    else{
        strImageUrl = UserManager.userInfor.weiboicon;
    }
    
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"news_list_default"]];
    if (UserManager.userInfor.nickName.length==0) {
          _nameLabel.text = @"未设置";
    }
     else
     {
         _nameLabel.text = UserManager.userInfor.nickName;

     }
 // signLabel.text = UserManager.userInfor.signature;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _headIcon.layer.masksToBounds = YES;
    _headIcon.layer.cornerRadius = 72.5*0.5;
    
    UITapGestureRecognizer *tapName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setUserFanKui:)];
    tapName.numberOfTapsRequired=1;
    [_cell_fankui addGestureRecognizer:tapName];
    
    UITapGestureRecognizer *tapset = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSetView:)];
    tapset.numberOfTapsRequired=1;
    [_cell_set addGestureRecognizer:tapset];
 
    
    UITapGestureRecognizer *tapteizi = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoTieZiView:)];
    tapteizi.numberOfTapsRequired=1;
    [_cell_tieZi addGestureRecognizer:tapteizi];
    
    UITapGestureRecognizer *tapKj = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotokjView:)];
    tapKj.numberOfTapsRequired=1;
    [_cell_kj addGestureRecognizer:tapKj];
    
    
}
//- (IBAction)UserLogin:(id)sender{
//    NSLog(@"----");
//    if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
//        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
//            NSLog(@"成功");
//            [self
//             InitUserData];
//        }andFaile:^{
//            NSLog(@"失败");
//        }];
//    }else{
//        [UserManager quitUserSuccess:^{
//            _headIcon.image = nil;
//            _nameLabel.text = @"";
//            //signLabel.text = @"";
//         //   [_outBtn setTitle:@"登录" forState:UIControlStateNormal];
//        }];
//    }
//}
-(void)gotoTieZiView:(id)sender
{
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
-(void)gotokjView:(id)sender
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
-(void)setUserFanKui:(id)sender
{
    if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            NSLog(@"成功");
            [self InitUserData];
        }andFaile:^{
            NSLog(@"失败");
        }];
    }else{
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        TJMineFeedbackView *commentView = [[TJMineFeedbackView alloc] initWithFrame:window.bounds];
//        [window addSubview:commentView];
        MyFeedBackViewController *back=[[MyFeedBackViewController alloc]init];
        back.hidesBottomBarWhenPushed=YES;
        [self.naviController pushViewController:back animated:YES];
    }
    


}
-(void)gotoSetView:(id)sender
{
    UIStoryboard *s = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MainSetViewController *ctrl = [s instantiateViewControllerWithIdentifier:@"MainSet"];
     ctrl.hidesBottomBarWhenPushed = YES;
    [self.naviController pushViewController:ctrl animated:YES];


}
- (IBAction)BtnClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        //用户信息验证
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
    else if (sender.tag==1003)
    {
        TJFoundSeachViewController *ctrl = [[TJFoundSeachViewController alloc]init];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.naviController pushViewController:ctrl animated:YES];
    
    }
//    }else if(sender.tag == 1001){
//        NSLog(@"成功");
//    }
//    else if(sender.tag == 2000){
//        if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
//            [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
//                NSLog(@"成功");
//                [self InitUserData];
//            }andFaile:^{
//                NSLog(@"失败");
//            }];
//        }else{
//            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            TJMineFeedbackView *commentView = [[TJMineFeedbackView alloc] initWithFrame:window.bounds];
//            [window addSubview:commentView];
//        }
//        
//    }
//    else if(sender.tag == 2001){
//        MainSettingViewController *ctrl = [[MainSettingViewController alloc]init];
//        ctrl.hidesBottomBarWhenPushed = YES;
//        [self.naviController pushViewController:ctrl animated:YES];
//    }
}

- (IBAction)myFuliPress:(id)sender {
    
    if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            NSLog(@"成功");
            [self InitUserData];
        }andFaile:^{
            NSLog(@"失败");
        }];
    }else{
        MyCollectViewController *my=[[MyCollectViewController alloc]init];
        my.state=fuli_KEY;
        my.hidesBottomBarWhenPushed = YES;
        [self.naviController pushViewController:my animated:YES];
    }
}
- (IBAction)myhuoDongPress:(id)sender {
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




@end
