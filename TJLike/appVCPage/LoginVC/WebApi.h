//
//  FuliWebApi.h
//  TJLike
//
//  Created by imac-1 on 16/8/22.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^HttpRequestFailedBlock)(NSError *error);

@interface WebApi : NSObject
@property (nonatomic, copy) HttpRequestFailedBlock failBlock;
+(WebApi*)sharedRequest;
-(void)request:(NSDictionary *)parm URL:(NSString *)url success:(void (^)(id))success fail:(void (^)())fail;
-(void)requestMorePic:(NSDictionary *)parm URL:(NSString *)url images:(NSArray*)imageDataArray  success:(void (^)(id))success fail:(void (^)())fail  progress:(void (^)(float))progress;
//福利列表
-(void)GetFuliListWithSuccess:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;
//福利列表滚动图
-(void)GetFuliListWithIsFocus:(NSString *)focus Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;
////福利、 活动的详情页
-(void)GetFuliDetailWithId :(NSString *)fuliId URLStr:(NSString *)URLStr Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;
//活动列表
-(void)GetHongDongListWithSuccess:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;
//活动列表滚动图
-(void)GetHongDongListWithIsFocus:(NSString *)focus  Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;
//福利的评论和参与列表
-(void)GetFuliCommetListWithId :(NSString *)fuliId status:(NSString *)status page:(NSString *)page  Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;
//活动的评论和参与列表
-(void)GetHdCommetListWithId :(NSString *)fuliId status:(NSString *)status
                         page:(NSString *)page
                      Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;
////用户收藏
-(void)AddUserCollectionWithUserId :(NSString *)UserId aid:(NSString *)aid type:(NSString *)type  Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;
//用户获得收藏列表(我的页面)
-(void)CollectionListWithUserId :(NSString *)UserId type:(NSString *)type  Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;
//论坛 获取天气
-(void)getWeatherSuccess:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;

-(void)userTieZiListWithUserId :(NSString *)UserId page:(NSString *)page type:(NSString *)type  Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;

//用户卡卷
-(void)GetMyKjWithId :(NSString *)user_id Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail; 
//使用卡券
-(void)UseUserKJWithId:(NSString *)user_id kjID:(NSString *)kjid Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;

// 增加评论和参与
-(void)AddHFCommentWithId :(NSString *)uid type:(NSString *)type status:(NSString *)status aid:(NSString *)aid reply:(NSString *)reply  font:(NSString *)font imgs:(NSData *)imaData  Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;

//获取个人主页
-(void)GetUserTeiZiWithId :(NSString *)user_id Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;
//广告页
-(void)GetUserAddverWithSuccess:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;
//我的福利
-(void)mlflWithUserId :(NSString *)UserId Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;
//我的活动
-(void)mlhdWithUserId :(NSString *)UserId Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;
//绑定手机
-(void)bindPhoneWithUserId :(NSString *)UserId num:(NSString *)num phone:(NSString *)phone
                   passWord:(NSString *)pw
                    Success:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;
//车辆限行
-(void)carLimtWithSuccess:(void(^)(NSDictionary *userInfo))success fail:(void(^)())fail;
@end
