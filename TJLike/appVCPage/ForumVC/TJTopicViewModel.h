//
//  TJTopicViewModel.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJTopicViewModel : NSObject

@property (nonatomic, strong) NSArray  *topLists;
@property (nonatomic, strong) NSArray  *contentLists;

//http://www.zounai.com/index.php/api/BbsNotice
- (void)postTopicBBSNotice:(NSString *)subId andFinishBlock:(void(^)(NSArray *results))finishBlock andFaileBlock:(void(^)(NSString *error))failBlock;
//http://www.zounai.com/index.php/api/BbsTopTieBa帖子置顶内容
- (void)postTopicBBSTopTieBa:(NSString *)subId andFinishBlock:(void(^)(NSArray *results))finishBlock andFaileBlock:(void(^)(NSString *error))failBlock;
// http://www.zounai.com/index.php/api/BbsTieBa  帖子内容列表
- (void)postTopicBBSTieBaContent:(NSString *)subId withPageIndex:(int)pageIndex withRank:(NSString *)rank andFinishBlock:(void(^)(NSArray *results))finishBlock andFaileBlock:(void(^)(NSString *error))failBlock;
// http://www.zounai.com/index.php/api/BbsAddTieba添加帖子
- (void)postTopicBBSAddTieba:(NSString *)cateId andUserId:(NSString *)userId withTitle:(NSString *)title withFont:(NSString *)font withPalce:(NSString *)palce withimageFile:(NSArray *)array andFinishBlock:(void(^)(NSArray *results))finishBlock andFaileBlock:(void(^)(NSString *error))failBlock;

- (void)postTopicBBSAddTieba:(NSArray *)images withCateID:(NSString *)cateId andUserId:(NSString *)userId withTitle:(NSString *)title withFont:(NSString *)font withPalce:(NSString *)palce andFinish:(void (^)(NSDictionary *resultDict))finishBlock andFailed:(void (^)(NSString *error))faileBlock;

@end
