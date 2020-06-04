//
//  TJBBSContentModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/15.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBBSContentModel.h"

@implementation TJBBSContentModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if (StringEqual(key, @"id")) {
        self.bbsId = value;
    }
}

@end
