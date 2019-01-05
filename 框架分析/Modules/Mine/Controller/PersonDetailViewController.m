//
//  PersonDetailViewController.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/19.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "BGReadHistoryTableViewController.h"
#import "BGSettingTableViewController.h"
#import "BGMyCollectionTableViewController.h"
#import "BGReadHistoryTableViewController.h"
#import "BGCommentTableViewController.h"
#import "BGMessageHistoryTableViewController.h"
#import "CommonViewController.h"

//#import "GFIMyImageView.h"

@interface PersonDetailViewController ()<UITabBarDelegate,UITableViewDataSource>{
    NSData *_imgData;
}
@property (weak, nonatomic) IBOutlet UIView *headerViewGround;
@property (weak, nonatomic) IBOutlet UITableView *bottomTableView;
@property (weak, nonatomic) IBOutlet UIView *circleBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *nameTitleText;
@property (weak, nonatomic) IBOutlet UIButton *personButton;
@property (strong, nonatomic) UILabel * messageNumbeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImageTopConstrait;
@property (strong, nonatomic) NSDictionary * personArray;

@end

@implementation PersonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
//    self.navigationController.title = @"个人中心";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.personArray = appDelegate.personArr;
    [self.navigationItem setTitle:@"个人中心"];
}
-(void)setupUI{
    _backImageTopConstrait.constant = -NAV_HEIGHT;
    _bottomTableView.delegate  = self;
    _bottomTableView.dataSource = self;
    _bottomTableView.scrollEnabled = NO;
    _bottomTableView.sectionFooterHeight = 10;
    _bottomTableView.sectionHeaderHeight = 0;
    _bottomTableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    [_bottomTableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _bottomTableView.backgroundColor = [GFICommonTool colorWithHexString:@"#f1f5f9"];

    ViewRadius(_personButton, 45);
    ViewRadius(_circleBackgroundView, 10);
//    _personButton.adjustsImageWhenHighlighted = NO;
    _personButton.userInteractionEnabled = YES;
    _circleBackgroundView.userInteractionEnabled = YES;
    _headerViewGround.userInteractionEnabled = YES;
    _headerViewGround.backgroundColor = [GFICommonTool colorWithHexString:@"#eef2f6"];
    self.nameTitleText.textColor = [GFICommonTool colorWithHexString:@"#00476e"];
    if(isRetina || isiPhone5){
       _bottomTableView.scrollEnabled = YES;
    }
    //导航栏闪白条
    [self.navigationController.navigationBar.subviews objectAtIndex:0].hidden = YES;
    [self wr_setNavBarBarTintColor:[UIColor clearColor]];
    [self wr_setNavBarBackgroundAlpha:0];

//    self.bottomTableView.contentInset = UIEdgeInsetsMake( - NAV_HEIGHT, 0, 0, 0);
//    self.view.frame = CGRectMake(0, -NAV_HEIGHT, 0, 0);
    self.navigationController.title = @"个人中心";
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self wr_setNavBarBarTintColor:[GFICommonTool colorWithHexString:@"#00486b"]];
    [self wr_setNavBarBackgroundAlpha:1];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //导航栏透明属性
    self.navigationController.navigationBar.translucent = YES;
    //导航栏闪白条
    [self.navigationController.navigationBar.subviews objectAtIndex:0].hidden = YES;
    [self wr_setNavBarBarTintColor:[UIColor clearColor]];
    [self wr_setNavBarBackgroundAlpha:0];
    self.navigationController.navigationBar.subviews.firstObject.hidden = YES;
}
- (IBAction)changePersonImageButton:(id)sender {
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照",@"从相册选择",nil];
    [actionSheet showInView:self.view];
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    DLog(@"buttonIndex = [%d]",buttonIndex);
    switch (buttonIndex) {
        case 0://照相机
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
                //无权限
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温情提示"
                                                                message:@"请在设备的\"设置-隐私-相机\"中允许访问相机"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
        }
            break;
        case 1://相册
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}



//++++++++++++++++++++++++++++++++++++++++++++++


#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    UIImage *img = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93, 93)];
    _imgData = UIImageJPEGRepresentation(img, 1.0f);
    [self _submitAvatar];
}

- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

- (void)_submitAvatar{
    NSInteger photoCapa = [_imgData length];
    NSInteger newLength = photoCapa+4;
    Byte *bytes = (Byte *)[_imgData bytes];
    
    uint8_t *newByte = malloc(sizeof(*newByte) * (newLength));//首部添加4个字节，暂时都为0
    unsigned i;
    for (i = 0; i < newLength; i++){
        if (i==0 || i==1 || i==2 || i==3) {
            newByte[i] = 0;
        }else{
            newByte[i] = bytes[i-4];
        }
    }
    
    NSData *imageData = [NSData dataWithBytesNoCopy:newByte length:newLength freeWhenDone:YES];
    
    [_personButton setImage:[UIImage imageWithData:_imgData] forState:UIControlStateNormal];
//    //请求后台
//    [super showHUDLoading:@""];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSInteger ret = [self _requestAvatar:imageData];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (ret == retSuccCode) {
//                [super hideHUDLoading];
//                _newAvatar = _imgData;
//                _imageView.image = [UIImage imageWithData:_imgData];
//            }else if(ret == retUnloginCode){//去登陆
//                [super hideHUDLoading];
//                [GFICommonTool login:self];
//            }else if(ret == retAccountInvalidCode){//账号封号 251
//                [super showHUDTip:AccountInvalidError];
//            }else if(ret == retAccountLockCode){//账号锁定 253
//                [super showHUDTip:accountLockError];
//            }else{
//                [super showHUDTip:TEXT_SERVER_NOT_RESPOND];
//            }
//        });
//    });
    
}

//
//- (NSInteger)_requestAvatar:(NSData *)imgData{
//    NSInteger ret = interInitErrorCode;
//    id res = [[GFINetWorkDataService sharedClientManager] requestWithURL:kIData_updateavata_url picData:imgData httpMethod:@"POST" mobileNo:nil];
//    DLog(@"%@",res);
//    if (res) {
//        NSString *returnCode = [res objectForKey:kRtnKey];
//        ret = [returnCode integerValue];
//        
//        if (ret == retSuccCode) {
//            self.outFromPickerImage = 1;
//        }
//    }
//    return ret;
//}
//++++++++++++++++++++++++++++++++++++++++++++++







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 2;
    }else if (section == 1){
        return 2;
    }else{
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    FDHomeModel *model = self.dataArr[indexPath.row];
    UITableViewCell *cell;
    //2、调整大小
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //普通咨询
    static NSString *normalNewID = @"normalNew";
    cell = [tableView dequeueReusableCellWithIdentifier:normalNewID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalNewID];
    }
    //    newCell.model = model;
    if(indexPath.section == 3){
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"退出账号";
        cell.textLabel.textColor = [GFICommonTool colorWithHexString:@"#00476e"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        if(indexPath.section == 0 && indexPath.row == 0){
            cell.textLabel.text = @"阅读记录";
            cell.imageView.image = [UIImage imageNamed:@"阅读记录"];
            
        }else if (indexPath.section == 0 && indexPath.row == 1){
            cell.textLabel.text = @"我的消息";
            cell.imageView.image = [UIImage imageNamed:@"我的消息"];
            _messageNumbeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 60, 15, 20, 20)];
            _messageNumbeLabel.text = @"12";
            _messageNumbeLabel.textAlignment = NSTextAlignmentCenter;
            _messageNumbeLabel.textColor = [UIColor whiteColor];
            ViewRadius(_messageNumbeLabel, 10);
            _messageNumbeLabel.backgroundColor = [UIColor redColor];
            [cell.contentView addSubview:_messageNumbeLabel];
            
        }else if (indexPath.section == 1 && indexPath.row == 0){
            cell.textLabel.text = @"我的收藏";
            cell.imageView.image = [UIImage imageNamed:@"我的收藏"];
        }else if (indexPath.section == 1 && indexPath.row == 1){
            cell.textLabel.text = @"我的评论";
            cell.imageView.image = [UIImage imageNamed:@"我的评论"];
        }else if (indexPath.section == 2 && indexPath.row == 0){
            cell.textLabel.text = @"个人设置";
            cell.imageView.image = [UIImage imageNamed:@"个人设置"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //2、调整大小
        CGSize itemSize = CGSizeMake(20, 20);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    //去灰
    cell.selectionStyle = UITableViewCellSelectionStyleNone;


    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 3){
        return 60;

    }else{
        return 50;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if(indexPath.section == 0 && indexPath.row == 0){//阅读记录
        CommonViewController *moreC = [[CommonViewController alloc]init];
        moreC.title = @"阅读记录";
        [self.navigationController pushViewController:moreC animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 1){//消息记录
        BGMessageHistoryTableViewController *messageHistoryC = [[BGMessageHistoryTableViewController alloc]init];
         [self.navigationController pushViewController:messageHistoryC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){//我的收藏
        CommonViewController *moreC = [[CommonViewController alloc]init];
        moreC.title = @"我的收藏";
        [self.navigationController pushViewController:moreC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 1){//我的评论
        BGCommentTableViewController *commentC = [[BGCommentTableViewController alloc]init];
        [self.navigationController pushViewController:commentC animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 0){//个人设置
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"MainBase" bundle:nil];
        
        BGSettingTableViewController * settingViewController = [sb instantiateViewControllerWithIdentifier:@"SettingTableView"];
        
        [self.navigationController pushViewController:settingViewController animated:YES];
    }else if (indexPath.section == 3 && indexPath.row == 0){//退出登录
        NSUserDefaults *defaults = USER_DEFAULT;
        [defaults removeObjectForKey:kIsLoginScuu];
        [defaults synchronize];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
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
