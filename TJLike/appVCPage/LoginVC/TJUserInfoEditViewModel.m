//
//  TJUserInfoEditViewModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/15.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJUserInfoEditViewModel.h"

@implementation TJUserInfoEditViewModel

- (void)postPerfectUserInfo:(NSString *)nickname anduid:(NSString *)uid andsignature:(NSString *)signature andbirthday:(NSString *)birthday andsex:(NSString *)sex finish:(void(^)(void))finishBlock failed:(void(^)(NSString *error))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@UpdateUserInfo",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         nickname,@"nickname",
                         uid,@"uid",
                         signature,@"signature",
                         birthday,@"birthday",
                         sex,@"sex",
                         nil];
 [HttpClient request:dic URL:strUrl success:^(NSDictionary *resultDic) {
        
        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
            
            
            finishBlock();
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
            failedBlock(@"修改个人信息失败");
        }
 } fail:^{
     [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
 }];
}
- (void)postBindThirdWeibo:(NSString *)weibo anduid:(NSString *)uid andweiboicon:(NSString *)weiboicon andtoken:(NSString *)token finish:(void(^)(void))finishBlock failed:(void(^)(NSString *error))failedBlock{
    NSString *strUrl = [NSString stringWithFormat:@"%@BindingWeibo",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         uid,@"uid",
                         weibo,@"weibo",
                         weiboicon,@"weiboicon",
                         token,@"token",
                         nil];
 [HttpClient request:dic URL:strUrl success:^(NSDictionary *resultDic) {
        
        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
            
            finishBlock();
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
            
            failedBlock(@"绑定失败失败");
        }
 } fail:^{
     [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
 }];}

- (void)postHeaderData:(id)images finish:(void (^)(void))finishBlock failed:(void (^)(NSString *))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@UpPic",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         images,@"uid",
                         nil];
[HttpClient request:dic URL:strUrl success:^(NSDictionary *resultDic) {
        
        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
            
            finishBlock();
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
            failedBlock(@"绑定失败失败");
        }
} fail:^{
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
}];
}

- (void)uploadUserHeaderImage:(NSData *)imagData withUserId:(NSString *)uid andFinish:(void (^)(NSDictionary *resultDict))finishBlock andFailed:(void (^)(NSString *error))faileBlock
{
    NSString *strPath = [NSString stringWithFormat:@"%@UpPic",TJZOUNAI_ADDRESS_URL];
    strPath = [strPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:uid,@"uid",nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 超时时间
    manager.requestSerializer.timeoutInterval = 30;
    // 声明获取到的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
 
    [manager POST:strPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png",str];
        
        [formData appendPartWithFileData:imagData name:@"za" fileName:fileName mimeType:@"image/jpg/file"];
        
        
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

    
//    NSMutableURLRequest *request = [requestSerializer  multipartFormRequestWithMethod:@"POST" URLString:strPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
////        for (int i =0;i<images.count;i++) {
////            NSData *imagData = [images objectAtIndex:i];
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            // 设置时间格式
//            formatter.dateFormat = @"yyyyMMddHHmmss";
//            NSString *str = [formatter stringFromDate:[NSDate date]];
//            NSString *fileName = [NSString stringWithFormat:@"%@.png",str];
//            
//            [formData appendPartWithFileData:imagData name:@"za" fileName:fileName mimeType:@"image/jpg/file"];
////            [formData appendPartWithFormData:imagData name:@"za"];
//            
////        }
//        
//        
//        
//        
//        
//        
//    } error:nil];
    
    /*
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        NSDictionary *response  = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        if (error) {
            TLog(@"WARNING : Serialize Json Failed!");
        }
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
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        TLog(@"%@",error);
        TLog(@"warning: error is %@",error.localizedDescription);
        faileBlock(error.localizedDescription);
        
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
     */
}


@end
