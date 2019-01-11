//
//  PersonListCollectionViewCell.h
//  框架分析
//
//  Created by 丙贵 on 18/7/14.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonModel.h"
#import "FDHomeModel.h"

@interface PersonListCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imgView;
@property(nonatomic,strong)FDHomeModel *personModel;

@end
