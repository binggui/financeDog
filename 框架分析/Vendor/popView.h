//
//  popView.h
//  yinyinyin
//
//  Created by WDX on 17/2/27.
//  Copyright © 2017年 aspire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface popView : UIView
//需要这个ID来统计
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)void (^dismissPopViewBlock)();
-(id)initView;
-(void)show;
@end
