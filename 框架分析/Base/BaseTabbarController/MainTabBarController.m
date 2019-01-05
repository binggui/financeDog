//
//  MainTabBarController.m
//  框架分析
//
//  Created by 丙贵 on 18/5/17.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "MainTabBarController.h"
#import "FDHomeTableViewController.h"
#import "BGHotViewController.h"
#import "RecommendTableViewController.h"
#import "PersonListViewController.h"

@interface MainTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic,strong) NSMutableArray * VCS;//tabbar root VC

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    //初始化tabbar
    [self setUpTabBar];
    //添加子控制器
    [self setUpAllChildViewController];
}

#pragma mark ————— 初始化TabBar —————
-(void)setUpTabBar{
    //设置背景色 去掉分割线
//        [self setValue:[XYTabBar new] forKey:@"tabBar"];
    [self.tabBar setBackgroundColor:[GFICommonTool colorWithHexString:@"#00486b"]];
        [self.tabBar setBackgroundImage:[UIImage new]];
    //通过这两个参数来调整badge位置
    //    [self.tabBar setTabIconWidth:29];
    //    [self.tabBar setBadgeTop:9];
}

#pragma mark - ——————— 初始化VC ————————
-(void)setUpAllChildViewController{
    _VCS = @[].mutableCopy;
    //    HomeViewController *homeVC = [[HomeViewController alloc]init];
    //    WaterFallListViewController *homeVC = [WaterFallListViewController new];
    FDHomeTableViewController *mineVC = [[FDHomeTableViewController alloc]init];
    [self setupChildViewController:mineVC title:@"热点" imageName:@"HOT" seleceImageName:@"HOT选中"];

    //    MakeFriendsViewController *makeFriendVC = [[MakeFriendsViewController alloc]init];
    BGHotViewController *makeFriendVC = [[BGHotViewController alloc]init];
    [self setupChildViewController:makeFriendVC title:@"热点" imageName:@"HOT" seleceImageName:@"HOT选中"];
    
    //    MsgViewController *msgVC = [[MsgViewController alloc]init];
    RecommendTableViewController *msgVC = [RecommendTableViewController new];
    [self setupChildViewController:msgVC title:@"推荐" imageName:@"推荐" seleceImageName:@"推荐选中"];
    
    PersonListViewController *homeVC = [[PersonListViewController alloc]init];
    [self setupChildViewController:homeVC title:@"案例" imageName:@"案例" seleceImageName:@"案例选中"];
    

    
    self.viewControllers = _VCS;
}

-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName{
    controller.title = title;
    controller.tabBarItem.title = title;//跟上面一样效果
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //未选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[GFICommonTool colorWithHexString:@"#a0a0a0"],NSFontAttributeName:SYSTEMFONT(10.0f)} forState:UIControlStateNormal];
    
    //选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:SYSTEMFONT(10.0f)} forState:UIControlStateSelected];
    //包装导航控制器
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:controller];
    
    //    [self addChildViewController:nav];
    [_VCS addObject:nav];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
