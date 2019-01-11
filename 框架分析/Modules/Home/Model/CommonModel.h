//
//  CommonModel.h
//  框架分析
//
//  Created by FuBG02 on 2019/1/9.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonModel : NSObject



//图片地址
@property (nonatomic, copy)NSString *img;
//描述信息
@property (nonatomic, copy)NSString *des;
//对应详情页的id
#pragma warning
@property (nonatomic, copy)NSString *ID;
//详情页URL
@property (nonatomic, copy)NSString *url;
//阅读量
@property (nonatomic, copy)NSString *readCount;
//信息数
@property (nonatomic, copy)NSString *messageCount;
//收藏数
@property (nonatomic, copy)NSString *collectionCount;// 暂不用

@property (copy, nonatomic) NSString * goodCount;//点赞数
//推荐详情
@property (copy, nonatomic) NSString * titleDes;//点赞数

@property (copy, nonatomic) NSString * time;//点赞数

@property (copy, nonatomic) NSString * jumpUrl;
//搜索
@property (copy, nonatomic) NSString * publishTime;
@property (copy, nonatomic) NSString * source;

@end
