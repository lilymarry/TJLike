//
//  TJFuliModel.m
//  TJLike
//
//  Created by imac-1 on 16/8/22.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "TJFuliModel.h"

@implementation TJFuliModel
-(instancetype)initWithDic:(NSDictionary *)dict
{
    if (self=[super init]) {
        
        self.count=dict[@"count"];
        self.endtime=dict[@"endtime"];
        self.focus=dict[@"focus"];
        self.FuliId=dict[@"id"];
        self.price=dict[@"price"];
        self.startime=dict[@"startime"];
        self.title=dict[@"title"];
        self.hb=dict[@"hb"];
    }
    return self;
}

@end
