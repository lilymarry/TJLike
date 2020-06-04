//
//  ChatRoomViewController.m
//  leanCloudChat
//
//  Created by imac-1 on 16/9/18.
//  Copyright © 2016年 魏艳丽. All rights reserved.
//

#import "ChatRoomViewController.h"

@interface ChatRoomViewController ()

@end

@implementation ChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *bar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    bar.tintColor=[UIColor redColor];
    [self.view addSubview:bar];
    
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame=CGRectMake(5, 15, 50, 50);
   [ btn1 setBackgroundImage:[UIImage imageNamed:@"appui_fanhui_"] forState:UIControlStateNormal];
    btn1.backgroundColor=[UIColor clearColor];
    [btn1 addTarget:self action:@selector(dissChart) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:btn1];
    
  
    UILabel *  nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-110, 30, 220, 19)];
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor blackColor];
    [bar  addSubview:nameLabel];
 
    
    NSDictionary *dic=self.conversation.attributes;
    
    NSString *name=[self getUserName:dic[@"roomname"]] ;
   // self .urlStr=
    if (name.length==0) {
        name=@"未设置";
    }
    [nameLabel setText:name];
}
-(NSString *)getUserName:(NSString*)str
{
    NSString *str1=@"&";
    NSRange range = [str rangeOfString:str1] ;
    if ( range.location != NSNotFound)
    {
        
        NSString *   string1 = [str substringFromIndex:range.length+range.location];
        return  string1;
    }
    
    return nil;
}
-(void)dissChart
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
 //   [[CDChatManager manager]closeWithCallback:^(BOOL succeeded, NSError *error) {}];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
