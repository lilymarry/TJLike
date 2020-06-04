//
//  UserModel.h
//  TJLike
//
//  Created by imac-1 on 16/8/24.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property(copy,nonatomic)NSString *datetime;
@property(copy,nonatomic)NSString *font;
@property(copy,nonatomic)NSString *icon;
@property(copy,nonatomic)NSString *uesrid;
@property(copy,nonatomic)NSString *imgs;
@property(copy,nonatomic)NSString *nickname;
@property(copy,nonatomic)NSString *uid;
@property(copy,nonatomic)NSString *username;
@property(copy,nonatomic)NSString *weiboicon;

-(instancetype)initWithDic:(NSDictionary *)dict;
@end
