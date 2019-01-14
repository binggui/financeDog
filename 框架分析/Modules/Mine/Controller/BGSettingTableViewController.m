//
//  BGSettingTableViewController.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/20.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "BGSettingTableViewController.h"
#import "HRChangeInfoViewController.h"
#import "BGForgetPasswordViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface BGSettingTableViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSData *_imgData;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *personImg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sexSegment;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;

@end

@implementation BGSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"个人设置"];
    [self getPics];
    [self  setupUI];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
    
    return section ==0?0.1f:8.0f;// 0.1f:防止tableView顶部留白一块
    
}
-(void)setupUI {
    NSUserDefaults *defaults = USER_DEFAULT;
    self.automaticallyAdjustsScrollViewInsets = false;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    ViewBorderRadius(_personImg, 30, 1, KBlackColor);
//    ViewRadius(self.sexSegment, 15);
    
    NSString *numberString = [[defaults objectForKey:@"mobile"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.phoneNumber.text = numberString;
    self.sexSegment.selectedSegmentIndex = [defaults integerForKey:@"sex"];
    self.nameLabel.text = [defaults objectForKey:@"user_nickname"];
    if (self.personSettingImg != nil) {
        self.personImg.image = self.personSettingImg;
    }else{
        
        [self.personImg sd_setImageWithURL:[NSURL URLWithString:[USER_DEFAULT objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"头像"]];
    }

  
    
}

//网络请求
- (void)getPics{
    
    [HRHTTPTool postWithURL:kJRG_getavatar_info parameters:nil success:^(id json) {
        NSString *result = [json objectForKey:@"error_code"];
        if ([result intValue] == 200) {
            if ([json isKindOfClass:[NSDictionary class]]) {
                
            [self.personImg sd_setImageWithURL:[json objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"头像"]];
                
            }
        }
    } failure:^(NSError *error) {
       
        NSLog(@"error == %@",error);
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if(section == 1){
        return 2;
    }else{
        return 3;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *lineBottom = [[UIView alloc]init];
    if(section == 1){
        lineBottom.frame = CGRectMake(0, 0, kScreenWidth, 5);
    }else{
        lineBottom.frame = CGRectMake(0, 0, kScreenWidth, 0);
    }
    return lineBottom;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0 && indexPath .row == 0){//头像
//        UIActionSheet* actionSheet = [[UIActionSheet alloc]
//                                      initWithTitle:nil
//                                      delegate:self
//                                      cancelButtonTitle:@"取消"
//                                      destructiveButtonTitle:nil
//                                      otherButtonTitles:@"拍照",@"从相册选择",nil];
//        [actionSheet showInView:self.view];
    }else if (indexPath.section == 0 && indexPath .row == 1){//昵称
        HRChangeInfoViewController *changeVC = [[HRChangeInfoViewController alloc]init];
        changeVC.backBlock = ^(NSString *str){
            _nameLabel.text = str;
        };
        [self.navigationController pushViewController:changeVC animated:YES];
    }else if (indexPath.section == 0 && indexPath .row == 0){//性别
        
    }else if (indexPath.section == 1 && indexPath .row == 0){//手机号
        BGForgetPasswordViewController *forgetPasswordC = [[BGForgetPasswordViewController alloc]init];
        forgetPasswordC.backMobileBlock = ^(NSString *str) {
            NSString *numberString = [str stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            self.phoneNumber.text = numberString;

        };
        forgetPasswordC.type = 1;
        [self.navigationController pushViewController:forgetPasswordC animated:YES];
    }else if (indexPath.section == 1 && indexPath .row == 1){//修改密码
        BGForgetPasswordViewController *forgetPasswordC = [[BGForgetPasswordViewController alloc]init];
        forgetPasswordC.type = 2;
        [self.navigationController pushViewController:forgetPasswordC animated:YES];
        
    }
    

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
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSUserDefaults *defaults = USER_DEFAULT;
    [defaults setInteger:self.sexSegment.selectedSegmentIndex forKey:@"sex"];
    [defaults setObject:self.phoneNumber.text forKey:@"mobile"];
    [defaults setObject:self.nameLabel.text forKey:@"user_nickname"];
    //2.1立即同步
    [defaults synchronize];


}
- (void)dealloc
{
    [self postUrl:kJRG_editsex_info andType:1];
    [self postUrl:kJRG_editnickname_info andType:2];
}


//网络请求
- (void)postUrl:(NSString *)URl andType:(NSInteger )type{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (type == 1) {//性别
        [params setObject:@(self.sexSegment.selectedSegmentIndex)  forKey:@"sex"];
    }else if (type == 2){//昵称
        [params setObject:self.nameLabel.text forKey:@"nickname"];
    }
    
    
    [HRHTTPTool postWithURL:URl parameters:params success:^(id json) {
        NSString *result = [json objectForKey:@"error_code"];
        
        if ([result intValue] == 200) {
            if ([json isKindOfClass:[NSDictionary class]]) {

            }
        }else{
//            [OMGToast showWithText:[json objectForKey:@"error_msg"] topOffset:KScreenHeight/2 duration:1.7];
            
        }
    } failure:^(NSError *error) {
//        [OMGToast showWithText:@"网络错误" topOffset:KScreenHeight/2 duration:1.7];
        NSLog(@"error == %@",error);
    }];
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
    
    _personImg.image = [UIImage imageWithData:_imgData];
    [self getPics:_imgData];
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
//网络请求
- (void)getPics:(NSData *)imgData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *imgStr = [imgData base64EncodedString];
    [params setObject:imgStr forKey:@"imgData"];
    
    [HRHTTPTool postWithURL:kJRG_exampleapi_info parameters:params success:^(id json) {
        NSString *result = [json objectForKey:@"error_code"];
        if ([result intValue] == 200) {
            if ([json isKindOfClass:[NSDictionary class]]) {
                
            }
        }else{
//            [OMGToast showWithText:[json objectForKey:@"error_msg"] topOffset:KScreenHeight/2 duration:1.7];
            
        }
    } failure:^(NSError *error) {
//        [OMGToast showWithText:@"网络错误" topOffset:KScreenHeight/2 duration:1.7];
        NSLog(@"error == %@",error);
    }];
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
