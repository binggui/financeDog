//
//  WGProductImageView.m
//
//
//  Created by Mac on 15-3-7.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "WGProductImageView.h"
#import "UIImageView+WebCache.h"

@implementation WGProductImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTap];
    }
    return self;
}
- (void)addTap
{
    self.backgroundColor = [UIColor whiteColor];
    NSString *str = self.dict.imgurl;;
    [self sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder_large"]];
    //给每个图片添加一个手势，点击进入相应的广告
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(makeNextConVc)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}
//给iamgeView添加广告图片
- (void)refresh
{
    NSString *str = self.dict.imgurl;
    
    ///////////////ceshi////////////////
    [self sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"DefaultImg"] options:SDWebImageRefreshCached];
    
}

- (void)makeNextConVc
{
    LSDetainViewController *VC=[[LSDetainViewController alloc]init];
    VC.URLString=self.dict.jumpurl;
    VC.firstConfigute=YES;
    VC.title = @"详情";
    

    [self.delegate pushAddViewController:VC withloginFlag:nil openWay:nil desc:self.dict.content];
    
    
}
@end
