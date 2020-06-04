//
//  TJLoginRegisterViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/3.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJLoginRegisterViewController.h"
#import "WTVTextField.h"
#import "TJRegistViewController.h"
#import "TJLoginViewModel.h"
#import <ShareSDK/ShareSDK.h>

@interface TJLoginRegisterViewController ()

@property (nonatomic, strong) TJLoginViewModel *viewModel;

@property (nonatomic, strong) UIImageView   *backImageView;

@property (nonatomic, strong) UIImageView   *headImageView;

@property (nonatomic, strong) WTVTextField   *phoneTextField;

@property (nonatomic, strong) WTVTextField   *passWordTextField;

@property (nonatomic, strong) UIButton      *btnLogin;

@property (nonatomic, strong) UIButton      *btnRegister;

@property (nonatomic, strong) UIButton      *btnWeibo;

@property (nonatomic, strong) UIButton      *btnForget;

@property(nonatomic,assign)EnterType enterType;

@end

@implementation TJLoginRegisterViewController

- (instancetype)init:(EnterType)enterType
{
    self = [super init];
    if (self) {
        self.enterType=enterType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewModel = [[TJLoginViewModel alloc] init];
    [self buildUI];
}

- (void)buildUI
{
    
//    _backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    [_backImageView setImage:[UIImage imageNamed:@"user_login_bg"]];
//    [self.view addSubview:_backImageView];
    self.view.backgroundColor=[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    
    UIButton *btnReturn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnReturn setFrame:CGRectMake(20, 30, 20, 28)];
    [btnReturn setImage:[UIImage imageNamed:@"appui_fanhui_"] forState:UIControlStateNormal];
    [[btnReturn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.enterType == EnterType_Push) {
            [self.naviController popToRootViewControllerAnimated:YES];
        }
        else if (self.enterType == EnterType_PresentPor)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        if (self.loginFinish) {
             self.loginFinish(nil);
        }
       
        
    }];
    [self.view addSubview:btnReturn];
    
   // UIImage *headImg = [UIImage imageNamed:@"head_img"];
    UIImage *headImg = [UIImage imageNamed:@"logo@2x.png"];
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 205, 58)];
    [_headImageView setImage:headImg];

    //_headImageView.layer.masksToBounds = YES;
   // _headImageView.layer.cornerRadius = headImg.size.width/2;
    [_headImageView setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/4)];
    [self.view addSubview:_headImageView];
    
   
    
    
   // UIImage * textImg = [UIImage imageNamed:@"sign_11_"];
    
    UIView *phView=[[UIView alloc ]initWithFrame:CGRectMake(20, _headImageView.frame.size.height + _headImageView.frame.origin.y +40 *SCREEN_PHISICAL_SCALE, self.view.frame.size.width-40, 46)];
    //phView.backgroundColor=[UIColor yellowColor];
    phView.layer.borderWidth = 1;
    phView.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    phView.layer.cornerRadius = 4;
    phView.layer.masksToBounds=YES;
    [self.view addSubview:phView];
    
    _phoneTextField = [[WTVTextField alloc] initWithFrame:CGRectMake(4, 5, phView.bounds.size.width-8, phView.bounds.size.height-10)];
  
   // [_phoneTextField setBackground:textImg];
   // [_phoneTextField setCenter:CGPointMake(SCREEN_WIDTH/2, _phoneTextField.center.y)];
    _phoneTextField.borderStyle=UITextBorderStyleNone;
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
   // UIImage *phoneImg = [UIImage imageNamed:@"sign_6_"];
  //  UIImageView *phoneLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, phoneImg.size.width/2, phoneImg.size.height/2)];
   // [phoneLeftView setImage:phoneImg];
    _phoneTextField.placeholder = @"请输入手机号";
  //  _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
  // _phoneTextField.leftView = phoneLeftView;
    _phoneTextField.returnKeyType=UIReturnKeyNext;
    _phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    [phView addSubview:_phoneTextField];
    
    
    UIView *pwView=[[UIView alloc ]initWithFrame:CGRectMake(20,CGRectGetMaxY(phView.frame)+22, self.view.frame.size.width-40, 46)];
  
    pwView.layer.borderWidth = 1;
    pwView.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    pwView.layer.cornerRadius = 4;
    pwView.layer.masksToBounds=YES;
    [self.view addSubview:pwView];
    
    _btnForget = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnForget setFrame:CGRectMake( self.view.frame.size.width-120, 0, 80, 46)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [_btnForget setAttributedTitle:str forState:UIControlStateNormal];
    [_btnForget setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [pwView addSubview:_btnForget];
    
    [[_btnForget rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        TJRegistViewController *registVC = [[TJRegistViewController alloc] init:PageType_Forget];
        [self.naviController pushViewController:registVC animated:YES];
        
    }];
    
    
    
    _passWordTextField = [[WTVTextField alloc] initWithFrame:CGRectMake(4, 5, pwView.bounds.size.width-_btnForget.bounds.size.width, pwView.bounds.size.height-10)];
    //[_passWordTextField setBackground:textImg];
   // [_passWordTextField setCenter:CGPointMake(SCREEN_WIDTH/2, _passWordTextField.center.y)];
    _passWordTextField.borderStyle=UITextBorderStyleNone;
    _passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWordTextField.secureTextEntry = YES;
    _passWordTextField.placeholder = @"请输入密码";
    
   // UIImage *passImg = [UIImage imageNamed:@"sign_5_"];
   // UIImageView *passLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, passImg.size.width/2, passImg.size.height/2)];
   // [passLeftView setImage:passImg];
   // _passWordTextField.leftViewMode = UITextFieldViewModeAlways;
  //  _passWordTextField.leftView = passLeftView;
    _passWordTextField.returnKeyType=UIReturnKeyGo;
    _passWordTextField.keyboardType=UIKeyboardTypeASCIICapable;
    [pwView addSubview:_passWordTextField];
    
    
    
   // UIImage *loginImg = [UIImage imageNamed:@"sign_9_"];
    _btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnLogin setBackgroundColor:[UIColor colorWithRed:217/255.0 green:44/255.0 blue:35/255.0 alpha:1] ];

   // [_btnLogin setBackgroundImage:loginImg forState:UIControlStateNormal];
    [_btnLogin setTitle:@"登陆" forState:UIControlStateNormal];
   // _btnLogin.layer.borderWidth = 1;
   // _btnLogin.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnLogin.layer.cornerRadius = 4;
    _btnLogin.layer.masksToBounds=YES;
    [_btnLogin setFrame:CGRectMake(0, CGRectGetMaxY(pwView.frame)+22,  self.view.frame.size.width-40, 46)];
    [_btnLogin setCenter:CGPointMake(SCREEN_WIDTH/2, _btnLogin.center.y)];
    [self.view addSubview:_btnLogin];
    [[_btnLogin rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [_viewModel postLoginUserInfo:_phoneTextField.text andPassWord:_passWordTextField.text finish:^{
            
            [self.view makeToast:@"登陆成功" duration:0.25 position:CSToastPositionCenter];
            if (self.loginFinish) {
                self.loginFinish(nil);
            }
        } failed:^(NSString *error) {
            [self.view makeToast:error duration:0.25 position:CSToastPositionCenter];
        }];
    }];
    
    
//    UIImageView *regImagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _btnLogin.frame.size.height + _btnLogin.frame.origin.y +20, self.view.frame.size.width-40, 44)];
//  //  [regImagView setImage:loginImg];
//    [regImagView setCenter:CGPointMake(SCREEN_WIDTH/2, regImagView.center.y)];
//    [self.view addSubview:regImagView];
//    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, regImagView.frame.size.height - 10)];
//    [line setBackgroundColor:[UIColor whiteColor]];
//    [line setCenter:CGPointMake(regImagView.frame.size.width/2, regImagView.frame.size.height/2)];
//    [regImagView addSubview:line];
//    regImagView.userInteractionEnabled = YES;
//    
//    UIImage *rePhoneImg = [UIImage imageNamed:@"sign_7_"];
//    UIImage *reWeiboImg = [UIImage imageNamed:@"sign_8_"];
    
    _btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnRegister setFrame:CGRectMake(20, CGRectGetMaxY(_btnLogin.frame)+22, 109, 41)];
   // [_btnRegister setTitle:@"手机注册" forState:UIControlStateNormal];
   // [_btnRegister setBackgroundColor:[UIColor redColor]];
    _btnRegister.layer.borderWidth = 1;
    _btnRegister.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    _btnRegister.layer.cornerRadius = 4;
    _btnRegister.layer.masksToBounds=YES;
    [[_btnRegister rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        TJRegistViewController *registVC = [[TJRegistViewController alloc] init:PageType_Register];
        [self.naviController pushViewController:registVC animated:YES];
        
    }];
    
    UIImageView *regImagView = [[UIImageView alloc] initWithFrame:CGRectMake(10,13,15, 15)];
      [regImagView setImage:[UIImage imageNamed:@"iphone@3x.png"]];
     [_btnRegister addSubview:regImagView];

    
    UILabel * _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25 ,10, 80, 20)];
    _titleLabel.text = @"手机注册";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:15];
   // _titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255.0/255.0 alpha:1.0];
    [_btnRegister addSubview:_titleLabel];
    
    
    

    
    
    _btnWeibo = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnWeibo setFrame:CGRectMake(self.view.frame.size.width- 129, CGRectGetMaxY(_btnLogin.frame)+22,109, 41)];
    // [_btnWeibo setBackgroundColor:[UIColor redColor]];
    _btnWeibo.layer.borderWidth = 1;
    _btnWeibo.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    _btnWeibo.layer.cornerRadius = 4;
    _btnWeibo.layer.masksToBounds=YES;
    UIImageView *WeiboImagView = [[UIImageView alloc] initWithFrame:CGRectMake(10,13,15, 15)];
    [WeiboImagView setImage:[UIImage imageNamed:@"sina-logo@3x.png"]];
    [_btnWeibo addSubview:WeiboImagView];

    UILabel * _title = [[UILabel alloc]initWithFrame:CGRectMake(25 ,10, 80, 20)];
    _title.text = @"微博授权";
    _title.textAlignment = NSTextAlignmentCenter;
    _title.font = [UIFont systemFontOfSize:15];
   // _title.backgroundColor=[UIColor redColor];
   // _title.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0];
    [_btnWeibo addSubview:_title];
    [[_btnWeibo rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
            [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        }
        
        [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
            if (result) {
                TLog(@"nick : %@",[userInfo nickname]);
                TLog(@"gender:%d",(int)[userInfo gender]);
                TLog(@"image : %@",[userInfo profileImage]);
                TLog(@"birthday : %@",[userInfo birthday]);
                TLog(@"user info is %@",[userInfo sourceData]);
                TLog(@"user token is %@",[[userInfo credential] token]);
                
                
                [_viewModel postThirdWeiBoLoginUserInfo:[userInfo uid] andWeiBoicon:[userInfo profileImage] andToken:[[userInfo credential] token] finish:^(NSDictionary *resultDict) {
                
                    NSMutableDictionary *userDic = [[NSMutableDictionary alloc] initWithDictionary:resultDict];
                    if ([userInfo nickname]) {
                         [userDic setObject:[userInfo nickname] forKey:@"nickname"];
                    }
                    if ([userInfo birthday]) {
                        [userDic setObject:[userInfo birthday] forKey:@"birthday"];
                    }
                    if ([userInfo uid]){
                        [userDic setObject:[userInfo uid] forKey:@"weibo"];
                    }
                    
                    
                    
                    [userDic setObject:[NSNumber numberWithInteger:[userInfo gender] == 0?1:0] forKey:@"sex"];

                    [UserManager saveUserInfor:userDic withPhone:nil];
                    if (self.loginFinish) {
                        self.loginFinish(nil);
                    }
                    
                } failed:^(NSString *error) {
                    
                }];
                

            }
            else
            {
                TLog(@"error:%@",[error errorDescription]);
                TLog(@"%ld",(long)[error errorCode]);
                [self.view makeToast:@"授权失败" duration:1.0 position:[NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/4)]];
            }
        }];
    }];
    
   [self.view addSubview:_btnRegister];
   [self.view addSubview:_btnWeibo];
    
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)handleKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    @weakify(self)
    [UIView animateWithDuration:animationDuration animations:^{
      
      
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    @weakify(self)
    [UIView animateWithDuration:animationDuration animations:^{
//        @strongify(self)
        
    } completion:nil];
  
}



@end
