//
//  CommonListLogic.h
//  框架分析
//
//  Created by FuBG02 on 2018/12/26.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol CommonListLogicDelegate <NSObject>
@optional
/**
 数据加载完成
 */
-(void)requestDataCompleted;

@end

@interface CommonListLogic : NSObject

@property (nonatomic,strong) NSMutableArray * dataArray;//数据源
@property (nonatomic,assign) NSInteger  page;//页码
@property (assign, nonatomic) NSInteger  type;
@property(nonatomic,weak)id<CommonListLogicDelegate> delegagte;

/**
 拉取数据
 */
-(void)loadData;

@end
