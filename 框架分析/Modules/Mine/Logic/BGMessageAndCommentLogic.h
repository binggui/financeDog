//
//  BGMessageAndCommentLogic.h
//  框架分析
//
//  Created by FuBG02 on 2019/1/12.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BGMessageAndCommentLogicDelegate <NSObject>
@optional
/**
 数据加载完成
 */
-(void)requestDataCompleted;

@end

@interface BGMessageAndCommentLogic : NSObject

@property (nonatomic,strong) NSMutableArray * dataArray;//数据源
@property (nonatomic,assign) NSInteger  page;//页码
@property (assign, nonatomic) NSInteger  type;
@property(nonatomic,weak)id<BGMessageAndCommentLogicDelegate> delegagte;

/**
 拉取数据
 */
-(void)loadData;

@end
