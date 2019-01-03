//
//  LoadFailView.h
//  ZGHR
//
//  Created by 贾金勋 on 17/5/19.
//  Copyright © 2017年 aspire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadFailView : UIView

@property (nonatomic,copy) void (^LoadAgain)();

@end
