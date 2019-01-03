//
//  HRHTTPToolWithSID.m
//  ZGHR
//
//  Created by WDX on 17/2/23.
//  Copyright © 2017年 aspire. All rights reserved.
//

#import "HRHTTPToolWithSID.h"

@implementation HRHTTPToolWithSID

+ (void)getWithURL:(NSString *)URL parameters:(NSMutableDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //取sid
    NSString *sid = [defaults objectForKey:@"sid"];
    if (sid != nil) {
        [parameters setObject:sid forKey:@"sid"];
    }
    [super getWithURL:URL parameters:parameters success:success failure:failure];
}


+ (void)postWithURL:(NSString *)URL parameters:(NSMutableDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (parameters == nil) {
        parameters = [NSMutableDictionary dictionary];
    }
    //取sid
    NSString *sid = [defaults objectForKey:@"sid"];
    if (sid != nil) {
        [parameters setObject:sid forKey:@"sid"];
    }
    [super postWithURL:URL parameters:parameters success:success failure:failure];
}
@end
