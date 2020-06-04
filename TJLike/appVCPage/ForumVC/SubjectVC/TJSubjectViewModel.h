//
//  TJSubjectViewModel.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/15.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJBBSContentModel.h"
#import "TJCommentModel.h"

@interface TJSubjectViewModel : NSObject

@property (nonatomic, strong) TJBBSContentModel  *bbsContent;
@property (nonatomic, strong) NSArray            *commentLists;

/**
 *  获得一个帖子的内容
 *
 *  @param bbsID       一个帖子的ID
 *  @param finishBlock <#finishBlock description#>
 *  @param failedBlock <#failedBlock description#>
 */
- (void)requestBBsContent:(id)bbsID andFinish:(void (^)(TJBBSContentModel *result))finishBlock andFailed:(void (^)(NSString *error))failedBlock;
/**
 *  评论列表
 *
 *  @param bid         <#bid description#>
 *  @param page        <#page description#>
 *  @param commentid   <#commentid description#>
 *  @param finishBlock <#finishBlock description#>
 *  @param failBlock   <#failBlock description#>
 */
- (void)postBBSCommentList:(NSString *)bid withPage:(NSString *)page withCommentid:(NSString *)commentid withRank:(NSString *)rank andFinishBlock:(void (^)(NSArray *results))finishBlock andFaileBlock:(void (^)(NSString *error))failBlock;
//添加评论
- (void)postBBSAddComment:(NSString *)bid withUserID:(NSString *)uid withParent:(NSString *)Parent withReplyid:(NSString *)Replyid withContent:(NSString *)content withImage:(NSArray *)image andFinishBlock:(void (^)(id result))finishBlock andFaileBlock:(void (^)(NSString *error))failBlock;
//举报论坛评论
- (void)postBBSCreport:(NSString *)bid withCid:(NSString *)cid andFinishBlock:(void (^)(NSArray *results))finishBlock andFaileBlock:(void (^)(NSString *error))failBlock;
//帖子点赞
- (void)postBBSTiBaGood:(NSString *)bid andFinishBlock:(void (^)(id result))finishBlock andFaileBlock:(void (^)(NSString *error))failBlock;

//删除帖子
- (void)postDeleteBBs:(NSString *)bbsId withUserId:(NSString *)userId andFinishBlock:(void (^)(id result))finishBlock andFaileBlock:(void (^)(NSString *error))failBlock;
- (void)postTopicAddComment:(NSString *)bid withUserID:(NSString *)uid withParent:(NSString *)Parent withReplyid:(NSString *)Replyid withContent:(NSString *)content withImage:(NSData *)imageData  andFinish:(void (^)(NSDictionary *resultDict))finishBlock andFailed:(void (^)(NSString *error))faileBlock;

@end
