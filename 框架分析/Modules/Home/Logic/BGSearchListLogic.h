//
//  BGSearchListLogic.h
//  框架分析
//
//  Created by FuBG02 on 2019/1/5.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BGSearchListLogicDelegate <NSObject>
@optional
/**
 数据加载完成
 */
-(void)requestDataCompleted;

@end

@interface BGSearchListLogic : NSObject

@property (nonatomic,strong) NSMutableArray * dataArray;//数据源
@property (nonatomic,assign) NSInteger  page;//页码
@property (strong, nonatomic) NSString * searchText;

@property(nonatomic,weak)id<BGSearchListLogicDelegate> delegagte;

/**
 拉取数据
 */
-(void)loadData;

@end
