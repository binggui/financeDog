//
//  MessageAndCommentModel.h
//  框架分析
//
//  Created by FuBG02 on 2019/1/12.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageAndCommentModel : NSObject
@property (copy, nonatomic) NSString * content;
@property (copy, nonatomic) NSString * pushTime;
@property (assign, nonatomic) NSInteger  desc;
@property (nonatomic, copy)NSString *imgurl;
@property (copy, nonatomic) NSString * target;
@property (copy, nonatomic) NSString * title;
@property (copy, nonatomic) NSString * name;
@property (copy, nonatomic) NSString * avatar;
@property (copy, nonatomic) NSString * img;

@property (nonatomic, copy)NSString *recommend_name;
@property (copy, nonatomic) NSString * recommend_user_id;
@property (nonatomic, copy)NSString *recommend_time;
@property (copy, nonatomic) NSString * recommend_post_id;
@property (nonatomic, copy)NSString *recommend_title;
@property (copy, nonatomic) NSString * recommend_hits;
@property (nonatomic, copy)NSString *recommend_favorites;
@property (copy, nonatomic) NSString * recommend_like;
@property (copy, nonatomic) NSString * recommend_count;
@property (copy, nonatomic) NSString * recommend_url;

@end
