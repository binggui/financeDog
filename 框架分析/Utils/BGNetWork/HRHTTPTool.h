//
//  HRHTTPTool.h
//  ZGHR
//
//  Created by 王大侠 on 16/12/7.
//  Copyright © 2016年 aspire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRHTTPTool : NSObject

/*
 *  封装get请求
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */

+ (void)getWithURL:(NSString *)URL parameters:(NSMutableDictionary *)parameters  success:(void (^)(id json))success failure: (void (^)(NSError *error))failure;

/**
 *  封装post请求
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)postWithURL:(NSString *)URL parameters:(NSMutableDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  封装带文件的POST请求
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param dataArray  上传内容数组
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)postWithURL:(NSString *)URL parameters:(NSMutableDictionary *)parameters fromDataArray:(NSArray *)dataArray success:(void (^)(id json))success failure:(void (^)(NSError *))failure;


/**
 *  上传文件中包含的参数
 */
@end

@interface HRFromData : NSObject

/** 文件数据 */
@property(nonatomic, strong)NSData *data;
/** 参数名 */
@property (nonatomic, copy) NSString *name;
/** 文件名 */
@property (nonatomic, copy) NSString *filename;
/** 文件类型 */
@property (nonatomic, copy) NSString *mimeType;



@end
