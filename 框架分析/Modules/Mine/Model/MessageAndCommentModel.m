//
//  MessageAndCommentModel.m
//  框架分析
//
//  Created by FuBG02 on 2019/1/12.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import "MessageAndCommentModel.h"
@implementation MessageAndCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"content":@"content",
             @"pushTime":@"push_time",
             @"desc":@"id",
             @"imgurl":@"image",
             @"target":@"target",
             @"title":@"title",
             @"name":@"user_nickname",
             @"recommend_name":@"full_name",
             @"recommend_user_id":@"user_id",
             @"recommend_time":@"create_time",
             @"recommend_post_id":@"post_id",
             @"recommend_title":@"post_title",
             @"recommend_hits":@"post_hits",
             @"recommend_favorites":@"post_favorites",
             @"recommend_like":@"post_like",
             @"recommend_count":@"comment_count",
             @"recommend_url":@"url"
             };

}
@end
