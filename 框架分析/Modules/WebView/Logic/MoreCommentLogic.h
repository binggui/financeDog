//
//  MoreCommentLogic.h
//  框架分析
//
//  Created by FuBG02 on 2019/1/3.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MoreCommentLogicDelegate <NSObject>
@optional
/**
 数据加载完成
 */
-(void)requestDataCompleted;

@end

@interface MoreCommentLogic : NSObject

@property (nonatomic,strong) NSMutableArray * dataArray;//数据源
@property (nonatomic,assign) NSInteger  page;//页码
@property (assign, nonatomic) NSInteger  type;
@property (assign, nonatomic) NSInteger  parent_id;
@property (assign, nonatomic) NSInteger  object_id;

@property(nonatomic,weak)id<MoreCommentLogicDelegate> delegagte;

/**
 拉取数据
 */
-(void)loadData;
@end
