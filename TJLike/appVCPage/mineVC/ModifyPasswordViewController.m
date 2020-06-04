//
//  ModifyPasswordViewController.m
//  TJLike
//
//  Created by MC on 15/4/18.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "AutoAlertView.h"
#define backView_Height (46)
#define LABELCELL_Height (35)
#define LABELCELL_WidthH (80)
@interface ModifyPasswordViewController ()
{
    UITableView *_tableView;
}
@end

@implementation ModifyPasswordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)inistalNavBar
{
    
    [self.naviController setNaviBarTitle:@"修改密码"];
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
    //    //    tap.delegate = self;
    //    [self.view addGestureRecognizer:tap];
    //
    //    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    //    _tableView.delegate = self;
    //    _tableView.dataSource = self;
    //    _tableView.showsHorizontalScrollIndicator = YES;
    //    _tableView.scrollEnabled = NO;
    //    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 10);
    //    [self.view addSubview:_tableView];
    
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 60)];
    [view setBackgroundColor:[UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1]];
    UILabel *lblel = [[UILabel alloc] initWithFrame:CGRectMake( 5, 0, self.view.frame.size.width - 10 ,57)];
    
    [lblel setText:@"请输入正确的旧密码"];
    
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
    mPassword = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(viewA.frame)+ 5, 0, viewB1.frame.size.width - viewA.frame.size.width - viewA.frame.origin.x, backView_Height)];
    mPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    //mPassword.delegate = self;
    mPassword.borderStyle = UITextBorderStyleNone;
    mPassword.placeholder = @"请输入您的旧密码";
    mPassword.keyboardType=UIKeyboardTypeNumberPad;
    mPassword.returnKeyType=UIReturnKeyNext;
    mPassword.secureTextEntry = YES;
    mPassword.font = [UIFont systemFontOfSize:15];
    [viewB1 addSubview:viewA];
    [viewB1 addSubview:mPassword];
    
    
    UIView *viewB2  = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(viewB1.frame)+17,SCREEN_WIDTH - 30,backView_Height)];
    viewB2.layer.borderWidth = 1;
    viewB2.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    viewB2.layer.cornerRadius = 4;
    viewB2.layer.masksToBounds=YES;
    [self.view addSubview:viewB2];
    UIView *viewA2  = [self setupTableViewCellSubView:CGRectMake(0, 5, 50, LABELCELL_Height) andTitle:@"设置新密码"];
    mPassword2 =[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(viewA.frame)+ 7, 0, viewB1.frame.size.width - viewA.frame.size.width - viewA.frame.origin.x, backView_Height)];
    
    mPassword2.clearButtonMode = UITextFieldViewModeWhileEditing;
    //mPassword2.backgroundColor=[UIColor redColor];
    //mPassword.delegate = self;
    mPassword2.borderStyle = UITextBorderStyleNone;
    mPassword2.placeholder = @"6-32位密码";
    mPassword2.keyboardType=UIKeyboardTypeNumberPad;
    mPassword2.returnKeyType=UIReturnKeyNext;
    mPassword2.secureTextEntry = YES;
    mPassword2.font = [UIFont systemFontOfSize:15];
    [viewB2 addSubview:viewA2];
    [viewB2 addSubview:mPassword2];
    
    UIView *viewB3  = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(viewB2.frame)+17,SCREEN_WIDTH - 30,backView_Height)];
    viewB3.layer.borderWidth = 1;
    viewB3.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    viewB3.layer.cornerRadius = 4;
    viewB3.layer.masksToBounds=YES;
    [self.view addSubview:viewB3];
    UIView *viewA3  = [self setupTableViewCellSubView:CGRectMake(0, 5, 50, LABELCELL_Height) andTitle:@"确认新密码"];
    [viewB3 addSubview:viewA3];
    mPassword3 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(viewA3.frame)+ 5, 0, viewB3.frame.size.width - viewA3.frame.size.width - viewA3.frame.origin.x, backView_Height)];
    mPassword3.clearButtonMode = UITextFieldViewModeWhileEditing;
    mPassword3.delegate = self;
    mPassword3.borderStyle = UITextBorderStyleNone;
    mPassword3.placeholder = @"确认密码";
    mPassword3.keyboardType=UIKeyboardTypeASCIICapable;
    mPassword3.returnKeyType=UIReturnKeyNext;
    mPassword3.secureTextEntry = YES;
    mPassword3.font = [UIFont systemFontOfSize:15];
    mPassword3.tag=1000;
    [viewB3 addSubview:mPassword3];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=COLOR(217, 44,35, 1);
    button.layer.cornerRadius=5;
    [button setFrame:CGRectMake(15, SCREEN_HEIGHT-backView_Height-40, SCREEN_WIDTH - 30, backView_Height)];
    [button setTitle:@"确认" forState:UIControlStateNormal];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    
        [self OnRegisterClick];
        
    }];
    
    
    
    [self.view addSubview:button];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self inistalNavBar];
    self.naviController.navigationBarHidden = NO;
    //[NOTIFICATION_CENTER addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
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
            return 3;
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
            return 40;
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
    
    UILabel *lblel = [[UILabel alloc] initWithFrame:CGRectMake( imageView.frame.size.width + imageView.frame.origin.x +10, 0, view.frame.size.width - imageView.frame.size.width - 10, 60)];
    [lblel setText:@"请输入正确的旧密码"];
    
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 70 *4 - 60 - NAVIBAR_HEIGHT - STATUSBAR_HEIGHT)];
    view.backgroundColor = [UIColor clearColor];
    
    
    UIImage *image =[UIImage imageNamed:@"sign_10_"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setFrame:CGRectMake(20, view.frame.size.height *3/4, SCREEN_WIDTH - 40, 50)];
    
    NSString *str = @"确认";
    
    [button setTitle:str forState:UIControlStateNormal];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //[self requestData];
        [self OnRegisterClick];
        
    }];
    
    [view addSubview:button];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"strCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                UIView *viewA  = [self setupTableViewCellSubView:CGRectMake(15, 0, 100, 40) andTitle:@"旧密码"];
                mPassword = [[UITextField alloc] initWithFrame:CGRectMake(viewA.frame.size.width + viewA.frame.origin.x + 5, viewA.frame.origin.y, cell.frame.size.width - viewA.frame.size.width - viewA.frame.origin.x, viewA.frame.size.height)];
                mPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
                //mPassword.delegate = self;
                mPassword.borderStyle = UITextBorderStyleNone;
                mPassword.placeholder = @"请输入您的旧密码";
                mPassword.keyboardType=UIKeyboardTypeNumberPad;
                mPassword.returnKeyType=UIReturnKeyNext;
                mPassword.secureTextEntry = YES;
                mPassword.font = [UIFont systemFontOfSize:15];
                [cell addSubview:viewA];
                [cell addSubview:mPassword];
            }
                break;
            case 1:
            {
                UIView *viewB  = [self setupTableViewCellSubView:CGRectMake(15, 0, 100, 40) andTitle:@"设新密码"];
                [cell addSubview:viewB];
                
                mPassword2 = [[UITextField alloc] initWithFrame:CGRectMake(viewB.frame.size.width + viewB.frame.origin.x + 5, viewB.frame.origin.y, cell.frame.size.width - viewB.frame.size.width - viewB.frame.origin.x, viewB.frame.size.height)];
                mPassword2.clearButtonMode = UITextFieldViewModeWhileEditing;
                //mPassword2.delegate = self;
                mPassword2.borderStyle = UITextBorderStyleNone;
                mPassword2.placeholder = @"6-32位密码";
                mPassword2.keyboardType=UIKeyboardTypeNumberPad;
                mPassword2.returnKeyType=UIReturnKeyNext;
                mPassword2.secureTextEntry = YES;
                mPassword2.font = [UIFont systemFontOfSize:15];
                [cell addSubview:mPassword2];
                
                
            }
                
                break;
                
            case 2:
            {
                NSString *strType = @"确认新密码";
                
                UIView *viewD  = [self setupTableViewCellSubView:CGRectMake(15, 0, 100, 40) andTitle:strType];
                [cell addSubview:viewD];
                mPassword3 = [[UITextField alloc] initWithFrame:CGRectMake(viewD.frame.size.width + viewD.frame.origin.x + 5, viewD.frame.origin.y, cell.frame.size.width - viewD.frame.size.width - viewD.frame.origin.x, viewD.frame.size.height)];
                mPassword3.clearButtonMode = UITextFieldViewModeWhileEditing;
                //mPassword3.delegate = self;
                mPassword3.borderStyle = UITextBorderStyleNone;
                mPassword3.placeholder = @"确认密码";
                mPassword3.keyboardType=UIKeyboardTypeASCIICapable;
                mPassword3.returnKeyType=UIReturnKeyNext;
                mPassword3.secureTextEntry = YES;
                mPassword3.font = [UIFont systemFontOfSize:15];
                [cell addSubview:mPassword3];
                
            }
                
                break;
            default:
                break;
        }
    }
    else if(indexPath.section == 0)
    {
        
    }
    
    
    
    return cell;
    
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
- (void)OnRegisterClick{
    
    if (!mPassword.text || mPassword.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请填写旧密码"];
        return;
    }
    if (!mPassword2.text || mPassword2.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请填写新密码"];
        return;
    }
    if (mPassword2.text.length < 6) {
        [AutoAlertView ShowAlert:@"提示" message:@"密码长度不小于6位"];
        return;
    }
    if (!mPassword3.text || mPassword3.text.length == 0 || ![mPassword3.text isEqualToString:mPassword2.text]) {
        [AutoAlertView ShowAlert:@"提示" message:@"两次输入密码不一致"];
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/UpdatePass"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:UserManager.userInfor.userId forKey:@"uid"];
    [dict setObject:mPassword.text forKey:@"oldpassword"];
    [dict setObject:mPassword2.text forKey:@"password"];
    //??????wentiwentiwentiwentiwentiwentiwentiwentiwenti
    [HttpClient request:dict URL:urlStr success:^(NSDictionary *info) {
     //   NSLog(@"修改信息----》%@",info);
        [AutoAlertView ShowMessage:@"修改成功"];
        [self.naviController popViewControllerAnimated:YES];
        
  } fail:^{
      [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
  }];

}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame=self.view.frame;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    //  if (!isEdit)
    //  {
    if (textField.tag==1000) {
        frame.origin.y-= window.frame.size.height==568?130:158;
        [UIView animateWithDuration:0.5f animations:^{
            self.view.frame=frame;
        }];
    }
    
    // }
    //  isEdit=YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect frame=self.view.frame;
    //  if (!isEdit) {
    frame.origin.y=0;
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame=frame;
    }];
    // }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //   isEdit=NO;
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
