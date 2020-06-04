//
//  TJMyKjModel.m
//  TJLike
//
//  Created by imac-1 on 16/9/23.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "TJMyKjModel.h"

@implementation TJMyKjModel
-(instancetype)initWithDic:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.kjID = dict[@"id"];
        self.endtime =dict[@"endtime"];
        self.focus = dict[@"focus"];
        self.is_use = dict[@"is_use"];
        self.recommand_title =dict[ @"recommand_title"];
        self.startime = dict[@"startime"];
        self.supplier = dict[@"supplier"];
        self.title =dict[@"title"];
     
     
    }
    return self;
}
@end
