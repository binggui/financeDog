//
//  BGForgetPasswordViewController.h
//  框架分析
//
//  Created by FuBG02 on 2018/12/20.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGForgetPasswordViewController : RootViewController
@property (assign, nonatomic) NSInteger  type;
@property (strong, nonatomic) NSString * title;
@property (nonatomic, copy)void (^backMobileBlock)(NSString *str);
@end
