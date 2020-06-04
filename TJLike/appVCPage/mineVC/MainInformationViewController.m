//
//  MainInformationViewController.m
//  TJLike
//
//  Created by MC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "MainInformationViewController.h"
#import "AutoAlertView.h"
#import "ModifyPasswordViewController.h"
#import "DatePickView.h"
#import "SexPickerView.h"
#import "WTVAlertView.h"
#import "TJUserInfoEditViewModel.h"
#import "UIImageView+WebCache.h"
#import <ShareSDK/ShareSDK.h>
#import "TJMainTiePhoneViewController.h"
#import "PrivacyInfoViewController.h"
#import "ImageHelper.h"

@interface MainInformationViewController ()<WTVAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    UIImageView *iconView;
    UITextField *nameLabel;
    UITextField *signLabel;
    UITextField *numLabel;
    UITextField *birthLabel;
    UITextField *sexLabel;
    UITextField *weiboLabel;
    NSDateFormatter *dateFormatter;
    
    UIButton *manBut;
    UIButton *womanBut;
    BOOL isEdit;
    UIScrollView *scrollView;
    
   // NSString *sexStr;
    
}
/**
 *  相册，图库选择器
 */
@property (nonatomic, strong) UIImagePickerController *pickerVC;

@property (nonatomic, strong) TJUserInfoEditViewModel *viewModel;

@end

@implementation MainInformationViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"编辑资料"];
    [self.naviController setNaviBarTitleStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NAVTITLE_COLOR_KEY,[UIFont systemFontOfSize:20.0],NAVTITLE_FONT_KEY,nil]];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
      [self InitInfo];
  //  [self.naviController setNaviBarRightBtn:[self GetRightBtn]];
}



- (void)OnModifyClick {
    /*
     nameLabel;
     signLabel;
     numLabel;
     birthLabel;
     sexLabel*/
    if (nameLabel.text.length == 0) {
        [AutoAlertView ShowMessage:@"请填写昵称"];
        return;
    }
    if (signLabel.text.length == 0) {
        signLabel.text =@"";
    }
    if (birthLabel.text.length == 0) {
        birthLabel.text =@"";
    }
    if (nameLabel.text.length == 0) {
        [AutoAlertView ShowMessage:@"请填写昵称"];
        return;
    }
    NSString *sex = @"";
    //NSString *sexStr;
    if (womanBut.selected==NO && manBut.selected==NO) {
        [AutoAlertView ShowMessage:@"请填写性别"];
        return;

    }
    else
    {  if(womanBut.selected==YES ){
          sex = @"0";
        //  sexStr=@"女";
        
    }
    else{
        sex = @"1";
      //  sexStr=@"男";

    }
    
    }
   //??????wentiwentiwentiwentiwentiwentiwentiwentiwenti

    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/UpdateUserInfo"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:UserManager.userInfor.userId forKey:@"uid"];
    
    NSString *modifyNickName=@"2";
    
    if ([nameLabel.text isEqualToString:UserManager.userInfor.nickName]) {
        
        modifyNickName=@"2";
    }
    else
    {
        modifyNickName=@"1";
        [dict setObject:nameLabel.text forKey:@"nickname"];

        
    }
    [dict setObject:modifyNickName forKey:@"modifynickname"];
    [dict setObject:signLabel.text forKey:@"signature"];
    [dict setObject:birthLabel.text forKey:@"birthday"];
    [dict setObject:sex forKey:@"sex"];
    
   [HttpClient request:dict URL:urlStr success:^(NSDictionary *info) {
        NSLog(@"修改信息----》%@",info);
        [AutoAlertView ShowMessage:@"修改成功"];
        UserManager.userInfor.nickName = nameLabel.text;
        UserManager.userInfor.signature= signLabel.text;
        UserManager.userInfor.birthday = birthLabel.text;
        UserManager.userInfor.sex = sex;
        self.mBlock();
        [self.naviController popViewControllerAnimated:YES];
        
   } fail:^{
       [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
   }];
    
}



- (void)InitInfo{
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:UserManager.userInfor.weiboicon]];
    
    UIImageView *imageViewB = [[UIImageView alloc] init];
    [imageViewB sd_setImageWithURL:[NSURL URLWithString:UserManager.userInfor.icon]];
    
    
    [iconView sd_setImageWithURL:(imageViewB.image?[NSURL URLWithString:UserManager.userInfor.icon]:[NSURL URLWithString:UserManager.userInfor.weiboicon]) placeholderImage:[UIImage imageNamed:@"head-portrait@2x.png"]];
    nameLabel.text = UserManager.userInfor.nickName;
    signLabel.text = UserManager.userInfor.signature;
    birthLabel.text = UserManager.userInfor.birthday;
   // NSLog(@"---->%@",UserManager.userInfor.userPhone);
   // NSLog(@"---->%@",UserManager.userInfor.weibo);
    if (UserManager.userInfor.userPhone) {
        numLabel.text = UserManager.userInfor.userPhone;
        
    }else{
        numLabel.text = @"未绑定";
    }
    if (UserManager.userInfor.weibo) {
        weiboLabel.text = @"已绑定";
    }else{
        weiboLabel.text = @"未绑定";
    }
    
    NSString *sex = [NSString stringWithFormat:@"%@",UserManager.userInfor.sex];
    if ([sex isEqualToString:@"0"]) {
        // sexStr = @"女";
        womanBut.selected=YES;
        manBut.selected=NO;
        
    }else{
       // sexStr = @"男";
        womanBut.selected=NO;
        manBut.selected=YES;
    }
}
- (void)NameLabelClick{
    WTVAlertView *alert = [[WTVAlertView alloc] initWithTitle:@"修改您的昵称" message:nil delegate:self textFieldPlaceholders:@[@"输入昵称"] specialLine:nil limits:@[[NSNumber numberWithInt:11]] cancelButton:@"取消" otherButton:@"确认"];
    alert.tag = 1;
    [alert show];
}

-(void)showSignatureEditAlert
{
    WTVAlertView *alert = [[WTVAlertView alloc] initWithTitle:@"修改您的个性签名" message:nil delegate:self textFieldPlaceholders:@[@"输入个性签名"] specialLine:nil limits:@[[NSNumber numberWithInt:50]] cancelButton:@"取消" otherButton:@"确认"];
    alert.tag = 2;
    [alert show];
}
-(void)ModifyPrivacyInfo
{
    PrivacyInfoViewController *pri=[[PrivacyInfoViewController alloc]init];
    [self.navigationController pushViewController:pri animated:YES];

}

#pragma mark - alert show
-(void)showIconEditAlert
{
    WTVAlertView *alert = [[WTVAlertView alloc] initWithTitle:@"设置您的头像" message:nil delegate:self buttonTitles:@[@"照相",@"从图库选择"] buttonImageNames:@[@"systemCamera",@"systemPhotoAlbum"]];
    alert.tag = 0;
    [alert show];
}

#pragma mark - AlertView delegate
-(void)wtvAlertView:(WTVAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==0) {
        switch (buttonIndex) {
            case 0:
            {
                //相机
                [self gainPhotoFromCamera];
            }
                break;
            case 1:
            {
                //系统相册
                [self gainPhotoFromPhotogallery];
                
            }
                break;
            default:
                break;
        }
    }
    
}
-(void)wtvAlertView:(WTVAlertView *)alertView textFieldArray:(NSArray *)textArray
{
    switch (alertView.tag) {
        case 1:
        {
            if ([[textArray objectAtIndex:0] length]>12) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改失败" message:@"昵称请小于12个字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                nameLabel.text = [textArray objectAtIndex:0];
            }
        }
            break;
        case 2:
        {
            if ([[textArray objectAtIndex:0] length]>50) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改失败" message:@"个性签名请小于50个字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                signLabel.text = [textArray objectAtIndex:0];
            }
        }
            break;
        default:
            break;
    }
}
- (void)wtvAlertViewCancel:(WTVAlertView *)alertView
{
    
}
#pragma mark - choose carmer ,image library

- (void)gainPhotoFromPhotogallery
{
    _pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_pickerVC animated:YES completion:^{
        
    }];
}

- (void)gainPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        _pickerVC.mediaTypes = @[@"public.image"];
        
        [self presentViewController:_pickerVC animated:YES completion:^{
            
        }];
    }
    else{
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"请注意" message:@"设备不支持相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image = nil;
    if([type isEqualToString:@"public.image"]){
        
        if (_pickerVC.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
            
        }
        else{
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
    }
    image =[ImageHelper imageScaleWithImage:image];
    
    @weakify(self);
    [_pickerVC dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        
        [iconView setImage:image];
        //        icon
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [_viewModel uploadUserHeaderImage:UIImagePNGRepresentation(image) withUserId:UserManager.userInfor.userId andFinish:^(NSDictionary *resultDict) {
                
                [self.view makeToast:@"头像上传成功" duration:0.3 position:CSToastPositionCenter];
            } andFailed:^(NSString *error) {
                [self.view makeToast:@"头像上传失败" duration:0.3 position:CSToastPositionCenter];
            }];
        });
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_pickerVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)initImagePicker
{
    _pickerVC = [[UIImagePickerController alloc] init];
    _pickerVC.allowsEditing = YES;
    _pickerVC.delegate = self;
}

-(void)hiddenKeyBoard
{
   // [self.view endEditing:YES];
   // TLog(@"%f",_tableView.contentOffset.y);
    //    if (_tableView.contentOffset.y != 0) {
   // [_tableView setContentOffset:CGPointMake(0,-64) animated:YES];
    //    }
    [nameLabel resignFirstResponder];
    [signLabel resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.backgroundColor = COLOR(246,246,246,1);
    // 设置内容大小
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+180);
    // 是否反弹
      scrollView.bounces = NO;
      [self.view addSubview:scrollView];
    
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
          [self.view addGestureRecognizer:tap];
    
    [self initImagePicker];
    
    _viewModel = [[TJUserInfoEditViewModel alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    double backView_Height ;
    double LABELCELL_WidthH =80;
    double LABELCELL_Height ;
    double iconH ;
    double y;
    
    
    if (SCREEN_HEIGHT==480) {
        iconH =62 ;
        y=7;
        backView_Height =35;
        LABELCELL_Height =26;
    }
    else
    {
        backView_Height =46;
        
        LABELCELL_Height =35;
        iconH=92;
        y=17;
        
    }
    iconView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 25, iconH, iconH)];
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = iconH*0.5;
    iconView.userInteractionEnabled = YES;
    [scrollView addSubview:iconView];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = iconView.bounds;
    btn.backgroundColor = [UIColor clearColor];
   // [btn setTitle:@"上传头像" forState:UIControlStateNormal];
   // btn.tintColor=[UIColor whiteColor];
    [btn addTarget:self action:@selector(showIconEditAlert) forControlEvents:UIControlEventTouchUpInside];
    [iconView addSubview:btn];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(SCREEN_WIDTH-100, 7+iconH/2, 80, 40);
    bt.backgroundColor = [UIColor clearColor];
    [bt setTitle:@"上传头像" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(showIconEditAlert) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:bt];
    
    UIView *viewB1  = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(iconView.frame)+y,SCREEN_WIDTH - 30,backView_Height)];
    viewB1.layer.borderWidth = 1;
    viewB1.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    viewB1.layer.cornerRadius = 4;
    viewB1.layer.masksToBounds=YES;
    [scrollView addSubview:viewB1];
    UIView *viewA1  = [self setupTableViewCellSubView:CGRectMake(20, 5, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"昵称"];
    [viewB1 addSubview:viewA1];
    nameLabel = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewA1.frame)+ 5, 0, viewB1.frame.size.width - viewA1.frame.size.width - viewA1.frame.origin.x, backView_Height)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.delegate=self;
    nameLabel.placeholder=@"请输入昵称";
    [viewB1 addSubview:nameLabel];
    
    
    UIView *viewB2  = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(viewB1.frame)+y,SCREEN_WIDTH - 30,backView_Height)];
    viewB2.layer.borderWidth = 1;
    viewB2.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    viewB2.layer.cornerRadius = 4;
    viewB2.layer.masksToBounds=YES;
    [scrollView addSubview:viewB2];
    
    UIView *viewA2  = [self setupTableViewCellSubView:CGRectMake(20, 5, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"性别"];
    [viewB2 addSubview:viewA2];
    manBut = [UIButton buttonWithType:UIButtonTypeCustom];
    manBut.backgroundColor=[UIColor clearColor];
    manBut.layer.cornerRadius=5;
    [manBut setFrame:CGRectMake(CGRectGetMaxX(viewA2.frame)+2,5, 100, LABELCELL_Height)];
    [manBut setImage:[UIImage imageNamed:@"nan@3x.png"] forState:UIControlStateNormal];
    [manBut setImage:[UIImage imageNamed:@"nv@3x.png"] forState:UIControlStateSelected];
    [manBut addTarget:self action:@selector(cheakButton1:) forControlEvents:UIControlEventTouchUpInside ];
    [viewB2 addSubview:manBut];
    UILabel *sexlab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 20, LABELCELL_Height)];
    [sexlab setTextAlignment:NSTextAlignmentLeft];
    [sexlab setText:@"男"];
    [sexlab  setFont:[UIFont systemFontOfSize:16]];
    [sexlab setTextColor:[UIColor blackColor]];
    [manBut addSubview:sexlab];
    
    womanBut = [UIButton buttonWithType:UIButtonTypeCustom];
    womanBut.backgroundColor=[UIColor clearColor];
    womanBut.layer.cornerRadius=5;
    [womanBut setFrame:CGRectMake(CGRectGetMaxX(manBut.frame)+2,5, 100, LABELCELL_Height)];
    [womanBut setImage:[UIImage imageNamed:@"nan@3x.png"] forState:UIControlStateNormal];
    [womanBut setImage:[UIImage imageNamed:@"nv@3x.png"] forState:UIControlStateSelected];
    [womanBut addTarget:self action:@selector(cheakButton2:) forControlEvents:UIControlEventTouchUpInside ];
    [viewB2 addSubview:womanBut];
    UILabel *sexlab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, LABELCELL_Height)];
    [sexlab1 setTextAlignment:NSTextAlignmentLeft];
    [sexlab1 setText:@"女"];
    [sexlab1  setFont:[UIFont systemFontOfSize:16]];
    [sexlab1 setTextColor:[UIColor blackColor]];
    [womanBut addSubview:sexlab1];
    
    
    UIView *viewB3  = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(viewB2.frame)+y,SCREEN_WIDTH - 30,backView_Height)];
    viewB3.layer.borderWidth = 1;
    viewB3.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    viewB3.layer.cornerRadius = 4;
    viewB3.layer.masksToBounds=YES;
    [scrollView addSubview:viewB3];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = viewB3.bounds;
    btn1.backgroundColor = [UIColor clearColor];
    [btn1 addTarget:self action:@selector(BirthLabelClick) forControlEvents:UIControlEventTouchUpInside];
    [viewB3 addSubview:btn1];
    UIView *viewA3  = [self setupTableViewCellSubView:CGRectMake(20, 5, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"生日"];
    [viewB3 addSubview:viewA3];
    birthLabel = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewA3.frame)+ 5, 0, viewB3.frame.size.width - viewA3.frame.size.width - viewA3.frame.origin.x, backView_Height)];
    birthLabel.inputAccessoryView = [self GetInputAccessoryView];
    birthLabel.backgroundColor = [UIColor clearColor];
    birthLabel.textColor = [UIColor grayColor];
    birthLabel.font = [UIFont systemFontOfSize:17];
    birthLabel.enabled = NO;
    [viewB3 addSubview:birthLabel];
    
    UIImageView *inmageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(birthLabel.frame)-30, 15, 10, 15)];
    inmageView.image=[UIImage imageNamed:@"return.png"];
    [birthLabel addSubview:inmageView];
    
    
    UIView *viewB4  = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(viewB3.frame)+y,SCREEN_WIDTH - 30,backView_Height)];
    viewB4.layer.borderWidth = 1;
    viewB4.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    viewB4.layer.cornerRadius = 4;
    viewB4.layer.masksToBounds=YES;
    [scrollView addSubview:viewB4];
    UIView *viewA4  = [self setupTableViewCellSubView:CGRectMake(20, 5, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"个性签名"];
    [viewB4 addSubview:viewA4];
    signLabel = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewA4.frame)+ 5, 0, viewB4.frame.size.width - viewA4.frame.size.width - viewA4.frame.origin.x, backView_Height)];
    signLabel.delegate=self;
    signLabel.tag=1000;
    signLabel.backgroundColor = [UIColor clearColor];
    signLabel.textColor = [UIColor blackColor];
    signLabel.placeholder=@"请输入个性签名";
    signLabel.font = [UIFont systemFontOfSize:18];
    [viewB4 addSubview:signLabel];
    
    
    UIView *viewB5  = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(viewB4.frame)+y,SCREEN_WIDTH - 30,backView_Height)];
    viewB5.layer.borderWidth = 1;
    viewB5.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    viewB5.layer.cornerRadius = 4;
    viewB5.layer.masksToBounds=YES;
    [scrollView addSubview:viewB5];
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = viewB5.bounds;
    btn3.backgroundColor = [UIColor clearColor];
    [btn3 addTarget:self action:@selector(NumLabelClick) forControlEvents:UIControlEventTouchUpInside];
    [viewB5 addSubview:btn3];
    UIView *viewA5  = [self setupTableViewCellSubView:CGRectMake(20, 5, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"绑定手机"];
    [viewB5 addSubview:viewA5];
    numLabel = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewA5.frame)+ 5, 0, viewB5.frame.size.width - viewA5.frame.size.width - viewA5.frame.origin.x, backView_Height)];
    numLabel.inputAccessoryView = [self GetInputAccessoryView];
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.textColor = [UIColor grayColor];
    numLabel.font = [UIFont systemFontOfSize:17];
    numLabel.enabled = NO;
    [viewB5 addSubview:numLabel];
    UIImageView *inmageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(numLabel.frame)-30, 15, 10, 15)];
    inmageView1.image=[UIImage imageNamed:@"return.png"];
    [numLabel addSubview:inmageView1];
    
    
    UIView *viewB6  = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(viewB5.frame)+y,SCREEN_WIDTH - 30,backView_Height)];
    viewB6.layer.borderWidth = 1;
    viewB6.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    viewB6.layer.cornerRadius = 4;
    viewB6.layer.masksToBounds=YES;
    [scrollView addSubview:viewB6];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = viewB6.bounds;
    btn2.backgroundColor = [UIColor clearColor];
    [btn2 addTarget:self action:@selector(WeiboLabelClick) forControlEvents:UIControlEventTouchUpInside];
    [viewB6 addSubview:btn2];
    UIView *viewA6  = [self setupTableViewCellSubView:CGRectMake(20, 5, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"绑定微博"];
    [viewB6 addSubview:viewA6];
    weiboLabel = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewA6.frame)+ 5, 0, viewB6.frame.size.width - viewA6.frame.size.width - viewA6.frame.origin.x, backView_Height)];
    weiboLabel.inputAccessoryView = [self GetInputAccessoryView];
    weiboLabel.backgroundColor = [UIColor clearColor];
    weiboLabel.textColor = [UIColor grayColor];
    weiboLabel.font = [UIFont systemFontOfSize:17];
    weiboLabel.enabled = NO;
    [viewB6 addSubview:weiboLabel];
    UIImageView *inView2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(weiboLabel.frame)-30, 15, 10, 15)];
    inView2.image=[UIImage imageNamed:@"return.png"];
    [weiboLabel addSubview:inView2];
    
    
    UIView *viewB7  = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(viewB6.frame)+y,SCREEN_WIDTH - 30,backView_Height)];
    viewB7.layer.borderWidth = 1;
    viewB7.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    viewB7.layer.cornerRadius = 4;
    viewB7.layer.masksToBounds=YES;
    [scrollView addSubview:viewB7];
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = viewB7.bounds;
    btn4.backgroundColor = [UIColor clearColor];
    [btn4 addTarget:self action:@selector(ModifyPassword) forControlEvents:UIControlEventTouchUpInside];
    [viewB7 addSubview:btn4];
    UIView *viewA7  = [self setupTableViewCellSubView:CGRectMake(20, 5, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"修改密码"];
    [viewB7 addSubview:viewA7];
    UIImageView *inmageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(viewB7.frame)-30, 15, 10, 15)];
    inmageView3.image=[UIImage imageNamed:@"return.png"];
    [viewB7 addSubview:inmageView3];
    
    
    UIView *viewB8  = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(viewB7.frame)+y,SCREEN_WIDTH - 30,backView_Height)];
    viewB8.layer.borderWidth = 1;
    viewB8.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    viewB8.layer.cornerRadius = 4;
    viewB8.layer.masksToBounds=YES;
    [scrollView addSubview:viewB8];
    UIButton *btn8 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn8.frame = viewB8.bounds;
    btn8.backgroundColor = [UIColor clearColor];
    [btn8 addTarget:self action:@selector(ModifyPrivacyInfo) forControlEvents:UIControlEventTouchUpInside];
    [viewB8 addSubview:btn8];
    UIView *viewA8  = [self setupTableViewCellSubView:CGRectMake(20, 5, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"隐私信息"];
    [viewB8 addSubview:viewA8];
    UIImageView *inmageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(btn8.frame)-30, 15, 10, 15)];
    inmageView4.image=[UIImage imageNamed:@"return.png"];
    [btn8 addSubview:inmageView4];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=COLOR(217, 44,35, 1);
    button.layer.cornerRadius=5;
    [button setFrame:CGRectMake(15,CGRectGetMaxY(viewB8.frame)+y, SCREEN_WIDTH - 30, backView_Height)];
    NSString *str=@"完成";;
    [button setTitle:str forState:UIControlStateNormal];
    [button addTarget:self action:@selector(OnModifyClick) forControlEvents:UIControlEventTouchUpInside ];
    [scrollView addSubview:button];
    
   
    
}
-(void)cheakButton1:(UIButton *)sender
{
    if (sender.selected==NO)
    {
        sender.selected = YES;
        womanBut.selected = NO;
        //sexStr = @"男";
   

    }
    else
    {
        if (womanBut.selected!=NO)
        {
            sender.selected = NO;
        }
    }
}
-(void)cheakButton2:(UIButton *)sender
{
    if (sender.selected==NO)
    {
        sender.selected = YES;
        manBut.selected = NO;
       // sexStr = @"女";
    }
    else
    {
        if (manBut.selected!=NO)
        {
            sender.selected = NO;
        }
    }
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
    view.frame = CGRectMake(frame.origin.x, frame.origin.y, label.frame.size.width + 5, frame.size.height);
    
    return view;
    
}
- (void)NumLabelClick{
    if (UserManager.userInfor.userPhone) {
        return;
    }
    else{
        NSLog(@"bangdingshouji");
        TJMainTiePhoneViewController *ctrl = [[TJMainTiePhoneViewController alloc]init];
        
        [self.naviController pushViewController:ctrl animated:YES];
        
    }
}
- (void)WeiboLabelClick{
    NSLog(@"绑定微博");
    
    NSDictionary *userInforDic=[SHARE_DEFAULTS objectForKey:UserLginInfo];
    if ([userInforDic objectForKey:@"weibo"]) {
        [self.view makeToast:@"此账号已绑定" duration:0.25 position:CSToastPositionCenter];
    }
    else{
        if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
            [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        }
    
        [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
            if (result) {
                NSString *strUrl = [NSString stringWithFormat:@"%@BindingWeibo",TJZOUNAI_ADDRESS_URL];
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     UserManager.userInfor.userId,@"uid",
                                     [userInfo uid],@"weibo",
                                     [userInfo profileImage],@"weiboicon",
                                     [[userInfo credential] token],@"token",
                                     nil];
              [HttpClient request:dic URL:strUrl success:^(NSDictionary *resultDic) {
                    
                    if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
                        //                        NSDictionary *resultDict = resultDic[@"data"];
                        NSMutableDictionary *userDic = [[NSMutableDictionary alloc] initWithDictionary:userInforDic];
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
                        
                        
                        [self.view makeToast:@"微博绑定成功" duration:0.25 position:CSToastPositionCenter];
                        
                        //                        TLog(@"%@",resultDict);
                        
                    }
                    else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
                        [self.view makeToast:@"微博绑定失败" duration:0.25 position:CSToastPositionCenter];
                    }
                    
              } fail:^{
                  [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
              }];

                
                
            }
            else
            {
                [self.view makeToast:@"授权失败" duration:1.0 position:[NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/4)]];
            }
        }];
        
  }
    
    
}

//- (void)SexLabelClick{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    SexPickerView *pickView = [[SexPickerView alloc]initWithFrame:window.bounds];
//    pickView.mDelegate = self;
//    pickView.okClick = @selector(SexOfUser:);
//    [window addSubview:pickView];
//}
//- (void)SexOfUser:(NSString *)sex{
//    sexLabel.text = sex;
//}
- (void)BirthLabelClick{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    DatePickView *pickView = [[DatePickView alloc]initWithFrame:window.bounds];
    pickView.mDelegate = self;
    pickView.okClick = @selector(DateOfBirth:);
    [window addSubview:pickView];
}

- (void)DateOfBirth:(NSDate *)date{
    NSString *time =  [dateFormatter stringFromDate:date];
    birthLabel.text = time;
}

- (void)ModifyPassword{
    ModifyPasswordViewController *ctrl = [[ModifyPasswordViewController alloc]init];
    [self.naviController pushViewController:ctrl animated:YES];
}
- (UIView *)GetInputAccessoryView
{
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    inputView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(inputView.frame.size.width-50, 0, 50, inputView.frame.size.height);
    [btn setTitle:@"隐藏" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(OnHideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:btn];
    
    return inputView;
}
- (void)OnHideKeyboard {
    [self.view endEditing:NO];
}


//- (void)requestSaveData {
//    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/UpdateUserInfo"];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:@"" forKey:@"nickname"];
//    [dict setObject:@"" forKey:@"uid"];
//    [dict setObject:@"" forKey:@"signature"];
//    [dict setObject:@"" forKey:@"birthday"];
//    [dict setObject:@"" forKey:@"sex"];//0女1男
//    [[HttpClient postRequestWithPath:urlStr para:dict] subscribeNext:^(NSDictionary *info) {
//        NSLog(@"info--------%@",info);
//        
//        
//    } error:^(NSError *error) {
//        HttpClient.failBlock(error);
//    }];
//    
//}

- (UIButton *)GetRightBtn{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(OnModifyClick) forControlEvents:UIControlEventTouchUpInside];
    
    return rightBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)wtvAlertPickerView:(NSString *)birthday
{
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
  
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - window.frame.size.height);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0 && textField.tag==1000) {
        self.view.frame = CGRectMake(0.0f, -offset-80, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect frame=self.view.frame;

        frame.origin.y=0;
        [UIView animateWithDuration:0.5f animations:^{
            self.view.frame=frame;
            scrollView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+180);
        }];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    isEdit=NO;
    [self.view endEditing:YES];
}




@end
