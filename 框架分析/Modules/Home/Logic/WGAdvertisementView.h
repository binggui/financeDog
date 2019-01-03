
#import <UIKit/UIKit.h>
#import "WGAdvertisementView.h"
#import "WGProductImageView.h"
#define IMAGEVIEWHEIGHT 120.0
//滚动视图类
@protocol WGAdvertisementViewDelegate <NSObject>
- (void)pushAdVc:(LSDetainViewController *)vc withloginFlag:(NSNumber *)mustlogin openWay:(NSNumber *)loadbybrowser desc:(NSNumber *)desc;
@end

@interface WGAdvertisementView : UIView<UIScrollViewDelegate,WGProductImageViewDelegate>
{
    UIPageControl * _pageControl;
    UIScrollView * _scrollView;//底层scrollView
    NSInteger _currentPage;//记录当前第几页
    NSTimer * _timer;//定时器
    int _interval;//几秒切换
}
@property (nonatomic,strong) NSArray * imageInfos;
@property (nonatomic ,weak) id <WGAdvertisementViewDelegate> delegate;

-(void)setImageInfos:(NSArray *)imageInfos;
@end
