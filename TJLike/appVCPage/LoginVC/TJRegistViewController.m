//
//  TJRegistViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJRegistViewController.h"
#import "TJUserInfoEditViewController.h"
#import "TJRegistViewModel.h"

#define LABELCELL_Height (35)
#define LABELCELL_AllHeight (55)
#define LABELCELL_Y      (40)
#define LABELCELL_WidthH (80)
#define ThirdPartHeight 167.5
#define ThirdIconWH 66.5
#define TextFieldH 50
#define LineH 0.5

#define backView_Height (46)


static NSString *registerTitle = @"手机注册";
static NSString *forgetPasswordTitle = @"重置密码";
static NSString *bindingTitle = @"绑定手机";

static NSString *registerAlter = @"通过输入短信内的验证码, 完成手机注册, 注册成功后, 可用手机号和密码登陆";
static NSString *forgetAlter = @"请输入您的手机号,接收短信验证码,即可修改密码,确认成功后重置密码";
static NSString *bindAlter = @"通过输入短信内的验证码,完成手机绑定,绑定成功后,可用手机号和密码登陆";



@interface TJRegistViewController ()<UITextFieldDelegate>
{
    UITextField *phoneTextField;
    UITextField *codeTextField;
    UITextField *passTextField;
    UITextField *verifyTextField;
    UIButton    *btnCode;
    NSTimer     *timer;
     BOOL isEdit;
}

//@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) TJRegistViewModel *viewModel;

@end

@implementation TJRegistViewController

-(instancetype)init:(PageType)verifyType
{
    if (self = [super init]) {
        _viewModel = [[TJRegistViewModel alloc] init];
        self.hidesBottomBarWhenPushed=YES;
        self.pageType=verifyType;
        self.view.userInteractionEnabled = YES;
    }
    return self;
}

- (void)requestData
{
    if (self.pageType == PageType_Register) {
        [_viewModel postPhoneRegisterUserInfo:phoneTextField.text andPassWord:passTextField.text andCode:codeTextField.text finish:^{
            
            [self.view makeToast:@"注册成功" duration:2.0 position:CSToastPositionCenter];
      //      TJUserInfoEditViewController *editInfo = [[TJUserInfoEditViewController alloc] init];
       //     [self.naviController pushViewController:editInfo animated:YES];
            
        } failed:^(NSString *error) {
            
            [self.view makeToast:error duration:2.0 position:CSToastPositionCenter];
        }];
        
        
//        [self.view makeToast:@"注册成功" duration:2.0 position:CSToastPositionCenter];
//        TJUserInfoEditViewController *editInfo = [[TJUserInfoEditViewController alloc] init];
//        [self.naviController pushViewController:editInfo animated:YES];

        
    }
    else if (self.pageType == PageType_Forget)
    {
        [_viewModel postForgetPassWord:phoneTextField.text andPassWord:passTextField.text andRepassword:verifyTextField.text andCode:codeTextField.text finish:^{
            [SHARE_WINDOW makeToast:@"密码重置成功" duration:2.0 position:CSToastPositionCenter];
            [self.naviController popViewControllerAnimated:YES];
        } failed:^(NSString *error) {
            [SHARE_WINDOW makeToast:error duration:2.0 position:CSToastPositionCenter];
        }];
    }
    else if (self.pageType == PageType_Bind)
    {
        
    }
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)inistalNavBar
{
    switch (self.pageType) {
        case PageType_Register:
            [self.naviController setNaviBarTitle:registerTitle];
            break;
        case PageType_Forget:
            [self.naviController setNaviBarTitle:forgetPasswordTitle];
            break;
        case PageType_Bind:
            [self.naviController setNaviBarTitle:bindingTitle];
            break;
        default:
            break;
    }
    [self.naviController setNaviBarTitleStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NAVTITLE_COLOR_KEY,[UIFont boldSystemFontOfSize:19.0],NAVTITLE_FONT_KEY,nil]];
    UIImage *leftImg = [UIImage imageNamed:@"appui_fanhui_"];
    UIButton *leftBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:@"appui_fanhui_" imgHighlight:nil withFrame:CGRectMake(0, 0, leftImg.size.width/2,leftImg.size.height/2)];
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self.naviController popViewControllerAnimated:YES];
        
    }];
    [self.naviController setNaviBarLeftBtn:leftBtn];
    
}

- (void)buildUI
{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recoveryTableView)];
////    tap.delegate = self;
//    [self.view addGestureRecognizer:tap];
    
     self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 60)];
    [view setBackgroundColor:[UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1]];
    UILabel *lblel = [[UILabel alloc] initWithFrame:CGRectMake( 5, 0, self.view.frame.size.width - 10 ,57)];
    
    switch (self.pageType) {
        case PageType_Register:
            [lblel setText:registerAlter];
            break;
        case PageType_Forget:
            [lblel setText:forgetAlter];
            break;
        case PageType_Bind:
            [lblel setText:bindAlter];
            break;
            
        default:
            break;
    }
    [lblel setFont:[UIFont systemFontOfSize:14.0]];
    [lblel setTextColor:[UIColor whiteColor]];
    lblel.numberOfLines = 2;
    [view addSubview:lblel];
    
    [self.view addSubview:view];
    
    UIView *viewB1  = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(view.frame)+17,SCREEN_WIDTH - 30,backView_Height)];
    viewB1.layer.borderWidth = 1;
    viewB1.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    viewB1.layer.cornerRadius = 4;
    viewB1.layer.masksToBounds=YES;
    // viewA.backgroundColor=[UIColor blueColor];
    [self.view addSubview:viewB1];
    
    UIView *viewA  = [self setupTableViewCellSubView:CGRectMake(20, 5, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"手机号"];
    phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(viewA.frame)+ 5, 0, viewB1.frame.size.width - viewA.frame.size.width - viewA.frame.origin.x, backView_Height)];
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTextField.delegate = self;
    phoneTextField.borderStyle = UITextBorderStyleNone;
    phoneTextField.placeholder = @"11位手机号码";
    phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    phoneTextField.returnKeyType=UIReturnKeyNext;
    phoneTextField.tag=1001;
    [viewB1 addSubview:viewA];
    [viewB1 addSubview:phoneTextField];
    
    
    
    UIView *viewB2  = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(viewB1.frame)+17,SCREEN_WIDTH - 30-125,backView_Height)];
    viewB2.layer.borderWidth = 1;
    viewB2.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    viewB2.layer.cornerRadius = 4;
    viewB2.layer.masksToBounds=YES;
    // viewA.backgroundColor=[UIColor blueColor];
    [self.view addSubview:viewB2];
    
    UIView *viewB  = [self setupTableViewCellSubView:CGRectMake(20, 5, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"验证码"];
    [viewB2 addSubview:viewB];
    
    codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(viewB.frame)+ 5, 0, viewB2.frame.size.width-viewB.frame.size.width, backView_Height)];
    codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeTextField.delegate = self;
    codeTextField.borderStyle = UITextBorderStyleNone;
    codeTextField.placeholder = @"手机短信验证码";
    codeTextField.keyboardType=UIKeyboardTypeNumberPad;
    codeTextField.returnKeyType=UIReturnKeyNext;
    codeTextField.tag=1002;

    
 
    btnCode=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewB2.frame)+ 5, CGRectGetMaxY(viewB1.frame)+17, 120, backView_Height)];
    btnCode.backgroundColor=COLOR(247, 73,74, 1);
    [btnCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    btnCode.titleLabel.font=[UIFont systemFontOfSize:16];
    btnCode.layer.cornerRadius=5;
    @weakify(self)
    [[btnCode rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel postSendNumbert:self->phoneTextField.text finish:^{
            
            [self.view makeToast:@"验证码发送成功" duration:0.3 position:CSToastPositionCenter];
            codeTextField.enabled=YES;
            
        } failed:^(NSString *error) {
            [self.view makeToast:@"验证码发送失败" duration:0.3 position:CSToastPositionCenter];
        }];
        
        [self->btnCode setTitle:@"60" forState:UIControlStateNormal];
        self->codeTextField.enabled=NO;
        if (self->timer)
        {[self->timer invalidate];
            self->timer=nil;
        }
        self->timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        self->btnCode.enabled=NO;
        if (self->codeTextField) {
            [self->codeTextField becomeFirstResponder];
        }
        
    }];
    [self.view addSubview:btnCode];
    [viewB2 addSubview:codeTextField];
    
    
    
    UIView *viewB3  = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(viewB2.frame)+17,SCREEN_WIDTH - 30,backView_Height)];
    viewB3.layer.borderWidth = 1;
    viewB3.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    viewB3.layer.cornerRadius = 4;
    viewB3.layer.masksToBounds=YES;
    // viewA.backgroundColor=[UIColor blueColor];
    [self.view addSubview:viewB3];
    
    NSString *strType = nil;
    if (self.pageType == PageType_Forget) {
        strType = @"设置新密码";
    }
    else{
        strType = @"设置登陆密码";
    }
    

    
    UIView *viewC  = [self setupTableViewCellSubView:CGRectMake(20, 5, LABELCELL_WidthH, LABELCELL_Height) andTitle:strType];
    [viewB3 addSubview:viewC];
    
    passTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(viewC.frame)+ 5, 0, viewB3.frame.size.width - viewC.frame.size.width - viewC.frame.origin.x, backView_Height)];
    passTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passTextField.delegate = self;
    passTextField.borderStyle = UITextBorderStyleNone;
    passTextField.secureTextEntry = YES;
    passTextField.placeholder = @"6-32位密码";
    passTextField.keyboardType=UIKeyboardTypeASCIICapable;
    passTextField.returnKeyType=UIReturnKeyNext;
    passTextField.tag=1003;
    [viewB3 addSubview:passTextField];

    
    
    UIView *viewB4  = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(viewB3.frame)+17,SCREEN_WIDTH - 30,backView_Height)];
    viewB4.layer.borderWidth = 1;
    viewB4.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    viewB4.layer.cornerRadius = 4;
    viewB4.layer.masksToBounds=YES;
    // viewA.backgroundColor=[UIColor blueColor];
    [self.view addSubview:viewB4];
    
    UIView *viewD  = [self setupTableViewCellSubView:CGRectMake(20, 5, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"确认密码"];
    [viewB4 addSubview:viewD];
    
    
    verifyTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(viewD.frame)+ 5, 0, viewB4.frame.size.width - viewD.frame.size.width - viewD.frame.origin.x, backView_Height)];
    verifyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    verifyTextField.delegate = self;
    verifyTextField.secureTextEntry = YES;
    verifyTextField.borderStyle = UITextBorderStyleNone;
    verifyTextField.placeholder = @"密码确认";
    verifyTextField.keyboardType=UIKeyboardTypeASCIICapable;
    verifyTextField.returnKeyType=UIReturnKeyNext;
    verifyTextField.tag=1004;
    [viewB4 addSubview:verifyTextField];
    
    
   // UIImage *image =[UIImage imageNamed:@"sign_10_"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=COLOR(217, 44,35, 1);

   // [button setBackgroundImage:image forState:UIControlStateNormal];
    button.layer.cornerRadius=5;
    //   [button setFrame:CGRectMake(20, view.frame.size.height *3/4, SCREEN_WIDTH - 40, 50)];
    [button setFrame:CGRectMake(15, SCREEN_HEIGHT-backView_Height-40, SCREEN_WIDTH - 30, backView_Height)];
    NSString *str;
    switch (self.pageType) {
        case PageType_Register:
            str = @"注册";
            break;
        case PageType_Forget:
            str = @"确认";
            break;
        case PageType_Bind:
            str = @"绑定";
            break;
            
        default:
            break;
    }
    
    [button setTitle:str forState:UIControlStateNormal];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self requestData];
        
        
    }];
    
    [self.view addSubview:button];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self inistalNavBar];
    self.naviController.navigationBarHidden = NO;
 //   [NOTIFICATION_CENTER addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (UIView *)setupTableViewCellSubView:(CGRect)frame andTitle:(NSString *)title
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] init];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setText:title];

    [label  setFont:[UIFont systemFontOfSize:16]];
    [label setTextColor:[UIColor blackColor]];
    CGSize size =  [UIUtil textToSize:title fontSize:16];
    [label setFrame:CGRectMake(0, 0, size.width, frame.size.height)];
    [view addSubview:label];
    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(label.frame.size.width + 20,0,1, label.frame.size.height)];
//    [line setBackgroundColor:[UIColor redColor]];
//    [view addSubview:line];
    
    view.frame = CGRectMake(frame.origin.x, frame.origin.y, label.frame.size.width + 5, frame.size.height);
    
    return view;
    
}
-(void)countDown
{
    NSString *seconds=[NSString stringWithFormat:@"%d",[btnCode.titleLabel.text intValue]-1];
    [btnCode setTitle:seconds forState:UIControlStateNormal];
//    countDownLabel.text=seconds;
    if ([seconds intValue]==-1)
    {
    
        if (self->timer)
        {[self->timer invalidate];
            self->timer=nil;
        }
        btnCode.enabled=YES;
        [btnCode setTitle:@"发送验证码" forState:UIControlStateNormal];

        codeTextField.enabled = YES;
    }
}




-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame=self.view.frame;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    if (!isEdit)
    {
        if (textField.tag>1002) {
            frame.origin.y-= window.frame.size.height==568?130:158;
            [UIView animateWithDuration:0.5f animations:^{
                self.view.frame=frame;
            }];
        }
       
    }
    isEdit=YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect frame=self.view.frame;
    if (!isEdit) {
        frame.origin.y=0;
        [UIView animateWithDuration:0.5f animations:^{
            self.view.frame=frame;
        }];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    isEdit=NO;
    [self.view endEditing:YES];
}


@end
