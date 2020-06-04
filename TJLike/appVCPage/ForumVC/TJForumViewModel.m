//
//  TJForumViewModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJForumViewModel.h"
#import "TJBBSPosterModel.h"
#import "TJBBSCommendModel.h"
#import "TJBBSHotListModel.h"
#import "TJBbsCatagoryModel.h"

@implementation TJForumViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _posterInfoArr = [[NSMutableArray alloc] init];
        _hotInfoArr    = [[NSMutableArray alloc] init];
       _limitDic=[[NSDictionary alloc]init];
        _weatherDic=[NSDictionary dictionary];
    }
    return self;
}

- (void)requestBBsHotCommendFinish:(void (^)(NSArray *))finishBlock andFailed:(void (^)(NSString *))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsHotCommend",TJZOUNAI_ADDRESS_URL];
  [HttpClient request:nil URL:strUrl success:^(NSDictionary *response) {
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
            NSArray *dicArray=response[@"data"];
            for (NSDictionary *item in dicArray) {
                TJBBSCommendModel *model = [[TJBBSCommendModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [resultList addObject:model];
            }
            self.hotInfoArr = resultList;
            finishBlock(resultList);;
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failedBlock([response objectForKey:@"msg"]);
        }
  } fail:^{
      [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
  
  }];

//    } error:^(NSError *error) {
//        failedBlock(error.localizedDescription);
//    }];
}

- (void)requestBBsHotFocusFinish:(void (^)(NSArray *))finishBlock andFailed:(void (^)(NSString *))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsHotFocus",TJZOUNAI_ADDRESS_URL];
 [HttpClient request:nil URL:strUrl success:^(NSDictionary *response) {
        TLog(@"%@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
            NSArray *dicArray=response[@"data"];
            for (NSDictionary *item in dicArray) {
                TJBBSPosterModel *model = [[TJBBSPosterModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [resultList addObject:model];
            }
            self.posterInfoArr = resultList;
            finishBlock(resultList);
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failedBlock([response objectForKey:@"msg"]);
        }
 } fail:^{
     [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
 }];

   
}

- (void)requestBBsHotListPage:(int)pageIndex andFinish:(void (^)(NSArray *))finishBlock andFailed:(void (^)(NSString *))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsHotList",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithInt:pageIndex],@"Page",
                         nil];
 [HttpClient request:dic URL:strUrl success:^(NSDictionary *response) {
       
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
            NSArray *dicArray=response[@"data"];
             TLog(@"*****%@",dicArray);
            for (NSDictionary *item in dicArray) {
                TJBBSHotListModel *model = [[TJBBSHotListModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [resultList addObject:model];
            }
            self.hotListArr = resultList;
            finishBlock(resultList);
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failedBlock([response objectForKey:@"msg"]);
        }
        
        
 } fail:^{
     [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
 }];
   
}


- (void)requestBBsCatagoryFinish:(void (^)(NSArray *))finishBlock andFailed:(void (^)(NSString *))failedBlock
{
     NSString *strUrl = [NSString stringWithFormat:@"%@BbsCatagory",TJZOUNAI_ADDRESS_URL];
  [HttpClient request:nil URL:strUrl success:^(NSDictionary *response) {
        TLog(@"%@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
            NSArray *dicArray=response[@"data"];
            for (NSDictionary *item in dicArray) {
                TJBbsCatagoryModel *model = [[TJBbsCatagoryModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [resultList addObject:model];
            }
            self.forumArr = resultList;
            finishBlock(resultList);
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failedBlock([response objectForKey:@"msg"]);
        }
} fail:^{
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
}];
    
}

- (void)requestBBsContent:(id)bbsID andFinish:(void (^)(void))finishBlock andFailed:(void (^)(void))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsContent",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         bbsID,@"Id",
                         nil];
   [HttpClient request:dic URL:strUrl success:^(id x) {
        //TLog(@"______ %@",x);
        
   } fail:^{
     
   }];
}
- (void)requestweatherAndFinish:(void (^)(NSDictionary *dic))finishBlock andFailed:(void (^)(NSString *errer))failedBlock
{
  
   
   //  NSString *strUrl = @"http://api.map.baidu.com/telematics/v3/weather?location=%E5%A4%A9%E6%B4%A5&output=json&ak=f9Bi39Z1z0dL58rUG5zuLWwk";
//    [[HttpClient getRequestWithPath:strUrl] subscribeNext:^(NSDictionary *info) {
//        NSLog(@"weather---->%@",info);
//    
//    } error:^(NSError *error) {
//        HttpClient.failBlock(error);
//    }];

}
- (void)requestCarLimtAndFinish:(void (^)(NSDictionary *dic))finishBlock andFailed:(void (^)(NSString *errer))failedBlock
{
  //  NSString *strUrl = @"http://www.zounai.com/index.php/api/CarLimit";
//    [[HttpClient getRequestWithPath:strUrl] subscribeNext:^(NSDictionary *info) {
//        NSLog(@"car---->%@",info);
//      self. limitDic=[info copy];
//         } error:^(NSError *error) {
//        HttpClient.failBlock(error);
//    }];
    
}

@end
