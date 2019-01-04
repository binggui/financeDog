//
//  popView.h
//  yinyinyin
//
//  Created by WDX on 17/2/27.
//  Copyright © 2017年 aspire. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol popViewDelegate <NSObject>
@optional
- (void)sendContentText:(NSIndexPath *)indexPath andContent: (NSString *)content ;

@end

@interface popView : UIView
//需要这个ID来统计
@property(nonatomic,weak)id<popViewDelegate> delegagte;
@property (nonatomic, copy)NSString *ID;
@property (strong, nonatomic) NSIndexPath * indexPath;
@property (strong, nonatomic) NSString * placeHolderTitle;
@property (nonatomic, copy)void (^dismissPopViewBlock)();
-(id)initView;
-(void)show;
@end
