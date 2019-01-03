//
//  WGAdvertisementModel.h
//  框架分析
//
//  Created by FuBG02 on 2019/1/3.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WGAdvertisementModel : NSObject
@property (copy, nonatomic) NSString * content;
@property (copy, nonatomic) NSString * des;
@property (assign, nonatomic) NSInteger  desc;
@property (nonatomic, copy)NSString *imgurl;
@property (copy, nonatomic) NSString * target;
@property (copy, nonatomic) NSString * title;
@property (copy, nonatomic) NSString * jumpurl;

@end
