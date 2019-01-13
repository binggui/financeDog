//
//  BGCommentModel.h
//  框架分析
//
//  Created by FuBG02 on 2019/1/7.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGCommentModel : NSObject


//文章信息
@property (nonatomic, assign) NSInteger activity_id;//文章ID

@property (nonatomic, assign) NSInteger acvitity_hits;//文章点击数

@property (nonatomic, assign) NSInteger acvitity_favorites;//文章收藏数

@property (nonatomic, assign) NSInteger acvitity_like;//文章点赞数

@property (nonatomic, assign) NSInteger acvitity_comment_count;//评论总数

//评论信息

@property (nonatomic, assign) NSInteger comment_id;//评论id

@property (nonatomic, assign) NSInteger comment_parent_id;//0恢复文章本身,大于0回复别人的

@property (nonatomic, assign) NSInteger comment_user_id;//评论人id

@property (nonatomic, assign) NSInteger comment_beUserd_id;//被评论人id

@property (nonatomic, assign) NSInteger comment_activity_id;//文章id

@property (nonatomic, assign) NSInteger comment_like;//点赞数

@property (nonatomic, assign) NSInteger comment_time;//评论的时间

@property (nonatomic, copy) NSString *comment_name;//评论人昵称

@property (nonatomic, copy) NSString *comment_content;//评论内容

@property (nonatomic, copy) NSString *comment_avatal;//头像

@property (nonatomic, assign) NSInteger comment_more;//更多

@end


