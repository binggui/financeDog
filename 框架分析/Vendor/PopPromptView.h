//
//  PopPromptView.h
//  ZGHR
//
//  Created by WDX on 17/5/9.
//  Copyright © 2017年 aspire. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PopPromptViewDelegate<NSObject>
@optional
- (void)popPromptViewCheckBtnCallBackWithTag:(NSInteger)tag;
- (void)popPromptViewCancelBtnCallBackWithTag:(NSInteger)tag;
@end
@interface PopPromptView : UIView
@property (nonatomic, weak)id<PopPromptViewDelegate> delegate;
+(void)showWithTag:(NSInteger)tag target:(id<PopPromptViewDelegate>)target title:(NSString *)title;
@end
