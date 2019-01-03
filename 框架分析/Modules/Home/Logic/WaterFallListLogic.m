//
//  WaterFallListLogic.m
//  UniversalApp
//
//  Created by 丙贵 on 2017/7/3.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "WaterFallListLogic.h"

@interface WaterFallListLogic()

@end

@implementation WaterFallListLogic

-(instancetype)init{
    self = [super init];
    if (self) {
        _dataArray = @[].mutableCopy;
    }
    return self;
}

#pragma mark ————— 拉取数据 —————
-(void)loadData{
//    //发起请求
    
    
//    [BGNetworkHelper postParameters:nil success:^(NSDictionary *resDict) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
//    GetWaterFallListAPI *req = [GetWaterFallListAPI new];
//    [req startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        NSLog(@"请求成功");
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//        NSLog(@"请求失败 %@",req.message);
//        //模拟成功
//        for (int i = 0; i < 14; i++) {
//            
//            NSString *imageName = NSStringFormat(@"%d.jpg", i);
//            
//            [_dataArray addObject:imageName];
//        }
//        if (self.delegagte && [self.delegagte respondsToSelector:@selector(requestDataCompleted)]) {
//            [self.delegagte requestDataCompleted];
//        }
//    }];
}


@end
