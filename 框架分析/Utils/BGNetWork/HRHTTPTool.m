    
//  HRHTTPTool.m
//  ZGHR
//
//  Created by 王大侠 on 16/12/7.
//  Copyright © 2016年 aspire. All rights reserved.
//

#import "HRHTTPTool.h"
#import "HRHTTPClient.h"

@implementation HRHTTPTool

+ (void)getWithURL:(NSString *)URL parameters:(NSMutableDictionary *)parameters success:(void (^)(id res))success failure:(void (^)(NSError *))failure{
    
    //创建请求管理对象
    HRHTTPClient *manager = [HRHTTPClient shareNetworkTools];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", nil];
    //HRLog(@"%@",[URL netLog:parameters]);
    [manager GET:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }
    }];
    
}

+ (void)postWithURL:(NSString *)URL parameters:(NSMutableDictionary *)parameters success:(void (^)(id res))success failure:(void (^)(NSError *))failure{
    
    //     创建请求管理对象
    HRHTTPClient *manager = [HRHTTPClient shareNetworkTools];
    //     json
      manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/json", @"text/javascript", nil];
    
    //     Cookie
    NSString *cookie = [USER_DEFAULT objectForKey:@"Cookie"];
    if (cookie != nil) {
        [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    }else{
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Cookie"];
    }
    
    //     给接口命令字(从url中截取)
    NSArray *strArr = [URL componentsSeparatedByString:@"/"];
    [manager.requestSerializer setValue:[strArr lastObject] forHTTPHeaderField:@"Action"];
    
    NSString *dataEncode = nil;
    if (parameters != nil) {
        //请求信息转json并base64编码
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        dataEncode = [data base64EncodedStringWithOptions:0];
    }

    //     发送请求
    [manager POST:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

//        NSLog(@"%@",task.currentRequest.URL);

       NSData *tempData = [responseObject mj_JSONData];
        //转成字典传出去
        NSDictionary *dic = [NSDictionary dictionary];
        if (tempData != nil) {
 
            dic = [NSJSONSerialization JSONObjectWithData:tempData options:NSJSONReadingMutableContainers error:nil];
        }
        //响应头
        NSHTTPURLResponse *resp =(NSHTTPURLResponse *)task.response;
        [resp.allHeaderFields.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:@"Set-Cookie"]) {
                [USER_DEFAULT setObject:[resp.allHeaderFields objectForKey:@"Set_Cookie"] forKey:@"Cookie"];
            }
        }];
        if (success) {
            success(dic);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
            NSLog(@"error == %@",error);
        }
    }];
    
}

//未完成
//上传图片
+ (void)postWithURL:(NSString *)URL parameters:(NSMutableDictionary *)parameters fromDataArray:(NSArray *)dataArray success:(void (^)(id res))success failure:(void (^)(NSError *))failure{
    // 1.创建请求管理对象
    HRHTTPClient *manager = [HRHTTPClient shareNetworkTools];
    
    // 2.发送请求
    [manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (HRFromData *formData in dataArray) {
            
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}



@end
/**
 *  用来封装文件数据的模型
 */
@implementation HRFromData
@end
