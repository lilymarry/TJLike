//
//  TJUserNewsViewController.m
//  TJLike
//
//  Created by imac-1 on 16/9/18.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "TJUserNewsViewController.h"
#import "UIImageView+WebCache.h"
#import <CDChatManager.h>
#import"ChatRoomViewController.h"
#import "MyTieZiViewController.h"
#import "AlertHelper.h"
#import "WebApi.h"
@interface TJUserNewsViewController ()
{
    // UIImageView *topBack;
    UIImageView *headIcon;
    UILabel *nameLabel;
   // UILabel *signLabel;
    UIButton *outBtn;
    UILabel *  signLabel;
    NSDictionary *userDict;
}
@end

@implementation TJUserNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * topBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 218)];
    topBack.image = [UIImage imageNamed:@"image01.png"];
    [self.view addSubview:topBack];
    
    UIButton *btnReturn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnReturn setFrame:CGRectMake(5, 5, 40, 54)];
    [btnReturn setImage:[UIImage imageNamed:@"appui_fanhui_"] forState:UIControlStateNormal];
    [[btnReturn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self.naviController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:btnReturn];
    
    
    headIcon = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-84/2, 20, 84, 84)];
    headIcon.layer.masksToBounds = YES;
    headIcon.layer.cornerRadius = 84*0.5;
    
   [topBack  addSubview:headIcon];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headIcon.frame)+10, SCREEN_WIDTH, 19)];
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = UIColorFromRGB(0xffffff);
       [topBack  addSubview:nameLabel];
    
    signLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame)+10, SCREEN_WIDTH, 19)];
    signLabel.font = [UIFont systemFontOfSize:12];
    signLabel.backgroundColor = [UIColor clearColor];
    signLabel.textAlignment = NSTextAlignmentCenter;
    signLabel.textColor = UIColorFromRGB(0xffffff);
    [topBack  addSubview:signLabel];

    
    [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
    [[WebApi sharedRequest]GetUserTeiZiWithId:_uid Success:^(NSDictionary *dic){
        [AlertHelper hideAllHUDsForView:self.view];
        if ([[dic objectForKey:@"code"] integerValue] == 200) {
            
            NSLog(@"AAAA___ %@",dic);
            NSDictionary *dict= dic[@"data"];
            userDict=dict;
            [nameLabel setText:StringEqual(dict[@"nickname"], @"")?dict[@"username"]:dict[@"nickname"]];
            [signLabel setText:StringEqual(dict[@"signature"], @"")?@"复杂世界里，一个就够了，这里没有陌生路":dict[@"signature"]];
            [headIcon  sd_setImageWithURL:[NSURL URLWithString:dict[@"icon"]] placeholderImage:ImageCache(@"lunbo_default_icon") options:SDWebImageLowPriority | SDWebImageRetryFailed];
            UIView *mView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topBack.frame), SCREEN_WIDTH, 10)];
            mView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [self.view  addSubview:mView1];
        
            UIView *viewA1  = [self setupTableViewCellSubView:CGRectMake(0, CGRectGetMaxY(mView1.frame)+5, SCREEN_WIDTH, 44) andTitle:@"他的帖子" ima:@"tiezi.png"  WithbutTag:2000];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor clearColor];
            btn.frame = viewA1.bounds;
            btn.tag = 2000;
            [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
            [viewA1 addSubview:btn];
            [self.view addSubview:viewA1];
            
            UIView *mView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewA1.frame)+5, SCREEN_WIDTH, 1)];
            mView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [self.view  addSubview:mView2];
            
            UIView *viewA2  = [self setupTableViewCellSubView:CGRectMake(0, CGRectGetMaxY(mView2.frame)+5, SCREEN_WIDTH, 44) andTitle:@"他的回帖" ima:@"kaquan.png" WithbutTag:2001 ];
            UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn2.backgroundColor = [UIColor clearColor];
            btn2.frame = viewA2.bounds;
            btn2.tag = 2001;
            [btn2 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
            [viewA2 addSubview:btn2];
            [self.view addSubview:viewA2];
            
            UIView *mView3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewA2.frame)+5, SCREEN_WIDTH, 1)];
            mView3.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [self.view  addSubview:mView3];
            
            UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn3.frame=CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49) ;
            //  btn3.backgroundColor = [UIColor redColor];
            [btn3 addTarget:self action:@selector(sendLetter:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn3];
            
            UILabel *  signLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
            signLab.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [btn3  addSubview:signLab];
            
            UIImageView * Icon = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, 7, 40, 40)];
            Icon.image=[UIImage imageNamed:@"私信.png"];
            [btn3  addSubview:Icon];
            
            UILabel *  signLabe = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(Icon.frame)+2, 17, 80, 19)];
            signLabe.font = [UIFont systemFontOfSize:13];
            signLabe.backgroundColor = [UIColor clearColor];
            signLabe.textAlignment = NSTextAlignmentLeft;
            signLabe.textColor = UIColorFromRGB(0x565656);
            [signLabe setText:@"发私信"];
            [btn3  addSubview:signLabe];

           
        }
        else
        {
            [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
            
        }
    } fail:^{
        [AlertHelper hideAllHUDsForView:self.view];
        
        [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
    }];

    
    
    
}
- (void)selectBtn:(UIButton *)sender
{
    if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            NSLog(@"成功");
           
        }andFaile:^{
            NSLog(@"失败");
        }];
    }else{
        MyTieZiViewController *my=[[MyTieZiViewController alloc]init];
        my.whoStr=_uid;
        my.hidesBottomBarWhenPushed = YES;
        [self.naviController pushViewController:my animated:YES];
        
    }
}
- (void)sendLetter:(UIButton *)sender
{
    [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
   NSString *idstr=[NSString stringWithFormat:@"ID#%@",_uid];
   NSString *iduser=[NSString stringWithFormat:@"ID#%@",UserManager.userInfor.userId];
    NSString *strImageUrl = nil;
    if ([NSData dataWithContentsOfURL:[NSURL URLWithString:UserManager.userInfor.icon]]) {
        strImageUrl = UserManager.userInfor.icon;
    }
    else{
        strImageUrl = UserManager.userInfor.weiboicon;
    }
    NSString *myStr;
    if (UserManager.userInfor.nickName.length==0) {
        myStr=idstr;
    }
    else
    {
       myStr=UserManager.userInfor.nickName;
    }
//    NSString *youStr;
//    if (_mode.username.length==0) {
//        youStr=idstr;
//    }
//    else
//    {
//        youStr=_mode.username;
//
//    }
    NSString *str=[NSString stringWithFormat:@"%@&%@",myStr,nameLabel.text];
    
   NSDictionary *dic=@{ idstr:userDict[@"icon"], iduser:strImageUrl,@"customConversationType":@"1",@"roomname":str };
  
    if ([_uid isEqualToString:UserManager.userInfor.userId]) {
         [AlertHelper hideAllHUDsForView:self.view];
         [AlertHelper singleMBHUDShow:@"不能给本人发私信" ForView:self.view AndDelayHid:2];
    
    }
    else
    {
      [[CDChatManager manager]fetchConversationWithOtherId:idstr  WithUserDic:dic callback:^(AVIMConversation *conversation, NSError *error) {
           [AlertHelper hideAllHUDsForView:self.view];
           ChatRoomViewController * chatRoom = [[ChatRoomViewController alloc]initWithConversation:conversation];
          
        [self presentViewController:chatRoom animated:YES completion:nil];
    
      }];
    }
    
   
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.naviController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.naviController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
//    [[CDChatManager manager]closeWithCallback:^(BOOL succeeded, NSError *error) {
//        
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)setupTableViewCellSubView:(CGRect)frame andTitle:(NSString *)title ima:(NSString *)ima WithbutTag:(int)butTag
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView * topBack = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 35, 35)];
   [topBack  sd_setImageWithURL:[NSURL URLWithString:userDict[@"icon"]] placeholderImage:ImageCache(@"lunbo_default_icon") options:SDWebImageLowPriority | SDWebImageRetryFailed];
    [topBack.layer setMasksToBounds:YES];
    topBack.layer.cornerRadius =10;
    [view addSubview:topBack];
    
    
    UILabel *label = [[UILabel alloc] init];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setText:title];
    [label  setFont:[UIFont systemFontOfSize:16]];
    [label setTextColor:[UIColor blackColor]];
    CGSize size =  [UIUtil textToSize:title fontSize:16];
    [label setFrame:CGRectMake(60, 4, size.width, frame.size.height)];
    [view addSubview:label];
    
    
    UIImageView * topBack1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 10, 10, 20)];
    topBack1.image = [UIImage imageNamed:@"return.png"];
    [view addSubview:topBack1];
    
    
    
    view.frame =frame;
    
    return view;
    
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
