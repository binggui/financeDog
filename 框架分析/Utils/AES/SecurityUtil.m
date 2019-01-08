//
//  SecurityUtil.h
//  Smile
//
//  Created by 蒲晓涛 on 12-11-24.
//  Copyright (c) 2012年 BOX. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "SecurityUtil.h"
#import "NSData+AES.h"

#define key @"$20^ecnd&cyxh_hs"

@implementation SecurityUtil


#pragma mark - AES加密
//将string转成带密码的data
+(NSData*)encryptAESData:(NSString*)string
{
    //将nsstring转化为nsdata
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对nsdata进行加密
    NSData *encryptedData = [data AES128EncryptWithKey:key];
    return encryptedData;
}


#pragma mark - AES解密
//将带密码的data转成string
+(NSString*)decryptAESData:(NSData*)data
{
    //使用密码对data进行解密
    NSData *decryData = [data AES128DecryptWithKey:key];
    //将解了密码的nsdata转化为nsstring
    NSString *str = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
    return str;
}

@end
