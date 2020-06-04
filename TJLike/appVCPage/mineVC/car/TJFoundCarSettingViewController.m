//
//  TJFoundCarSettingViewController.m
//  TJLike
//
//  Created by MC on 15/4/18.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJFoundCarSettingViewController.h"
#import "TJFoundCarModel.h"
#import "DatePickView.h"

@interface TJFoundCarSettingViewController ()
{
    UILabel *mLabel1;
    UILabel *mLabel2;
    UILabel *mLabel3;
    UILabel *mLabel4;
    
    UIButton *button;
    
    TJFoundCarModel *carModel;
    
    NSDateFormatter *dateFormatter;
}
@end

@implementation TJFoundCarSettingViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"车务提醒"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSArray *imageArray = @[@"carxianxing.png",@"carnianjian.png",@"carxubao.png",@"carhuanzheng.png"];
    NSArray *titleArray = @[@"车辆限行提醒",@"车辆年检提醒",@"车辆续保提醒",@"驾照换证提醒"];
    for (int i = 0; i<4; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 74+i*70, SCREEN_WIDTH, 70)];
        view.backgroundColor = [UIColor whiteColor];
        view.userInteractionEnabled = YES;
        [self.view addSubview:view];
        
        for (int j = 0; j<2; j++) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, j*69.5, SCREEN_WIDTH, 0.5)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:lineView];
        }
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 30, 30)];
        icon.image = [UIImage imageNamed:imageArray[i]];
        [view addSubview:icon];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(70, 15, 200, 20)];
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:18];
        title.textColor = [UIColor darkGrayColor];
        title.text = titleArray[i];
        [view addSubview:title];
        
        UILabel *bLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 35, 200, 20)];
        bLabel.backgroundColor = [UIColor clearColor];
        bLabel.font = [UIFont systemFontOfSize:17];
        bLabel.textColor = [UIColor grayColor];
        [view addSubview:bLabel];
        
        if (i==0) {
            mLabel1 = bLabel;
        }else if(i==1){
            mLabel2 = bLabel;
        }else if(i==2){
            mLabel3 = bLabel;
        }else if(i==3){
            mLabel4 = bLabel;
        }
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH-80, 22, 70, 40);
        [btn setTitle:i==0?@"关闭":@"设置" forState:UIControlStateNormal];
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ btn setBackgroundColor:UIColorFromRGB(0xcccccc) ];
         btn.layer.cornerRadius=15;
        [view addSubview:btn];
        if (i==0) {
            button = btn;
        }
    }
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(15, SCREEN_HEIGHT-150, self.view.frame.size.width-30, 44);
    [loginBtn setBackgroundColor:COLOR(194, 40, 31, 1)];
    [loginBtn setTitle:@"删除该车辆信息" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn addTarget:self action:@selector(OnRegisterClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    
    carModel = [CarManager CarInfoAtIndexPath:self.indexPath];
    [self GetData];
}
- (void)BtnClick:(UIButton *)sender{
    if (sender.tag==1000) {
        [self DealLimit];
    }else if (sender.tag == 1001){
        [self DealCheck];
    }else if (sender.tag == 1002){
        [self DealBaoxian];
    }else if (sender.tag == 1003){
        [self DealJiazhao];
    }
}

- (void)SaveData{
    [CarManager ReplaceCarInfoAtIndexPath:self.indexPath With:carModel];
}
- (void)DealJiazhao{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    DatePickView *pickView = [[DatePickView alloc]initWithFrame:window.bounds];
    pickView.mDelegate = self;
    pickView.okClick = @selector(DateOfJiazhao:);
    [window addSubview:pickView];
}
- (void)DateOfJiazhao:(NSDate *)date{
    NSString *time =  [dateFormatter stringFromDate:date];
    carModel.jiazhao = time;
    [self GetData];
    [self SaveData];
    
    if ([carModel.jiazhao isEqualToString:@""]) {
        
    }else{
        NSString *title = [NSString stringWithFormat:@"需于%@前换证",carModel.jiazhao];
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        if (notification) {
            // 设置通知的提醒时间
            notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
            notification.fireDate = [dateFormatter dateFromString:carModel.jiazhao];
            
            // 设置提醒的文字内容
            notification.alertBody   = title;
            notification.alertAction = NSLocalizedString(title, nil);
            
            // 通知提示音 使用默认的
            notification.soundName= UILocalNotificationDefaultSoundName;
            
            // 设置应用程序右上角的提醒个数
            notification.applicationIconBadgeNumber++;
            
            // 设定通知的userInfo，用来标识该通知
            NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
            [aUserInfo setObject:@"LocalNotificationID" forKey:@"kLocalNotificationID"];
            notification.userInfo = aUserInfo;
            
            // ios8后，需要添加这个注册，才能得到授权
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                // 通知重复提示的单位，可以是天、周、月
                notification.repeatInterval = 0;
            } else {
                // 通知重复提示的单位，可以是天、周、月
                notification.repeatInterval = 0;
            }
            
            // 将通知添加到系统中
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}
- (void)DealBaoxian{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    DatePickView *pickView = [[DatePickView alloc]initWithFrame:window.bounds];
    pickView.mDelegate = self;
    pickView.okClick = @selector(DateOfBaoxian:);
    [window addSubview:pickView];
}
- (void)DateOfBaoxian:(NSDate *)date{
    NSString *time =  [dateFormatter stringFromDate:date];
    carModel.baoxian = time;
    [self GetData];
    [self SaveData];
    if ([carModel.baoxian isEqualToString:@""]) {
        
    }else{
        NSString *title = [NSString stringWithFormat:@"需于%@前续保",carModel.baoxian];
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        if (notification) {
            // 设置通知的提醒时间
            notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
            notification.fireDate = [dateFormatter dateFromString:carModel.baoxian];
            
            
            // 设置提醒的文字内容
            notification.alertBody   = title;
            notification.alertAction = NSLocalizedString(title, nil);
            
            // 通知提示音 使用默认的
            notification.soundName= UILocalNotificationDefaultSoundName;
            
            // 设置应用程序右上角的提醒个数
            notification.applicationIconBadgeNumber++;
            
            // 设定通知的userInfo，用来标识该通知
            NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
            [aUserInfo setObject:@"LocalNotificationID" forKey:@"kLocalNotificationID"];
            notification.userInfo = aUserInfo;
            
            // ios8后，需要添加这个注册，才能得到授权
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                // 通知重复提示的单位，可以是天、周、月
                notification.repeatInterval = 0;
            } else {
                // 通知重复提示的单位，可以是天、周、月
                notification.repeatInterval = 0;
            }
            
            // 将通知添加到系统中
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}
- (void)DealCheck{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    DatePickView *pickView = [[DatePickView alloc]initWithFrame:window.bounds];
    pickView.mDelegate = self;
    pickView.okClick = @selector(DateOfCheck:);
    [window addSubview:pickView];
}
- (void)DateOfCheck:(NSDate *)date{
    NSLog(@"---->%@",date);
    NSString *time =  [dateFormatter stringFromDate:date];
    carModel.check = time;
    [self GetData];
    [self SaveData];
    // 初始化本地通知对象
    if ([carModel.check isEqualToString:@""]) {
        
    }else{
        NSString *title = [NSString stringWithFormat:@"需于%@前车检",carModel.check];
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        if (notification) {
            // 设置通知的提醒时间
            notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
            notification.fireDate = [dateFormatter dateFromString:carModel.baoxian];
            
            // 设置提醒的文字内容
            notification.alertBody   = title;
            notification.alertAction = NSLocalizedString(title, nil);
            
            // 通知提示音 使用默认的
            notification.soundName= UILocalNotificationDefaultSoundName;
            
            // 设置应用程序右上角的提醒个数
            notification.applicationIconBadgeNumber++;
            
            // 设定通知的userInfo，用来标识该通知
            NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
            [aUserInfo setObject:@"LocalNotificationID" forKey:@"kLocalNotificationID"];
            notification.userInfo = aUserInfo;
            
            // ios8后，需要添加这个注册，才能得到授权
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                // 通知重复提示的单位，可以是天、周、月
                notification.repeatInterval = 0;
            } else {
                // 通知重复提示的单位，可以是天、周、月
                notification.repeatInterval = 0;
            }
            
            // 将通知添加到系统中
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}
- (void)DealLimit{
    if ([carModel.limit intValue]==0) {
        carModel.limit = @"1";
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        mLabel1.text = @"该功能已经开启";
    }else{
        carModel.limit = @"0";
        [button setTitle:@"开启" forState:UIControlStateNormal];
        mLabel1.text = @"该功能已经关闭";
    }
}
- (void)GetData{
    
    if ([carModel.limit intValue]==0) {
        [button setTitle:@"开启" forState:UIControlStateNormal];
        mLabel1.text = @"该功能已经关闭";
    }else{
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        mLabel1.text = @"该功能已经开启";
    }
    
    if ([carModel.check isEqualToString:@""]) {
        mLabel2.text = @"该功能未开启";
    }else{
        mLabel2.text = [NSString stringWithFormat:@"需于%@前年检",carModel.check];
    }
    
    if ([carModel.baoxian isEqualToString:@""]) {
        mLabel3.text = @"该功能未开启";
    }else{
        mLabel3.text = [NSString stringWithFormat:@"需于%@前续保",carModel.baoxian];
    }
    
    if ([carModel.jiazhao isEqualToString:@"0"]) {
        mLabel4.text = @"该功能未开启";
    }else{
        mLabel4.text = [NSString stringWithFormat:@"需于%@前换证",carModel.jiazhao];
    }
    
}
- (void)OnRegisterClick{
    [CarManager removeCarInfo:self.indexPath];
    self.mBlock();
    [self.naviController popViewControllerAnimated:YES];
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
