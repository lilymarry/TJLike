//
//  MyCollectViewController.m
//  TJLike
//
//  Created by imac-1 on 16/8/30.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "MyCollectViewController.h"
#import "TJForumViewModel.h"
#import "MJRefresh.h"
#import "TypeSelectView.h"
#import "WTVHomePosterView.h"
#import "TJBBSPosterModel.h"
#import "TJBBSHotsCommendCell.h"
#import "TJTopicViewCell.h"
#import "TJForumTableView.h"


#import "TJSubForumViewController.h"
#import "TJLoginRegisterViewController.h"
#import "TJSubjectPlacardViewController.h"

#import "TJBBSHotListModel.h"
#import "TJBBSCommendModel.h"

#import "WebApi.h"
#import "FuLiViewCell.h"
#import "TJFuliModel.h"
#import "FuLiDetailViewController.h"
#import "HuoDongDetailViewController.h"
#import "AlertHelper.h"
#define table_headerView_height         140.0 * SCREEN_PHISICAL_SCALE
//#define NaviBtnTitles @[@"福利",@"活动"]
@interface MyCollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //海报
   // UIView *currentPosterVi;
    //热点标题
   // UIView  *hotView;
   // int     requestInt;
  //  UIScrollView  *_ScrollView;
    
//    UILabel *timeLabel;
//    UILabel *todayLimit;
//    UILabel *tomorrowLimit;
//    
//    UILabel *wLabel1;
//    UILabel *wLabel2;
//    UILabel *wLabel3;
    
  //  NSString *sre;
    
    NSArray * resultList;
    //NSMutableArray * huoDongList;
    
}

//@property (nonatomic, strong) NSArray    *posterLists;
//@property (nonatomic, strong) NSArray    *hotCommendLists;
//@property (nonatomic, strong) NSArray    *hotLists;
//海报视图
//@property (nonatomic, strong) WTVHomePosterView *posterView;

//@property (nonatomic, strong) TJForumViewModel  *viewModel;

//@property (nonatomic,strong) NSMutableArray *navBtns;

//@property (nonatomic, strong)UIButton       *preBtn;

//@property (nonatomic, strong)UIButton       *curBtn;

@property (nonatomic, strong)UITableView    *tableView;
//@property (nonatomic, strong)UITableView    *FtableView;

//@property (nonatomic, strong)TJForumTableView *fTableVIew;

//@property (strong, nonatomic)  UISegmentedControl *segControl;

@end
//static NSString *LeftImg = @"luntan_fenlei_";
//static NSString *RightImg = @"luntan_xinxi_";
@implementation MyCollectViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
      //  _navBtns = [[NSMutableArray alloc] init];
        // _viewModel = [[TJForumViewModel alloc] init];
        // requestInt = 0;
        //        [self.naviController.navigationBar setTranslucent:NO];
       // self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    resultList =[NSArray array];
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
    [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
    [[WebApi sharedRequest]CollectionListWithUserId:UserManager.userInfor.userId type:_state Success:^(NSDictionary *response){
         [AlertHelper hideAllHUDsForView:self.view];
        NSLog(@"AAAAAAA %@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            // NSMutableArray *resultList=[[NSMutableArray alloc]init];
         
            resultList=response[@"data"];
//            for (NSDictionary *item in dicArray) {
//                TJFuliModel *model = [[TJFuliModel alloc] initWithDic:item];
//                //[model setValuesForKeysWithDictionary:item];
//                [resultList addObject:model];
//            }
            [_tableView reloadData];
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            //  failedBlock([response objectForKey:@"msg"]);
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
    return 60;
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier];
        
    }
    NSString *str=[NSString stringWithFormat:@"%@",[resultList objectAtIndex:indexPath.row][@"title"]];
    cell.textLabel.text=str;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font=[UIFont systemFontOfSize:12];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([_state isEqualToString:@"1"]) {
       
        FuLiDetailViewController *detail=[[FuLiDetailViewController alloc]init];
        detail.fuliId=[resultList objectAtIndex:indexPath.row][@"aid"];
        detail.urlStr=@"FlView";
        detail.state=@"1";
        detail.hidesBottomBarWhenPushed = YES;
        [self.naviController pushViewController:detail animated:YES];
    }
    else
    {
        HuoDongDetailViewController *detail=[[HuoDongDetailViewController alloc]init];
        detail.fuliId=[resultList objectAtIndex:indexPath.row][@"aid"];
        detail.urlStr=@"HdView";
        detail.state=@"1";
        detail.hidesBottomBarWhenPushed = YES;
        [self.naviController pushViewController:detail animated:YES];
        
    }
    
    
    
    
}




@end

