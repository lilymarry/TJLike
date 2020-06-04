//
//  PrivacyInfoViewController.m
//  TJLike
//
//  Created by imac-1 on 16/7/28.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "PrivacyInfoViewController.h"
#define backView_Height (46)
#define LABELCELL_Height (35)
#define LABELCELL_WidthH (80)
@interface PrivacyInfoViewController ()
{
    UITextField *tf_name;
    UITextField *tf_phone;

}
@end

@implementation PrivacyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];

}
-(void)viewWillAppear:(BOOL)animated
{
    [self.naviController setNaviBarTitle:@"隐私信息"];
    [self.naviController setNaviBarTitleStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NAVTITLE_COLOR_KEY,[UIFont systemFontOfSize:20.0],NAVTITLE_FONT_KEY,nil]];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];

}
- (void)buildUI
{
    
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    UIView *viewB1  = [[UIView alloc]initWithFrame:CGRectMake(15,84,SCREEN_WIDTH - 30,backView_Height)];
    viewB1.layer.borderWidth = 1;
    viewB1.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    viewB1.layer.cornerRadius = 4;
    viewB1.layer.masksToBounds=YES;
    // viewA.backgroundColor=[UIColor blueColor];
    [self.view addSubview:viewB1];
  //  UIView *viewA  = [self setupTableViewCellSubView:CGRectMake(20, 5, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"手机号"];
    tf_name = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, viewB1.frame.size.width, backView_Height)];
    tf_name.clearButtonMode = UITextFieldViewModeWhileEditing;
    //mPassword.delegate = self;
    tf_name.borderStyle = UITextBorderStyleNone;
    tf_name.placeholder = @"请输入姓名";
    tf_name.keyboardType=UIKeyboardTypeNumberPad;
    tf_name.returnKeyType=UIReturnKeyNext;
    tf_name.secureTextEntry = YES;
    tf_name.font = [UIFont systemFontOfSize:15];
  //  [viewB1 addSubview:viewA];
    [viewB1 addSubview:tf_name];
    
    
    UIView *viewB2  = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(viewB1.frame)+17,SCREEN_WIDTH - 30,backView_Height)];
    viewB2.layer.borderWidth = 1;
    viewB2.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    viewB2.layer.cornerRadius = 4;
    viewB2.layer.masksToBounds=YES;
    [self.view addSubview:viewB2];
   // UIView *viewA2  = [self setupTableViewCellSubView:CGRectMake(0, 5, 50, LABELCELL_Height) andTitle:@"设置新密码"];
    tf_phone =[[UITextField alloc] initWithFrame:CGRectMake(15, 0, viewB2.frame.size.width, backView_Height)];
    
    tf_phone.clearButtonMode = UITextFieldViewModeWhileEditing;
    //mPassword2.backgroundColor=[UIColor redColor];
    //mPassword.delegate = self;
    tf_phone.borderStyle = UITextBorderStyleNone;
    tf_phone.placeholder = @"请输入手机号";
    tf_phone.keyboardType=UIKeyboardTypeNumberPad;
    tf_phone.returnKeyType=UIReturnKeyNext;
   
    tf_phone.font = [UIFont systemFontOfSize:15];
    //[viewB2 addSubview:viewA2];
    [viewB2 addSubview:tf_phone];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=COLOR(217, 44,35, 1);
    
    // [button setBackgroundImage:image forState:UIControlStateNormal];
    button.layer.cornerRadius=5;
    //   [button setFrame:CGRectMake(20, view.frame.size.height *3/4, SCREEN_WIDTH - 40, 50)];
    [button setFrame:CGRectMake(15, SCREEN_HEIGHT-backView_Height-40, SCREEN_WIDTH - 30, backView_Height)];
    [button setTitle:@"确认" forState:UIControlStateNormal];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //[self requestData];
        [self OnRegisterClick];
        
    }];
    
    
    
    [self.view addSubview:button];
    
}
- (void)OnRegisterClick{
    
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
