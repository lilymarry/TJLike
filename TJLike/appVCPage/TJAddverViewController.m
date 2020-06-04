//
//  TJAddverViewController.m
//  TJLike
//
//  Created by imac-1 on 2016/12/5.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "TJAddverViewController.h"
#import "AddverViewController.h"
@interface TJAddverViewController ()

@end

@implementation TJAddverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AddverViewController *add= self.viewControllers[0];
    add.nid=self.nid;
    add.sharePicUrl=self.sharePicUrl;
  
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
