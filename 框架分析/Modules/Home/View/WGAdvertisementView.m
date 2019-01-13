

//#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#import "WGAdvertisementView.h"
#import "WGProductImageView.h"


@implementation WGAdvertisementView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self becomeFirstResponder];
        
        _interval = 0;//轮播秒数初始化
        //底层scrollView初始化
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_scrollView];
        //轮播视图下方的pageControl
        if(isRetina || isiPhone5){
            _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-25, 150, 20)];
        }else{
            _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-20, 150, 20)];
        }
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
            
            _pageControl.pageIndicatorTintColor = [GFICommonTool colorWithHexString:appColorDefault];
            _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        }
        
        [_pageControl setEnabled:NO];
        
        CGPoint center = _pageControl.center;
        center.x = CGRectGetWidth(self.frame)/2;
        _pageControl.center = center;
        
        _pageControl.backgroundColor = [UIColor clearColor];
        [self addSubview:_pageControl];
        
        _currentPage = 0;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beginAutoCarousel) userInfo:nil repeats:YES];
        [_timer fire];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self becomeFirstResponder];
        
        _interval = 0;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_scrollView];

        
        if(isRetina || isiPhone5){
            _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-25, 150, 20)];
        }else{
            _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-20, 150, 20)];
        }
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
            
            _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
            _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        }
        
        [_pageControl setEnabled:NO];
        
        CGPoint center = _pageControl.center;
        center.x = CGRectGetWidth(self.frame)/2;
        _pageControl.center = center;
        
        _pageControl.backgroundColor = [UIColor clearColor];
        [self addSubview:_pageControl];
        
        _currentPage = 0;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beginAutoCarousel) userInfo:nil repeats:YES];
        [_timer fire];
        
    }
    return self;
}

//开始自动轮播
-(void)beginAutoCarousel
{
    _interval++;
    //4秒换一张轮播图片
    if (_interval == 4) {
        
        _interval = 0;
        [self performSelector:@selector(autoCarouselImage)];
    }
    
}

//对外接口传入的数组元素是字典
-(void)setImageInfos:(NSArray *)imageInfos
{
    if (self.imageInfos != imageInfos && imageInfos != nil) {
        
        _imageInfos = imageInfos ;
        
        if ([self.imageInfos count]) {
            
            [self addImageViews];
        }
    }
}

-(void)addImageViews
{
    for(UIView * subView in _scrollView.subviews){
        
        if ([subView isKindOfClass:[WGProductImageView class]]) {
            
            [subView removeFromSuperview];
        }
    }
    
    for(int i = 0;i <= [self.imageInfos count]+1;i++)
    {
        
        WGProductImageView *imageView = [[WGProductImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake((i)*(CGRectGetWidth(self.frame)), 0, CGRectGetWidth(self.frame), KCurrentHeights(368/2));
        
        NSDictionary * imageInfo = nil;
        
        if (i == 0) {
            
            imageInfo = [self.imageInfos lastObject];
            
            
            imageView.dict = imageInfo;
            [imageView refresh];
        }
        else if (i == [self.imageInfos count]+1)
        {
            imageInfo = [self.imageInfos firstObject];
            
            imageView.dict = imageInfo;
            [imageView refresh];
        }
        else{
            imageInfo = [self.imageInfos objectAtIndex:i-1];
            imageView.dict = imageInfo;
            [imageView refresh];
        }
        imageView.delegate = self;
        [_scrollView addSubview:imageView];
    }
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*([self.imageInfos count]+2),0);
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
    
    //添加UIPageControl
    _pageControl.numberOfPages = [self.imageInfos count];
    _pageControl.currentPage = 0;
}

#pragma -mark UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_timer) {
        
        [_timer invalidate];
        _timer = nil;
    }
    _interval = 0;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(beginAutoCarousel) userInfo:nil repeats:YES];
        [_timer fire];
    }
    
    _currentPage = (NSInteger)(scrollView.contentOffset.x/CGRectGetWidth(self.frame));
    
    [self jugdeEdgePage];
}


#pragma -mark 计时器自动轮播
-(void)autoCarouselImage{
    
    if (_timer) {
        
        _currentPage = (NSInteger)(_scrollView.contentOffset.x/CGRectGetWidth(self.frame));
        [UIView animateWithDuration:0.25 animations:^{
            
            [_scrollView setContentOffset:CGPointMake((_currentPage+1)*CGRectGetWidth(self.frame), 0)];
        } completion:^(BOOL finished) {
            
            _currentPage = (NSInteger)(_scrollView.contentOffset.x/CGRectGetWidth(self.frame));
            [self jugdeEdgePage];
        }];
    }
}

-(void)jugdeEdgePage
{
    if (_currentPage >= [self.imageInfos count]+1) {
        
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0)];
        _currentPage = 0;
    }
    else if(_currentPage <= 0){
        
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame)*[self.imageInfos count], 0)];
        _currentPage = [self.imageInfos count]-1;
    }
    else{
        
        _currentPage -= 1;
    }
    
    _pageControl.currentPage = _currentPage;
}

#pragma mark -代理方法，推出对应的广告
- (void)pushAddViewController:(LSDetainViewController *)vc withloginFlag:(NSNumber *)mustlogin openWay:(NSString *)loadbybrowser desc:(NSInteger)desc
{
    [self.delegate pushAdVc:vc withloginFlag:mustlogin openWay:loadbybrowser desc:desc];

    
}




@end
