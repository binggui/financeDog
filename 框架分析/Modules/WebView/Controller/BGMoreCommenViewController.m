//
//  BGMoreCommenViewController.m
//  框架分析
//
//  Created by FuBG02 on 2019/1/3.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import "BGMoreCommenViewController.h"
#import "TTWeiboCommentTwoCell.h"
#import "TTWeiboCommentCell.h"
#import "popView.h"
#import "MoreCommentLogic.h"

static NSString *const cellfidf=@"TTWeiboCommentCell";

@interface BGMoreCommenViewController ()<UITableViewDelegate,UITableViewDataSource,popViewDelegate,TTWeiboCommentCellDelegate,MoreCommentLogicDelegate>
@property (nonatomic, strong)popView *popview;
@property(nonatomic,strong) MoreCommentLogic *logic;//逻辑层
@end

@implementation BGMoreCommenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"评论"];
    //开始第一次数据拉取
    [self.tableView.mj_header beginRefreshing];
    //初始化逻辑类
    _logic = [MoreCommentLogic new];
    _logic.parent_id = self.model.comment_id;
    _logic.object_id = self.object_id;
    _logic.delegagte = self;
}
-(void)setupUI{
    [self.navigationItem setTitle:self.title];
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight );
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.sectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TTWeiboCommentCell" bundle:nil] forCellReuseIdentifier:cellfidf];
    self.tableView.rowHeight = 126;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    TTWeiboCommentCell *cell= nil;
    
    BGCommentModel *model = _logic.dataArray[indexPath.row];
    if (cell==nil) {
        cell=[tableView dequeueReusableCellWithIdentifier:cellfidf];
    }
    cell.cellIndexPath = indexPath;
    cell.delegate = self;
    cell.type = 2;
    cell.model = model;
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 126;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
}
-(void)alertPopView:(NSIndexPath *)indexPath andPlaceHolderTitle:(NSString *)title{
    self.popview = [[popView alloc] initView];
    self.popview.delegagte = self;
    self.popview.indexPath = indexPath;
    self.popview.placeHolderTitle = title;
    __weak typeof (self) weaklf = self;
    _popview.dismissPopViewBlock = ^{
        [weaklf.popview removeFromSuperview];
        weaklf.popview = nil;
    };
    //    _popview.ID = _ID;
    [_popview show];
}
- (void)didSelectPeople:(NSIndexPath *) cellIndexPath; {
    
    [self alertPopView:cellIndexPath andPlaceHolderTitle:@"回复"];
}

- (void)sendContentText:(NSIndexPath *)indexPath andContent: (NSString *)content{
     [OMGToast showWithText:@"回复了" topOffset:KScreenHeight/2 duration:3.0];
    [self getPics:content andType:indexPath.row andUrl:kJRG_portal_addcomment_info];
    
}
//网络请求
- (void)getPics:(NSString*)content andType:(NSInteger)type andUrl:(NSString *)url{
    
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
//        [params setObject:_object_id forKey:@"portal_id"];
//        [params setObject:_parent_id forKey:@"parent_id"];
//        [params setObject:_parent_id forKey:@"to_user_id"];
        [params setObject:content forKey:@"content"];
    
    
    [HRHTTPTool postWithURL:url parameters:params success:^(id json) {
        NSString *result = [json objectForKey:@"error_code"];
        if ([result intValue] == 200) {
            if ([json isKindOfClass:[NSDictionary class]]) {
               
                [_logic.dataArray removeAllObjects];
                    
                [self getPics:nil andType:1 andUrl:kJRG_portal_comment_info];
                [self.tableView reloadData];
                
            }
        }else{
            [OMGToast showWithText:[json objectForKey:@"error_msg"] topOffset:KScreenHeight/2 duration:1.7];
            
        }
    } failure:^(NSError *error) {
        [OMGToast showWithText:@"网络错误" topOffset:KScreenHeight/2 duration:1.7];
        NSLog(@"error == %@",error);
    }];
}
@end
