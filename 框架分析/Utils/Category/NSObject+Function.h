//
//  NSObject+Function.h
//  ZGHR
//
//  Created by WDX on 17/2/17.
//  Copyright © 2017年 aspire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Function)
//判断是否为中文
- (BOOL)isChinese;
//判断号码是否符合手机号
- (BOOL)isTelephoneNum;
//判断密码是否符合标准
- (BOOL)isSecret;


- (BOOL)controlDonateBeanNumWithString :(NSString *)string;
@end
