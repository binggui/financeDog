
//
//  LSDetainViewController.m
//  LSNewsDetailWebviewContainer
//
//  Created by liusong on 2018/12/15.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "LSDetainViewController.h"
#import "LSNewsDetailWebviewContainer.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import <WebKit/WebKit.h>
#import "WJButton.h"
#import "popView.h"
#import "NSDate+YYAdd.h"
#import "WeiboCommentModel.h"
#import "TTWeiboCommentCell.h"
#import "TTWeiboCommentTwoCell.h"
#import "BGMoreCommenViewController.h"


static NSString *const cellfidf=@"TTWeiboCommentCell";
static NSString *const cellTwofidf=@"TTWeiboCommentTwoCell";
@interface LSDetainViewController ()<UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate,TTWeiboCommentCellDelegate,popViewDelegate>

@property (nonatomic,strong) NSMutableArray *datas;//底部tableview的数据
@property (nonatomic,strong) NSMutableArray *cellDatas;//底部tableview的数据
@property (nonatomic,weak) LSNewsDetailWebviewContainer *detailWebviewContainer;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (nonatomic,strong) UIImageView *robotImageView; //滚至顶部

@property (nonatomic, strong)popView *popview;

@property (strong, nonatomic) UIButton * collectionBtn;

@property (strong, nonatomic) UIButton * readBtn;

@property (assign, nonatomic) BOOL  collectionFlag;

@property(nonatomic,strong) NSArray *dataArrs;//评论数据
@end

@implementation LSDetainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.translucent=NO;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];


    [self setupViews1];
   
    _collectionFlag = NO;
    self.navigationController.title = self.title;
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self.view bringSubviewToFront:self.emptyView];
//    [self.view addSubview:self.robotImageView];
//    [self.view bringSubviewToFront:self.robotImageView];
}

//使用内部创建的WKWebview和UITableview
-(void)setupViews1
{
    LSNewsDetailWebviewContainer *container=[[LSNewsDetailWebviewContainer alloc]init];
    container.URLString=self.URLString;
    container.cachePolicy=NSURLRequestReturnCacheDataElseLoad;
    container.scrollview.delegate=self;
    container.tableview.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    container.tableview.mj_footer.automaticallyChangeAlpha=YES;
    container.tableview.dataSource=self;
    container.tableview.delegate=self;
    container.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    container.tableview.sectionHeaderHeight = 0;
    container.tableview.backgroundColor = [UIColor whiteColor];
    [container.tableview registerNib:[UINib nibWithNibName:@"TTWeiboCommentCell" bundle:nil] forCellReuseIdentifier:cellfidf];
    [container.tableview registerNib:[UINib nibWithNibName:@"TTWeiboCommentTwoCell" bundle:nil] forCellReuseIdentifier:cellTwofidf];
    container.webview.navigationDelegate=self;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth,40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *headerTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 20)];
    headerTitle.text = [NSString stringWithFormat:@"全部评论 (126)"];
    [headerView addSubview:headerTitle];
    container.tableview.tableHeaderView  = headerView;
    self.detailWebviewContainer=container;
    
    [self.view addSubview:container];

    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(44);
    }];
    [self loadClick:nil];
}

#pragma mark - CircleCellDelegate,LikeUserCellDelegate

- (void)sendContentText:(NSIndexPath *)indexPath andContent: (NSString *)content{
    
    
    [self.cellDatas addObject:@"1"];
    
    [self.detailWebviewContainer.tableview reloadData];
}
- (void)didSelectPeople:(NSIndexPath *) cellIndexPath; {
    
    [self alertPopView:cellIndexPath andPlaceHolderTitle:@"回复"];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==self.detailWebviewContainer.scrollview) {
        if (scrollView.contentOffset.y>=self.detailWebviewContainer.webview.scrollView.contentSize.height-self.view.frame.size.height+44+46) {
            self.title=@"贵哥博客";
        }else{
            self.title=@"";
        }
    }
}

- (IBAction)loadClick:(id)sender {

        [self.detailWebviewContainer loadRequest];

}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.emptyView.hidden=YES;
    self.datas=[NSMutableArray array];
    self.cellDatas = [NSMutableArray array];
    //一般新闻评论每页数据都是20条
    for (int i=0; i<4; i++) {
        [self.datas addObject:@"1"];
    }
    for (int i=0; i<2; i++) {
        [self.cellDatas addObject:@"1"];
    }
    [self.detailWebviewContainer.tableview reloadData];

}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    self.emptyView.hidden=NO;

}



-(void)loadMoreData
{
    //延迟模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i=0; i<2; i++) {
            [self.datas addObject:@"1"];
        }
        if (self.datas.count>=60) {
            [self.detailWebviewContainer.tableview.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.detailWebviewContainer.tableview.mj_footer endRefreshing];
        }
        [self.detailWebviewContainer.tableview reloadData];
    });
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datas.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellDatas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    if(indexPath.row >=1){
        TTWeiboCommentTwoCell *cellTwo= nil;
        if (cellTwo==nil) {
            cellTwo=[tableView dequeueReusableCellWithIdentifier:cellTwofidf];
        }
        cell = cellTwo;
    }else{
        //    WeiboCommentModel *model=_dataArrs[indexPath.row];
        TTWeiboCommentCell *cellOne= nil;
        if (cellOne==nil) {
            cellOne=[tableView dequeueReusableCellWithIdentifier:cellfidf];
        }
        //    [cell setDataModel:model];
        //    cell.textLabel.text=[NSString stringWithFormat:@"%ld",indexPath.row];
        cellOne.delegate = self;
        cellOne.remmentButton.tag = indexPath.section;
        cellOne.cellIndexPath = indexPath;
        cell = cellOne;
        
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        [self alertPopView:indexPath andPlaceHolderTitle:@"给丙贵回复"];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *backgorundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 55)];
    backgorundView.backgroundColor = [UIColor whiteColor];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(73, 0, KScreenWidth - 93,40)];
    footerView.backgroundColor = [GFICommonTool colorWithHexString:@"#f1f5f9"];
    UILabel *headerTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, footerView.width - 30, 20)];
    headerTitle.text = [NSString stringWithFormat:@"共15条互动评论 > "];
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToMore:)];
    [footerView addGestureRecognizer:labelTap];
    
    UIView *footerLineView = [[UIView alloc]initWithFrame:CGRectMake(0, backgorundView.bottom - 2, KScreenWidth ,2)];
    footerLineView.backgroundColor = [GFICommonTool colorWithHexString:@"#f2f5f5"];
    [footerView addSubview:headerTitle];
    [backgorundView addSubview:footerView];
    [backgorundView addSubview:footerLineView];
    return backgorundView;
}
- (void)goToMore:(NSInteger)type{
    BGMoreCommenViewController *mooreC = [[BGMoreCommenViewController alloc]init];
    [self.navigationController pushViewController:mooreC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 55;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupTabbar];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES];
    self.navigationController.navigationBar.translucent = NO;
    
}



//底部tabbar
- (void)setupTabbar{
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    [self.navigationController.toolbar setBarStyle:UIBarStyleDefault];
    self.navigationController.toolbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-44, [UIScreen mainScreen].bounds.size.width, 44);
    
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil action:nil];
    //评论按钮
    WJButton *readBtn = [WJButton buttonWithType:UIButtonTypeCustom];
    //    readBtn.backgroundColor = [GFICommonTool colorWithHexString:@"#fafafa"];
    [readBtn addTarget:self action:@selector(gotoJudge) forControlEvents:UIControlEventTouchUpInside];
    [readBtn setTitle:@"表达我的看法.." forState:UIControlStateNormal];
    [readBtn setTitleColor:[GFICommonTool colorWithHexString:@"#676767"] forState:UIControlStateNormal];
    [readBtn setImage:[UIImage imageNamed:@"写评论"] forState:UIControlStateNormal];
    //    [btn1 setBackgroundColor:[UIColor blueColor]];
    //    btn1.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    NSInteger tempWidth = 120;
    if (kISiPhone5) {
        tempWidth = 90;
    }
    readBtn.frame = CGRectMake(0, 5, tempWidth, 30);
    UIBarButtonItem *customItem1 = [[UIBarButtonItem alloc]initWithCustomView:readBtn];
    //阅读按钮
    _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_readBtn addTarget:self action:@selector(readNumber) forControlEvents:UIControlEventTouchUpInside];
    [_readBtn setTitle:@"635" forState:UIControlStateNormal];
    [_readBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_readBtn setImage:[UIImage imageNamed:@"阅读量"] forState:UIControlStateNormal];
    _readBtn.frame = CGRectMake(0, 0, 60, 40);
    _readBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self initButton:_readBtn];
    UIBarButtonItem *customItem2 = [[UIBarButtonItem alloc]initWithCustomView:_readBtn];
    
    //收藏按钮
    _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_collectionBtn addTarget:self action:@selector(makeACollection) forControlEvents:UIControlEventTouchUpInside];
    [_collectionBtn setTitle:@"30" forState:UIControlStateNormal];
    [_collectionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_collectionBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    _collectionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _collectionBtn.frame = CGRectMake(0, 0, 60, 40);
    [self initButton:_collectionBtn];
    UIBarButtonItem *customItem4 = [[UIBarButtonItem alloc]initWithCustomView:_collectionBtn];
    
    
    //分享按钮
    UIImage *sharedIcon = [UIImage imageNamed:@"分享"];
    sharedIcon = [sharedIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *customItem3 = [[UIBarButtonItem alloc]
                                    initWithImage:sharedIcon style:UIBarButtonItemStyleDone
                                    target:self action:@selector(gotoShared)];
    
    NSArray *arr1 = [[NSArray alloc]initWithObjects:customItem1,spaceItem,customItem2,customItem4,customItem3, nil];
    self.toolbarItems = arr1;
}
//将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    float  spacing = 0;//图片和文字的上下间距
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}

//评论
- (void)gotoJudge{
    [self alertPopView:nil andPlaceHolderTitle:@"请输入1-200字的评论"];
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
//阅读量
- (void)readNumber{
    NSLog(@"阅读量");
}

//收藏
- (void)makeACollection{
    NSLog(@"点赞");
    _collectionFlag = !_collectionFlag;
    if(_collectionFlag){
        [self.collectionBtn setImage:[UIImage imageNamed:@"收藏选中"] forState:UIControlStateNormal];
        [self.collectionBtn setTitle:@"31" forState:UIControlStateNormal];
    }else{
        [self.collectionBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
        [self.collectionBtn setTitle:@"30" forState:UIControlStateNormal];
    }
    
}
//分享
- (void)gotoShared{
    NSLog(@"分享");
}



-(UIImageView *)robotImageView{
    if (_robotImageView == nil) {
        
        UIImage *imgRobot = [UIImage imageNamed:@"置顶"];
        _robotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-62, kScreenHeight - TAB_HEIGHT -NAV_HEIGHT - 75, 42, 42)];
        //    ViewRadius(_robotImageView, 21);
        _robotImageView.image = imgRobot;
        _robotImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapRobotAction:)];
        [_robotImageView addGestureRecognizer:singleTap];
        
    }
    return _robotImageView;
}
- (void) singleTapRobotAction:(UIGestureRecognizer *) gesture
{
    
    if ([self.detailWebviewContainer.webview subviews]){
        
        UIScrollView* scrollView = [[self.detailWebviewContainer.webview subviews] objectAtIndex:0];
        //CGPointMake(0, 0)回到顶部
        [scrollView setContentOffset:CGPointMake(0, -NAV_HEIGHT) animated:YES];
    }
    
}



@end
