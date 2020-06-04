//
//  TJForumViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/29.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJForumViewController.h"
#import "TJForumViewModel.h"
#import "MJRefresh.h"
#import "TypeSelectView.h"
#import "WTVHomePosterView.h"
#import "TJBBSPosterModel.h"
#import "TJBBSHotsCommendCell.h"
#import "TJTopicViewCell.h"
#import "TJForumTableView.h"
#import<QuartzCore/QuartzCore.h>

#import "TJSubForumViewController.h"
#import "TJLoginRegisterViewController.h"
#import "TJSubjectPlacardViewController.h"

#import "TJBBSHotListModel.h"
#import "TJBBSCommendModel.h"

#import "WebApi.h"

#define table_headerView_height         140.0 * SCREEN_PHISICAL_SCALE
//#define NaviBtnTitles @[@"热点",@"板块"]

@interface TJForumViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,TJBBSHotsCommendCelldelegate>
{
    //海报
     UIView *currentPosterVi;
    //热点标题
    UIView  *hotView;
    int     requestInt;
    UIScrollView  *_ScrollView;
    
    UILabel *timeLabel;
    UILabel *todayLimitlab;
    UILabel *tomorrowLimitlab;
    
    UILabel *temperaturelab;
    UILabel *datelab;
    UILabel *currentCitylab;
    UILabel *windlab;
    
    NSString *time;
    NSString *todayLimit;
    NSString *tomorrowLimit;
    
    NSString *temperature;
    NSString *date;
    NSString *currentCity;
    NSString *wind;
    
}

@property (nonatomic, strong) NSArray    *posterLists;
@property (nonatomic, strong) NSArray    *hotCommendLists;
@property (nonatomic, strong) NSArray    *hotLists;
//海报视图
@property (nonatomic, strong) WTVHomePosterView *posterView;

@property (nonatomic, strong) TJForumViewModel  *viewModel;

@property (nonatomic,strong) NSMutableArray *navBtns;

@property (nonatomic, strong)UIButton       *preBtn;

@property (nonatomic, strong)UIButton       *curBtn;

@property (nonatomic, strong)UITableView    *tableView;

@property (nonatomic, strong)TJForumTableView *fTableVIew;

@property (strong, nonatomic)  UISegmentedControl *segControl;

@end

static NSString *LeftImg = @"luntan_fenlei_";
static NSString *RightImg = @"luntan_xinxi_";

@implementation TJForumViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _navBtns = [[NSMutableArray alloc] init];
        _viewModel = [[TJForumViewModel alloc] init];
        requestInt = 0;
//        [self.naviController.navigationBar setTranslucent:NO];
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
     self.view.backgroundColor = [UIColor whiteColor];
    [self initialNaviBar];
    [self setupContentView];
    [self bindViewModel];
    
   
    
    
}

- (void)requestData
{
    [_viewModel requestBBsHotFocusFinish:^(NSArray *results) {
        
    } andFailed:^(NSString *errer) {
        
    }];
    
    
    [_viewModel requestBBsHotCommendFinish:^(NSArray *results) {
        
    } andFailed:^(NSString *errer) {
        
    }];
    
   // [_viewModel requestweatherAndFinish:^(NSDictionary *results) {}
      //                        andFailed:^(NSString *errer){}];
    
    [[WebApi sharedRequest]getWeatherSuccess:^(NSDictionary *dic){
      //  NSLog(@"SWSW %@",dic);
        if ([dic[@"status"]isEqualToString:@"success"]) {

            NSDictionary *weat=dic[@"results"][0][@"weather_data"][0];
            wind=weat[@"wind"];
            NSString *city=[NSString stringWithString:dic[@"results"][0][@"currentCity"]];
            
            currentCity=[NSString stringWithFormat:@"%@ %@",city,weat[@"weather"]];
           
            //  "date": "周四 09月01日 (实时：26℃)",
            NSString *str1=@"(";
            NSRange range = [weat[@"date"] rangeOfString:str1] ;
            if ( range.location != NSNotFound)
            {
             
                NSString *   string1 = [weat[@"date"] substringToIndex:range.location];
                date= string1;
            }
            NSString *str2=@"实时：";
            NSRange range2 = [weat[@"date"] rangeOfString:str2] ;
            if ( range2.location != NSNotFound)
            {
                 NSString *   string = [weat[@"date"] substringFromIndex:range2.length+range2.location];
                
                 NSString *str3=@"℃)";
                 NSRange range3 = [string rangeOfString:str3];
                
                if (range3.location != NSNotFound) {
                    NSString *string1 = [string substringToIndex:range3.location];
                   
                    temperature= [ NSString stringWithFormat:@"%@°", string1 ];

                }
            }
            [_tableView reloadData];
        }
        
            
                
                
       
    } fail:^(){}];
    
    [[WebApi sharedRequest]carLimtWithSuccess:^(NSDictionary *dic){
        if ([[dic objectForKey:@"code"] integerValue] == 200) {

        todayLimit = [NSString stringWithFormat:@"今日限行 %@",dic[@"data"][0]];
        tomorrowLimit = [NSString stringWithFormat:@"明日限行 %@",dic[@"data"][1]];
        }
        [_tableView reloadData];

    }fail:^{
        
    }];
    
//    [_viewModel requestCarLimtAndFinish:^(NSDictionary *results) {}
//                              andFailed:^(NSString *errer){}];
    
    
    [self requestHotList];
    
   
   
    
}


- (void)bindViewModel
{
    _posterLists = [[NSArray alloc] init];
    _hotCommendLists = [[NSArray alloc] init];
    _hotLists = [[NSArray alloc] init];
    
    /**
     *  监听海报数组
     */
    @weakify(self)
    [[RACObserve(self.viewModel, posterInfoArr) filter:^BOOL(NSArray *value) {
        
        return value.count != 0;
    }] subscribeNext:^(NSArray *values) {
        @strongify(self)
        self.posterLists = values;
        
        self->currentPosterVi = [self->_posterView posterViewWithInfo:self->_viewModel.posterInfoArr withFrame:CGRectMake(0, 0, SCREEN_WIDTH,155)];
        
        
        
        [self->_tableView reloadData];
        [self.tableView headerEndRefreshing];
    }];
    
    
//    //车辆限行
//    [[RACObserve(self.viewModel, posterInfoArr) filter:^BOOL(NSDictionary *value) {
//        
//        return value.count != 0;
//    }] subscribeNext:^(NSArray *values) {
//        @strongify(self)
//        todayLimit = [NSString stringWithFormat:@"今日限行 %@",self->_viewModel.limitDic[@"data"][0]];
//         tomorrowLimit = [NSString stringWithFormat:@"明日限行 %@",self->_viewModel.limitDic[@"data"][1]];
//          [self->_tableView reloadData];
//       [self.tableView headerEndRefreshing];
//    }];
//    
    
    /**
     *  监听推荐数组
     *
     */
    [[RACObserve(self.viewModel, hotInfoArr) filter:^BOOL(NSArray *value) {
        return value.count != 0;
    }] subscribeNext:^(NSArray *results) {
        @strongify(self)
        self.hotCommendLists = results;
        [self->_tableView reloadData];
    }];
    
    [[RACObserve(self.viewModel, hotListArr) filter:^BOOL(NSArray *value) {
        
        return value.count != 0;
    }] subscribeNext:^(NSArray *results) {
        @strongify(self)
        self.hotLists = results;
        [self->_tableView reloadData];
        
    }];
    
    [[RACObserve(self.viewModel, forumArr) filter:^BOOL(NSArray *value) {
     
        return value.count != 0;
    }] subscribeNext:^(NSArray *results) {
       @strongify(self)
        self.fTableVIew.forumTitles = results;
        [self->_fTableVIew reloadData];
        
    }];
    
}

- (void)requestHotList
{
    @weakify(self)
    [_viewModel requestBBsHotListPage:requestInt andFinish:^(NSArray *results) {
        @strongify(self)
        [self.tableView footerEndRefreshing];
        
    } andFailed:^(NSString *errer) {
        @strongify(self)
       [self.tableView footerEndRefreshing];
        
    }];
}

- (void)requestForumList
{
    [self.fTableVIew headerBeginRefreshing];
}


-(void)segmentAction{
   	    NSInteger Index = _segControl.selectedSegmentIndex;
    if (Index==0) {
        [_ScrollView setContentOffset:CGPointMake(0,0) animated:YES];
        [self.tableView headerBeginRefreshing];
    }
    else
    {
        [_ScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        [self requestForumList];

    }
}
- (void)initialNaviBar
{
      NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"热点",@"版块",nil];
   	     _segControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
   	    _segControl.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, 30);
   	    _segControl.selectedSegmentIndex = 0;//设置默认选择项索引
   	    _segControl.tintColor = COLOR(198, 41, 42, 1);
        [_segControl addTarget:self action:@selector(segmentAction) forControlEvents:UIControlEventValueChanged];
    [self.naviController setNaviBarTitleView: _segControl];
    
   
    
}

- (void)setupContentView
{
   
    
    _ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIBAR_HEIGHT + STATUSBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT -(NAVIBAR_HEIGHT + STATUSBAR_HEIGHT))];
    
    [_ScrollView setContentSize:CGSizeMake(SCREEN_WIDTH *2, 0)];
    _ScrollView.showsHorizontalScrollIndicator = NO;
    _ScrollView.showsVerticalScrollIndicator = NO;
    _ScrollView.pagingEnabled = YES;
    _ScrollView.delegate = self;
    _ScrollView.bounces = NO;
    [self.view addSubview:_ScrollView];
//    [_ScrollView setBackgroundColor:[UIColor redColor]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _ScrollView.frame.size.height) style:UITableViewStylePlain];
 //   NSLog(@"%@",NSStringFromCGRect(_tableView.frame));
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor=COLOR(246, 246, 246, 1);
    [_ScrollView addSubview:_tableView];
    @weakify(self)
    [self.tableView addHeaderWithCallback:^{
        @strongify(self)
        
        [self requestData];
        
    }];
    [self.tableView addFooterWithCallback:^{
        @strongify(self)
        self->requestInt = self->requestInt + 3;
        [self requestHotList];
    }];
    
    [self.tableView headerBeginRefreshing];
    
    
    _fTableVIew = [[TJForumTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH,  0, SCREEN_WIDTH, _ScrollView.frame.size.height) style:UITableViewStylePlain];
    [self.fTableVIew addHeaderWithCallback:^{
        @strongify(self)
        
        [self.viewModel requestBBsCatagoryFinish:^(NSArray *results) {
            
            
            [self.fTableVIew headerEndRefreshing];
        } andFailed:^(NSString *errer) {
            
            [self.fTableVIew headerEndRefreshing];
        }];
        
    }];
    self.fTableVIew.tapFuromCell = ^(TJBBSCateSubModel *item){
        @strongify(self)
       TJSubForumViewController *subForumVC = [[TJSubForumViewController alloc] initWithItem:item];
        [self.naviController pushViewController:subForumVC animated:YES];
        
    };
    
    
//    [self.fTableVIew addFooterWithCallback:^{
////        @strongify(self)
//
//    }];
    [_ScrollView addSubview:_fTableVIew];
    
//     backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220)];
//     currentPosterVi = [[UIView alloc] init];
//    backView.backgroundColor=[UIColor yellowColor];
//    [backView addSubview:currentPosterVi];
    
    currentPosterVi = [[UIView alloc] init];
    _posterView = [[WTVHomePosterView alloc] init];
    
   
    
   // UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 20)];
   // view.backgroundColor=[UIColor redColor];
   // [backView addSubview:view];
    

    hotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    UILabel *lblHot = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 24)];
    [lblHot setText:@"  热门帖子"];
    [lblHot setTextAlignment:NSTextAlignmentLeft];
    [lblHot setFont:[UIFont systemFontOfSize:12.0f]];
    [hotView addSubview:lblHot];
    [lblHot setBackgroundColor:[UIColor clearColor]];
    
    
    _posterView.showPosterDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(TJBBSPosterModel *posterDetailInfo) {
//        @strongify(self)
 //       TLog(@"posterDetailInfo : %@", posterDetailInfo.bbsID);
        
       [self pushHotRecommend:posterDetailInfo];
        
       
        return [RACSignal empty];
    }];
    
    
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
//    if (_navBtns.count) {
//        [_navBtns removeAllObjects];
//    }
  
 //   [self initialNaviBar];
    _segControl.hidden=NO;
//    if (_segControl.selectedSegmentIndex==0) {
//          [_ScrollView setContentOffset:CGPointMake(0,0) animated:NO];
//    }
//    if (_curBtn) {
//        [_ScrollView setContentOffset:CGPointMake(0,0) animated:NO];
//    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    _segControl.hidden=YES;
}
- (void)viewDidDisappear:(BOOL)animated
{
  
     [super viewDidDisappear:animated];
     [self.posterView timerStop];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return _hotLists.count;
            break;
        case 4:
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
            return 90;
            break;
        case 2:
            return 34;
            break;
        case 3:
            return 70;
            break;
        default:
            return 0;
            break;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0://header区域
          //  return table_headerView_height+80;
           return 265;
            break;
        case 2://header区域
            //  return table_headerView_height+80;
            return 10;
            break;
        default:
            return 0;
            break;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0://header区域
        {
            UIView *     backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 265)];
            //    backView.backgroundColor=[UIColor yellowColor];
             UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 155, SCREEN_WIDTH, 110)];
            topView.image = [UIImage imageNamed:@"splash_bg"];
            [backView addSubview:topView];
//
//            NSDate *dates = [NSDate date];
//            NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"HH:MM"];
//            NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
//            [formatter setTimeZone:timeZone];
//            NSString *loctime = [formatter stringFromDate:dates];
//            
//            timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, 18,60, 21)];
//            timeLabel.textAlignment = NSTextAlignmentRight;
//            timeLabel.font = [UIFont systemFontOfSize:17];
//            timeLabel.textColor = [UIColor whiteColor];
//            timeLabel.text=loctime;
//            [topView addSubview:timeLabel];
            
            
            todayLimitlab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 18, 71, 21)];
            todayLimitlab.textAlignment = NSTextAlignmentRight;
            todayLimitlab.font = [UIFont systemFontOfSize:12];
            todayLimitlab.textColor = [UIColor whiteColor];
            todayLimitlab.text=todayLimit;
            todayLimitlab.layer.cornerRadius = 5.0;
            todayLimitlab.layer.masksToBounds = YES;
            todayLimitlab.backgroundColor=UIColorFromRGB(0xdfb301);
            [todayLimitlab sizeToFit];
            [topView addSubview:todayLimitlab];
            
            tomorrowLimitlab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 47, 71, 21)];
            tomorrowLimitlab.textAlignment = NSTextAlignmentRight;
            tomorrowLimitlab.font = [UIFont systemFontOfSize:12];
            tomorrowLimitlab.textColor = [UIColor whiteColor];
            tomorrowLimitlab.text=tomorrowLimit;
            tomorrowLimitlab.layer.cornerRadius = 5.0;
            tomorrowLimitlab.layer.masksToBounds = YES;
            tomorrowLimitlab.backgroundColor=UIColorFromRGB(0xdfb301);
            [tomorrowLimitlab sizeToFit];
            [topView addSubview:tomorrowLimitlab];
            
            
            temperaturelab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 38)];
            temperaturelab.textAlignment = NSTextAlignmentLeft;
            temperaturelab.font = [UIFont systemFontOfSize:32];
            temperaturelab.textColor = [UIColor whiteColor];
            temperaturelab.text=temperature;
            [topView addSubview:temperaturelab];
            
                       
            windlab = [[UILabel alloc]initWithFrame:CGRectMake(74, 34, 71, 21)];
            windlab.textAlignment = NSTextAlignmentLeft;
            windlab.font = [UIFont systemFontOfSize:12];
            windlab.textColor = [UIColor whiteColor];
            windlab.text=wind;
            [topView addSubview:windlab];
          
            
            currentCitylab= [[UILabel alloc]initWithFrame:CGRectMake(74, 58, 76, 21)];
            currentCitylab.textAlignment = NSTextAlignmentLeft;
            currentCitylab.font = [UIFont systemFontOfSize:12];
            currentCitylab.textColor = [UIColor whiteColor];
            currentCitylab.text=currentCity;
            [topView addSubview:currentCitylab];
            
       
            
            datelab= [[UILabel alloc]initWithFrame:CGRectMake(74, 10, 86, 21)];
            datelab.textAlignment = NSTextAlignmentLeft;
            datelab.font = [UIFont systemFontOfSize:12];
            datelab.textColor = [UIColor whiteColor];
            datelab.text=date;
            [topView addSubview:datelab];
            
            [backView addSubview:currentPosterVi];
          
        
            return backView;
            break;
        }
        case 2:{
            UIView *     backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
            backView.backgroundColor=UIColorFromRGB(0xdcdcdc);
           
            return backView;
            break;
        }
            
        default:
            return nil;
            break;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 4:
            return 100;
            break;
            
        default:
            return 0;
            break;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 4:
        {
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
            footerView.backgroundColor = COLOR(246, 246, 246, 1);
           

            UIButton *editBut = [UIButton buttonWithType:UIButtonTypeCustom];
            editBut.frame =  CGRectMake(0, 0, 290, 45);
            editBut.center = CGPointMake(SCREEN_WIDTH/2.0, 100/2);
            [editBut setTitle:@"加载更多" forState:UIControlStateNormal];
            [editBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             editBut.backgroundColor=COLOR(246, 246, 246, 1);
//            @weakify(self)
            [[editBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
//                @strongify(self)
                
                requestInt = requestInt +5;
                [self requestHotList];
               
                
            }];
            
            [footerView addSubview:editBut];
            return footerView;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"TJTopicViewCell";
    static NSString *hotIdentifier = @"TJBBSHotsCommendCell";
    static NSString *hotTitleCell  = @"hotCell";
    if (indexPath.section == 1) {
        TJBBSHotsCommendCell *cell = (TJBBSHotsCommendCell *)[tableView dequeueReusableCellWithIdentifier:hotIdentifier];
        if (!cell) {
            cell = [[TJBBSHotsCommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotIdentifier];
            cell.delegate = self;
        }
        if (_hotCommendLists.count != 0) {
            [cell bindModel:_hotCommendLists];
        }
        
        
        return cell;
    }
    else if(indexPath.section == 3){
         TJTopicViewCell *cell = (TJTopicViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CustomCellIdentifier owner:self options:nil] lastObject];
        }
         cell.backgroundColor=COLOR(246, 246, 246, 1);
        [cell bindModel:[_hotLists objectAtIndex:indexPath.row]];
        
        
        return cell;
    }
    else if (indexPath.section == 2)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:hotTitleCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotTitleCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor=COLOR(246, 246, 246, 1);

        [cell addSubview:hotView];
        return cell;
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 3) {
        
        [self pushHotRecommend:[_hotLists objectAtIndex:indexPath.row]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger curCount = scrollView.contentOffset.x/SCREEN_WIDTH;
 
    if (curCount==0) {
        _segControl.selectedSegmentIndex=0;
    }
    else
    {
      _segControl.selectedSegmentIndex=1;
     //   [self requestForumList];
    }
    
//    if (curCount == _preBtn.tag - 100) {
//        return;
//    }
//    
//    
//    UIButton *button = [_navBtns objectAtIndex:curCount];
//   
//    button.selected = YES;
//    _preBtn.selected = NO;
//    [_preBtn setBackgroundColor:[UIColor clearColor]];
//    [button setBackgroundColor:[UIColor grayColor]];
//    _preBtn = button;
//    if (_preBtn.tag == 100) {
////        [self inistalForumNaviBar:YES];
//    }
//    else{
////        [self inistalForumNaviBar:NO];
//        [self requestForumList];
//    }
}

- (void)pressHotRecommend:(int)index
{
    [self pushHotRecommend:[_hotCommendLists objectAtIndex:index]];
}

- (void)pushHotRecommend:(id)obj
{
    if ([obj isKindOfClass:[TJBBSHotListModel class]]) {
        TJBBSHotListModel *model = (TJBBSHotListModel *)obj;
        TJSubjectPlacardViewController *spVC = [[TJSubjectPlacardViewController alloc] initWithItem:model.bbsId];
        spVC.isExistDelete = NO;
        [self.naviController pushViewController:spVC animated:YES];
    }
    else if ([obj isKindOfClass:[TJBBSCommendModel class]]){
        TJBBSCommendModel *model = (TJBBSCommendModel *)obj;
        TJSubjectPlacardViewController *spVC = [[TJSubjectPlacardViewController alloc] initWithItem:model.hotID];
        spVC.isExistDelete = NO;
        [self.naviController pushViewController:spVC animated:YES];
    }
    else if ([obj isKindOfClass:[TJBBSPosterModel class]])
    {
        TJBBSPosterModel *model = (TJBBSPosterModel *)obj;
        TJSubjectPlacardViewController *spVC = [[TJSubjectPlacardViewController alloc] initWithItem:model.bbsID];
        spVC.isExistDelete = NO;
        [self.naviController pushViewController:spVC animated:YES];
    }
}


@end
