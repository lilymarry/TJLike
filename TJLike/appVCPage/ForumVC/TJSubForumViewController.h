//
//  TJSubForumViewController.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"
#import "TJBBSCateSubModel.h"
#import "TJBBSTopTieBaModel.h"
#import "TJTieBaContentModel.h"

//typedef NS_ENUM(NSInteger, ContentSort){
//    ContentSort_desc = 0, //降序
//    ContentSort_asc
//};


@interface TJSubForumViewController : TJBaseViewController

- (instancetype)initWithItem:(TJBBSCateSubModel*)item;

@end
