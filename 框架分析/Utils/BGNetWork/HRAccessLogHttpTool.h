//
//  HRAccessLogHttpTool.h
//  ZGHR
//
//  Created by WDX on 17/3/14.
//  Copyright © 2017年 aspire. All rights reserved.
//
//埋点请求
#import "HRHTTPTool.h"

@interface HRAccessLogHttpTool : HRHTTPTool

+ (void)postLogWithparameters:(NSMutableDictionary *)parameters;
@end
