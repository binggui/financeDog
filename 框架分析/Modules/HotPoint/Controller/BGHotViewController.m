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
@interface BGHotViewController ()
@property (nonatomic,strong)  HRScrollPageView *hrS;
@end

@implementation BGHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.extendedLayoutIncludesOpaqueBars = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
