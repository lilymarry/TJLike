//
//  TJCarManager.m
//  TJLike
//
//  Created by MC on 15/4/25.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJCarManager.h"

@interface TJCarManager()
{
}

@end

@implementation TJCarManager

+ (instancetype)shareCarManager
{
    static dispatch_once_t onceToken;
    static TJCarManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initCarManager];
    });
    return manager;
}
- (instancetype)init {
    NSAssert(NO, @"Singleton class, use shared method");
    return nil;
}

- (instancetype)initCarManager {
    self = [super init];
    if (!self) return nil;
    
    if ([SHARE_DEFAULTS objectForKey:@"Car"]) {
        
    }else{
        
    }
    return self;
}
- (NSMutableArray *)carInfoArray{
    NSMutableArray *carInfoArray =[[NSMutableArray alloc]init];
    if ([SHARE_DEFAULTS objectForKey:@"Car"]){
        carInfoArray =[SHARE_DEFAULTS objectForKey:@"Car"];
    }
    NSMutableArray *carArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<carInfoArray.count; i++) {
        NSDictionary *dict = [carInfoArray objectAtIndex:i];
        TJFoundCarModel *model = [[TJFoundCarModel alloc]init];
        model.name = dict[@"name"];
        model.num = dict[@"num"];
        model.model = dict[@"model"];
        model.limit = dict[@"limit"];
        model.check = dict[@"check"];
        model.baoxian = dict[@"baoxian"];
        model.jiazhao = dict[@"jiazhao"];
        [carArray addObject:model];
    }
    return carArray;
}
- (void)addCarInfo:(TJFoundCarModel *)carModel{
    
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    
    if ([SHARE_DEFAULTS objectForKey:@"Car"]) {
        mArray = [[NSMutableArray alloc]initWithArray:[SHARE_DEFAULTS objectForKey:@"Car"]];
    }else{
        
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:carModel.name forKey:@"name"];
    [dict setObject:carModel.num forKey:@"num"];
    [dict setObject:carModel.model forKey:@"model"];
    [dict setObject:carModel.check forKey:@"check"];
    [dict setObject:carModel.baoxian forKey:@"baoxian"];
    [dict setObject:carModel.jiazhao forKey:@"jiazhao"];
    [dict setObject:carModel.limit forKey:@"limit"];
    [mArray addObject:dict];
    [SHARE_DEFAULTS setObject:mArray forKey:@"Car"];
    [SHARE_DEFAULTS synchronize];
}

- (void)removeCarInfo:(int)indexPath{
    NSMutableArray *carInfoArrayRemove = [[NSMutableArray alloc] initWithArray:[SHARE_DEFAULTS objectForKey:@"Car"]];
//    carInfoArrayRemove = (NSMutableArray *)[SHARE_DEFAULTS objectForKey:@"Car"];
    if (!carInfoArrayRemove && carInfoArrayRemove.count == 0) {
        return;
    }
    
    [carInfoArrayRemove removeObjectAtIndex:indexPath];
    [SHARE_DEFAULTS setObject:carInfoArrayRemove forKey:@"Car"];
    [SHARE_DEFAULTS synchronize];
}
- (void)ReplaceCarInfoAtIndexPath:(int)indexPath With:(TJFoundCarModel *)carModel{
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    
    if ([SHARE_DEFAULTS objectForKey:@"Car"]) {
        mArray = [[NSMutableArray alloc]initWithArray:[SHARE_DEFAULTS objectForKey:@"Car"]];
    }else{
        
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:carModel.name forKey:@"name"];
    [dict setObject:carModel.num forKey:@"num"];
    [dict setObject:carModel.model forKey:@"model"];
    [dict setObject:carModel.check forKey:@"check"];
    [dict setObject:carModel.baoxian forKey:@"baoxian"];
    [dict setObject:carModel.jiazhao forKey:@"jiazhao"];
    [dict setObject:carModel.limit forKey:@"limit"];
    [mArray replaceObjectAtIndex:indexPath withObject:dict];
    [SHARE_DEFAULTS setObject:mArray forKey:@"Car"];
    [SHARE_DEFAULTS synchronize];
}

- (TJFoundCarModel *)CarInfoAtIndexPath:(int)indexPath{
    NSMutableArray *carInfoArray =[SHARE_DEFAULTS objectForKey:@"Car"];
    NSDictionary *dict = [carInfoArray objectAtIndex:indexPath];
    TJFoundCarModel *model = [[TJFoundCarModel alloc]init];
    model.name = dict[@"name"];
    model.num = dict[@"num"];
    model.model = dict[@"model"];
    model.limit = dict[@"limit"];
    model.check = dict[@"check"];
    model.baoxian = dict[@"baoxian"];
    model.jiazhao = dict[@"jiazhao"];

    return model;
}

@end
