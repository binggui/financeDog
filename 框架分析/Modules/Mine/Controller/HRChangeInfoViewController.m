//
//  HRChangeInfoViewController.m
//  ZGHR
//
//  Created by WDX on 17/1/18.
//  Copyright © 2017年 aspire. All rights reserved.
//

#import "HRChangeInfoViewController.h"

@interface HRChangeInfoViewController ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *changeText;
@end

@implementation HRChangeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.navigationItem.title = @"修改昵称";
    self.view.backgroundColor = kColor(245, 246, 247);
    
}

- (void)setupUI{
    _changeText = [[UITextField alloc]init];
    _changeText.backgroundColor = [UIColor whiteColor];
    _changeText.layer.borderColor = [GFICommonTool colorWithHexString:@"#dddddd"].CGColor;
    _changeText.tag = 300;
    _changeText.delegate = self;
    _changeText.layer.borderWidth = 1.0;
    //设置距左间距(包括占位字和文字)
    [_changeText setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [self.view addSubview:_changeText];
    [_changeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(20);
        make.height.mas_equalTo(50);
    }];
    
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];

    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.equalTo(_changeText);
        make.top.equalTo(_changeText.mas_bottom).offset(20);
    }];
    
    [commitBtn setTitleColor:kColor(25, 164, 244) forState:UIControlStateNormal];
    commitBtn.layer.cornerRadius = 6.0;
    commitBtn.layer.masksToBounds = true;
    commitBtn.layer.borderWidth = 1.0;
    commitBtn.layer.borderColor = kColor(160, 216, 249).CGColor;
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    
    [commitBtn setTitle:@"保存" forState:UIControlStateNormal];
    NSAttributedString *attributeStr = [[NSAttributedString alloc]initWithString:@"请输入2~10位昵称" attributes:@{NSForegroundColorAttributeName:kColor(134, 134, 135),NSFontAttributeName:_changeText.font                                          }];
    _changeText.attributedPlaceholder = attributeStr;
    _changeText.keyboardType = UIKeyboardTypeDefault;
}
- (void)clickBtn{
   
    if (self.backBlock) {
        self.backBlock(_changeText.text);
    }
    [self.navigationController popViewControllerAnimated:YES];

    
    
}

//监听回车以及限制字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 300) {
        if ([[textField textInputMode] primaryLanguage]==nil||[[[textField textInputMode] primaryLanguage]isEqualToString:@"emoji"]) {
//            [OMGToast showWithText:@"昵称暂不支持表情输入" topOffset:180.0f duration:1.0];
            return NO;
        }
    }
    return YES;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
