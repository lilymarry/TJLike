//
//  TJFuliViewController.m
//  TJLike
//
//  Created by imac-1 on 16/8/22.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "TJFuliViewController.h"

#import "UIImageView+WebCache.h"
#import "WebApi.h"
#import "FuLiViewCell.h"
#import "TJFuliModel.h"
#import "FuLiDetailViewController.h"
#import "HuoDongDetailViewController.h"
#import "AlertHelper.h"
#import "HuoDongViewCell.h"
#import "HuoDongModel.h"
#import "WTVHomePosterView.h"
#import "FuLiTittleImaCell.h"
#import "HuoDongTittleImaCell.h"
#define NaviBtnTitles @[@"福利",@"活动"]
@interface TJFuliViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSString *strSelect;
    
    NSMutableArray * fuliList;
    NSMutableArray * huoDongList;
    NSMutableArray *FULiimaArr;
    NSMutableArray *huoDongimaArr;
    
    NSDate *nowDate;
    
}

@property (nonatomic,strong) NSMutableArray *navBtns;
@property (nonatomic, strong)UIButton       *preBtn;
@property (nonatomic, strong)UIButton       *curBtn;
@property (nonatomic, strong)UITableView    *tableView;
//@property (nonatomic, strong) WTVHomePosterView *posterView;

@end
@implementation TJFuliViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _navBtns = [[NSMutableArray alloc] init];
        
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    fuliList =[NSMutableArray array];
    huoDongList=[NSMutableArray array];
    FULiimaArr=[NSMutableArray array];
    huoDongimaArr=[NSMutableArray array];
    
  //  NSDate *dates = [NSDate date];
    nowDate = [NSDate date];
    
//    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
//    [formatter setTimeZone:timeZone];
//    nowtime = [formatter stringFromDate:dates];
    
    
}
- (void)requestDataWithHuodong
{
    
    [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
    [[WebApi sharedRequest]GetHongDongListWithSuccess:^(NSDictionary *response){
        [AlertHelper hideAllHUDsForView:self.view];
        
        //    NSLog(@"BBBBBQQ!  %@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            
            NSArray *dicArray=response[@"data"];
            [huoDongList removeAllObjects];
            //   [fuliList removeAllObjects];
            for (NSDictionary *item in dicArray) {
                HuoDongModel *model = [[HuoDongModel alloc] initWithDic:item];
                
                [huoDongList addObject:model];
            }
            [_tableView reloadData];
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            [AlertHelper singleMBHUDShow:[response objectForKey:@"msg"] ForView:self.view AndDelayHid:1];
        }
        else
        {
            [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
            
        }
        
        
    } fail:^(){
        [AlertHelper hideAllHUDsForView:self.view];
        
        [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
        
    }];
    
    
}
- (void)requestDataWithFuli
{
    [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
    [[WebApi sharedRequest]GetFuliListWithSuccess:^(NSDictionary *response){
        [AlertHelper hideAllHUDsForView:self.view];
        NSLog(@"111AAAAAAA %@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            
            NSArray *dicArray=response[@"data"];
            [fuliList removeAllObjects];
            //  [huoDongList removeAllObjects];
            for (NSDictionary *item in dicArray) {
                TJFuliModel *model = [[TJFuliModel alloc] initWithDic:item];
                
                [fuliList addObject:model];
            }
            [_tableView reloadData];
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            [AlertHelper singleMBHUDShow:[response objectForKey:@"msg"] ForView:self.view AndDelayHid:1];
            
        }
        
        else
        {
            [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
            
        }
        
    } fail:^(){
        
        [AlertHelper hideAllHUDsForView:self.view];
        
        [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
        
    }];
    
}
- (void)requestDataWithHuodongTittleView
{
    
    [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
    [[WebApi sharedRequest]GetHongDongListWithIsFocus:@"1" Success:^(NSDictionary *response){
        [AlertHelper hideAllHUDsForView:self.view];
        
        //    NSLog(@"BBBBBQQ!  %@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            
            NSArray *dicArray=response[@"data"];
            [huoDongimaArr removeAllObjects];
            //  [FULiimaArr removeAllObjects];
            for (NSDictionary *item in dicArray) {
                HuoDongModel *model = [[HuoDongModel alloc] initWithDic:item];
                
                [huoDongimaArr addObject:model];
            }
            [_tableView reloadData];
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            [AlertHelper singleMBHUDShow:[response objectForKey:@"msg"] ForView:self.view AndDelayHid:1];
        }
        else
        {
            [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
            
        }
        
        
    } fail:^(){
        [AlertHelper hideAllHUDsForView:self.view];
        
        [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
        
    }];
    
    
}
- (void)requestDataWithFuliTittleView
{
    [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
    [[WebApi sharedRequest]GetFuliListWithIsFocus:@"1" Success:^(NSDictionary *response){
        [AlertHelper hideAllHUDsForView:self.view];
        //  NSLog(@"AAAAAAA %@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            
            NSArray *dicArray=response[@"data"];
            [FULiimaArr removeAllObjects];
            //  [huoDongimaArr removeAllObjects];
            for (NSDictionary *item in dicArray) {
                TJFuliModel *model = [[TJFuliModel alloc] initWithDic:item];
                
                [FULiimaArr addObject:model];
            }
            
            [_tableView reloadData];
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            [AlertHelper singleMBHUDShow:[response objectForKey:@"msg"] ForView:self.view AndDelayHid:1];
            
        }
        
        else
        {
            [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
            
        }
        
    } fail:^(){
        
        [AlertHelper hideAllHUDsForView:self.view];
        
        [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
        
    }];
}
- (void)initialNaviBar
{
    
    for (int i = 0 ; i<NaviBtnTitles.count; i++) {
        UIButton *btncenter = [TJBaseNaviBarView createNaviBarBtnByTitle:    [NaviBtnTitles objectAtIndex:i] imgNormal:nil imgHighlight:nil imgSelected:@"redline.png" withFrame:CGRectMake(i *10, 25, 50,30)];
        [btncenter.layer setMasksToBounds:YES];
        btncenter.layer.cornerRadius = 10;
        [btncenter setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        // [btncenter setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btncenter setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btncenter.tag = 100 +i;
        
        @weakify(self)
        [[btncenter rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if (self.preBtn.tag != btncenter.tag) {
                btncenter.selected = YES;
                self.curBtn = btncenter;
                self.preBtn.selected = NO;
                
                if (btncenter.tag == 100 ) {
                    strSelect=@"100";
                    [self requestDataWithFuli];
                    [self requestDataWithFuliTittleView];
                    
                }
                else if (btncenter.tag == 101)
                {
                    strSelect=@"101";
                    [self requestDataWithHuodong];
                    [self requestDataWithHuodongTittleView];
                    
                    
                    
                }
                _preBtn = btncenter;
            }
            
        }];
        [_navBtns addObject:btncenter];
    }
    [self.naviController setNaviBarCenterBtnsWithButtonArray:_navBtns];
    
    _preBtn = [_navBtns objectAtIndex:0];
    _preBtn.selected = YES;
    
}

- (void)setupContentView
{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIBAR_HEIGHT + STATUSBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT -(NAVIBAR_HEIGHT + STATUSBAR_HEIGHT)) style:UITableViewStylePlain];
    _tableView.separatorStyle=UITableViewCellAccessoryNone;
    //   NSLog(@"%@",NSStringFromCGRect(_tableView.frame));
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor=COLOR(246, 246, 246, 1);
    [self.view addSubview:_tableView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.naviController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    if (_navBtns.count) {
        [_navBtns removeAllObjects];
    }
    [self setupContentView];
    [self initialNaviBar];
    // [timer invalidate];
    strSelect=@"100";
    [self requestDataWithFuli];
    [self requestDataWithFuliTittleView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if ([strSelect isEqualToString:@"100"]) {
        if (FULiimaArr.count>0) {
            return fuliList.count+1;
            
        }
        return fuliList.count;
    }
    else
    {
        if (huoDongimaArr.count>0) {
            return huoDongList.count+1;
        }
        
        return huoDongList.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((FULiimaArr.count>0 && indexPath.row==0)||(huoDongimaArr.count>0 && indexPath.row==0)) {
        return 165.f;
    }
    else
        return 223;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([strSelect isEqualToString:@"100"]) {
        if (FULiimaArr.count>0 && indexPath.row==0) {
            static NSString *CellIdentifier = @"Cell1";
            FuLiTittleImaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FuLiTittleImaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                /// cell.mRootCtrl =[self vi].navigationController;
            }
            [cell LoadContent:FULiimaArr];
            return cell;
            
        }
        
        else
        {
            static NSString *CustomCellIdentifier = @"Cell2";
            FuLiViewCell *cell = (FuLiViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
            if (!cell) {
                NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FuLiViewCell" owner:nil options:nil];
                cell= [nibView lastObject];
            }
            TJFuliModel *model = nil;
            if (FULiimaArr.count>0) {
                model = [fuliList objectAtIndex:(indexPath.row-1)];
            }else model = [fuliList objectAtIndex:indexPath.row];
            
            [cell.ima_back  sd_setImageWithURL:[NSURL URLWithString:model.focus]                               placeholderImage:[UIImage imageNamed:@"news_list_default"]
                                       options:0
                                     completed:^(UIImage *image,
                                                 NSError *error,
                                                 SDImageCacheType cacheType,
                                                 NSURL *imageURL){}];
            NSString *time=[NSString stringWithFormat:@"%@",  model.endtime ];
            NSTimeInterval stime=[time doubleValue];
            NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:stime];
            
            cell.lab_endTime.text=[NSString stringWithFormat:@"%@", [self setJiShi:nowDate date2:detaildate]];
            
            cell.lab_tittle.text=[NSString stringWithFormat:@"%@",model.title];
            cell.lab_num.text=[NSString stringWithFormat:@"共%@份",model.count];
            cell.lab_price.text=[NSString stringWithFormat:@"%@",model.price];
            
            if (! [cell.lab_endTime.text isEqualToString:@"已结束"]) {
                cell.btn_state.text=@"马上参加";
                [cell.btn_state setBackgroundColor:[UIColor redColor]];
                
                
            }
            else
            {
                cell.btn_state.text=@"已经过期";
                [cell.btn_state setBackgroundColor:[UIColor lightGrayColor]];
            }
            return cell;
        }
        
    }
    else
    {
        if (huoDongimaArr.count>0 && indexPath.row==0) {
            static NSString *CellIdentifier = @"Cell3";
            HuoDongTittleImaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[HuoDongTittleImaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            [cell LoadContent:huoDongimaArr];
            return cell;
            
        }
        
        else
        {
            static NSString *CustomCellIdentifier = @"Cell4";
            HuoDongViewCell *cell = (HuoDongViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
            if (!cell) {
                NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HuoDongViewCell" owner:nil options:nil];
                cell= [nibView lastObject];
            }
            HuoDongModel *model = nil;
            if (huoDongimaArr.count>0) {
                model = [huoDongList objectAtIndex:(indexPath.row-1)];
            }else model = [huoDongList objectAtIndex:indexPath.row];
            [cell.ima_back  sd_setImageWithURL:[NSURL URLWithString:model.hb]                                placeholderImage:[UIImage imageNamed:@"news_list_default"]
                                       options:0
                                     completed:^(UIImage *image,
                                                 NSError *error,
                                                 SDImageCacheType cacheType,
                                                 NSURL *imageURL){}];
            NSString *Stime=[NSString stringWithFormat:@"%@",  model.startime];
            NSString *etime=[NSString stringWithFormat:@"%@",  model.endtime ];
            cell.lab_endTime.text=[NSString stringWithFormat:@"时间:%@-%@", [self dateFromDate: Stime ],[self dateFromDate: etime ]];
            cell.lab_tittle.text=[NSString stringWithFormat:@"%@",model.title];
            cell.lab_adddr.text=[NSString stringWithFormat:@"地点:%@",model.address];
            NSTimeInterval stime=[etime doubleValue];
            NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:stime];
            NSString *str =[self huodongTime:nowDate date2:detaildate];
            if (! [str isEqualToString:@"已结束"]) {
                cell.btn_state.text=@"报名";
                [cell.btn_state setBackgroundColor:[UIColor redColor]];
            }
            else
            {
                cell.btn_state.text=@"已经过期";
                [cell.btn_state setBackgroundColor:[UIColor lightGrayColor]];
            }
            
            return cell;
            
            
        }
    }
    
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([strSelect isEqualToString:@"100"]) {
        TJFuliModel *model = nil;
        if (FULiimaArr.count>0) {
            if (indexPath.row==0) {
                return;
            }
            else{
                model = fuliList[indexPath.row-1];
            }
        }
        else{
            model = fuliList[indexPath.row];
        }
        NSString *time=[NSString stringWithFormat:@"%@",  model.endtime ];
        NSTimeInterval stime=[time doubleValue];
        NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:stime];
        
       NSString *str= [self setJiShi:nowDate date2:detaildate];
        if (! [str isEqualToString:@"已结束"]) {
            FuLiDetailViewController *detail=[[FuLiDetailViewController alloc]init];
            detail.fuliId=model.FuliId;
            detail.urlStr=@"FlView";
            detail.state=@"1";//
            detail.hidesBottomBarWhenPushed = YES;
            [self.naviController pushViewController:detail animated:YES];
            
            
        }
        else
        {
            [AlertHelper singleMBHUDShow:@"活动已结束" ForView:self.view AndDelayHid:1];

        }

        

    }
    else
    {
        HuoDongModel *model = nil;
        if (huoDongimaArr.count>0) {
            if (indexPath.row==0) {
                return;
            }
            else{
                model = huoDongList[indexPath.row-1];
            }
        }
        else{
            model = huoDongList[indexPath.row];
        }
        
        NSString *etime=[NSString stringWithFormat:@"%@",  model.endtime ];
        NSTimeInterval stime=[etime doubleValue];
        NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:stime];
        NSString *str =[self huodongTime:nowDate date2:detaildate];
        if (! [str isEqualToString:@"已结束"]) {
            HuoDongDetailViewController *detail=[[HuoDongDetailViewController alloc]init];
            detail.fuliId=model.FuliId;
            detail.urlStr=@"HdView";
            detail.state=@"1";//
            detail.hidesBottomBarWhenPushed = YES;
            [self.naviController pushViewController:detail animated:YES];
        }
        else
        {
          [AlertHelper singleMBHUDShow:@"活动已结束" ForView:self.view AndDelayHid:1];
        }
 
       
        
    }
    
    
    
}

-(NSString *)dateFromDate:(NSString *)str

{   if(str.length!=0)
{
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}
    return nil;
}
-(NSString *)huodongTime:(NSDate *)startDate date2:(NSDate *)endDate
{
    int timeInterval =[endDate timeIntervalSinceDate:startDate];
    if(timeInterval<=0){ //倒计时结束，关闭
        return @"已结束";
        
    }else{
        return @"";
    }
}

-(NSString *)setJiShi:(NSDate *)startDate date2:(NSDate *)endDate
{
    NSMutableString *str=[NSMutableString string];
    int timeInterval =[endDate timeIntervalSinceDate:startDate];
    if(timeInterval<=0){ //倒计时结束，关闭
        return @"已结束";
        
    }else{
        int days = (int)(timeInterval/(3600*24));
        if (days==0) {
            
        }
        int hours = (int)((timeInterval-days*24*3600)/3600);
        int minute = (int)(timeInterval-days*24*3600-hours*3600)/60;
        int second = timeInterval-days*24*3600-hours*3600-minute*60;
        [str appendString:@"距离结束"];
        if (days==0) {
            [str appendString:@"0天"];
            
        }else{
            
            [str appendFormat:@"%@", [NSString stringWithFormat:@"%d天",days]];
            
        }
        if (hours<10) {
            [str appendFormat:@"%@", [NSString stringWithFormat:@"0%d:",hours]];
            
        }else{
            [str appendFormat:@"%@",  [NSString stringWithFormat:@"%d:",hours]];
            
        }
        if (minute<10) {
            [str appendFormat:@"%@", [NSString stringWithFormat:@"0%d:",minute]];
            
        }else{
            [str appendFormat:@"%@", [NSString stringWithFormat:@"%d:",minute]];
            
            
        }
        if (second<10) {
            [str appendFormat:@"%@",  [NSString stringWithFormat:@"0%d",second]];
            
        }else{
            [str appendFormat:@"%@",  [NSString stringWithFormat:@"%d",second]];
            
        }
        return str;
    }
}


@end
