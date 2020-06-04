//
//  TJLoginViewModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJLoginViewModel.h"

@implementation TJLoginViewModel



- (void)postLoginUserInfo:(NSString *)userName andPassWord:(NSString *)password finish:(void (^)(void))finishBlock failed:(void (^)(NSString *error))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@Login",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                    userName,@"username",
                                                      password,@"password",
                                                        nil];
   [HttpClient request:dic URL:strUrl success:^(NSDictionary *resultDic) {
        
        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
            NSDictionary *resultDict = resultDic[@"data"];
        
            [UserManager saveUserInfor:resultDict withPhone:userName];
            finishBlock();
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
            failedBlock(@"用户名或密码错误");
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 401){
            failedBlock(@"手机已用");
        }
        
   } fail:^{
       [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
   }];

}

- (void)postThirdLoginUserInfo:(NSString *)jasonStr finish:(void(^)(void))finishBlock failed:(void(^)(NSString *error))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@Weibo",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         jasonStr,@"param",
                         nil];
    [HttpClient request:dic URL:strUrl success:^(NSDictionary *resultDic) {

        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
            
            NSDictionary *resultDict = resultDic[@"data"];
            [UserManager saveUserInfor:resultDict withPhone:nil];
            
            TLog(@"%@",resultDict);
            
            finishBlock();
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
            failedBlock(@"登陆失败");
        }
        
    } fail:^{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
    }];

}

- (void)postThirdWeiBoLoginUserInfo:(NSString *)weibo andWeiBoicon:(NSString *)weiboicon andToken:(NSString *)token finish:(void(^)(NSDictionary *resultDict))finishBlock failed:(void(^)(NSString *error))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@Weibo",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         weibo,@"weibo",
                         weiboicon,@"weiboicon",
                         token,@"token",
                         nil];
    [HttpClient request:dic URL:strUrl success:^(NSDictionary *resultDic) {
        
        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
            
            NSDictionary *resultDict = resultDic[@"data"];
//            [UserManager saveUserInfor:resultDict withPhone:nil];
            
            TLog(@"%@",resultDict);
            
            finishBlock(resultDict);
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
            failedBlock(@"登陆失败");
        }
        
    } fail:^{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
    }];
}


@end
