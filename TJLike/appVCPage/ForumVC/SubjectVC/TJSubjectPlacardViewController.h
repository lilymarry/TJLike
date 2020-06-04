//
//  TJSubjectPlacardViewController.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"

typedef NS_ENUM(NSInteger, ContentSort){
    ContentSort_desc = 0, //降序
    ContentSort_asc
};


@interface TJSubjectPlacardViewController : TJBaseViewController

@property (nonatomic, assign) BOOL isExistDelete;

- (instancetype)initWithItem:(NSString *)cateId;
@end
