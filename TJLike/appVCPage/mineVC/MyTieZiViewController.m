//
//  MyTieZiViewController.m
//  TJLike
//
//  Created by imac-1 on 16/9/5.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "MyTieZiViewController.h"
#import "WebApi.h"
#import "MJRefresh.h"
#import "COMMON.h"
#import "TieziUserModel.h"
#import "TieZiCell.h"
#import "TJSubjectPlacardViewController.h"
@interface MyTieZiViewController ()
<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray *dataArray;
    UIButton *but1;
    UIButton *but2;
    int     requestInt;
    NSString *typeC;
    
}
@property(strong,nonatomic)UITableView *tableView;
@end

@implementation MyTieZiViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([_whoStr isEqualToString:UserManager.userInfor.userId]) {
        [self.naviController setNaviBarTitle:@"我的帖子"];
    }
    else{
        [self.naviController setNaviBarTitle:@"ta的帖子"];
    }
    
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
  
}

-(void)setUI
{
    but1= [UIButton buttonWithType:UIButtonTypeCustom];
    [but1 setTitleColor:UIColorFromRGB(0x161616) forState:UIControlStateNormal];
    [but1 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    but1.frame = CGRectMake(10, 64, SCREEN_WIDTH/2-20, 45);
    but1.tag = 1000;
    if ([_whoStr isEqualToString:UserManager.userInfor.userId]) {
        [but1 setTitle:@"我发表过的" forState:UIControlStateNormal];
    }
    else{
        [but1 setTitle:@"ta发表过的" forState:UIControlStateNormal];
        
    }
    
    
    [but1 addTarget:self action:@selector(selectFaBiao) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but1];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-10, 74, 0.5, 35)];
    label.backgroundColor = UIColorFromRGB(0x333333);
    [self.view addSubview:label];
    
    but2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [but2 setTitleColor:UIColorFromRGB(0x161616) forState:UIControlStateNormal];
    [but2 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    but2.frame = CGRectMake(SCREEN_WIDTH/2-10, 64, SCREEN_WIDTH/2-20, 45);
    but2.tag = 1001;
    if ([_whoStr isEqualToString:UserManager.userInfor.userId]) {
        [but2 setTitle:@"我评论过的" forState:UIControlStateNormal];
    }
    else{
        [but2 setTitle:@"ta评论过的" forState:UIControlStateNormal];
        
    }    [but2 addTarget:self action:@selector(selectcanyu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but2];
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,110, SCREEN_WIDTH, SCREEN_HEIGHT-110) style:UITableViewStylePlain];
    //   NSLog(@"%@",NSStringFromCGRect(_tableView.frame));
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor=COLOR(246, 246, 246, 1);
    [self.view addSubview:_tableView];
    
    
    
    
}
- (void)setupRefresh
{
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (void)headerRereshing
{
    requestInt=0;
    NSString *page=[NSString stringWithFormat:@"%d",requestInt];
    [[WebApi sharedRequest ]userTieZiListWithUserId:_whoStr  page:page type:typeC Success:^(NSDictionary * dic){
      
        [dataArray removeAllObjects];
        if ([dic[@"code"] integerValue]==200) {
            for (NSDictionary *dct in dic[@"data"]) {
                TieziUserModel *model=[[TieziUserModel alloc]initWithDic:dct];
                [dataArray addObject:model];
            }
        }
        [_tableView reloadData];
        [self.tableView headerEndRefreshing];
    } fail:^(){
        
    }];
    
}

- (void)footerRereshing
{
    requestInt=requestInt +1;
    NSString *page=[NSString stringWithFormat:@"%d",requestInt];
    [[WebApi sharedRequest ]userTieZiListWithUserId:_whoStr  page:page type:typeC Success:^(NSDictionary * dic){
      
        if ([dic[@"code"] integerValue]==200) {
            for (NSDictionary *dct in dic[@"data"]) {
                TieziUserModel *model=[[TieziUserModel alloc]initWithDic:dct];
                [dataArray addObject:model];
            }
        }
        [self.tableView footerEndRefreshing];
        [_tableView reloadData];
    } fail:^(){
        
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc]init];
     [self setUI];
    but1.selected=YES;
    but2.selected=NO;
    requestInt=0;
    typeC=@"pubList";
   
    [self setupRefresh];
    
}
-(void)selectFaBiao
{
    but1.selected=YES;
    but2.selected=NO;
    typeC=@"pubList";
    [self.tableView headerBeginRefreshing];
}
-(void)selectcanyu
{   typeC=@"pubComment";
    but1.selected=NO;
    but2.selected=YES;
    [self.tableView headerBeginRefreshing];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TieZiCell *cell = (TieZiCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *tiezi = @"TieziUserModel";
    TieZiCell *cell = [[TieZiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tiezi];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TieziUserModel *model = (TieziUserModel *)[dataArray objectAtIndex:indexPath.row];
    if (but1.selected) {
         [cell bindModel:model withStr:@"1"];
    }
   else
   {
      [cell bindModel:model withStr:@"2"];
   }
    return cell;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TieziUserModel *model = (TieziUserModel *)[dataArray objectAtIndex:indexPath.row];
    TJSubjectPlacardViewController *spVC = [[TJSubjectPlacardViewController alloc] initWithItem:model.Tieziid];
    spVC.isExistDelete = NO;
    [self.naviController pushViewController:spVC animated:YES];
    
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
