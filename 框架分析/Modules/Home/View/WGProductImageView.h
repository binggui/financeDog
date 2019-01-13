//
//  WGProductImageView.h
//
//
//  Created by Mac on 15-3-7.
//  Copyright (c) 2015年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGAdvertisementModel.h"
//自定义UIImageView

@protocol WGProductImageViewDelegate <NSObject>
@required
- (void)pushAddViewController:(LSDetainViewController *)vc withloginFlag:(NSNumber *)mustlogin openWay:(NSString *)loadbybrowser desc:(NSInteger)desc;

@end
@interface WGProductImageView : UIImageView

@property (nonatomic ,strong) WGAdvertisementModel *dict;
@property (nonatomic ,weak) id<WGProductImageViewDelegate>delegate;
- (void)refresh;
@end
