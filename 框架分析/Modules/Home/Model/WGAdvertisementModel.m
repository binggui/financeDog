//
//  WGAdvertisementModel.m
//  框架分析
//
//  Created by FuBG02 on 2019/1/3.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import "WGAdvertisementModel.h"

@implementation WGAdvertisementModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"content":@"content",
             @"des":@"description",
             @"desc":@"id",
             @"imgurl":@"image",
             @"target":@"target",
             @"title":@"title",
             @"jumpurl":@"url"
             };
}
//+ (NSValueTransformer *)iconurlJSONTransformer{
//    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
//}
@end
