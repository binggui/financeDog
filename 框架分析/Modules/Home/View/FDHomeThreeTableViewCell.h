//
//  FDHomeThreeTableViewCell.h
//  框架分析
//
//  Created by FuBG02 on 2019/1/15.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDHomeThreeTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *leftImg;//左边图片
@property (strong, nonatomic) UIImageView * middleImg;//中间的图片
@property (strong, nonatomic) UIImageView * rightImg;//右边的图片
@property (nonatomic, strong) UILabel *titleLab;//标题
@property (nonatomic, strong) UILabel *desLab;//描述
@property (strong, nonatomic) UILabel * sourceTitle;
@property (strong, nonatomic) UILabel * publishTime;
@property (nonatomic, strong) UIButton *clickbtn;//按钮
@property (nonatomic, strong) UILabel *btnLab;//按钮文字
@property (nonatomic, strong) UIView *bottomline;//底部线
@property (strong, nonatomic) NSArray *photos;//三张图片数组

@property (nonatomic) NSInteger indexPath;
@property (nonatomic, strong)FDHomeModel *model;
@end
