//
//  TJMyKjModel.h
//  TJLike
//
//  Created by imac-1 on 16/9/23.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "TJLikeBaseDataModel.h"

@interface TJMyKjModel : NSObject
@property (nonatomic, strong) NSString *kjID;
@property (nonatomic, strong) NSString *   endtime;
@property (nonatomic, strong) NSString *   focus;
@property (nonatomic, strong) NSString *   is_use;
@property (nonatomic, strong) NSString *   recommand_title;
@property (nonatomic, strong) NSString *   startime;
@property (nonatomic, strong) NSString *   supplier;
@property (nonatomic, strong) NSString *   title;

-(instancetype)initWithDic:(NSDictionary *)dict;
@end
