//
//  PersonModel.h
//  框架分析
//
//  Created by 丙贵 on 18/5/17.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Pictures;

@interface PersonModel : NSObject

@property (copy, nonatomic) NSString * jumpUrl;

@property (nonatomic, copy) NSString *picture;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *juli;

@property (nonatomic, assign) float height;

@property (nonatomic, assign) float width;

@property (nonatomic, copy) NSString *hobbys;

@property (nonatomic,assign) float hobbysHeight;

@property (strong, nonatomic) NSString * collectionCount;
@property (strong, nonatomic) NSString * goodCount;
@property (strong, nonatomic) NSString * messageCount;
@property (strong, nonatomic) NSString * ID;
@property (strong, nonatomic) NSString * updateTime;
@property (strong, nonatomic) NSString * publishTime;






@end
@interface Pictures : NSObject

@property (nonatomic, assign) NSInteger height;


@property (nonatomic, assign) NSInteger width;



@end
