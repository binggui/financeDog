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
             @"name":@"user_nickname"
             };
    
}
@end
