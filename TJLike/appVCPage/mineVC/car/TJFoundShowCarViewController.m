//
//  TJFoundShowCarViewController.m
//  TJLike
//
//  Created by MC on 15/4/18.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJFoundShowCarViewController.h"
#import "PutInCarNameView.h"
#import "TJFoundSeachViewController.h"

@interface TJFoundShowCarViewController ()
{
    UILabel *nameLabel;
}
@end

@implementation TJFoundShowCarViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"违章查询"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.view.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    
    UIView *mView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 70)];
    mView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mView];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 28, 28)];
    icon.image = [UIImage imageNamed:@"fonud_8_"];
    [mView addSubview:icon];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 13, 200, 20)];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [NSString stringWithFormat:@"津：%@",self.CarId];
    [mView addSubview:nameLabel];
    
    UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 43, 200, 20)];
    mLabel.textColor = [UIColor redColor];
    mLabel.font = [UIFont systemFontOfSize:18];
    mLabel.text = @"未处理违章次数0次";
    [mView addSubview:mLabel];
    
    mLabel = [[UILabel alloc]initWithFrame:CGRectMake(mView.bounds.size.width-60, 0, 50, 70)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.textColor = [UIColor blackColor];
    mLabel.font = [UIFont systemFontOfSize:30];
    mLabel.text = @"0";
    mLabel.textAlignment = NSTextAlignmentRight;
    [mView addSubview:mLabel];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(15, SCREEN_HEIGHT-150, self.view.frame.size.width-30, 44);
    [loginBtn setBackgroundColor:COLOR(194, 40, 31, 1)];
    [loginBtn setTitle:@"是否为此车辆设置限号提醒？" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn addTarget:self action:@selector(OnRegisterClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (void)OnRegisterClick{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    PutInCarNameView *view = [[PutInCarNameView alloc]initWithFrame:window.bounds];
    view.mDelegate = self;
    view.OKClick = @selector(AddCar:);
    [window addSubview:view];
}
- (void)AddCar:(NSString *)carName{
    TJFoundCarModel *model = [[TJFoundCarModel alloc]init];
    model.name = carName;
    model.num = self.CarId;
    model.limit = @"1";
    model.model = self.CarModel;
    [CarManager addCarInfo:model];
    
    
    self.mBlock();
    for (int i = 0; i<self.naviController.viewControllers.count; i++) {
        @autoreleasepool {
            UIViewController *ctrl = self.naviController.viewControllers[i];
            if ([ctrl isKindOfClass:[TJFoundSeachViewController class]]) {
                [self.naviController popToViewController:ctrl animated:YES];
                break;
            }
        }
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
