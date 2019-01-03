//
//  NSObject+Function.m
//  ZGHR
//
//  Created by WDX on 17/2/17.
//  Copyright © 2017年 aspire. All rights reserved.
//

#import "NSObject+Function.h"
@implementation NSObject (Function)

//是否为中文
- (BOOL)isChinese
{
    NSString *regex = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}
//输入是否符合手机号标准
- (BOOL)isTelephoneNum{
    NSString *regex = @"^((14[0-9])|(13[0-9])|(15[0-9])|(16[0-9])|(18[0-9])|(17[0-9])|(19[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}
//
- (BOOL)isSecret{
    NSString *regex = @"^((?=.*[0-9].*)(?=.*[A-Za-z].*))[0-9A-Za-z\\S]{6,25}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

//手机号中间加星
- (NSString *)telePhoneNumberToStar :(NSString *)num{
    //不做判断了,用的时候注意11位
    NSString *leftNum = [num substringToIndex:3];
    NSString *rightNum = [num substringWithRange:NSMakeRange(7, 4)];
    NSString *starNum = [NSString stringWithFormat:@"%@****%@",leftNum,rightNum];
    return starNum;
    
}
//0-1000的正则  var reg=/^(100|[1-9]\\d|\\d)$/;
- (BOOL)controlDonateBeanNumWithString :(NSString *)string{
    NSString *regex = @"^(1000|[1-9]\\d|\\d|\\d)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}
@end
