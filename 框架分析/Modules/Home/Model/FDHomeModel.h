//
//  FDHomeModel.h
//  框架分析
//
//  Created by FuBG02 on 2018/12/19.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDHomeModel : NSObject
//资讯类型
/*
 1-表示普通资讯；
 2-表示视频资讯；
 3-表示图片资讯
 */
// 栏目类型
@property (strong, nonatomic) NSString * excerpt;

@property (nonatomic, assign) float height;

@property (nonatomic, assign) float width;

@property (nonatomic,assign) float hobbysHeight;

@property (nonatomic,assign) NSInteger column;

@property (nonatomic, assign)NSInteger is_show;
//图片地址
@property (nonatomic, copy)NSArray *photos;

@property (nonatomic, assign)NSInteger type;

@property (nonatomic, assign)NSInteger is_fav;

//图片地址
@property (nonatomic, copy)NSString *img;
//描述信息
@property (nonatomic, copy)NSString *des;
//对应详情页的id
#pragma warning
@property (nonatomic, copy)NSString *ID;

@property (nonatomic, copy)NSString *user_id;
//详情页URL
@property (nonatomic, copy)NSString *url;

@property (copy, nonatomic) NSString * jumpUrl;
//阅读量
@property (nonatomic, copy)NSString *readCount;// 暂不用
//信息数
@property (nonatomic, copy)NSString *messageCount;// 暂不用
//收藏数
@property (nonatomic, copy)NSString *collectionCount;// 暂不用

@property (copy, nonatomic) NSString * goodCount;
@property (strong, nonatomic) NSString * CommentCount;
//标题
@property (nonatomic, copy)NSString *title;

//图片数组(type == 3时存在)
@property (nonatomic, copy)NSArray *pics;
// /“独家”或“专题”等小图标url
@property (nonatomic, copy)NSString *icon;

@property (nonatomic,copy)NSString *columnId;

//最新评论时间差
@property (nonatomic,copy)NSString *timestamp;

//搜索
@property (copy, nonatomic) NSString * publishTime;
@property (copy, nonatomic) NSString * source;


@end
