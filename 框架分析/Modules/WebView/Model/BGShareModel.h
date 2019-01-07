//
//  BGShareModel.h
//  框架分析
//
//  Created by FuBG02 on 2019/1/7.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGShareModel : NSObject
@property (nonatomic, strong) NSURL *weburl;//分享链接
@property (nonatomic, strong) NSURL *shareimgurl;//图片链接

@property (nonatomic, strong) NSNumber *type;//分享类型1.微信好友2.微信朋友圈3.飞信好友4.飞信身边5.新浪微博6.复制链接7.短信8.邮件

@property (nonatomic, copy) NSString *title;//标题
@property (nonatomic, copy) NSString *message;//内容
@end
