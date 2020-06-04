//
//  MainSettingViewController.m
//  TJLike
//
//  Created by MC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "MainSettingViewController.h"
#import "MyHomeCell.h"
#import "AutoAlertView.h"

@interface MainSettingViewController ()
{
    UITableView *_theTable;
    UIButton *_outBtn;
}
@end

@implementation MainSettingViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"设置"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
    
    
//    if ([[TJUserAuthorManager registerPageManager]gainCurrentStateForUserLoginAndBind]==0) {
//        [_outBtn setTitle:@"登录" forState:UIControlStateNormal];
//        
//    }else{
//        [_outBtn setTitle:@"退出登录" forState:UIControlStateNormal];   }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _theTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _theTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _theTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _theTable.delegate = self;
    _theTable.dataSource = self;
    _theTable.showsVerticalScrollIndicator = NO;
    _theTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:_theTable];
    
//    if ([[TJUserAuthorManager registerPageManager]gainCurrentStateForUserLoginAndBind]==0) {
//        [_outBtn setTitle:@"登录" forState:UIControlStateNormal];
//        
//    }else{
//         [_outBtn setTitle:@"退出登录" forState:UIControlStateNormal];   }
 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else
    {
    return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell00";
    MyHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[MyHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.section==0) {
          cell.myLabel.text = @"清理缓存";
    }
    else
    {
    if (indexPath.row==0) {
        cell.myLabel.text = @"检查更新";
       // cell.myImage.image = [UIImage imageNamed:@"181.png"];
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 42.5, SCREEN_WIDTH-30, 1)];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell.contentView addSubview:lineView];
    }
    else{
        cell.myLabel.text = @"关于奏耐天津";
       // cell.myImage.image = [UIImage imageNamed:@"183.png"];
      //  UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 42.5, SCREEN_WIDTH, 1)];
      //  lineView.backgroundColor = [UIColor darkGrayColor];
      //  [cell.contentView addSubview:lineView];
    }
    }
    
    //cell.myImage.frame = CGRectMake(20, (45-cell.myImage.image.size.height/2)/2, cell.myImage.image.size.width/2, cell.myImage.image.size.height/2);
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    else
    {
        return SCREEN_HEIGHT - 70 *3 - NAVIBAR_HEIGHT - STATUSBAR_HEIGHT;
    
    }

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return nil;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 70 *3 - NAVIBAR_HEIGHT - STATUSBAR_HEIGHT)];
        view.backgroundColor = [UIColor clearColor];
        
        
        UIImage *image =[UIImage imageNamed:@"sign_10_"];
         _outBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_outBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_outBtn setFrame:CGRectMake(20, view.frame.size.height *3/4, SCREEN_WIDTH - 40, 50)];
        if ([[TJUserAuthorManager registerPageManager]gainCurrentStateForUserLoginAndBind]==0) {
            [_outBtn setTitle:@"登录" forState:UIControlStateNormal];
            
        }else{
            [_outBtn setTitle:@"退出登录" forState:UIControlStateNormal];   }
        
        [_outBtn addTarget:self
                   action:@selector(exitLogin) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_outBtn];
        
        return view;
        
    }

}
-(void)exitLogin
{
      NSLog(@"AAAAAA成功");
    if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            NSLog(@"成功");
        //    [self InitUserData];
        //     [_outBtn setTitle:@"登录" forState:UIControlStateNormal];
        
             [_theTable reloadData];
         //    [AutoAlertView ShowMessage:@"已退出"];
       // [self.navigationController popViewControllerAnimated:YES];
        }andFaile:^{
            NSLog(@"失败");
        }];
    }else{
        [UserManager quitUserSuccess:^{
          //  _headIcon.image = nil;
          //  _nameLabel.text = @"";
          //  //signLabel.text = @"";
          //  [_outBtn setTitle:@"登录" forState:UIControlStateNormal];
        }];
    }

    

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if (indexPath.row == 0) {
        [AutoAlertView ShowMessage:@"缓存已清除"];
    }
    else if (indexPath.row == 1){
        [AutoAlertView ShowAlert:@"" message:@"QQ:2498128223"];
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
