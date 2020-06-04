//
//  HuoDongModel.h
//  TJLike
//
//  Created by imac-1 on 16/9/21.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuoDongModel : NSObject
@property(copy,nonatomic)NSString *address;
@property(copy,nonatomic)NSString *endtime;
@property(copy,nonatomic)NSString *hb;
@property(copy,nonatomic)NSString *FuliId;
@property(copy,nonatomic)NSString *title;
@property(copy,nonatomic)NSString *startime;


-(instancetype)initWithDic:(NSDictionary *)dict;
@end
