//
//  LoadFailView.m
//  ZGHR
//
//  Created by 贾金勋 on 17/5/19.
//  Copyright © 2017年 aspire. All rights reserved.
//

#import "LoadFailView.h"

@interface LoadFailView ()

@property (nonatomic,strong) UILabel *remindLabel;
@property (nonatomic,strong) UIImageView *iconimageView;

@end

@implementation LoadFailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setUI];

    }
    
    return self;
}

- (void)setUI {
    //刷新页本体
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIImage *failImage = [UIImage imageNamed:@"failView"];
    _iconimageView = [[UIImageView alloc] initWithImage:failImage];
    _iconimageView.center = CGPointMake(kScreenWidth / 2, (kScreenWidth - SUM_HEIGHT)/2 - 10);
    _iconimageView.size = failImage.size;
    [self addSubview:_iconimageView];
    _iconimageView.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.LoadAgain) {
        self.LoadAgain();
    }
}

@end
