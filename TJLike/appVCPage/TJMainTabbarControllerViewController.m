//
//  TJMainTabbarControllerViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/29.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJMainTabbarControllerViewController.h"

#import "TJNewsNaviController.h"
#import "TJForumNaviController.h"
//#import "TJFoundNaviController.h"
#import "TJMineNaviController.h"
//#import "TJMAinViewController.h"
#import "TJFuliViewController.h"
#import "TJFuliNaviController.h"
#import "ScrollViewController.h"
#define ItemsImageName @[@"news_bottom",@"bbs_bottom",@"found_bottom",@"mine_bottom"]
#define ItemsSelectedImageName @[@"news_bottom_secelted",@"bbs_bottom_selected",@"found_bottom_selected",@"mine_bottom_selected"]
#define ItemsTitle @[@"资讯",@"论坛",@"发现",@"我的"]


@interface TJMainTabbarControllerViewController ()

@end

@implementation TJMainTabbarControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
  
    //资讯
    TJNewsNaviController *newsNavi = [[TJNewsNaviController alloc] initWithRootViewController:[[TJNewsViewController alloc] init]];
    //福利
    // TJFoundNaviController *foundNavi = [[TJFoundNaviController alloc] initWithRootViewController:[[TJFoundViewController alloc] init]];
     TJFuliNaviController *foundNavi = [[TJFuliNaviController alloc] initWithRootViewController:[[TJFuliViewController alloc] init]];
    
 //    UIViewController *found = [[UIViewController alloc] initWithRootViewController:[[TJFuliViewController alloc] init]];
    //论坛
    TJForumNaviController *forumNavi = [[TJForumNaviController alloc] initWithRootViewController:[[TJForumViewController alloc] init]];
   
    TJMineNaviController *mineNavi = [[[TJMineNaviController alloc] init] initWithRootViewController:[[TJMineViewController alloc] init]];
 //    TJMineNaviController *mineNavi = [[[TJMineNaviController alloc] init] initWithRootViewController:[[TJMAinViewController alloc] initWithNibName:@"TJMAinViewController" bundle:nil]];
    
    //我的
//    UIStoryboard *s = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UIViewController *changyongController = [s instantiateViewControllerWithIdentifier:@"MYView"];
//    TJMineNaviController *mineNavi = [[[TJMineNaviController alloc] init] initWithRootViewController:changyongController];
    self.viewControllers = @[newsNavi,foundNavi,forumNavi,mineNavi];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabbarViewModel.models = [self initialBusPageTabBarItems];
   
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
//    BOOL Have = [user boolForKey:@"cunzai"];
//    if (!Have)
//    {
//        ScrollViewController* start = [[ScrollViewController alloc] init];
//  
//        [self presentViewController:start animated:YES completion:nil];
//        
//    }
//
//}


/**
 *  设置按钮图片
 *
 *  @return tabbar item 的数据模型数组
 */
-(NSArray *)initialBusPageTabBarItems
{
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i< ItemsImageName.count; i++) {
        TJBaseTabbarItem *model = [[TJBaseTabbarItem alloc] init];
        model.itemImageName = ItemsImageName[i];
        model.itemSelectedImageName = ItemsSelectedImageName[i];
        model.itemTitle = ItemsTitle[i];
        model.itemEnable = YES;
        model.itemTag = i;
        [arr addObject:model];
    }
    
    return arr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
