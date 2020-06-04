//
//  TJVillageViewModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/15.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJVillageViewModel.h"
#import "TJCityModel.h"

@implementation TJVillageViewModel

- (void)getCityFinish:(void(^)(NSArray * results))finishBlock andFailed:(void(^)(NSString *errer))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@City",TJZOUNAI_ADDRESS_URL];
    NSLog(@"%@",strUrl);
    
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]]];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *html = operation.responseString;
//        NSDictionary *dict = [HttpClient serializeJsonString:html];
//        if ([[dict objectForKey:@"code"] integerValue] == 200) {
//            id subobj = dict[@"data"];
//            if ([subobj isKindOfClass:[NSArray class]]) {
//                
//            }
//            else if([subobj isKindOfClass:[NSDictionary class]]){
//                NSDictionary *subDict = (NSDictionary *)subobj;
//                NSMutableArray *dicArray = [[NSMutableArray alloc] initWithCapacity:[subDict allKeys].count];
//                for (int i = 0; i < [subDict allKeys].count; i++) {
//                    TJCityModel *model = [[TJCityModel alloc] init];
//                    model.villageID = [NSString stringWithFormat:@"%d",i + 1];
//                    model.villageName = [subDict objectForKey:model.villageID];
//                    NSLog(@"%@  %@",[NSString stringWithFormat:@"%d",i + 1],[subDict objectForKey:model.villageID]);
//                    [dicArray addObject:model];
//                }
//                self.cityArr = dicArray;
//            }
//        
//            finishBlock(nil);
//        }
//        else if ([[dict objectForKey:@"code"] integerValue] == 500){
//            failedBlock([dict objectForKey:@"msg"]);
//        }
//
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"发生错误！%@",error);
//        failedBlock(error.localizedDescription);
//    }];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [queue addOperation:operation];;
    
}

- (void)postStreet:(NSString *)cityId andFinish:(void(^)(NSArray * results))finishBlock andFailed:(void(^)(NSString *errer))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@Street",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         cityId ,@"id",
                         nil];
//    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *resultDic) {
//    
//           
//        
//        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
//            id subobj = resultDic[@"data"];
//            if ([subobj isKindOfClass:[NSArray class]]) {
//                
//            }
//            else if([subobj isKindOfClass:[NSDictionary class]]){
//                
//                NSDictionary *subDict = (NSDictionary *)subobj;
//                NSMutableArray *dicArray = [[NSMutableArray alloc] initWithCapacity:[subDict allKeys].count];
//                NSArray *allIds = [subDict allKeys];
//                
//                for (int i = 0; i < [subDict allKeys].count; i++) {
//                    TJCityModel *model = [[TJCityModel alloc] init];
//                    model.villageID = [allIds objectAtIndex:i];
//                    model.villageName = [subDict objectForKey:model.villageID];
//                    [dicArray addObject:model];
//                }
//                self.streetArr = dicArray;
//                
//                
//            }
//            finishBlock(nil);
//            
//            
//        }
//        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
//            failedBlock(@"获取失败");
//        }
//    } error:^(NSError *error) {
//        failedBlock(error.localizedDescription);
//    }];

}

- (void)postCommunity:(NSString *)streetID andFinish:(void(^)(NSArray * results))finishBlock andFailed:(void(^)(NSString *errer))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@Community",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         streetID ,@"id",
                         nil];
//    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *resultDic) {
//        
//        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
//            
//            id subobj = resultDic[@"data"];
//            if ([subobj isKindOfClass:[NSArray class]]) {
//                
//            }
//            else if([subobj isKindOfClass:[NSDictionary class]]){
//                NSDictionary *subDict = (NSDictionary *)subobj;
//                NSMutableArray *dicArray = [[NSMutableArray alloc] initWithCapacity:[subDict allKeys].count];
//                NSArray *allIds = [subDict allKeys];
//                
//                for (int i = 0; i < [subDict allKeys].count; i++) {
//                    TJCityModel *model = [[TJCityModel alloc] init];
//                    model.villageID = [allIds objectAtIndex:i];
//                    model.villageName = [subDict objectForKey:model.villageID];
//                    [dicArray addObject:model];
//                }
//                self.communityArr = dicArray;
//                
//            }
//            finishBlock(nil);
//        }
//        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
//            failedBlock(@"获取失败");
//        }
//    } error:^(NSError *error) {
//        failedBlock(error.localizedDescription);
//    }];
}
- (void)postAddCommunity:(NSString *)streetID communtyName:(NSString *)name andFinish:(void(^)(NSArray * results))finishBlock andFailed:(void(^)(NSString *errer))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@AddCommunity",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         streetID ,@"id",
                         name,@"name",
                         nil];
//    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *resultDic) {
//        
//    
//        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
//            finishBlock(nil);
//        }
//        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
//            failedBlock(@"获取失败");
//        }
//    } error:^(NSError *error) {
//        failedBlock(error.localizedDescription);
//    }];
}
- (void)postUserAddCommunity:(NSString *)city andStreet:(NSString *)street andCommunity:(NSString *)community andUserid:(NSString *)uid andStatus:(NSString *)status andFinish:(void(^)(NSArray * results))finishBlock andFailed:(void(^)(NSString *errer))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@UserAddCommunity",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         city ,@"city",
                         street,@"street",
                         community,@"community",
                         uid,@"uid",
                         status,@"status",
                         nil];
//    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *resultDic) {
//        
//        
//        
//        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
//            NSMutableArray *resultList=[[NSMutableArray alloc]init];
//            //            NSArray *dicArray=resultDic[@"data"];
//            
//            
//            self.communityArr = resultList;
//            finishBlock(nil);
//        }
//        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
//            failedBlock(@"获取失败");
//        }
//    } error:^(NSError *error) {
//        failedBlock(error.localizedDescription);
//    }];
}


@end
