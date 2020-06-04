//
//  MyKjController.m
//  TJLike
//
//  Created by imac-1 on 16/9/5.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "MyKjViewController.h"
#import "WebApi.h"
#import "KjViewCell.h"
#import "KJDetailView.h"
#import "TJMyKjModel.h"
#import "FuLiDetailViewController.h"
#import "AlertHelper.h"
@interface MyKjViewController ()<TJMyKjDelegate, UITableViewDataSource,UITableViewDelegate>
{
    //  UIView *otisView;
    //  RefreshTableView *mTableView;
    NSMutableArray *dataArray;
    UIView *bgView ; //遮罩层
    KJDetailView *detail;

//    UIButton *but1;
//    UIButton *but2;
//    int     requestInt;
//    NSString *typeC;
    
}
@property(strong,nonatomic)UITableView *tableView;
@end

@implementation MyKjViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray =[NSMutableArray array];
    [self setUI];
    [self requestData];
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"我的卡券"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
    //  [self.naviController setNaviBarRightBtn:[self GetRightBtn]];
}
-(void)requestData
{
  [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
    [[WebApi sharedRequest]GetMyKjWithId:UserManager.userInfor.userId Success:^(NSDictionary *dic){
        NSLog(@"dsasdsAAAAAAAAAAAA %@",dic);
         [AlertHelper hideAllHUDsForView:self.view];
        if ([[dic objectForKey:@"code"] integerValue] == 200) {
            // NSMutableArray *resultList=[[NSMutableArray alloc]init];
            
          //  resultList=response[@"data"];
                        for (NSDictionary *item in dic[@"data"]) {
                            TJMyKjModel *model = [[TJMyKjModel alloc] initWithDic:item];
                           //  [model setValuesForKeysWithDictionary:item];
                            [dataArray addObject:model];
                        }
            [_tableView reloadData];
        }
        else if ([[dic objectForKey:@"code"] integerValue] == 500){
            [AlertHelper singleMBHUDShow:[dic objectForKey:@"msg"] ForView:self.view AndDelayHid:1];
        }
        else
        {
            [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
            
        }
    } fail:^(){
        [AlertHelper hideAllHUDsForView:self.view];
        
        [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
    
    }];
//        [[WebApi sharedRequest ]userCommentListWithUserId:UserManager.userInfor.userId  page:page type:@"" Success:^(NSDictionary * dic){
//            NSLog(@"ZZZZZ--- %@",dic);
//    
//        } fail:^(){
//        
//        }];
    
    
}
-(void)setUI
{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    //   NSLog(@"%@",NSStringFromCGRect(_tableView.frame));
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor=COLOR(246, 246, 246, 1);
    [self.view addSubview:_tableView];
    
 }
-(void)showThebgview{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH,  SCREEN_HEIGHT)];
    bgView.backgroundColor=[UIColor blackColor];
    bgView.alpha=0;
    [self.view.window addSubview:bgView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidThebgview)];
    tapGesture.numberOfTapsRequired=1;
    [bgView addGestureRecognizer:tapGesture];
    
    [UIView animateWithDuration:0.3 animations:^(){
        bgView.alpha=0.8;
    }completion:^(BOOL finished){
        
    } ];
}
//撤销背景蒙板
-(void)hidThebgview{
    
    [UIView animateWithDuration:0.3 animations:^(){
        bgView.alpha=0;
    }completion:^(BOOL finished){
        [detail removeFromSuperview];
        [bgView removeFromSuperview];
        
    } ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // return 10;
     return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
      return 94;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CustomCellIdentifier = @"Cell";
    KjViewCell *cell = (KjViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (!cell) {
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"KjViewCell" owner:nil options:nil];
        cell= [nibView lastObject];
    }
    TJMyKjModel *model=[dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lab_subTittle.text=model.recommand_title;
    cell.lab_tittle.text=model.title;
    cell.lab_time.text=[NSString stringWithFormat:@"%@",model.endtime] ;
    return cell;
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showThebgview];
    TJMyKjModel *model=[dataArray objectAtIndex:indexPath.row];

    detail=[[KJDetailView alloc]instanceChooseViewHidChooseViewWithModel:model];
    detail.delegate=self;
    
    [self.view.window  addSubview:detail];

}
-(void)tapDetailWithKjID:(NSString *)kjID
{
   // NSLog(@"tap");
    FuLiDetailViewController *detai=[[FuLiDetailViewController alloc]init];
    detai.fuliId=kjID;
    detai.urlStr=@"FlView";
    detai.state=@"1";
    detai.hidesBottomBarWhenPushed = YES;
     [self hidThebgview];
    [self.naviController pushViewController:detai animated:YES];
   


}
-(void)useKjWithKjID:(NSString *)kjID
{
   // NSLog(@"use");
    [self hidThebgview];
    [AlertHelper MBHUDShow:@"请稍后..." ForView:self.view AndDelayHid:30];
    [[WebApi sharedRequest]UseUserKJWithId:UserManager.userInfor.userId kjID:kjID Success:^(NSDictionary *userInfo) {
        [AlertHelper hideAllHUDsForView:self.view];
         if ([[userInfo objectForKey:@"code"] integerValue] == 200)
         {
             [AlertHelper singleMBHUDShow:@"已使用" ForView:self.view AndDelayHid:1];
         
         }
         else if ([[userInfo objectForKey:@"code"] integerValue] == 500){
             [AlertHelper singleMBHUDShow:[userInfo objectForKey:@"msg"] ForView:self.view AndDelayHid:1];
         }
         else
         {
             [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
             
         }
    //   NSLog(@"sdsdsf %@",userInfo);
    } fail:^{
        [AlertHelper hideAllHUDsForView:self.view];
        
        [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
    }];
}
@end
