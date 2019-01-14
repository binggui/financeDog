//
//  BGHotViewController.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/21.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "BGHotViewController.h"
#import "BGHotPointTableViewController.h"
#import "HRScrollPageView.h"
#import "CXSearchController.h"
#import "PersonDetailViewController.h"
#import "BGMessageHistoryTableViewController.h"
#import "BGSearchTableViewController.h"

@interface BGHotViewController ()<CXSearchControllerDelegate>
@property (nonatomic,strong)  HRScrollPageView *hrS;
@end

@implementation BGHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupNavigation];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.extendedLayoutIncludesOpaqueBars = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupNavigation{
    //    [self wr_setNavBarBarTintColor:[UIColor clearColor]];
    //    [self wr_setNavBarBackgroundAlpha:0];
    //    self.tableView.contentInset = UIEdgeInsetsMake( - NAV_HEIGHT, 0, 0, 0);
    [self addNavigationItemWithImageNames:@[@"个人"] isLeft:YES target:self action:@selector(personClickedOKbtn:) tags:@[@999]];
    [self addNavigationItemWithImageNames:@[@"消息"] isLeft:NO target:self action:@selector(naviBtnClick:) tags:@[@1000]];
    
    UIView *backgroundV = [[UIView alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth - 100, 30)];
    backgroundV.backgroundColor = [UIColor whiteColor];
    ViewRadius(backgroundV, 15);
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, kScreenWidth - 100, 30);
    [backgroundV addSubview:button];
    [button setTitle:@"搜内容/标题/咨询" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showAllQuestions) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    
    UIView *pointVIew = [[UIView alloc]initWithFrame:CGRectMake(backgroundV.width - 45, 7, 2, 16)];
    pointVIew.backgroundColor = [UIColor grayColor];
    [backgroundV addSubview:pointVIew];
    
    UILabel *searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(backgroundV.width - 40, 0, 40, 30)];
    searchLabel.text = @"搜索";
    searchLabel.textColor = [UIColor grayColor];
    searchLabel.font = [UIFont systemFontOfSize:13];
    [backgroundV addSubview:searchLabel];
    self.navigationItem.titleView =backgroundV;
    
    
}
-(void)showAllQuestions{
    
    //先判断是否登录
    NSInteger flag = [GFICommonTool isLogin];
    if (flag == finishLogin) {//已登录
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"CXShearchStoryboard" bundle:nil];
        
        CXSearchController * searchC = [sb instantiateViewControllerWithIdentifier:@"CXSearch"];
        searchC.delegate = self;
        [self.navigationController presentViewController:searchC animated:NO completion:nil];
        
    }else{//未登录
        //为了显示未登录布局，不弹出登录框
        
        [GFICommonTool login:self];
        
    }
    
    
    
}
-(void)personClickedOKbtn:(UIButton *)btn{
    //先判断是否登录
    NSInteger flag = [GFICommonTool isLogin];
    if (flag == finishLogin) {//已登录
        PersonDetailViewController *personC = [[PersonDetailViewController alloc]init];
        [self.navigationController pushViewController:personC animated:YES];
        
    }else{//未登录
        //为了显示未登录布局，不弹出登录框
        
        [GFICommonTool login:self];
        
    }
    
    //    [self.navigationController presentModalViewController:personC animated:YES];
    
}
-(void)naviBtnClick:(UIButton *)btn{
    //先判断是否登录
    NSInteger flag = [GFICommonTool isLogin];
    if (flag == finishLogin) {//已登录
        BGMessageHistoryTableViewController *messageHistoryC = [[BGMessageHistoryTableViewController alloc]init];
        [self.navigationController pushViewController:messageHistoryC animated:YES];
        
    }else{//未登录
        //为了显示未登录布局，不弹出登录框
        
        [GFICommonTool login:self];
        
    }
    
}
-(void)goToSearchView:(NSString*)typeString{
    
    
    BGSearchTableViewController *searchResultC = [[BGSearchTableViewController alloc]init];
    searchResultC.searchText = typeString;
    [self.navigationController pushViewController:searchResultC animated:NO];
    
}

-(void)setupUI{
    
    BGHotPointTableViewController *vc_1 = [[BGHotPointTableViewController alloc] init];
    vc_1.type = 1;
    
    BGHotPointTableViewController *vc_2 = [[BGHotPointTableViewController alloc] init];
    vc_2.type = 2;
    
    BGHotPointTableViewController *vc_3 = [[BGHotPointTableViewController alloc] init];
    vc_3.type = 3;
    

    HRScrollPageView *hs = [[HRScrollPageView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, kScreenWidth, kScreenHeight - NAV_HEIGHT - TAB_HEIGHT - 40) ViewControllers:@[vc_1, vc_2, vc_3] names:@[@"24小时", @"周热点", @"月热点"]];
    
    hs.endScrollWithIndex = ^(NSInteger currentPage){
    };
    hs.isAddHeaderV = YES;
    [self.view addSubview:hs];
    
    self.hrS = hs;
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
