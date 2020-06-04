//
//  TJTopicViewModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJTopicViewModel.h"
#import "TJBBSTopTieBaModel.h"
#import "TJTieBaContentModel.h"

@implementation TJTopicViewModel

- (void)postTopicBBSNotice:(NSString *)subId andFinishBlock:(void (^)(NSArray *results))finishBlock andFaileBlock:(void (^)(NSString *))failBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsNotice",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         subId,@"subId",
                         nil];
    [HttpClient request:dic URL:strUrl success: ^(NSDictionary *response) {
        TLog(@"%@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSArray *resultList=[[NSArray alloc]init];
            resultList = [response objectForKey:@"data"];
            finishBlock(resultList);
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failBlock(@"数据请求失败");
        }
        
        
    } fail:^{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
    }];
}

- (void)postTopicBBSTopTieBa:(NSString *)subId andFinishBlock:(void(^)(NSArray *results))finishBlock andFaileBlock:(void(^)(NSString *error))failBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsTopTieBa",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         subId,@"cid",
                         nil];
    [HttpClient request:dic URL:strUrl success:^(NSDictionary *response) {
        TLog(@"%@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
            NSArray *dicArray=response[@"data"];
            for (NSDictionary *item in dicArray) {
                TJBBSTopTieBaModel *model = [[TJBBSTopTieBaModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [resultList addObject:model];
            }
            self.topLists = resultList;
            finishBlock(resultList);
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failBlock(@"请求失败");
        }
        
        
    } fail:^{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
    }];
    
    
}

- (void)postTopicBBSTieBaContent:(NSString *)subId withPageIndex:(int)pageIndex withRank:(NSString *)rank andFinishBlock:(void(^)(NSArray *results))finishBlock andFaileBlock:(void(^)(NSString *error))failBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsTieBa",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         subId,@"cid",
                         [NSNumber numberWithInt:pageIndex],@"page",
                         rank,@"rank",
                         nil];
    [HttpClient request:dic URL:strUrl success:^(NSDictionary *response) {
        TLog(@"%@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
            NSArray *dicArray=response[@"data"];
            for (NSDictionary *item in dicArray) {
                TJTieBaContentModel *model = [[TJTieBaContentModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [resultList addObject:model];
                
            }
            if (pageIndex == 0) {
                self.contentLists = resultList;
            }
            else{
                NSMutableArray *dataList = [[NSMutableArray alloc] init];
                [dataList addObjectsFromArray:self.contentLists];
                [dataList addObjectsFromArray:resultList];
                self.contentLists = dataList;
            }
            
            
            
            finishBlock(resultList);
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failBlock(@"数据返回失败");
        }
    } fail:^{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
    }];
}

- (void)postTopicBBSAddTieba:(NSString *)cateId andUserId:(NSString *)userId withTitle:(NSString *)title withFont:(NSString *)font withPalce:(NSString *)palce withimageFile:(NSArray *)array andFinishBlock:(void(^)(NSArray *results))finishBlock andFaileBlock:(void(^)(NSString *error))failBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsAddTieba",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         cateId ,@"cid",
                         userId,@"uid",
                         title,@"title",
                         font,@"font",
                         palce,@"palce",
                         array,@"$_FILES[0]",
                         nil];
    TLog(@"%@",dic);
    [HttpClient request:dic URL:strUrl success:^(NSDictionary *response) {
        TLog(@"%@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            
            finishBlock(nil);
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failBlock(@"发布失败");
        }
    } fail:^{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
    }];
}

- (void)postTopicBBSAddTieba:(NSArray *)images withCateID:(NSString *)cateId andUserId:(NSString *)userId withTitle:(NSString *)title withFont:(NSString *)font withPalce:(NSString *)palce andFinish:(void (^)(NSDictionary *resultDict))finishBlock andFailed:(void (^)(NSString *error))faileBlock
{
    NSString *strPath = [NSString stringWithFormat:@"%@BbsAddTieba",TJZOUNAI_ADDRESS_URL];
    strPath = [strPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:cateId ,@"cid",
                                userId,@"uid",
                                title,@"title",
                                font,@"font",
                                palce,@"palce",nil];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 超时时间
    manager.requestSerializer.timeoutInterval = 30;
    // 声明获取到的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:strPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i =0;i<images.count;i++) {
            NSData *imagData = [images objectAtIndex:i];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@_%d.png",str,i];
            
            
            if (images.count != 0) {
                [formData appendPartWithFileData:imagData name:[NSString stringWithFormat:@"%d",i] fileName:fileName mimeType:@"image/jpg/file"];
            }
            
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject){
            NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            //      NSString *urlencodeStr=[aString  stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            //      NSString *str =[urlencodeStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
            
            NSData* data = [aString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *response;
            if (data!=nil) {
                response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
            
            if ( response) {
                int strCode = [[response objectForKey:@"code"] intValue];
                if ([[response allKeys] containsObject:@"code"]) {
                    if (strCode == 200) {
                        TLog(@"***** post success ******");
                        
                        
                        finishBlock(response);
                    }
                    else{
                        faileBlock([response objectForKey:@"message"]);
                    }
                }
                else{
                    
                    faileBlock([response objectForKey:@"error_description"]);
                }
                
                
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faileBlock(error.localizedDescription);
    }];
    
    
    //   [HttpClient requestMorePic:parameters URL:strPath images:images success:^(NSDictionary *response) {
    //       int strCode = [[response objectForKey:@"code"] intValue];
    //               if ([[response allKeys] containsObject:@"code"]) {
    //                   if (strCode == 200) {
    //                       TLog(@"***** post success ******");
    //
    //
    //                       finishBlock(response);
    //                   }
    //                   else{
    //                       faileBlock([response objectForKey:@"message"]);
    //                   }
    //               }
    //               else{
    //
    //                   faileBlock([response objectForKey:@"error_description"]);
    //               }
    //
    //   } fail:^{
    //         [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
    //   } progress:^(float progress) {
    //
    //   }];
    //    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    //    NSMutableURLRequest *request = [requestSerializer  multipartFormRequestWithMethod:@"POST" URLString:strPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    //        for (int i =0;i<images.count;i++) {
    //            NSData *imagData = [images objectAtIndex:i];
    //            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //            // 设置时间格式
    //            formatter.dateFormat = @"yyyyMMddHHmmss";
    //            NSString *str = [formatter stringFromDate:[NSDate date]];
    //            NSString *fileName = [NSString stringWithFormat:@"%@_%d.png",str,i];
    //
    //
    //        if (images.count != 0) {
    //            [formData appendPartWithFileData:imagData name:[NSString stringWithFormat:@"%d",i] fileName:fileName mimeType:@"image/jpg/file"];
    //        }
    //
    //        }
    //    } error:nil];
    
    
    
    //    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //
    //    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    //
    //        NSError *error;
    //        NSDictionary *response  = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
    //        if (error) {
    //            TLog(@"WARNING : Serialize Json Failed!");
    //        }
    //        int strCode = [[response objectForKey:@"code"] intValue];
    //        if ([[response allKeys] containsObject:@"code"]) {
    //            if (strCode == 200) {
    //                TLog(@"***** post success ******");
    //
    //
    //                finishBlock(response);
    //            }
    //            else{
    //                faileBlock([response objectForKey:@"message"]);
    //            }
    //        }
    //        else{
    //
    //            faileBlock([response objectForKey:@"error_description"]);
    //        }
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        TLog(@"%@",error);
    //        faileBlock(error.localizedDescription);
    //    }];
    //    [[NSOperationQueue mainQueue] addOperation:op];
}


@end
