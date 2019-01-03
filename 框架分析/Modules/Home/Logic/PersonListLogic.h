//
//  PersonListLogic.h
//  框架分析
//
//  Created by 丙贵 on 18/7/14.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PersonListLogicDelegate <NSObject>
@optional
/**
 数据加载完成
 */
-(void)requestDataCompleted;

@end

@interface PersonListLogic : NSObject

@property (nonatomic,strong) NSMutableArray * dataArray;//数据源
@property (nonatomic,assign) NSInteger  page;//页码

@property(nonatomic,weak)id<PersonListLogicDelegate> delegagte;

/**
 拉取数据
 */
-(void)loadData;

@end
