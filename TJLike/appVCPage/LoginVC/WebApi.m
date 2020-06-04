//
//  FuliWebApi.m
//  TJLike
//
//  Created by imac-1 on 16/8/22.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "WebApi.h"
//#import <AFHTTPRequestOperationManager.h>
#import <AFNetworking.h>

@implementation WebApi
//{
//    AFHTTPRequestOperationManager *_manager;
//    NSOperationQueue *_queue;
//}

+(WebApi *)sharedRequest
{
    static WebApi *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[WebApi alloc] init];
    });
    return _sharedManager;
    
}
-(AFHTTPSessionManager *)manager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 超时时间
    manager.requestSerializer.timeoutInterval = 30;
    
    // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
    //  manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    
    // 声明获取到的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
    // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
   
    return manager;
}
-(void)request:(NSDictionary *)parm URL:(NSString *)url success:(void (^)(id))success fail:(void (^)())fail
{
    
    AFHTTPSessionManager *manager = [self manager];
    [manager POST:url parameters:parm progress:^(NSProgress * _Nonnull downloadProgress) {
        // 这里可以获取到目前数据请求的进度
        //    NSLog(@"图片上传进度%f",downloadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        if(responseObject){
            NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
      //      NSString *urlencodeStr=[aString  stringByReplacingOccurrencesOfString:@"+" withString:@" "];
      //      NSString *str =[urlencodeStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
            
            NSData* data = [aString dataUsingEncoding:NSUTF8StringEncoding];
            id  arr;
            if (data!=nil) {
                arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
      
            if (arr) {
                success(arr);
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        fail(
        );
 
        
       NSLog(@"请求失败：%@",error);
    }];
}


//带有上传一张图片的请求
-(void)request:(NSDictionary *)parm URL:(NSString *)url imageData:(NSData*)imgData  success:(void (^)(id))success fail:(void (^)())fail
{
    AFHTTPSessionManager *manager = [self manager];
    // [manager setSecurityPolicy:[NetRequestTool customSecurityPolicy]];
    
    [manager POST:url parameters:parm constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /******** 1.上传已经获取到的img *******/
        // 把图片转换成data
        //   NSData *data = UIImagePNGRepresentation(upImg);
        // 拼接数据到请求题中
        if (imgData) {
            [formData appendPartWithFileData:imgData name:@"img" fileName:@"1.jpg" mimeType:@"image/jpeg"];
        }
        // [formData appendPartWithFileData:imgData name:@"file" fileName:@"123.png" mimeType:@"image/png"];
        /******** 2.通过路径上传沙盒或系统相册里的图片 *****/
        //        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"文件地址"] name:@"file" fileName:@"1234.png" mimeType:@"application/octet-stream" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 打印上传进度
        //  NSLog(@"@@@@+ %lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        // NSLog(@"请求成功：%@",responseObject);
        if(responseObject){
            NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSString *urlencodeStr=[aString  stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            NSString *str =[urlencodeStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
            
            NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            id  arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (arr) {
                success(arr);
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        //   NSLog(@"请求失败：%@",error);
        fail();
    }];
    
}
-(void)requestMorePic:(NSDictionary *)parm URL:(NSString *)url images:(NSArray*)imageDataArray  success:(void (^)(id))success fail:(void (^)())fail  progress:(void (^)(float))progress

{
    AFHTTPSessionManager *manager = [self manager];
    [manager POST:url parameters:parm constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /******** 1.上传已经获取到的img *******/
        // 把图片转换成data
        //   NSData *data = UIImagePNGRepresentation(upImg);
        // 拼接数据到请求题中
        for(int  i = 0; i <imageDataArray.count; i++)
        {   UIImage * image = [imageDataArray objectAtIndex:i];
            NSData *imageData=UIImageJPEGRepresentation(image, 0.5);
            // NSData *imageData=imageDataArray[i];
            [formData appendPartWithFileData:imageData name:@"" fileName:[NSString stringWithFormat:@"img%d.jpg", i+1] mimeType:@"image/jpeg"];
        }
        // [formData appendPartWithFileData:imgData name:@"file" fileName:@"123.png" mimeType:@"image/png"];
        /******** 2.通过路径上传沙盒或系统相册里的图片 *****/
        //        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"文件地址"] name:@"file" fileName:@"1234.png" mimeType:@"application/octet-stream" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 打印上传进度
        float uploadProgressF=1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        //  NSLog(@"@@@@+ %lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        progress(uploadProgressF);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        // NSLog(@"请求成功：%@",responseObject);
        if(responseObject){
            NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSString *urlencodeStr=[aString  stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            NSString *str =[urlencodeStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
            
            NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            id  arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (arr) {
                success(arr);
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        //   NSLog(@"请求失败：%@",error);
        fail();
    }];
    
}


#pragma AppleDelegate
//广告页
-(void)GetUserAddverWithSuccess:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    
    [self request:nil URL:@"http://www.zounai.com/index.php/api_vers2/topPic" success:success fail:fail];
}
#pragma 福利列表

//福利列表
-(void)GetFuliListWithSuccess:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    [self request:nil URL:@"http://www.zounai.com/index.php/api_vers3/FlList" success:success fail:fail];


}
//福利列表滚动图
-(void)GetFuliListWithIsFocus:(NSString *)focus Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    NSDictionary * param = @{@"is_focus":focus};

    [self request:param URL:@"http://www.zounai.com/index.php/api_vers3/FlList" success:success fail:fail];
}

//活动列表
-(void)GetHongDongListWithSuccess:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    [self request:nil URL:@"http://www.zounai.com/index.php/api_vers3/HdList" success:success fail:fail];
}
//活动列表滚动图
-(void)GetHongDongListWithIsFocus:(NSString *)focus  Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{    NSDictionary * param = @{@"is_focus":focus};
    [self request:param URL:@"http://www.zounai.com/index.php/api_vers3/HdList" success:success fail:fail];
}

//福利、 活动的详情页
-(void)GetFuliDetailWithId :(NSString *)fuliId URLStr:(NSString *)URLStr  Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    NSDictionary * param = @{@"id":fuliId};
    NSString *url=[NSString stringWithFormat:@"http://www.zounai.com/index.php/api_vers3/%@",URLStr];
    [self request:param URL:url success:success fail:fail];
}

//福利的评论和参与列表
-(void)GetFuliCommetListWithId :(NSString *)fuliId status:(NSString *)status page:(NSString *)page  Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    NSDictionary * param = @{@"id":fuliId,@"status":status ,@"page":page};
    
    [self request:param URL:@"http://www.zounai.com/index.php/api_vers3/FlComment" success:success fail:fail];
}

//活动的评论和参与列表
-(void)GetHdCommetListWithId :(NSString *)fuliId status:(NSString *)status
         page:(NSString *)page
                      Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    NSDictionary * param = @{@"id":fuliId,@"status":status ,@"page":page};
    [self request:param URL:@"http://www.zounai.com/index.php/api_vers3/HdComment" success:success fail:fail];
}

////用户收藏
-(void)AddUserCollectionWithUserId :(NSString *)UserId aid:(NSString *)aid type:(NSString *)type  Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    NSDictionary * param = @{@"user_id":UserId,@"aid":aid,@"type":type};
    
    [self request:param URL:@"http://www.zounai.com/index.php/api_vers3/AddCollection" success:success fail:fail];
}

// 增加评论和参与
-(void)AddHFCommentWithId :(NSString *)uid type:(NSString *)type status:(NSString *)status aid:(NSString *)aid reply:(NSString *)reply  font:(NSString *)font imgs:(NSData *)imaData  Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    NSDictionary * param = @{@"uid":uid,@"type":type,@"status":status,@"aid":aid,@"reply":reply,@"font":font};
    
    [self request:param URL:@"http://www.zounai.com/index.php/api_vers3/AddHFComment" imageData:imaData success:success fail:fail];
    
    
}

#pragma 论坛
//论坛 获取天气
-(void)getWeatherSuccess:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    [self request:nil URL:@"http://api.map.baidu.com/telematics/v3/weather?location=%E5%A4%A9%E6%B4%A5&output=json&ak=f9Bi39Z1z0dL58rUG5zuLWwk" success:success fail:fail];}
//获取个人主页
-(void)GetUserTeiZiWithId :(NSString *)user_id Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    NSDictionary * param = @{@"uid":user_id};
    
    [self request:param URL:@"http://www.zounai.com/index.php/Api/getUserInfo" success:success fail:fail];
}

#pragma 我的
//用户帖子
-(void)userTieZiListWithUserId :(NSString *)UserId page:(NSString *)page type:(NSString *)type  Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    NSDictionary * param = @{@"uid":UserId,@"page":page};
    NSString *url=[NSString stringWithFormat:@"http://www.zounai.com/index.php/api_vers2/%@",type];
    [self request:param URL:url success:success fail:fail];
    
}
//用户卡卷
-(void)GetMyKjWithId :(NSString *)user_id Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    NSDictionary * param = @{@"user_id":user_id};
    
    [self request:param URL:@"http://www.zounai.com/index.php/api_vers3/MyKj" success:success fail:fail];
}
//使用卡券
-(void)UseUserKJWithId:(NSString *)user_id kjID:(NSString *)kjid Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    NSDictionary * param = @{@"user_id":user_id,@"aid":kjid};
    
    [self request:param URL:@"http://www.zounai.com/index.php/api_vers3/UseKj" success:success fail:fail];

}


//用户获得收藏列表
-(void)CollectionListWithUserId :(NSString *)UserId type:(NSString *)type  Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    NSDictionary * param = @{@"user_id":UserId,@"type":type};
    
    [self request:param URL:@"http://www.zounai.com/index.php/api_vers3/CollectionList" success:success fail:fail];
    
}
//我的福利
-(void)mlflWithUserId :(NSString *)UserId Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    NSDictionary * param = @{@"uid":UserId};
   // NSString *url=[NSString stringWithFormat:@"http://www.zounai.com/index.php/api_vers2/%@",type];
    [self request:param URL:@"http://www.zounai.com/index.php/api_vers3/MyFl" success:success fail:fail];
    
}
//我的活动
-(void)mlhdWithUserId :(NSString *)UserId Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    NSDictionary * param = @{@"uid":UserId};
    // NSString *url=[NSString stringWithFormat:@"http://www.zounai.com/index.php/api_vers2/%@",type];
    [self request:param URL:@"http://www.zounai.com/index.php/api_vers3/MyHd" success:success fail:fail];
    
}
//绑定手机
-(void)bindPhoneWithUserId :(NSString *)UserId num:(NSString *)num phone:(NSString *)phone
                   passWord:(NSString *)pw
                    Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
    NSDictionary * param = @{@"uid":UserId,@"telphone":phone,@"number":num,@"password":pw};
    // NSString *url=[NSString stringWithFormat:@"http://www.zounai.com/index.php/api_vers2/%@",type];
    [self request:param URL:@"http://www.zounai.com/index.php/api/BindTelphone" success:success fail:fail];
    
}
//车辆限行
-(void)carLimtWithSuccess:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail
{
   // NSDictionary * param = @{@"uid":UserId,@"telphone":phone,@"number":num,@"password":pw};
    // NSString *url=[NSString stringWithFormat:@"http://www.zounai.com/index.php/api_vers2/%@",type];
    [self request:nil URL: @"http://www.zounai.com/index.php/api/CarLimit" success:success fail:fail];
    
}

@end
