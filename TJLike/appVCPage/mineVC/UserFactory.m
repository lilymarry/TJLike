//
//  UserFactory.m
//  leanCloudChat
//
//  Created by 123 on 16/9/18.
//  Copyright © 2016年 魏艳丽. All rights reserved.
//

#import "UserFactory.h"
#import "CDUserModel.h"

@interface CDUser : NSObject <CDUserModelDelegate>

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *avatarUrl;

@end

@implementation CDUser

@end
@implementation UserFactory
- (void)cacheUserByIds:(NSSet *)userIds block:    (AVBooleanResultBlock)block {
    block(YES, nil);
}

- (id <CDUserModelDelegate> )getUserById:(NSString *)userId {
    CDUser *user = [[CDUser alloc] init];
    user.userId = userId;
    //在cell中显示的聊天对象的名字
    user.username = userId;
    //聊天对象的头像
   // user.avatarUrl =@"http://tp2.sinaimg.cn/5088940253/180/5745995456/1";
    return user;
}

- (id<CDUserModelDelegate>)getUserById:(NSString *)userId  withUserUrl:(NSString *)url {
    CDUser *user = [[CDUser alloc] init];
    user.userId = userId;
    //在cell中显示的聊天对象的名字
    user.username = userId;
    //聊天对象的头像
    //@"http://tp2.sinaimg.cn/5088940253/180/5745995456/1"
    user.avatarUrl =  url;
    return user;
}
- (id<CDUserModelDelegate>)getUserById:(NSString *)userId name:(NSString *)nam withUserUrl:(NSString *)url {
    CDUser *user = [[CDUser alloc] init];
    user.userId = userId;
    //在cell中显示的聊天对象的名字
    user.username = nam;
    //聊天对象的头像
    //@"http://tp2.sinaimg.cn/5088940253/180/5745995456/1"
    user.avatarUrl =  url;
    return user;
}

@end
