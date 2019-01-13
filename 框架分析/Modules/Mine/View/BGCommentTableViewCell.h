//
//  BGCommentTableViewCell.h
//  框架分析
//
//  Created by FuBG02 on 2018/12/22.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageAndCommentModel.h"

@interface BGCommentTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString * cellType;
@property (nonatomic, strong)MessageAndCommentModel *model;
@end
