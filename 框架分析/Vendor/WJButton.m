//
//  WJButton.m
//  ZGHR
//
//  Created by 王大侠 on 16/12/8.
//  Copyright © 2016年 aspire. All rights reserved.
//

#import "WJButton.h"

@implementation WJButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.x = 0;
    self.titleLabel.x = self.imageView.width + 5;
    self.titleLabel.font = [UIFont systemFontOfSize:14];

}
@end
