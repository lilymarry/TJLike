//
//  TJSubjectViewModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/15.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJSubjectViewModel.h"


@implementation TJSubjectViewModel

- (void)requestBBsContent:(id)bbsID andFinish:(void (^)(TJBBSContentModel *result))finishBlock andFailed:(void (^)(NSString *error))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsContent",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         bbsID,@"id",
                         nil];
 [HttpClient request:dic URL:strUrl success:^(NSDictionary *response) {
        
    NSLog(@"ZZZZZZZ___ %@",response);
        
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSDictionary *dicArray=response[@"data"];
            TJBBSContentModel *model = [[TJBBSContentModel alloc] init];
            [model setValuesForKeysWithDictionary:dicArray];
    
            self.bbsContent = model;
            finishBlock(model);
            
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failedBlock(@"数据请求失败");
        }
        
 } fail:^{
     [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
 }];
}

- (void)postBBSCommentList:(NSString *)bid withPage:(NSString *)page withCommentid:(NSString *)commentid withRank:(NSString *)rank andFinishBlock:(void (^)(NSArray *results))finishBlock andFaileBlock:(void (^)(NSString *error))failBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsCommentList",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         bid,@"bid",
                         page,@"page",
                         commentid,@"commentid",
                         rank,@"rank",
                         nil];
    [HttpClient request:dic URL:strUrl success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            
           NSLog(@"______ %@",response);
            
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
            NSArray *dicArray=response[@"data"];
            for (NSDictionary *item in dicArray) {
                TJCommentModel *model = [[TJCommentModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
              //  model.subLists=item[@"sub"];
                [resultList addObject:model];
            }
            
            if (!StringEqual(page, @"0")) {
                NSMutableArray *dataList = [[NSMutableArray alloc] init];
                [dataList addObjectsFromArray:self.commentLists];
                [dataList addObjectsFromArray:resultList];
                 self.commentLists = dataList;
            }
            else{
                self.commentLists = resultList;
            }
            
            finishBlock(resultList);
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failBlock(@"请求失败");
        }
    } fail:^{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
    }];
}
//添加评论
- (void)postBBSAddComment:(NSString *)bid withUserID:(NSString *)uid withParent:(NSString *)Parent withReplyid:(NSString *)Replyid withContent:(NSString *)content withImage:(NSArray *)image andFinishBlock:(void (^)(id result))finishBlock andFaileBlock:(void (^)(NSString *error))failBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsAddComment",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         bid,@"bid",
                         uid,@"uid",
                         Parent,@"parent",
                         Replyid,@"replyid",
                         content,@"content",
                       //  image,@"image",
                         nil];
     [HttpClient request:dic URL:strUrl success:^(NSDictionary *response) {
        TLog(@"%@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            
            finishBlock(nil);
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failBlock(@"评论失败");
        }
     } fail:^{
         [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
     }];
}

- (void)postTopicAddComment:(NSString *)bid withUserID:(NSString *)uid withParent:(NSString *)Parent withReplyid:(NSString *)Replyid withContent:(NSString *)content withImage:(NSData *)imageData  andFinish:(void (^)(NSDictionary *resultDict))finishBlock andFailed:(void (^)(NSString *error))faileBlock
{
    NSString *strPath = [NSString stringWithFormat:@"%@BbsAddComment",TJZOUNAI_ADDRESS_URL];
    strPath = [strPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys: bid,@"bid",
                                uid,@"uid",
                                Parent,@"parent",
                                Replyid,@"replyid",
                                content,@"content",nil];
    
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
       if (imageData) {
           [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpg/file"];
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

    
    
    
//    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
//    NSMutableURLRequest *request = [requestSerializer  multipartFormRequestWithMethod:@"POST" URLString:strPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
////            NSData *imagData = [images objectAtIndex:i];
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            // 设置时间格式
//            formatter.dateFormat = @"yyyyMMddHHmmss";
//            NSString *str = [formatter stringFromDate:[NSDate date]];
//            NSString *fileName = [NSString stringWithFormat:@"%@.png",str];
//        if (imageData) {
//            [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpg/file"];
//        }
//        
//        
//            
//        
//    } error:nil];
    
    

}


//举报论坛评论
- (void)postBBSCreport:(NSString *)bid withCid:(NSString *)cid andFinishBlock:(void (^)(NSArray *results))finishBlock andFaileBlock:(void (^)(NSString *error))failBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsCreport",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         bid,@"bid",
                         cid,@"cid",
                         nil];
[HttpClient request:dic URL:strUrl success:^(NSDictionary *response) {
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            
            finishBlock(nil);
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failBlock(@"举报成功");
        }
} fail:^{
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
}];
}
//帖子点赞
- (void)postBBSTiBaGood:(NSString *)bid andFinishBlock:(void (^)(id result))finishBlock andFaileBlock:(void (^)(NSString *error))failBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsTiBaGood",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         bid,@"id",
                         nil];
    [HttpClient request:dic URL:strUrl success:^(NSDictionary *response) {
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            
            finishBlock(nil);
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failBlock(@"点赞失败");
        }
        finishBlock(nil);
        
    } fail:^{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
    }];}
//删除帖子
- (void)postDeleteBBs:(NSString *)bbsId withUserId:(NSString *)userId andFinishBlock:(void (^)(id result))finishBlock andFaileBlock:(void (^)(NSString *error))failBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@deletebbs",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         bbsId,@"id",
                         userId,@"uid",
                         nil];
    [HttpClient request:dic URL:strUrl success:^(NSDictionary *response) {
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            
            finishBlock(nil);
        }
        else{
            failBlock(@"帖子删除失败");
        }
        
    } fail:^{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
    }];
    
}


@end
