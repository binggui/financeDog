//
//  TTWeiboCommentTwoCell.h
//  框架分析
//
//  Created by FuBG02 on 2019/1/2.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGCommentModel.h"

@interface TTWeiboCommentTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) BGCommentModel * model;
@end
