//
//  UserModel.m
//  TJLike
//
//  Created by imac-1 on 16/8/24.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
-(instancetype)initWithDic:(NSDictionary *)dict
{
    if (self=[super init]) {
        
        self.datetime=dict[@"datetime"];
        self.font=dict[@"font"];
        self.icon=dict[@"icon"];
        self.uesrid=dict[@"id"];
        self.imgs=dict[@"imgs"];
        self.nickname=dict[@"nickname"];
        self.uid=dict[@"uid"];
        self.username=dict[@"username"];
        self.weiboicon=dict[@"weiboicon"];

    }
    return self;
}
@end
