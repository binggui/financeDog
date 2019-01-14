//
//  RootViewController.h
//  框架分析
//
//  Created by 丙贵 on 18/5/17.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"

#define VIEW_SIZE_HEIGHT1 (self.view.bounds.size.height - 64) / 16//屏幕的高度减去navigationBar以及导航条的高度然后平均分成16份
#define VIEWWIDTH self.view.bounds.size.width//获取屏幕的宽度
#define VIEWHEIGHT self.view.bounds.size.height//获取屏幕的高度
#define  GET_HEIGHT(height, i , j) ((CGFloat) height/ (CGFloat) i)* (CGFloat) j//传入一个高度height,把它平均分成i份，去其中的j份
#define  GET_WIDTH(width, i , j) ((CGFloat) width/ (CGFloat) i)* (CGFloat) j//传入一个宽度width,把它平均分成i份，去其中的j份

@interface RootViewController : UIViewController
/**
 *  弹出登录界面
 *
 *  @param controller 登录界面
 */
+ (void)login:(UIViewController *)controller;
/**
 *  修改状态栏颜色
 */
@property (nonatomic, assign) UIStatusBarStyle StatusBarStyle;
//用第三方插件提示
@property(nonatomic,retain)MBProgressHUD *hud;
//表示网络不好标识(加载页面持续存在)
@property (strong, nonatomic) NSString * loadingFlag;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic,strong) UIImageView *robotImageView; //滚回顶部
@property (strong, nonatomic) UITableView * tableHomeView;;
@property (strong, nonatomic) UITableView * tableCommentView;
- (AppDelegate *)appDelegate;

//用第三方插件显示网络加载提示
- (void)showHUDLoading:(NSString *)title;
- (void)hideHUDLoading;
- (void)showHUDComplete:(NSString *)title;
- (void)showHUDTip:(NSString *)title;
- (void)showHUDTip:(NSString *)title duration:(CGFloat)duration;
- (void)showHUDTipAfterFiveM:(NSString *)title;
- (void)showHUDTipWithInit:(NSString *)title;
- (void)showHUDTipCannotFindAppWithInit:(NSString *)title;//添加的方法，当不能找到App时，添加提示
/**
 *  显示没有数据页面
 */
-(void)showNoDataImage;

/**
 *  移除无数据页面
 */
-(void)removeNoDataImage;

/**
 *  加载视图
 */
- (void)showLoadingAnimation;

/**
 *  停止加载
 */
- (void)stopLoadingAnimation;

/**
 *  是否显示返回按钮,默认情况是YES
 */
@property (nonatomic, assign) BOOL isShowLiftBack;

/**
 是否隐藏导航栏
 */
@property (nonatomic, assign) BOOL isHidenNaviBar;

/**
 导航栏添加文本按钮
 
 @param titles 文本数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;

/**
 导航栏添加图标按钮
 
 @param imageNames 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;

/**
 *  默认返回按钮的点击事件，默认是返回，子类可重写
 */
- (void)backBtnClicked;

//取消网络请求
- (void)cancelRequest;

//持久化数据plist
- (NSMutableDictionary*)getDataFromPlist ;

- (void)writeDataToPlist:(NSMutableDictionary *)dic;

@end
