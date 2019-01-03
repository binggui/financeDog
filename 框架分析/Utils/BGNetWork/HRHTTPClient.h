//
//  HRHTTPClient.h
//  ZGHR
//
//  Created by 王大侠 on 16/12/7.
//  Copyright © 2016年 aspire. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking.h>


@interface HRHTTPClient : AFHTTPSessionManager
+ (instancetype)shareNetworkTools;

@end
