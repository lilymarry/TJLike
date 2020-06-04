//
//  HuoDongModel.m
//  TJLike
//
//  Created by imac-1 on 16/9/21.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "HuoDongModel.h"

@implementation HuoDongModel
-(instancetype)initWithDic:(NSDictionary *)dict
{
    if (self=[super init]) {
        
        self.address=dict[@"address"];
        self.endtime=dict[@"endtime"];
      
        self.FuliId=dict[@"id"];
 
        self.startime=dict[@"startime"];
        self.title=dict[@"title"];
        self.hb=dict[@"hb"];
    }
    return self;
}

@end
