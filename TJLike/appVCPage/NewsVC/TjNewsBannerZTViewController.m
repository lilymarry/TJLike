//
//  TjNewsBannerZTViewController.m
//  TJLike
//
//  Created by MC on 15/4/25.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TjNewsBannerZTViewController.h"
#import "TJNewsZTDetailViewController.h"
#import "ZTListVIew.h"

@interface TjNewsBannerZTViewController ()
{
    UIScrollView *mScrollView;
}
@end

@implementation TjNewsBannerZTViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"专题"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.naviController setNaviBarDefaultLeftBut_Back];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    mScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    mScrollView.backgroundColor = [UIColor clearColor];
    mScrollView.showsHorizontalScrollIndicator = NO;
    mScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mScrollView];
    
    [self requestRegionsInfo];
}

- (void)requestRegionsInfo {
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/ZtList"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%d",self.nid] forKey:@"ztid"];
   [HttpClient request:dict URL:urlStr success:^(NSDictionary *info) {
      //  TLog(@"--------->%@",info);
        
        NSArray *mArray = info[@"data"][@"content"];
        for (int i = 0; i<mArray.count; i++) {
            NewsListInfo *info = [NewsListInfo CreateWithDict:mArray[i]];
            ZTListVIew *listView = [[ZTListVIew alloc]initWithFrame:CGRectMake(0, i*84, SCREEN_WIDTH, 84)];
            listView.mDelegate = self;
            listView.onClick = @selector(ListViewClick:);
            [listView LoadContent:info];
            [mScrollView addSubview:listView];
        }
        mScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 45+mArray.count*84);
 } fail:^{
     [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
 }];

    
}
- (void)ListViewClick:(NewsListInfo *)info{
    TJNewsZTDetailViewController *ctrl = [[TJNewsZTDetailViewController alloc]init];
    ctrl.mlInfo = info;
    [self.naviController pushViewController:ctrl animated:YES];
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
