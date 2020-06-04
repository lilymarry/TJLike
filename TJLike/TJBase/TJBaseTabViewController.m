//
//  TJBaseTabViewController.m
//  TJLike
//
//  Created by 123 on 16/8/1.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "TJBaseTabViewController.h"

@interface TJBaseTabViewController ()

@end

@implementation TJBaseTabViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (TJBaseNavigationController *)naviController
{
    return (TJBaseNavigationController *)self.navigationController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.naviController.interactivePopGestureRecognizer.enabled = NO;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.naviController hideOriginalBarItems];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

@end
