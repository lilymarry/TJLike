//
//  XKTabBarController.m
//  百思
//
//  Created by 优仕汇 on 2017/3/22.
//  Copyright © 2017年 Fukui. All rights reserved.
//  个人简书，欢迎前来讨论： http://www.jianshu.com/u/289ca6a70dc9

#import "XKTabBarController.h"
#import "TJNewsNaviController.h"
#import "TJForumNaviController.h"
#import "TJMineNaviController.h"
#import "TJFuliViewController.h"
#import "TJFuliNaviController.h"
#import "ScrollViewController.h"

#import "XKTabBar.h"

@interface XKTabBarController ()

@end

@implementation XKTabBarController



- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
//    NSMutableDictionary *attributeNormalDic = [[NSMutableDictionary alloc] init];
//    attributeNormalDic[NSForegroundColorAttributeName] = [UIColor grayColor];
//
//    NSMutableDictionary *attributeSelectDic = [[NSMutableDictionary alloc] init];
//    attributeSelectDic[NSForegroundColorAttributeName] = [UIColor blackColor];
//  
//    // 设置字体颜色
//    UITabBarItem *item = [UITabBarItem appearance];
//    [item setTitleTextAttributes:attributeNormalDic forState:UIControlStateNormal];
//    [item setTitleTextAttributes:attributeSelectDic forState:UIControlStateSelected];
    
   // ---------------------- 在这里添加子视图 -----------------------------------------
    
    //资讯
    TJNewsNaviController *newsNavi = [[TJNewsNaviController alloc] initWithRootViewController:[[TJNewsViewController alloc] init]];
    //newsNavi.tabBarItem.title = @"资讯";
    // 设置图片是否被渲染
    [newsNavi.tabBarItem setImage:[[UIImage imageNamed:@"news_bottom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [newsNavi.tabBarItem setSelectedImage:[[UIImage imageNamed:@"news_bottom_secelted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    [self addChildViewController:newsNavi];
    
    
    
    TJFuliNaviController *foundNavi = [[TJFuliNaviController alloc] initWithRootViewController:[[TJFuliViewController alloc] init]];
    
  //  foundNavi.tabBarItem.title = @"福利";
    // 设置图片是否被渲染
    [foundNavi.tabBarItem setImage:[[UIImage imageNamed:@"bbs_bottom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [foundNavi.tabBarItem setSelectedImage:[[UIImage imageNamed:@"bbs_bottom_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self addChildViewController:foundNavi];
   
    
    
    //论坛
    TJForumNaviController *forumNavi = [[TJForumNaviController alloc] initWithRootViewController:[[TJForumViewController alloc] init]];
  //  forumNavi.tabBarItem.title = @"论坛";
    // 设置图片是否被渲染
    [forumNavi.tabBarItem setImage:[[UIImage imageNamed:@"found_bottom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [forumNavi.tabBarItem setSelectedImage:[[UIImage imageNamed:@"found_bottom_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self addChildViewController:forumNavi];
  
    
    TJMineNaviController *mineNavi = [[[TJMineNaviController alloc] init] initWithRootViewController:[[TJMineViewController alloc] init]];
  //  mineNavi.tabBarItem.title = @"我的";
    // 设置图片是否被渲染
    [mineNavi.tabBarItem setImage:[[UIImage imageNamed:@"mine_bottom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [mineNavi.tabBarItem setSelectedImage:[[UIImage imageNamed:@"mine_bottom_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self addChildViewController:mineNavi];
    
    
    // kvc 自定义tabBar - 因为self.tabBar readOnly
    // 对象思想，在这里面，可以根据自己的需求，自定义tabBar
     [self setValue:[[XKTabBar alloc] init] forKey:@"tabBar"];
    
}




//#pragma mark - 提取方法
///**
// 集成的方法
//
// @param childVC 子控制器
// @param tittle 标题
// @param normalIamge 正常图片
// @param selectIamage 选中图片
// */
//- (void)createTabBarItemWithChildVC:(UIViewController *)childVC  tittle:(NSString *)tittle normalIamge:(UIImage *)normalIamge selectImage:(UIImage *)selectIamage{
//
//    
//    childVC.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100.0 green:arc4random_uniform(100)/100.0 blue:arc4random_uniform(100)/100.0 alpha:1.0];
//    
//    childVC.tabBarItem.title = tittle;
//    
//    // 设置图片是否被渲染
//    [childVC.tabBarItem setImage:[normalIamge imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [childVC.tabBarItem setSelectedImage:[selectIamage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVC];
//    
//    [self addChildViewController:nav];
//    
//}


@end
