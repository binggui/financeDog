//
//  BGMoreCommenViewController.h
//  框架分析
//
//  Created by FuBG02 on 2019/1/3.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGCommentModel.h"

@interface BGMoreCommenViewController : RootViewController
@property (assign, nonatomic) NSInteger  type;
@property (strong, nonatomic) BGCommentModel * model;
@end
