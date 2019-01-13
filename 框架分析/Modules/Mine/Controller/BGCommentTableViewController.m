//
//  BGCommentTableViewController.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/22.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "BGCommentTableViewController.h"
#import "BGCommentModel.h"
#import "BGCommentTableViewCell.h"
#import "FDHomeTableViewCell.h"
#import "FDHomeTableViewCell.h"
#import "FDHomeModel.h"
#import "BGMessageAndCommentLogic.h"
#import "MessageAndCommentModel.h"

@interface BGCommentTableViewController ()<UITableViewDataSource,UITableViewDelegate,BGMessageAndCommentLogicDelegate>
@property(nonatomic,strong) BGMessageAndCommentLogic *logic;//逻辑层
@end

@implementation BGCommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self.navigationItem setTitle:@"我的评论"];
    //开始第一次数据拉取
    [self.tableView.mj_header beginRefreshing];
    //初始化逻辑类
    _logic = [BGMessageAndCommentLogic new];
    _logic.type = 1;
    _logic.delegagte = self;
}
- (void)setupUI{
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight );
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.sectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    self.tableView.rowHeight = 126;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 116;
    }else{
        return 120;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row % 2 == 0){
        //评论
        
        BGCommentTableViewCell *cell;
        //    BGCommentModel *model = self.dataArr[indexPath.row];
        static NSString *normalNewID = @"normalNew";
        cell = [tableView dequeueReusableCellWithIdentifier:normalNewID];
        if (cell == nil) {
            kAppDelegate.cellType = @"comment";
            cell = [[BGCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalNewID];
        }
        return  cell;
    }else{
        //文章
        FDHomeTableViewCell *cell;
        //    FDHomeModel *model = self.dataArr[indexPath.row];
        //普通咨询
        static NSString *normalSecondNew = @"normalSecondNew";
        cell = [tableView dequeueReusableCellWithIdentifier:normalSecondNew];
        if (cell == nil) {
            cell = [[FDHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalSecondNew];
        }
        return  cell;
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
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if(section == 0){
//        return nil;
//    }
//    UIView *pointVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
//    pointVIew.backgroundColor = [GFICommonTool colorWithHexString:@"#f1f5f9"];
//
//    return pointVIew;
//}
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
