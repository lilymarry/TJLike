//
//  NewsBannerInfo.m
//  TJLike
//
//  Created by MC on 15-3-30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "NewsBannerInfo.h"

@implementation NewsBannerInfo
+ (NewsBannerInfo *)CreateWithDict:(NSDictionary *)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[NewsBannerInfo alloc] initWithDict:dict];
}

- (NSDictionary *)GetFormatDict:(NSDictionary *)dictionary {
    NSMutableDictionary *netDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    for (NSString *key in netDic.allKeys) {
        id target = [netDic objectForKey:key];
        if ([target isKindOfClass:[NSNull class]]) {
            [netDic removeObjectForKey:key];
        }
    }
    return netDic;
}

- (id)initWithDict:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        NSDictionary *netDic = [self GetFormatDict:dictionary];
        for (NSString *key in netDic.allKeys) {
            if ([key isEqualToString:@"nid"]) {
                self.nid = [netDic[key] intValue];
            }
            else if ([key isEqualToString:@"图文"]){
                NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:netDic[key]];
                self.tuwen = [NSArray arrayWithObject:dict];
            }
            else {
                [self setValue:netDic[key] forKey:key];
            }
        }
    }
    return self;
}

- (void)dealloc {
    self.focusimg = nil;
    self.property = nil;
    self.title = nil;
    self.tuwen = nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"the undeFinedKey is -->%@",key);
}
@end
