//
//  HRHTTPClient.m
//  ZGHR
//
//  Created by 王大侠 on 16/12/7.
//  Copyright © 2016年 aspire. All rights reserved.
//

#import "HRHTTPClient.h"

@implementation HRHTTPClient
static HRHTTPClient *_shareInstance;
static dispatch_once_t onceToken;

+ (instancetype)shareNetworkTools
{
    dispatch_once(&onceToken, ^{
        _shareInstance = [[HRHTTPClient alloc] init];
        
        AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
        
        
        [_shareInstance setResponseSerializer:serializer];
        
        //如果报接受类型不一致请替换一致text/html或别的
        _shareInstance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"text/html", nil];
        
        
        
            //设置请求头
//        声明请求的格式,这里需要与后台沟通,默认为二进制
        AFJSONRequestSerializer *jsonRequestSerializer = [AFJSONRequestSerializer serializer];
        [_shareInstance setRequestSerializer:jsonRequestSerializer];
        
        _shareInstance.requestSerializer.timeoutInterval = 25;
        //IMEI
        [_shareInstance.requestSerializer setValue:@"5d36f8c6e8ef5dbfe03462a6fb7a0827cfbce84277a7542e05fc7bf98e01c01513ac19e35fbe384deef9f11a707b844d" forHTTPHeaderField:@"IMEI"];
        //消息协议版本
        [_shareInstance.requestSerializer setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"APIVersion"];
        //消息体类型
        [_shareInstance.requestSerializer setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
        //分辨率
        CGFloat scale_screen = [UIScreen mainScreen].scale;
        NSString *resolution = [NSString stringWithFormat:@"%f*%f",KScreenHeight * scale_screen,KScreenWidth * scale_screen];
        //屏幕分辨率
        [_shareInstance.requestSerializer setValue:resolution forHTTPHeaderField:@"Resolution"];
        //客户端版本号
        NSString *clientVer = [NSString stringWithFormat:@"IOS%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleShortVersionString"]];
        [_shareInstance.requestSerializer setValue:clientVer forHTTPHeaderField:@"ClientVer"];
        //客户端渠道标识
        [_shareInstance.requestSerializer setValue:@"" forHTTPHeaderField:@"Channel"];
        
        //接口命令字在下一步设置

    });
    return _shareInstance;
    
}

//+ (instancetype)shareNetworkTools
//{
//    
//    dispatch_once(&onceToken, ^{
//        _shareInstance = [[HRHTTPClient alloc] init];
//        
//        //        声明请求的数据是json类型
//        AFJSONRequestSerializer *jsonRequestSerializer = [AFJSONRequestSerializer serializer];
//        [_shareInstance setRequestSerializer:jsonRequestSerializer];
//        
//        _shareInstance.requestSerializer.timeoutInterval = 25;
//        
//        //把null变为nil
//        //去除返回json中的null值
//        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
//        
//        [serializer setRemovesKeysWithNullValues:YES];
//        
//        [_shareInstance setResponseSerializer:serializer];
//        
//        //如果报接受类型不一致请替换一致text/html或别的
//        _shareInstance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/octet-stream", nil];
//        
//    });
//    return _shareInstance;
    
//}


@end
