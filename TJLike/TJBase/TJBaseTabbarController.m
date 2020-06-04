//
//  TJBaseTabbarController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/28.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseTabbarController.h"
#import "TJNewsViewController.h"
#import "TJForumViewController.h"
//#import "TJFoundViewController.h"
#import "TJMineViewController.h"



@interface TJBaseTabbarController()
/**
 *  覆盖在系统tabbar上的view
 */
@property (nonatomic, strong) UIView *tabBarView;

@property (nonatomic, strong) NSArray  *itemList;

//@property(nonatomic,strong)UIView *k_tabBar;

@property(nonatomic,strong)UIView *k_shadeView;

@end

@implementation TJBaseTabbarController



//!创建遮罩
-(void)createShadeView{
    
  //  NSLog(@"WWW %f %f",self.view.bounds.size.height,self.view.bounds.size.width);
    self.k_shadeView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.k_shadeView.alpha = 0.8;
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.k_shadeView.bounds];
    toolbar.barStyle = UIBarStyleBlackOpaque;
    toolbar.translucent = NO;
    [_k_shadeView addSubview:toolbar];
    self.k_shadeView.hidden = YES;
    [self.view addSubview:self.k_shadeView];
    [self.view insertSubview:_k_shadeView belowSubview:_tabBarView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _itemList = [[NSArray alloc] init];
    //覆盖自定义view
    _tabBarView =[[UIView alloc]initWithFrame:self.tabBar.frame];
    _tabBarView.backgroundColor = [UIColor clearColor];
    //初始化viewmodel实例
    _tabbarViewModel = [[TJBaseTabbarViewModel alloc] init];
    //监听items的数据，设置按键
    
    @weakify(self)
    [[RACObserve(_tabbarViewModel, models) filter:^BOOL(NSArray *value) {
        return value.count != 0;
    }] subscribeNext:^(NSArray *results) {
       @strongify(self)
         TLog(@"model change，%@",results);
        _itemList = results;
        @weakify(self)
        [[_tabbarViewModel.models rac_sequence] foldLeftWithStart:_tabbarViewModel.models[0] reduce:^id(id accumulator, TJBaseTabbarItem *value) {
            @strongify(self)
        
            UIButton *button = [self->_tabbarViewModel creatItemsWithItem:value];
            @weakify(self)
            //button点击事件监听
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self)
                if (button.tag != _tabbarViewModel.previousBut.tag) {
                    if ([self.selectDelegate respondsToSelector:@selector(selectBaseTabbarItem:)]) {
                        [self.selectDelegate selectBaseTabbarItem:(long)button.tag];
                    }
                    self.selectedIndex = button.tag;
                    button.selected = YES;
                    value.itemEnable = YES;
                    if (self->_tabbarViewModel.previousBut != button) {
                        _tabbarViewModel.previousBut.selected = NO;
                        _tabbarViewModel.preItem.itemEnable = NO;
                        
                    } else {
                        [self reSelectCurrentItem];
                    }
                    _tabbarViewModel.preItem = value;
                    _tabbarViewModel.previousBut = button;
                }
                
                
           
            }];
            [_tabBarView addSubview:button];
            
            return nil;
        }];
        
        //初始化页面，首先选中首个button
        for (id objc in _tabBarView.subviews) {
            if ([objc isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)objc;
                if (button.tag == 0) {
                    TJBaseTabbarItem *items = (TJBaseTabbarItem *)[results objectAtIndex:button.tag];
                    items.itemEnable = NO;
                    self.selectedIndex = button.tag;
                    button.selected = YES;
                    
                    _tabbarViewModel.previousBut = button;
                    _tabbarViewModel.preItem = items;
                    break;
                }
            }
        }
      //  [self.tabBar addSubview:_tabBarView];
         [self.view addSubview:_tabBarView];
    }];
      [self createShadeView];

}

-(NSInteger)currentSelectedIndex
{
    return self.selectedIndex;
}

-(void)setCurrentSelectedIndex:(NSInteger)currentSelectedIndex
{
    UIButton *but = _tabBarView.subviews[currentSelectedIndex];
    self.selectedIndex = but.tag;
    but.selected = YES;
    if (_tabbarViewModel.previousBut != but) {
        _tabbarViewModel.previousBut.selected = NO;
        _tabbarViewModel.preItem.itemEnable = NO;
       
    } else {
        [self reSelectCurrentItem];
    }
    _tabbarViewModel.preItem = (TJBaseTabbarItem *)[_itemList objectAtIndex:self.selectedIndex];
    _tabbarViewModel.previousBut = but;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)reSelectCurrentItem
{

}

- (void)dealloc
{
    TLog(@"<%@>dealloc",NSStringFromClass(self.class));
}

@end

