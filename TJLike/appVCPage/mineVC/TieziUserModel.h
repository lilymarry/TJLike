//
//  TieziUserModel.h
//  TJLike
//
//  Created by imac-1 on 16/9/5.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TieziUserModel : NSObject
@property (nonatomic, strong) NSString *comment; //= 2;
@property (nonatomic, strong) NSString *font; //= 2;
@property (nonatomic, strong) NSString *good; //= 46;
@property (nonatomic, strong) NSString *icon; //= 46;
@property (nonatomic, strong) NSString *Tieziid; //= "\U4e0d\U80fd";
@property (nonatomic, strong) NSString *imgs; //= 18722506554;
@property (nonatomic, strong) NSString *nickname; //= 13;
@property (nonatomic, strong) NSString *time; //= 13;
@property (nonatomic, strong) NSString *title; //= "\U8fd9\U662f\U4ec0\U4e48";

@property (nonatomic, strong) NSString *uid; //= 13;
@property (nonatomic, strong) NSString *username; //= "\U8fd9\U662f\U4ec0\U4e48";
@property (nonatomic, strong) NSString *weiboicon; //= "\U8fd9\U662f\U4ec0\U4e48";
@property (nonatomic, strong) NSString *count; //= "\U8fd9\U662f\U4ec0\U4e48";
-(instancetype)initWithDic:(NSDictionary *)dict;
//count = 13;
//font = "\U4e8b";
//good = 3;
//icon = "http://www.zounai.com/upload/avatar/20160914/20160914155036_31338.png";
//id = 581;
//imgs = "";
//nickname = "\U7a46\U7a46";
//title = "\U8bd5\U8bd5";
//userid = 1561;
//username = 18222112651;
//weiboicon = "";
@end
