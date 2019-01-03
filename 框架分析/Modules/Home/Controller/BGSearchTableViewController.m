//
//  BGSearchTableViewController.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/24.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "BGSearchTableViewController.h"
#import "FDHomeModel.h"
#import "FDHomeTableViewCell.h"
#import "CXSearchController.h"

@interface BGSearchTableViewController ()<CXSearchControllerDelegate>
@property (strong, nonatomic) UIButton * SearchButton;
@end

@implementation BGSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)setupUI{
    [self searchHar];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)searchHar{
    
    UIView *backgroundV = [[UIView alloc]initWithFrame:CGRectMake(-20, 0, kScreenWidth - 50, 30)];
    backgroundV.backgroundColor = [UIColor whiteColor];
    _SearchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 50, 30)];
    
    ViewRadius(backgroundV, 15);
    [_SearchButton setTitle:self.searchText forState:UIControlStateNormal];
    [_SearchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _SearchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _SearchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_SearchButton addTarget:self action:@selector(presentSearchController) forControlEvents:UIControlEventTouchUpInside];
    [backgroundV addSubview:_SearchButton];
    UIBarButtonItem * searchButton = [[UIBarButtonItem alloc]initWithCustomView:backgroundV];
    self.navigationItem.rightBarButtonItem = searchButton;
    
}
-(void)goToSearchView:(NSString*)typeString{
    [_SearchButton setTitle:typeString forState:UIControlStateNormal];
}
-(void)presentSearchController{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"CXShearchStoryboard" bundle:nil];
    CXSearchController * searchC = [sb instantiateViewControllerWithIdentifier:@"CXSearch"];
    searchC.delegate = self;
//    searchC.textfieldText = _searchText;
    [self.navigationController presentViewController:searchC animated:NO completion:nil];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    //普通咨询
    static NSString *normalNewID = @"normalNew";
    cell = [tableView dequeueReusableCellWithIdentifier:normalNewID];
    if (cell == nil) {
        cell = [[FDHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalNewID];
    }
    FDHomeTableViewCell *newCell = (FDHomeTableViewCell *)cell;
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 126;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
