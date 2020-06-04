//
//  TJFoundCarModel.m
//  TJLike
//
//  Created by MC on 15/4/25.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJFoundCarModel.h"

@implementation TJFoundCarModel

- (id)init{
    self = [super init];
    if (self) {
        self.name = @"";
        self.num = @"";
        self.limit = @"";
        self.check = @"";
        self.baoxian = @"";
        self.jiazhao = @"";
        self.model = @"";
    }
    return self;
}

@end
