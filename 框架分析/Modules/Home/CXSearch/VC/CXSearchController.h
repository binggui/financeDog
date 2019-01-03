//
//  CXsearchController.h
//  搜索页面的封装
//
//  Created by 蔡翔 on 16/7/28.
//  Copyright © 2016年 蔡翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CXSearchControllerDelegate <NSObject>

-(void)goToSearchView:(NSString*)typeString;

@end
@interface CXSearchController : UIViewController<UITextFieldDelegate>
@property(nonatomic,weak) id <CXSearchControllerDelegate> delegate;
@property (strong, nonatomic) NSString * textfieldText;
@end
