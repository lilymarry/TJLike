//
//  TJMainTiePhoneViewController.m
//  TJLike
//
//  Created by MacBook on 15/5/9.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#define LABELCELL_Height (30)
#define LABELCELL_Y      (35)
#define LABELCELL_WidthH (80)
#define ThirdPartHeight 167.5
#define ThirdIconWH 66.5
#define TextFieldH 50
#define LineH 0.5

#define backView_Height (46)
#import "TJMainTiePhoneViewController.h"
#import "TJRegistViewModel.h"
#import "WebApi.h"
#import "AutoAlertView.h"
@interface TJMainTiePhoneViewController ()<UITextFieldDelegate>
{
    UITableView *_tableView;
    UITextField *phoneTextField;
    UITextField *codeTextField;
    UITextField *passTextField;
    UITextField *verifyTextField;
    UIButton    *btnCode;
    NSTimer     *timer;
    NSString    *code;
    BOOL isEdit;
}

@property (nonatomic, strong) TJRegistViewModel *viewModel;

@end

@implementation TJMainTiePhoneViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"绑定手机号"];
    [self.naviController setNaviBarTitleStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NAVTITLE_COLOR_KEY,[UIFont systemFontOfSize:20.0],NAVTITLE_FONT_KEY,nil]];
    [self.naviController setNaviBarDefaultLeftBut_Back];
    [self.naviController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _viewModel = [[TJRegistViewModel alloc] init];
    
    [self buildUI];
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
    lblel.text=@"通过输入短信内的验证码，完成手机号绑定";
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
         //   codeTextField.enabled=YES;
           // [self->btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];

            
        } failed:^(NSString *error) {
            [self.view makeToast:@"验证码发送失败" duration:0.3 position:CSToastPositionCenter];
            if (self->timer)
            {[self->timer invalidate];
                self->timer=nil;
            }
            self->codeTextField.enabled=NO;
            [self->btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];


        }];
        
      
//        if (self->timer)
//        {[self->timer invalidate];
//            self->timer=nil;
//        }
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
    
    NSString *strType = @"设置密码";
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
    NSString * str = @"确定";;
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


#pragma mark -- tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 0;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 0;
            break;
        case 1:
            return 70;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 60;
            break;
            
        default:
            return 0;
            break;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    [view setBackgroundColor:[UIColor yellowColor]];
    UIImage *image = [UIImage imageNamed:@"sign_2_"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, image.size.width, image.size.height)];
    [imageView setImage:image];
    [view addSubview:imageView];
    
    UILabel *lblel = [[UILabel alloc] initWithFrame:CGRectMake( imageView.frame.size.width+10 + imageView.frame.origin.x, 10, view.frame.size.width - imageView.frame.size.width - 10, image.size.height)];
    lblel.text = @"通过输入短信内的验证码，完成手机号绑定";
    [lblel setFont:[UIFont systemFontOfSize:14.0]];
    [lblel setTextColor:[UIColor blackColor]];
    [view addSubview:lblel];
    
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 2:
            return SCREEN_HEIGHT - 70 *4 - 60;
            break;
        default:
            return 0;
            break;
    }
    
    
}

- (void)requestData{
    if (!phoneTextField.text || phoneTextField.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请填写手机号"];
        return;
    }
    if (!codeTextField.text || codeTextField.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请填写验证码"];
        return;
    }
    if (passTextField.text.length < 6) {
        [AutoAlertView ShowAlert:@"提示" message:@"密码长度不小于6位"];
        return;
    }
    if (!passTextField.text || passTextField.text.length == 0 || ![passTextField.text isEqualToString:verifyTextField.text]) {
        [AutoAlertView ShowAlert:@"提示" message:@"两次输入密码不一致"];
        return;
    }
   [[WebApi sharedRequest]bindPhoneWithUserId:UserManager.userInfor.userId num:codeTextField.text phone:phoneTextField.text  passWord:passTextField.text  Success:^(NSDictionary *userInfo) {
       if ([[userInfo objectForKey:@"code"] integerValue] == 200) {
          [AutoAlertView ShowAlert:@"提示" message:@"绑定成功"];
       }
     else  if ([[userInfo objectForKey:@"code"] integerValue] == 500) {
           [AutoAlertView ShowAlert:@"提示" message:userInfo[@"msg"]];
       }
       else{
           [AutoAlertView ShowAlert:@"提示" message:@"绑定失败"];

       }

       
   } fail:^{
       [AutoAlertView ShowAlert:@"提示" message:@"网络错误"];
   }];
    
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 70 *4 - 60 - NAVIBAR_HEIGHT - STATUSBAR_HEIGHT)];
//    view.backgroundColor = [UIColor clearColor];
//    
//    
//    UIImage *image =[UIImage imageNamed:@"sign_10_"];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundImage:image forState:UIControlStateNormal];
//    [button setFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 50)];
//   // view.frame.size.height *3/4
//    [button setTitle:@"确定" forState:UIControlStateNormal];
//    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [self requestData];
//        
//    }];
//    
//    [view addSubview:button];
//    return view;
//}
//
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *strCell = @"strCell";
//    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:strCell];
//    if (!cell) {
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    if (indexPath.section == 1) {
//        switch (indexPath.row) {
//            case 0:
//            {
//                UIView *viewA  = [self setupTableViewCellSubView:CGRectMake(15, LABELCELL_Y, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"手机号"];
//                phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(viewA.frame.size.width + viewA.frame.origin.x + 5, viewA.frame.origin.y, cell.frame.size.width - viewA.frame.size.width - viewA.frame.origin.x, viewA.frame.size.height)];
//                phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//                phoneTextField.delegate = self;
//                phoneTextField.borderStyle = UITextBorderStyleNone;
//                phoneTextField.placeholder = @"11位手机号码";
//                phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
//                phoneTextField.returnKeyType=UIReturnKeyNext;
//                
//                [cell addSubview:viewA];
//                [cell addSubview:phoneTextField];
//            }
//                break;
//            case 1:
//            {
//                UIView *viewB  = [self setupTableViewCellSubView:CGRectMake(15, LABELCELL_Y, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"验证码"];
//                [cell addSubview:viewB];
//                
//                codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(viewB.frame.size.width + viewB.frame.origin.x + 5, viewB.frame.origin.y, cell.frame.size.width - viewB.frame.size.width - viewB.frame.origin.x - 100, viewB.frame.size.height)];
//                codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//                codeTextField.delegate = self;
//                codeTextField.borderStyle = UITextBorderStyleNone;
//                codeTextField.placeholder = @"手机短信验证码";
//                codeTextField.keyboardType=UIKeyboardTypeNumberPad;
//                codeTextField.returnKeyType=UIReturnKeyNext;
//                
//                
//                btnCode=[[UIButton alloc]initWithFrame:CGRectMake(codeTextField.frame.origin.x + codeTextField.frame.size.width +15, codeTextField.frame.origin.y, 120, 35)];
//                btnCode.backgroundColor=COLOR(242, 244, 248, 1);
//                [btnCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                [btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
//                btnCode.titleLabel.font=[UIFont systemFontOfSize:12];
//                btnCode.layer.cornerRadius=5;
//                @weakify(self)
//                [[btnCode rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//                    @strongify(self)
//                    
//                    [self.viewModel postSendNumbert:self->phoneTextField.text finish:^{
//                        
//                        [self.view makeToast:@"验证码发送成功" duration:0.3 position:CSToastPositionCenter];
//                        codeTextField.enabled=YES;
//                        
//                        [self->btnCode setTitle:@"60" forState:UIControlStateNormal];
//                        self->codeTextField.enabled=NO;
//                        if (self->timer)
//                        {[self->timer invalidate];
//                            self->timer=nil;
//                        }
//                        self->timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
//                        self->btnCode.enabled=NO;
//                        
//                        if (self->codeTextField) {
//                            [self->codeTextField becomeFirstResponder];
//                        }
//                        
//                    } failed:^(NSString *error) {
//                        [self.view makeToast:@"验证码发送失败" duration:0.3 position:CSToastPositionCenter];
//                        [self->btnCode setTitle:@"获取验证码"forState:UIControlStateNormal];
//                       // self->codeTextField.enabled=NO;
//                        if (self->timer)
//                        {[self->timer invalidate];
//                            self->timer=nil;
//                        }
//
//                    }];
//                    
//                    
//                    
//                    
//                    
//                }];
//                
//                [cell addSubview:codeTextField];
//                [cell addSubview:btnCode];
//                
//                
//            }
//                
//                break;
//            case 2:
//            {
//                NSString *strType = @"设置密码";
//                
//                UIView *viewC  = [self setupTableViewCellSubView:CGRectMake(15, LABELCELL_Y, LABELCELL_WidthH, LABELCELL_Height) andTitle:strType];
//                [cell addSubview:viewC];
//                
//                passTextField = [[UITextField alloc] initWithFrame:CGRectMake(viewC.frame.size.width + viewC.frame.origin.x + 5, viewC.frame.origin.y, cell.frame.size.width - viewC.frame.size.width - viewC.frame.origin.x, viewC.frame.size.height)];
//                passTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//                passTextField.delegate = self;
//                passTextField.borderStyle = UITextBorderStyleNone;
//                passTextField.secureTextEntry = YES;
//                passTextField.placeholder = @"6-32位密码";
//                passTextField.keyboardType=UIKeyboardTypeASCIICapable;
//                passTextField.returnKeyType=UIReturnKeyNext;
//                
//                [cell addSubview:passTextField];
//                
//            }
//                
//                break;
//            case 3:
//            {
//                NSString *strType = @"确认密码";
//                
//                UIView *viewD  = [self setupTableViewCellSubView:CGRectMake(15, LABELCELL_Y, LABELCELL_WidthH, LABELCELL_Height) andTitle:strType];
//                [cell addSubview:viewD];
//                
//                
//                verifyTextField = [[UITextField alloc] initWithFrame:CGRectMake(viewD.frame.size.width + viewD.frame.origin.x + 5, viewD.frame.origin.y, cell.frame.size.width - viewD.frame.size.width - viewD.frame.origin.x, viewD.frame.size.height)];
//                verifyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//                verifyTextField.delegate = self;
//                verifyTextField.secureTextEntry = YES;
//                verifyTextField.borderStyle = UITextBorderStyleNone;
//                verifyTextField.placeholder = @"密码确认";
//                verifyTextField.keyboardType=UIKeyboardTypeASCIICapable;
//                verifyTextField.returnKeyType=UIReturnKeyNext;
//                [cell addSubview:verifyTextField];
//                
//            }
//                
//                break;
//            default:
//                break;
//        }
//    }
//    else if(indexPath.section == 0)
//    {
//        
//    }
//    
//    
//    
//    return cell;
//    
//}


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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
