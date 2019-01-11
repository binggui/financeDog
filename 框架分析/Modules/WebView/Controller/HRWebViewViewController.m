//
//  HRWebViewViewController.m
//  ZGHR
//
//  Created by 贾金勋 on 2017/7/3.
//  Copyright © 2017年 aspire. All rights reserved.
//

#import "HRWebViewViewController.h"
#import <WebKit/WebKit.h>
#import "WJButton.h"
#import "popView.h"

@interface HRWebViewViewController ()<WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *wkWebView;

@property (nonatomic,strong) UIImageView *robotImageView; //滚至顶部

@property (nonatomic,copy) NSString *url;

@property (nonatomic, strong)popView *popview;

@property (strong, nonatomic) UIButton * collectionBtn;

@property (strong, nonatomic) UIButton * readBtn;

@property (assign, nonatomic) BOOL  collectionFlag;
@end

@implementation HRWebViewViewController





- (instancetype)initWithUrl:(NSString *)url {
    if (self = [super init]) {

        _url = url;
        WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight - 44)];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        webView.navigationDelegate = self;
        [self.view addSubview:webView];
        [self.view addSubview:self.robotImageView];
        self.wkWebView = webView;
//        [HRLoadingView showHUDAddedTo:self.view animated:YES];
       
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _collectionFlag = NO;
//    self.navigationItem.title = @"我的红豆";
//    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.title = self.title;
    self.extendedLayoutIncludesOpaqueBars = YES;

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
    [_readBtn setImage:[UIImage imageNamed:@"阅读量1"] forState:UIControlStateNormal];
    _readBtn.frame = CGRectMake(0, 0, 60, 40);
    _readBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self initButton:_readBtn];
    UIBarButtonItem *customItem2 = [[UIBarButtonItem alloc]initWithCustomView:_readBtn];
    
    //收藏按钮
    _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [_collectionBtn addTarget:self action:@selector(makeACollection) forControlEvents:UIControlEventTouchUpInside];
    [_collectionBtn setTitle:@"30" forState:UIControlStateNormal];
    [_collectionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_collectionBtn setImage:[UIImage imageNamed:@"收藏1"] forState:UIControlStateNormal];
    _collectionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _collectionBtn.frame = CGRectMake(0, 0, 60, 40);
    [self initButton:_collectionBtn];
    UIBarButtonItem *customItem4 = [[UIBarButtonItem alloc]initWithCustomView:_collectionBtn];
    

    //分享按钮
    UIImage *sharedIcon = [UIImage imageNamed:@"分享1"];
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
    self.popview = [[popView alloc] initView];
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
        [self.collectionBtn setImage:[UIImage imageNamed:@"收藏1选中"] forState:UIControlStateNormal];
        [self.collectionBtn setTitle:@"31" forState:UIControlStateNormal];
    }else{
        [self.collectionBtn setImage:[UIImage imageNamed:@"收藏1"] forState:UIControlStateNormal];
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
        _robotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-62, kScreenHeight -TAB_HEIGHT - 75, 42, 42)];
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
    
    if ([self.wkWebView subviews]){
        
        UIScrollView* scrollView = [[self.wkWebView subviews] objectAtIndex:0];
        //CGPointMake(0, 0)回到顶部
        [scrollView setContentOffset:CGPointMake(0, -NAV_HEIGHT) animated:YES];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
