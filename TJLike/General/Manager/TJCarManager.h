//
//  TJCarManager.h
//  TJLike
//
//  Created by MC on 15/4/25.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJFoundCarModel.h"

@interface TJCarManager : NSObject

@property (nonatomic, strong) NSMutableArray *carInfoArray;

+ (instancetype)shareCarManager;
- (void)addCarInfo:(TJFoundCarModel *)carModel;
- (TJFoundCarModel *)CarInfoAtIndexPath:(int)indexPath;
- (void)removeCarInfo:(int)indexPath;
- (void)ReplaceCarInfoAtIndexPath:(int)indexPath With:(TJFoundCarModel *)model;
@end
