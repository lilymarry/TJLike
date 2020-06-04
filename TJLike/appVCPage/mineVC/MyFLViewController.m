//
//  MyFLViewController.m
//  TJLike
//
//  Created by imac-1 on 16/9/27.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "MyFLViewController.h"
#import "FuLiDetailViewController.h"
#import "WebApi.h"
#import "FuLiViewCell.h"
#import "TJFuliModel.h"
#import "UIImageView+WebCache.h"
@interface MyFLViewController ()<UITableViewDataSource,UITableViewDelegate>
{
 
     NSString *nowtime;
    NSMutableArray * resultList;
 
    
}
@property (nonatomic, strong)UITableView    *tableView;
@end
//static NSString *LeftImg = @"luntan_fenlei_";
//static NSString *RightImg = @"luntan_xinxi_";
@implementation MyFLViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    resultList =[NSMutableArray array];
    NSDate *dates = [NSDate date];
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [formatter setTimeZone:timeZone];
    nowtime = [formatter stringFromDate:dates];
    //  huoDongList=[NSMutableArray array];
    [self requestData];
    [self setupContentView];
    //  [self bindViewModel];
}
- (void)requestData
{
    //    NSString *str;
    //    if ([_state isEqualToString:@"0"]) {
    //        str =@"0";
    //    }
    //    else
    //    {
    //        str =@"1";
    //
    //    }
    [[WebApi sharedRequest]mlflWithUserId:UserManager.userInfor.userId Success:^(NSDictionary *response) {
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            // NSMutableArray *resultList=[[NSMutableArray alloc]init];
            [resultList removeAllObjects];
        NSArray *    dicArray=response[@"data"];
                        for (NSDictionary *item in dicArray) {
                            TJFuliModel *model = [[TJFuliModel alloc] initWithDic:item];
                            //[model setValuesForKeysWithDictionary:item];
                            [resultList addObject:model];
                        }
            [_tableView reloadData];
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            //  failedBlock([response objectForKey:@"msg"]);
        }
        
 
    } fail:^{
        
    }];
//    [[WebApi sharedRequest]CollectionListWithUserId:UserManager.userInfor.userId type:_state Success:^(NSDictionary *response){
//        
//        NSLog(@"AAAAAAA %@",response);
//        if ([[response objectForKey:@"code"] integerValue] == 200) {
//            // NSMutableArray *resultList=[[NSMutableArray alloc]init];
//            
//            resultList=response[@"data"];
//            //            for (NSDictionary *item in dicArray) {
//            //                TJFuliModel *model = [[TJFuliModel alloc] initWithDic:item];
//            //                //[model setValuesForKeysWithDictionary:item];
//            //                [resultList addObject:model];
//            //            }
//            [_tableView reloadData];
//        }
//        else if ([[response objectForKey:@"code"] integerValue] == 500){
//            //  failedBlock([response objectForKey:@"msg"]);
//        }
//        
//        
//        
//    } fail:^(){}];
    
    
    
}


- (void)setupContentView
{
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStylePlain];
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
    
    [self.naviController setNaviBarTitle:@"详情"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
}
-(void)viewWillDisappear:(BOOL)animated
{
    //  _segControl.hidden=YES;
}
- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    //  [self.posterView timerStop];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return resultList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CustomCellIdentifier = @"Cell";
//    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
//    if (!cell) {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier];
//        
//    }
//    
//    
//    cell.textLabel.text=[resultList objectAtIndex:indexPath.row][@"title"];
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//    cell.textLabel.font=[UIFont systemFontOfSize:12];
//    
//    return cell;
    static NSString *CustomCellIdentifier = @"Cell";
    FuLiViewCell *cell = (FuLiViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (!cell) {
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FuLiViewCell" owner:nil options:nil];
        cell= [nibView lastObject];
    }
    TJFuliModel *model=  [resultList objectAtIndex:indexPath.row];
    // [cell.ima_back   sd_setImageWithURL:[NSURL URLWithString:model.focus] placeholderImage:ImageCache(@"lunbo_default_icon") options:SDWebImageLowPriority | SDWebImageRetryFailed];
    [cell.ima_back  sd_setImageWithURL:[NSURL URLWithString:model.focus]                               placeholderImage:[UIImage imageNamed:@"news_list_default"]
                               options:0
                             completed:^(UIImage *image,
                                         NSError *error,
                                         SDImageCacheType cacheType,
                                         NSURL *imageURL){}];
    NSString *time=[NSString stringWithFormat:@"%@",  model.endtime ];
    cell.lab_endTime.text=[NSString stringWithFormat:@"结束时间 %@", [self dateFromDate: time ]];
    
    cell.lab_tittle.text=[NSString stringWithFormat:@"%@",model.title];
    cell.lab_num.text=[NSString stringWithFormat:@"共%@份",model.count];
    cell.lab_price.text=[NSString stringWithFormat:@"%@",model.price];
    int i=  [self compareDate:nowtime withDate: [self dateFromDate: time ]];
    if (i>0) {
     //   [cell.btn_state setTitle:@"马上参加" forState:UIControlStateNormal];
     //   [cell.btn_state setBackgroundColor:[UIColor redColor]];
          cell.btn_state.text=@"马上参加";
    }
    else
    {
       // [cell.btn_state setTitle:@"已经过期" forState:UIControlStateNormal];
       // [cell.btn_state setBackgroundColor:[UIColor lightGrayColor]];
          cell.btn_state.text=@"马上参加";
        
        
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  //  if ([_state isEqualToString:@"1"]) {
        TJFuliModel *model=  [resultList objectAtIndex:indexPath.row];
        FuLiDetailViewController *detail=[[FuLiDetailViewController alloc]init];
        detail.fuliId=model.FuliId;
        detail.urlStr=@"FlView";
        detail.state=@"0";
        detail.hidesBottomBarWhenPushed = YES;
        [self.naviController pushViewController:detail animated:YES];
//    }
//    else
//    {
//        HuoDongDetailViewController *detail=[[HuoDongDetailViewController alloc]init];
//        detail.fuliId=[resultList objectAtIndex:indexPath.row][@"aid"];
//        detail.urlStr=@"HdView";
//        detail.state=@"0";
//        detail.hidesBottomBarWhenPushed = YES;
//        [self.naviController pushViewController:detail animated:YES];
//        
//    }
    
    
    
    
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

-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
            
        default: //NSLog(@"erorr dates %@, %@", dt2, dt1);
            break;
    }
    //   NSLog(@"dates %d, ", ci);
    return ci;
}




@end
