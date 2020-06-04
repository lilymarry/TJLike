//
//  TJCommentModel.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/15.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJLikeBaseDataModel.h"
//2222
@interface TJCommentModel : TJLikeBaseDataModel
@property (nonatomic, strong) NSString *bid; //= 2;
@property (nonatomic, strong) NSString *cid; //= 42;
@property (nonatomic, strong) NSString *commentuserid; //= 13;
@property (nonatomic, strong) NSString *content; //= "\U56de\U590d7";
@property (nonatomic, strong) NSString *icon; //= "http://www.zounai.com/upload/avatar/20150411/20150411161914_68062.png";
@property (nonatomic, strong) NSString *image; //= "";
@property (nonatomic, strong) NSString *nickname; //= "\U4e0d\U80fd";
@property (nonatomic, strong) NSArray  *subLists;
@property (nonatomic, strong) NSString *time; //= "2015-03-30 20:25:27";
@property (nonatomic, strong) NSString *username; //= 18722506554;
@property (nonatomic, strong) NSString *weibo; //= "";
@property (nonatomic, strong) NSString *weiboicon; //= "";

@property (nonatomic, assign) BOOL    isLoading;

@end
