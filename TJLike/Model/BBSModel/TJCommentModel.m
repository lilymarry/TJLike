//
//  TJCommentModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/15.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJCommentModel.h"
#import "TJSubCommentModel.h"

@implementation TJCommentModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [super setValue:value forUndefinedKey:key];
    if (StringEqual(key, @"sub")) {
   
        NSMutableArray *results = [[NSMutableArray alloc] init];
        for (NSDictionary *item in value) {
          TJSubCommentModel *model = [[TJSubCommentModel alloc] init];
       //  TJSubCommentModel *model = [[TJSubCommentModel alloc] initWithDic:item];
        [model setValuesForKeysWithDictionary:item];
        [results addObject:model];
        }
        self.subLists = results;
    }
}

@end
