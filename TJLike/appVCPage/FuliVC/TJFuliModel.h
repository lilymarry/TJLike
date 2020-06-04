//
//  TJFuliModel.h
//  TJLike
//
//  Created by imac-1 on 16/8/22.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJFuliModel : NSObject
@property(copy,nonatomic)NSString *count;
@property(copy,nonatomic)NSString *endtime;
@property(copy,nonatomic)NSString *focus;
@property(copy,nonatomic)NSString *FuliId;
@property(copy,nonatomic)NSString *price;
@property(copy,nonatomic)NSString *startime;
@property(copy,nonatomic)NSString *title;
@property(copy,nonatomic)NSString *hb;
-(instancetype)initWithDic:(NSDictionary *)dict;
@end
