//
//  TJFoundSeachViewController.m
//  TJLike
//
//  Created by MC on 15/4/13.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJFoundSeachViewController.h"
#import "TJFountInputCarViewController.h"
#import "CarCell.h"
#import "TJFountAddCarViewController.h"
#import "TJFoundCarSettingViewController.h"
#import "TjNewsZTListViewController.h"
#import "RefreshTableView.h"
#import "AlertHelper.h"
@interface TJFoundSeachViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshTableViewDelegate>
{
    UIView *otisView;
    RefreshTableView *mTableView;
    NSMutableArray *dataArray;
}
@end

@implementation TJFoundSeachViewController


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
    NSArray *tittle=[NSArray arrayWithObjects:@"违章查询",@"限行限号",@"车务提醒",nil];
    NSArray *imaArr=[NSArray arrayWithObjects:@"carweizhang.png",@"carxianhao.png",@"cartixing.png",nil];

    dataArray = [[NSMutableArray alloc]init];
    //fonud_5_
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
       // btn.backgroundColor = UIColorFromRGB(0x333333);
        btn.frame = CGRectMake(i*SCREEN_WIDTH/3, 64, 3*SCREEN_WIDTH, 90);
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 43, 43)];
        image.image = [UIImage imageNamed:imaArr[i]];
        image.center = CGPointMake(SCREEN_WIDTH/6, 30);
        [btn addSubview:image];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH/3, 20)];
        label.text = tittle[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColorFromRGB(0x333333);
        [btn addSubview:label];
//        if (i==0) {
//            UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5-0.5, 0, 0.5, 90)];
//            lineView.backgroundColor = [UIColor grayColor];
//            [btn addSubview:lineView];
//        }
//        
//        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 89.5, SCREEN_WIDTH*0.5, 0.5)];
//        lineView.backgroundColor = [UIColor grayColor];
//        [btn addSubview:lineView];
    }
    
    mTableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 155, SCREEN_WIDTH, self.view.bounds.size.height-210)];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.mDelegate = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.mbMoreHidden = YES;
    [self.view addSubview:mTableView];
    
    
    otisView = [[UIView alloc]initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 100)];
    otisView.backgroundColor = [UIColor whiteColor];
    otisView.userInteractionEnabled = YES;
    otisView.hidden = YES;
//    [self.view addSubview:otisView];
    [mTableView setTableFooterView:otisView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    //btn.center = CGPointMake(SCREEN_WIDTH*0.5, 60);
    [btn addTarget:self action:@selector(AddCar) forControlEvents:UIControlEventTouchUpInside];
    [otisView addSubview:btn];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-22.5, 10, 45, 45)];
    image.image = [UIImage imageNamed:@"caradd.png"];
   // image.center = CGPointMake(SCREEN_WIDTH*0.25, 42.5);
    [btn addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-80, 70, 160, 20)];
    label.text = @"点击添加车辆";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = UIColorFromRGB(0x333333);
    [btn addSubview:label];
    
    [self GetData];
}
- (void)AddCar{
    TJFountAddCarViewController *ctrl = [[TJFountAddCarViewController alloc]init];
    ctrl.mBlock = ^{
        [self GetData];
    };
    [self.naviController pushViewController:ctrl animated:YES];
}
- (void)GetData{
    dataArray = CarManager.carInfoArray;
    if (dataArray.count == 0) {
        otisView.hidden = NO;
    }else{
        otisView.hidden = NO;
    }
    [mTableView reloadData];
}
- (void)BtnClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        TJFountInputCarViewController *ctrl = [[TJFountInputCarViewController alloc]init];
        ctrl.mBlock = ^{
            [self GetData];
        };
        [self.naviController pushViewController:ctrl animated:YES];
    }
    else if (sender.tag == 1001){
        TjNewsZTListViewController *Ctrl = [[TjNewsZTListViewController alloc]init];
        Ctrl.ztid = @"1";
        [self.naviController pushViewController:Ctrl animated:YES];
    }
    else
    {
        if (dataArray.count==0) {
            [AlertHelper singleMBHUDShow:@"请添加车辆" ForView:self.view AndDelayHid:1];
        }
        else
        {
       
        TJFoundCarSettingViewController *ctrl = [[TJFoundCarSettingViewController alloc]init];
        ctrl.indexPath = 0;
        ctrl.mBlock = ^{
            [self GetData];
        };
        [self.naviController pushViewController:ctrl animated:YES];

        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)ReloadList:(RefreshTableView *)sender {
    [self GetData];
    [mTableView FinishLoading];
    [mTableView reloadData];
}
- (BOOL)CanRefreshTableView:(RefreshTableView *)sender{
    return YES;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    CarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [cell LoadContent:dataArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    TJFoundCarSettingViewController *ctrl = [[TJFoundCarSettingViewController alloc]init];
    ctrl.indexPath = indexPath.row;
    ctrl.mBlock = ^{
        [self GetData];
    };
    [self.naviController pushViewController:ctrl animated:YES];
  
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
