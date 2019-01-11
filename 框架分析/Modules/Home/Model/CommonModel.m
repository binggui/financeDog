//
//  CommonModel.m
//  框架分析
//
//  Created by FuBG02 on 2019/1/9.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import "CommonModel.h"

@implementation CommonModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"ID":@"id",
             @"des":@"post_title",
             @"readCount":@"post_hits",
             @"collectionCount":@"post_favorites",
             @"goodCount":@"post_like",
             @"messageCount":@"comment_count",
             @"img":@"thumbnail",
             @"time":@"published_time",
             @"titleDes":@"post_excerpt",
             @"url":@"url",
             @"jumpUrl":@"portal_url",
             @"publishTime":@"update_time",
             @"source":@"post_source"
             };

}
@end
