//
//  FDHomeModel.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/19.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "FDHomeModel.h"

@implementation FDHomeModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID":@"id",
             @"des":@"post_title",
             @"readCount":@"post_hits",
             @"collectionCount":@"post_favorites",
             @"goodCount":@"post_like",
             @"messageCount":@"comment_count",
             @"img":@"thumbnail"
             };
    
}
@end
