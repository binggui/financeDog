//
//  BGCommentModel.m
//  框架分析
//
//  Created by FuBG02 on 2019/1/7.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import "BGCommentModel.h"

@implementation BGCommentModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"activity_id":@"id",
             @"acvitity_hits":@"post_hits",
             @"acvitity_favorites":@"post_favorites",
             @"acvitity_like":@"post_like",
             @"acvitity_comment_count":@"comment_count",
             //评论
             @"comment_id":@"id",
             @"comment_parent_id":@"parent_id",
             @"comment_user_id":@"user_id",
             @"comment_beUserd_id":@"to_user_id",
             @"comment_activity_id":@"object_id",
             @"comment_like":@"like_count",
             @"comment_time":@"create_time",
             @"comment_name":@"full_name",
             @"comment_content":@"content"
             };
 
}
@end
