//
//  FDHomeTableViewCell.h
//  框架分析
//
//  Created by FuBG02 on 2018/12/19.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDHomeModel.h"

@interface FDHomeTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *leftImg;//左边图片
@property (nonatomic, strong) UILabel *titleLab;//标题
@property (nonatomic, strong) UILabel *desLab;//描述
@property (nonatomic, strong) UIButton *clickbtn;//按钮
@property (nonatomic, strong) UILabel *btnLab;//按钮文字
@property (nonatomic, strong) UIView *bottomline;//底部线
@property (nonatomic) NSInteger indexPath;
@property (nonatomic, strong)FDHomeModel *model;
@end
