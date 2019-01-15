//
//  BGHotPointTableViewController.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/20.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "BGHotPointTableViewController.h"
#import "FDHomeModel.h"
#import "FDHomeTableViewCell.h"
#import "HotListLogic.h"
#import "FDHomeTwoTableViewCell.h"

@interface BGHotPointTableViewController ()<UITableViewDataSource,UITableViewDelegate,HotListLogicDelegate>
@property(nonatomic,strong) HotListLogic *logic;//逻辑层
@end

@implementation BGHotPointTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    //开始第一次数据拉取
    [self.tableView.mj_header beginRefreshing];
    //初始化逻辑类
    _logic = [HotListLogic new];
    _logic.delegagte = self;
    _logic.type = self.type;

}
-(void)setupUI{
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - TAB_HEIGHT - TAB_HEIGHT - 40);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.sectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    self.robotImageView.frame = CGRectMake(kScreenWidth-62, self.tableView.frame.size.height - 90, 42, 42);
    [self.view addSubview:self.robotImageView];
    
    self.tableView.rowHeight = 126;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}
- (void) singleTapRobotAction:(UIGestureRecognizer *) gesture
{

    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _logic.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row % 2 == 1){
        FDHomeTwoTableViewCell *celltwo;
        //普通咨询
        static NSString *normalNewID = @"normalTwoNew";
        celltwo = [tableView dequeueReusableCellWithIdentifier:normalNewID];
        if (celltwo == nil) {
            celltwo = [[FDHomeTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalNewID];
        }
        
        celltwo.model = _logic.dataArray[indexPath.row];
        cell = celltwo;
    }else{
        FDHomeTableViewCell *cellone;
        //普通咨询
        static NSString *normalNewID = @"normalOneNew";
        cellone = [tableView dequeueReusableCellWithIdentifier:normalNewID];
        if (cellone == nil) {
            cellone = [[FDHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalNewID];
        }
        
        cellone.model = _logic.dataArray[indexPath.row];
        cell = cellone;
    }
   
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //先判断是否登录
    NSInteger flag = [GFICommonTool isLogin];
    if (flag == finishLogin) {//已登录
        FDHomeModel *model = _logic.dataArray[indexPath.row];
        LSDetainViewController *VC=[[LSDetainViewController alloc]init];
        VC.URLString = model.url;
        VC.firstConfigute=YES;
        VC.model = model;
        VC.title = @"详情";
        [[self viewController] pushViewController:VC animated:YES];
        
    }else{//未登录
        //为了显示未登录布局，不弹出登录框
        
        [GFICommonTool login:[self viewController]];
        
    }

}
#pragma mark ————— 下拉刷新 —————
-(void)headerRereshing{
    [_logic loadData];
}

#pragma mark ————— 上拉刷新 —————
-(void)footerRereshing{
    _logic.page+=1;
    [_logic loadData];
}

#pragma mark ————— 数据拉取完成 渲染页面 —————
-(void)requestDataCompleted{
    [self.tableView.mj_header endRefreshing];

    if (_logic.dataArray.count % 10 == 0 && _logic.dataArray.count !=0) {
        [self.tableView.mj_footer endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }

    [self.tableView reloadData];
}
- (UINavigationController *)viewController {
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)nextResponder;
        }
    }
    return nil;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
