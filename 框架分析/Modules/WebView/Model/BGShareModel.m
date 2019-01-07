//
//  BGShareModel.m
//  框架分析
//
//  Created by FuBG02 on 2019/1/7.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import "BGShareModel.h"

@implementation BGShareModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"weburl": @"weburl",
             @"shareimgurl": @"shareimgurl",
             @"type": @"type",
             @"title": @"title",
             @"message": @"message"
             };
    
}
@end
