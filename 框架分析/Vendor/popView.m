//
//  popView.m
//  yinyinyin
//
//  Created by WDX on 17/2/27.
//  Copyright © 2017年 aspire. All rights reserved.
//

#import "popView.h"
#import <Masonry/Masonry.h>
#import "YYTextView.h"
#import <CoreLocation/CoreLocation.h>
//#import "HRAccessLogHttpTool.h"
#define  CSPopRemarkViewSpace  14.0f
#define  imgWidth ([UIScreen mainScreen].bounds.size.width - 10 * 5) / 4
#define  MAX_LIMIT_NUMS 200
//static CGFloat maxHeight = 60.0f;
@interface popView ()<UITextViewDelegate,CLLocationManagerDelegate>
{
    CGFloat _tempTextHeight;
    CGFloat _keyBoardHeight;
}
@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic,strong)UITextView *textView;//输入框
@property (nonatomic,strong)UIView * grayBackView;//灰色遮罩层
@property (nonatomic,strong)UITapGestureRecognizer * tap;//手势
@property (nonatomic,strong)UIView * topBackView;//上半部分背景
@property (nonatomic,strong)UIView * topContentView;//上半部分-内容-灰色背景
@property (nonatomic,strong)UIView * topImgBackView;//图片view
@property (nonatomic,strong)UIView * bottomBackView;//下半部分背景
@property (nonatomic,strong)NSMutableArray * selectImageArray;//图片
@property (nonatomic,strong)UITextView *placeHolderTextView;//充当占位符的textview
@property (nonatomic,strong)UILabel *lineViewLabel;//分割线
@property (nonatomic,strong)UIButton *locationBtn;//定位小图标
@property (nonatomic,strong)UILabel *locationLabel;//获取定位label
@property (nonatomic,strong)UILabel *numLabel;
@end

@implementation popView
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(id)initView
{
    if (self=[super init]) {
        self.backgroundColor=[UIColor whiteColor];
        
        _tempTextHeight=[popView defaultHeight];
        self.topBackView=[[UIView alloc] init];
        [self addSubview:self.topBackView];
        
        self.bottomBackView=[[UIView alloc] init];
        [self addSubview:self.bottomBackView];
        
        [self.topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self.bottomBackView.mas_top);
        }];
        [self.bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.topBackView.mas_bottom);
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.height.mas_equalTo(30);
            make.bottom.mas_equalTo(self);
        }];
        
        [self setTopUI];
        [self setBottomUI];
        [self registerNotifications];
    }
    return self;
//    self.bounds
    
}
#pragma mark setTopUI
-(void)setTopUI
{
    
    self.topContentView=[[UIView alloc] init];
    self.topContentView.layer.masksToBounds=YES;
    self.topContentView.layer.cornerRadius=5;
    self.topContentView.backgroundColor=[GFICommonTool colorWithHexString:@"e9e9e9"];
    [self.topBackView addSubview:self.topContentView];
    
    [self.topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topBackView).mas_equalTo(CSPopRemarkViewSpace);
        make.bottom.mas_equalTo(self.topBackView).mas_equalTo(-CSPopRemarkViewSpace);
        make.left.mas_equalTo(self.topBackView).offset(CSPopRemarkViewSpace);
        make.right.mas_equalTo(self.topBackView).offset(-CSPopRemarkViewSpace);
        
    }];
    
    self.topImgBackView=[[UIView alloc] init];
    [self.topContentView addSubview:self.topImgBackView];
    [self.topImgBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topContentView);
        make.right.mas_equalTo(self.topContentView);
        make.top.mas_equalTo(self.topContentView);
        make.height.mas_equalTo(0);
    }];
    
    self.textView=[[UITextView alloc] init];
    self.textView.backgroundColor=[UIColor clearColor];
    self.textView.tintColor = [UIColor blackColor];
    self.textView.layer.masksToBounds=YES;
    self.textView.layer.cornerRadius=4;
    self.textView.delegate=self;
    self.textView.font = [UIFont systemFontOfSize:14];
    
    [self.topContentView addSubview:self.textView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.topImgBackView.mas_bottom);
        make.left.mas_equalTo(self.topContentView).offset(2);
        make.right.mas_equalTo(self.topContentView);
        make.bottom.mas_equalTo(self.topContentView).offset(-CSPopRemarkViewSpace);
    }];
    
    
    self.placeHolderTextView=[[UITextView alloc] init];
    self.placeHolderTextView.text=@"请输入1~200字";
    self.placeHolderTextView.textColor=[UIColor grayColor];
    self.placeHolderTextView.userInteractionEnabled = NO;
    self.placeHolderTextView.backgroundColor=[UIColor clearColor];
    
    self.placeHolderTextView.editable = NO;
    self.placeHolderTextView.selectable = NO;
    self.placeHolderTextView.font = [UIFont systemFontOfSize:14];
    
    [self.topContentView addSubview:self.placeHolderTextView];
    
    [self.placeHolderTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.topImgBackView.mas_bottom);
        make.left.mas_equalTo(self.topContentView);
        make.right.mas_equalTo(self.topContentView).offset(-CSPopRemarkViewSpace);
        make.bottom.mas_equalTo(self.topContentView).offset(-CSPopRemarkViewSpace);
    }];
    
    self.numLabel = [[UILabel alloc] init];
    self.numLabel.text = @"0/200";
    self.numLabel.font = [UIFont systemFontOfSize:15];
    self.numLabel.textColor = [GFICommonTool colorWithHexString:@"#999999"];
    
    [self.topContentView addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.textView.mas_bottom).offset(-8);
        make.bottom.equalTo(self.topContentView.mas_bottom);
        make.right.equalTo(self.textView.mas_right).offset(-10);
        
        
    }];
}

- (void)setPlaceHolderTitle:(NSString *)placeHolderTitle{
    self.placeHolderTextView.text = placeHolderTitle;
}
#pragma mark setBottomUI
-(void)setBottomUI
{
    //发表
    UIButton * sendBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendBtn setTitle:@"发表" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[GFICommonTool colorWithHexString:@"c9c9c9"] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    sendBtn.layer.borderWidth=1;
    sendBtn.layer.borderColor=[GFICommonTool colorWithHexString:@"c9c9c9"].CGColor;
    sendBtn.layer.masksToBounds=YES;
    sendBtn.layer.cornerRadius=4;
    [sendBtn addTarget:self action:@selector(sendBtnDown) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBackView addSubview:sendBtn];
    
    
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bottomBackView).offset(-CSPopRemarkViewSpace);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.bottomBackView).offset(0);
    }];
    
    /*
     
    self.lineViewLabel = [[UILabel alloc]init];
    self.lineViewLabel.backgroundColor = [UIColor grayColor];
    [self.bottomBackView addSubview:self.lineViewLabel];
    [self.lineViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomBackView).offset(10);
        make.right.mas_equalTo(self.bottomBackView).offset(-10);
        make.top.mas_equalTo(sendBtn.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    
    self.locationBtn = [[UIButton alloc]init];
    [self.locationBtn setImage:[UIImage imageNamed:@"locationChoose-Icon"] forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(locationLabelTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBackView addSubview:self.locationBtn];
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineViewLabel);
        make.top.mas_equalTo(self.lineViewLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    self.locationLabel = [[UILabel alloc]init];
    self.locationLabel.text = @"自动获取位置";
    self.locationLabel.textColor = [UIColor grayColor];
    self.locationLabel.font = [UIFont systemFontOfSize:14];
    // 打开交互
    self.locationLabel.userInteractionEnabled = YES;
    // 添加点击事件
    UITapGestureRecognizer *labelTabGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationLabelTap:)];
    [self.locationLabel addGestureRecognizer:labelTabGestureRecognizer];
    [self.bottomBackView addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.locationBtn);
        make.left.mas_equalTo(self.locationBtn.mas_right).offset(10);
    }];
     
     */
    
}

- (void)sendBtnDown{
    
    //block回调
    if ([self.textView.text isEqualToString:@""]) {
        [OMGToast showWithText:@"请输入评论内容" topOffset:180.0f duration:1.0];
        return;
    }
    if (self.textView.text.length > 200) {
        [OMGToast showWithText:@"评论字数不得超过200字" topOffset:180.0f duration:1.0];
        return;
    }
    //消失本身
    if (self.dismissPopViewBlock) {
        [self dismissAlert];
        self.dismissPopViewBlock();
    }
    
    if ([self.delegagte respondsToSelector:@selector(sendContentText:andContent:)]){
        
        [self.delegagte sendContentText:self.indexPath andContent:self.textView.text];
    }
    
    
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:self.ID forKey:@"id"];
//    NSString *sid = [USER_DEFAULT objectForKey:@"sid"];
//    if (sid != nil) {
//        [params setObject:sid forKey:@"sid"];
//    }
    
//    [params setObject:[GFICommonTool encodeEmoji:self.textView.text] forKey:@"comment"];
////    if ([self.locationLabel.text isEqualToString:@"自动获取位置"]) {
////        [params setObject:@"未知" forKey:@"location"];
////    }else{
////        [params setObject:self.locationLabel.text forKey:@"location"];
////    }
//    [HRHTTPTool postWithURL:kHrhs_commit_comment parameters:params success:^(id json) {
//        NSLog(@"%@",json);
//        if ([[json objectForKey:@"result"] intValue] == 200) {
//            [OMGToast showWithText:[json objectForKey:@"feedback"] topOffset:300.0f duration:1.0];
//
//
//            //成功回调中
//            //日志
//            NSMutableDictionary *mparams = [NSMutableDictionary dictionary];
//            [mparams setValue:@"22" forKey:@"type"];
//            [mparams setValue:self.ID forKey:@"id"];
//            [HRAccessLogHttpTool postLogWithparameters:mparams];
//
//        }else{
//            [OMGToast showWithText:[json objectForKey:@"errMsg"] topOffset:300.0f duration:1.0];
//        }
//
//    } failure:^(NSError *error) {
//
//    }];
    
}
/***************  定位  ******************/
- (void)locationLabelTap :(UILabel *)locationLabel{
    NSLog(@"点击了");
    if (_locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    [self findMe];
    
}- (void)locationManager:(CLLocationManager *)manager
      didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    
    // 2.停止定位
    [manager stopUpdatingLocation];
    // 反地理编码
    CLGeocoder *geo = [[CLGeocoder alloc]init];
    [geo reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = placemarks[0];
        //省
        NSLog(@"%@",placeMark.administrativeArea);
        //市
        NSLog(@"%@",placeMark.locality);
        
        self.locationLabel.text = [NSString stringWithFormat:@"%@%@",placeMark.administrativeArea,placeMark.locality];
        
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}
- (void)findMe
{
    /** 由于IOS8中定位的授权机制改变 需要进行手动授权
     * 获取授权认证，两个方法：
     * [self.locationManager requestWhenInUseAuthorization];
     * [self.locationManager requestAlwaysAuthorization];
     */
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        NSLog(@"requestAlwaysAuthorization");
        [self.locationManager requestAlwaysAuthorization];
    }
    
    //开始定位，不断调用其代理方法
    [self.locationManager startUpdatingLocation];
    NSLog(@"start gps");
}

/*********************************/
-(void)show
{
    [[popView rootViewController].view addSubview:self];
    self.frame = CGRectMake(0, KScreenHeight - 170.0f, KScreenWidth, 140.0f);
    [self.textView becomeFirstResponder];
}
-(void)addDepen{
    [self.textView becomeFirstResponder];
}

- (void)dismissAlert
{
    [self unRegisterNotifications];
    [self removeFromSuperview];
}
- (void)removeFromSuperview
{
    [self.topBackView removeFromSuperview];
    [self.bottomBackView removeFromSuperview];
    [self.grayBackView removeFromSuperview];
    self.grayBackView = nil;
    
    UIViewController *topVC = [popView rootViewController];
    [topVC.view removeGestureRecognizer:self.tap];
    
    [super removeFromSuperview];
}

#pragma mark  UITextViewDelegate

#pragma mark -限制病情描述输入字数(最多不超过255个字)
 - (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
 //不支持系统表情的输入
 
//     if ([[textView textInputMode] primaryLanguage]==nil||[[[textView textInputMode] primaryLanguage]isEqualToString:@"emoji"]) {
//
//         return NO;
//
//     }
     UITextRange *selectedRange = [textView markedTextRange];
      //获取高亮部分
     UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
     //获取高亮部分内容
     //NSString * selectedtext = [textView textInRange:selectedRange];
     //如果有高亮且当前字数开始位置小于最大限制时允许输入
      if (selectedRange && pos) {
       NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
       NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
       NSRange offsetRange =NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location <MAX_LIMIT_NUMS) {
            return YES;
            }else{
             return NO;
            }
        }
     NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
     NSInteger caninputlen =MAX_LIMIT_NUMS - comcatstr.length;
     if (caninputlen >=0){
         return YES;
     }else{
         NSInteger len = text.length + caninputlen;
         //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
         NSRange rg = {0,MAX(len,0)};
         if (rg.length >0){
             NSString *s =@"";
             //判断是否只普通的字符或asc码(对于中文和表情返回NO)
             BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
             if (asc) {
                 s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
             }else{
                 __block NSInteger idx =0;
                 __block NSString  *trimString =@"";//截取出的字串
                 //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                 [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                          options:NSStringEnumerationByComposedCharacterSequences
                                       usingBlock: ^(NSString* substring,NSRange substringRange,NSRange enclosingRange,BOOL* stop) {
                                           if (idx >= rg.length) {
                                               *stop =YES;//取出所需要就break，提高效率
                                               return ;
                                           }
                                           trimString = [trimString stringByAppendingString:substring];
                                           idx++;
                                       }];
                 s = trimString;
             }
             //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
             [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
             //既然是超出部分截取了，哪一定是最大限制了。
             self.numLabel.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
         }
         return NO;
     }
}
 
 #pragma mark -显示当前可输入字数/总字数
 - (void)textViewDidChange:(UITextView *)textView{
 
     if (self.textView.text.length > 0) {
         self.placeHolderTextView.hidden = YES;
     }else{
         self.placeHolderTextView.hidden = NO;
     }
     
     UITextRange *selectedRange = [textView markedTextRange];
     //获取高亮部分
     UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
     //如果在变化中是高亮部分在变，就不要计算字符了
     if (selectedRange && pos) {
         return;
     }
     NSString  *nsTextContent = textView.text;
     NSInteger existTextNum = nsTextContent.length;
        if (existTextNum >MAX_LIMIT_NUMS){
            //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
            NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
            [textView setText:s];
        }
 //不让显示负数
 
 
     if (textView.text.length >= MAX_LIMIT_NUMS) {
         textView.text = [textView.text substringWithRange:NSMakeRange(0, MAX_LIMIT_NUMS)];
         self.numLabel.text = [NSString stringWithFormat:@"%lu/%d",MAX(0,textView.text.length),MAX_LIMIT_NUMS];
         }else{
         self.numLabel.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,existTextNum),MAX_LIMIT_NUMS];
         }
 }

- (void)dealloc
{
    NSLog(@"hahah");
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [popView rootViewController];
    
    if (!self.grayBackView) {
        
        self.grayBackView=[[UIView alloc] init];
        self.grayBackView.backgroundColor = [UIColor blackColor];
        
        self.grayBackView.alpha = 0.3f;
        self.grayBackView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:self.grayBackView];
    
    [self.grayBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(topVC.view);
    }];
    self.tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert)];
    [self.grayBackView addGestureRecognizer:self.tap];
    [super willMoveToSuperview:newSuperview];
}

#pragma mark - 通知
- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unRegisterNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 输入键盘相关

//Code from Brett Schumann
- (void)keyboardWillShow:(NSNotification *)note{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    _keyBoardHeight=keyboardBounds.size.height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    self.frame = CGRectMake(0,KScreenHeight - self.frame.size.height - keyboardBounds.size.height , KScreenWidth, self.frame.size.height);
    if (kISiPhoneX) {
        self.y = self.y + 35;
    }
    [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)note{
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    _keyBoardHeight=0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.frame = CGRectMake(0, KScreenHeight - self.frame.size.height -0,KScreenWidth, self.frame.size.height);
    [UIView commitAnimations];
}

+(CGFloat)defaultHeight{
    return 50.0f;
}
+(UIViewController *)rootViewController{
    return [[UIApplication sharedApplication].delegate window].rootViewController;
}

@end
