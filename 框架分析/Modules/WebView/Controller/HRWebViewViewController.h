//
//  HRWebViewViewController.h
//  ZGHR
//
//  Created by 贾金勋 on 2017/7/3.
//  Copyright © 2017年 aspire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRWebViewViewController : UIViewController
@property(nonatomic,assign) BOOL isTransition;//是否开启转场动画
@property (nonatomic,assign) BOOL isScreen;
@property (strong, nonatomic) NSString * title;
@property (nonatomic, copy) NSString *urlString;
- (instancetype)initWithUrl:(NSString *)url;

@end
