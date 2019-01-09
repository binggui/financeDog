//
//  PersonModel.m
//  框架分析
//
//  Created by 丙贵 on 18/5/17.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID":@"id",
             @"city":@"post_title",
             @"juli":@"post_hits",
             @"collectionCount":@"post_favorites",
             @"goodCount":@"post_like",
             @"messageCount":@"comment_count",
             @"hobbys":@"post_excerpt",
             @"picture":@"thumbnail"
             };
}
@end
