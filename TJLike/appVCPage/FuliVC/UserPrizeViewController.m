//
//  UserPrizeViewController.m
//  TJLike
//
//  Created by imac-1 on 16/8/30.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "UserPrizeViewController.h"
#import "UserPrizeCell.h"
#import "UserPrizeTittleViewCell.h"

#import "UIImageView+WebCache.h"
@interface UserPrizeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
   UITableView *_tableView ;
}

@end

@implementation UserPrizeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"中奖名单"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
    //  [self.naviController setNaviBarRightBtn:[self GetRightBtn]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColorFromRGB(0xe5e5e5);
   if (_winnerArr.count >0) {
        [self setTableViewUI];
    }
    else
    {
       [self setlabUI];
    }
}
-(void)setTableViewUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.separatorStyle=UITableViewCellAccessoryNone;
    //   NSLog(@"%@",NSStringFromCGRect(_tableView.frame));
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor=UIColorFromRGB(0xe5e5e5);
    [self.view addSubview:_tableView];
    
}
-(void)setlabUI
{
 
  
 
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(   self.view.center.x-46,96, 92, 12)];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:UIColorFromRGB(0x1d1c1c)];
    [lblTitle setFont:[UIFont systemFontOfSize:15.0f]];
    lblTitle.backgroundColor=[UIColor clearColor];
    [lblTitle setText:_winnerStr];
    [self.view addSubview:lblTitle];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30,102,  self.view.center.x-92, 1)];
    view.backgroundColor = UIColorFromRGB(0x1d1c1c);
    [self.view addSubview:view];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lblTitle.frame)+10,102,  self.view.center.x-92, 1)];
    view1.backgroundColor = UIColorFromRGB(0x1d1c1c);
    [self.view addSubview:view1];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==1) {
        
       return _winnerArr.count;
  //      return 4;

    }
    
    else
    {
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // return 250;
    switch (indexPath.section) {
        case 0:
            return 91;
            break;
        case 1:
            return 65;
            break;
        default:
            return 44;
            break;
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            
            return 0;
            break;
        case 1:
        
       
          
            return 12;
            
            break;
        default:
            return 0;
            break;
            
      
    }
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return nil;
            break;
      
            
        case 1:
            // case 6:
        {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
            view.backgroundColor = UIColorFromRGB(0xf0f0f0);
            return view;
            
        }
            
            break;
            
        default:
            return nil;
            break;
    }
    
    
    
    
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 1:{
         
                return 46;
    
        }
            
            break;
            
        default:
            return 0;
            break;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 1:
        {
         
                UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46)];
                footerView.backgroundColor = UIColorFromRGB(0xf0f0f0);;
                
            UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(   self.view.center.x-46,17, 112, 12)];
            [lblTitle setTextAlignment:NSTextAlignmentCenter];
            [lblTitle setTextColor:UIColorFromRGB(0x1d1c1c)];
            [lblTitle setFont:[UIFont systemFontOfSize:12.0f]];
            lblTitle.backgroundColor=[UIColor clearColor];
            [lblTitle setText:@"以上是全部中奖名单"];
            [footerView addSubview:lblTitle];
            
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30,17,  self.view.center.x-92, 1)];
            view.backgroundColor = UIColorFromRGB(0x1d1c1c);
            [footerView addSubview:view];
            
            UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lblTitle.frame)+18,17,  self.view.center.x-92, 1)];
            view1.backgroundColor = UIColorFromRGB(0x1d1c1c);
            [footerView addSubview:view1];
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
    if (indexPath.section == 0) {
        
        static NSString *CustomCellIdentifier = @"Cell1";
        UserPrizeTittleViewCell *cell = (UserPrizeTittleViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (!cell) {
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"UserPrizeTittleViewCell" owner:nil options:nil];
            cell= [nibView lastObject];
        }

        return cell;
    }
    
    else
        
    {
        static NSString *CustomCellIdentifier = @"Cell2";
        UserPrizeCell *cell = (UserPrizeCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (!cell) {
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"UserPrizeCell" owner:nil options:nil];
            cell= [nibView lastObject];
        }
        
        [cell.name setText:StringEqual(_winnerArr[indexPath.row][@"Nickname"], @"")?_winnerArr[indexPath.row][@"Nickname"]:_winnerArr[indexPath.row][@"Username"]];
         [cell.time setText:_winnerArr[indexPath.row][@"Datetime"]];
         [cell.userIMA sd_setImageWithURL:[NSURL URLWithString:_winnerArr[indexPath.row][@"Icon"]] placeholderImage:ImageCache(@"lunbo_default_icon") options:SDWebImageLowPriority | SDWebImageRetryFailed];
        
        return cell;
        
        
        
    }
    
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
