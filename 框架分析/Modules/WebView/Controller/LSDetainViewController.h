//
//  LSDetainViewController.h
//  LSNewsDetailWebviewContainer
//
//  Created by liusong on 2018/12/15.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDHomeModel.h"

@interface LSDetainViewController : UIViewController

@property (nonatomic,copy)NSString *URLString;
@property (nonatomic,assign) BOOL firstConfigute;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) FDHomeModel * model;

@end
