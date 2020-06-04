//
//  MainSetViewController.m
//  TJLike
//
//  Created by imac-1 on 16/8/2.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "MainSetViewController.h"
#import "AutoAlertView.h"
@interface MainSetViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *cell_clearData;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell_cherkVersion;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell_aboutTJLike;
@property (weak, nonatomic) IBOutlet UIButton *outBtn;



@end

@implementation MainSetViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"设置"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
   
    UITapGestureRecognizer *tapClearData = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearData:)];
    tapClearData.numberOfTapsRequired=1;
    [_cell_clearData addGestureRecognizer:tapClearData];
    
    UITapGestureRecognizer *tapCherkVersion = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cherkVersion:)];
    tapCherkVersion.numberOfTapsRequired=1;
    [_cell_cherkVersion addGestureRecognizer:tapCherkVersion];
    
    UITapGestureRecognizer *tapAboutTJLike = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutTJLike:)];
    tapAboutTJLike.numberOfTapsRequired=1;
    [_cell_aboutTJLike addGestureRecognizer:tapAboutTJLike];
    
    if ([[TJUserAuthorManager registerPageManager]gainCurrentStateForUserLoginAndBind]==0) {
        [_outBtn setTitle:@"登录" forState:UIControlStateNormal];
        
    }else{
        [_outBtn setTitle:@"退出登录" forState:UIControlStateNormal];

    
    }
    
}
-(void)clearData:(id)sender
{
    [AutoAlertView ShowMessage:@"缓存已清除"];
}
-(void)cherkVersion:(id)sender
{
     [AutoAlertView ShowMessage:@"最新版本"];
}
-(void)aboutTJLike:(id)sender
{
    [AutoAlertView ShowAlert:@"" message:@"QQ:2498128223"];
}
- (IBAction)cherkLogin:(id)sender {
    if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            NSLog(@"成功");
    
             [_outBtn setTitle:@"登录" forState:UIControlStateNormal];
            
            
        }andFaile:^{
             [AutoAlertView ShowMessage:@"网络错误，稍后再试"];
            NSLog(@"失败");
        }];
    }else{
        [UserManager quitUserSuccess:^{
            //  _headIcon.image = nil;
            //  _nameLabel.text = @"";
            //  //signLabel.text = @"";
            [AutoAlertView ShowMessage:@"已退出"];
            [_outBtn setTitle:@"登录" forState:UIControlStateNormal];
        }];
    }
  
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
