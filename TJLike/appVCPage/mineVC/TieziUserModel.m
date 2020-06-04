//
//  TieziUserModel.m
//  TJLike
//
//  Created by imac-1 on 16/9/5.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "TieziUserModel.h"

@implementation TieziUserModel
-(instancetype)initWithDic:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.comment = dict[@"comment"];
         self.font = dict[@"font"];
        
        self.good =dict[@"good"];
         self.icon =dict[@"icon"];
        self.Tieziid = dict[@"id"];
        
        self.imgs = dict[@"imgs"];
        self.nickname = dict[@"nickname"];
        
        self.time = dict[@"time"];
        self.title =dict[ @"title"];
        self.uid = dict[@"uid"];
        self.username =dict[@"username"];
        self.weiboicon = dict[@"weiboicon"];
        self.count = dict[@"count"];
    }
    return self;
}
@end
