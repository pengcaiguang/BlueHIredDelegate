//
//  LPChangePasswordVC.m
//  BlueHired
//
//  Created by peng on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPChangePasswordVC.h"
#import "LWLoginRegisterVC.h"

@interface LPChangePasswordVC ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField *phoneTextField;
@property(nonatomic,strong) UIView *phoneLineView;
@property(nonatomic,strong) UITextField *passwordTextField;
@property(nonatomic,strong) UIView *passwordLineView;
@property(nonatomic,strong) UITextField *repasswordTextField;
@property(nonatomic,strong) UIView *repasswordLineView;

@property(nonatomic,strong) UITextField *verificationCodeTextField;
@property(nonatomic,strong) UIView *verificationCodeLineView;
@property(nonatomic,strong) UIButton *getVerificationCodeButton;

@property(nonatomic,strong) NSString *token;
@property(nonatomic,strong) NSString *phone;



@end

@implementation LPChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}
-(void)setupUI{
    self.navigationItem.title = self.Type == 1 ? @"忘记密码" : @"登录密码修改";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
 
    UIView *phoneBgView = [[UIView alloc]init];
    [self.view addSubview:phoneBgView];
    phoneBgView.backgroundColor = [UIColor whiteColor];
    [phoneBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(LENGTH_SIZE(10));
        make.height.mas_equalTo(LENGTH_SIZE(48));
    }];
    UILabel *phoneImg = [[UILabel alloc]init];
    [phoneBgView addSubview:phoneImg];
    [phoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.centerY.equalTo(phoneBgView);
        make.width.mas_equalTo(LENGTH_SIZE(80));
    }];
//    phoneImg.image = [UIImage imageNamed:@"password_img"];
    phoneImg.text = self.Type == 1 ? @"手机号" : @"旧密码";
    phoneImg.textColor = [UIColor colorWithHexString:@"#333333"];
    phoneImg.font = FONT_SIZE(16);
    

    
    UIView *PhoneImgLine = [[UIView alloc] init];
    [phoneBgView addSubview:PhoneImgLine];
    [PhoneImgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneImg.mas_right).offset(0);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(22);
        make.centerY.equalTo(phoneBgView);
    }];
    PhoneImgLine.backgroundColor = [UIColor colorWithHexString:@"#FF939393"];
    
    
    self.phoneTextField = [[UITextField alloc]init];
    [phoneBgView addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PhoneImgLine.mas_right).offset(0);
        make.right.mas_equalTo(LENGTH_SIZE(-13));
        make.height.mas_equalTo(LENGTH_SIZE(48));
        make.centerY.equalTo(phoneBgView);
        
    }];
    self.phoneTextField.delegate = self;
    self.phoneTextField.placeholder = self.Type == 1 ? @"请输入当前手机号" : @"请输入当前登录密码";
    self.phoneTextField.tintColor = [UIColor baseColor];
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.keyboardType = self.Type == 1 ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
    self.phoneTextField.secureTextEntry = self.Type == 1 ? NO : YES;
    
    
    
    if (self.Type == 1  && self.UserPhone.length>0) {
        self.phoneTextField.text = self.UserPhone;
        self.phoneTextField.enabled = NO;
    }
    
//    self.phoneLineView = [[UIView alloc]init];
//    [phoneBgView addSubview:self.phoneLineView];
//    [self.phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(1);
//    }];
//    self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
    
    
    UIView *verificationCodeBgView = [[UIView alloc]init];
    [self.view addSubview:verificationCodeBgView];
    [verificationCodeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(phoneBgView.mas_bottom).offset(0);
        make.height.mas_equalTo( self.Type == 1 ? LENGTH_SIZE(48) : 0);
    }];
    verificationCodeBgView.backgroundColor = [UIColor whiteColor];
    verificationCodeBgView.clipsToBounds = YES;
    
    self.verificationCodeLineView = [[UIView alloc]init];
    [verificationCodeBgView addSubview:self.verificationCodeLineView];
    [self.verificationCodeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.verificationCodeLineView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    
    
    UILabel *verificationCodeImg = [[UILabel alloc]init];
    [verificationCodeBgView addSubview:verificationCodeImg];
    [verificationCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.centerY.equalTo(verificationCodeBgView);
        make.width.mas_offset(LENGTH_SIZE(80));
    }];
    verificationCodeImg.text = @"验证码";
    verificationCodeImg.textColor = [UIColor colorWithHexString:@"#333333"];
    verificationCodeImg.font = FONT_SIZE(16);
    
    UIView *PverificationCodeImgLine = [[UIView alloc] init];
    [verificationCodeBgView addSubview:PverificationCodeImgLine];
    [PverificationCodeImgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(verificationCodeImg.mas_right).offset(0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(22);
        make.centerY.equalTo(verificationCodeBgView);
    }];
    //    PverificationCodeImgLine.backgroundColor = [UIColor colorWithHexString:@"#FF939393"];
    
    self.verificationCodeTextField = [[UITextField alloc]init];
    [verificationCodeBgView addSubview:self.verificationCodeTextField];
    [self.verificationCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PverificationCodeImgLine.mas_right).offset(0);
        make.right.mas_equalTo(LENGTH_SIZE(-100));
        make.height.mas_equalTo(LENGTH_SIZE(48));
        make.centerY.equalTo(verificationCodeBgView);
    }];
    self.verificationCodeTextField.delegate = self;
    self.verificationCodeTextField.placeholder = @"请输入验证码";
    self.verificationCodeTextField.tintColor = [UIColor baseColor];
    self.verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    UIButton *getVerificationCodeButton = [[UIButton alloc]init];
    [verificationCodeBgView addSubview:getVerificationCodeButton];
    [getVerificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(LENGTH_SIZE(100), LENGTH_SIZE(16)));
        make.centerY.equalTo(verificationCodeBgView);
    }];
    getVerificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(15)];
    [getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerificationCodeButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [getVerificationCodeButton addTarget:self action:@selector(touchGetVerificationCodeButtonButton:) forControlEvents:UIControlEventTouchUpInside];
    self.getVerificationCodeButton = getVerificationCodeButton;
    
    

    
    
    UIView *passwordBgView = [[UIView alloc]init];
    passwordBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:passwordBgView];
    [passwordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(verificationCodeBgView.mas_bottom).offset(0);
        make.height.mas_equalTo(LENGTH_SIZE(48));
    }];
    
    UIView *passwordBgLineView = [[UIView alloc]init];
    [passwordBgView addSubview:passwordBgLineView];
    [passwordBgLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    passwordBgLineView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    
    UILabel *passwordImg = [[UILabel alloc]init];
    [passwordBgView addSubview:passwordImg];
    [passwordImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.centerY.equalTo(passwordBgView);
        make.width.mas_equalTo(LENGTH_SIZE(80));
    }];
//    passwordImg.image = [UIImage imageNamed:@"password_img"];
    passwordImg.text = @"新密码";
    passwordImg.textColor = [UIColor colorWithHexString:@"#333333"];
    passwordImg.font = FONT_SIZE(16);
    
    UIView *passwordImgLine = [[UIView alloc] init];
    [passwordBgView addSubview:passwordImgLine];
    [passwordImgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(passwordImg.mas_right).offset(0);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(22);
        make.centerY.equalTo(passwordBgView);
    }];
    passwordImgLine.backgroundColor = [UIColor colorWithHexString:@"#FF939393"];
    
    self.passwordTextField = [[UITextField alloc]init];
    [passwordBgView addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(passwordImgLine.mas_right).offset(0);
        make.right.mas_equalTo(LENGTH_SIZE(-13));
        make.height.mas_equalTo(LENGTH_SIZE(48));
        make.centerY.equalTo(passwordBgView);
    }];
    self.passwordTextField.delegate = self;
    self.passwordTextField.placeholder = @"请设置6-16位密码";
    self.passwordTextField.tintColor = [UIColor baseColor];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.secureTextEntry = YES;
 
    

    
    
//    UIButton *showPasswordButton = [[UIButton alloc]init];
//    [passwordBgView addSubview:showPasswordButton];
//    [showPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-15);
//        make.size.mas_equalTo(CGSizeMake(22, 16));
//        make.centerY.equalTo(passwordBgView);
//    }];
//    [showPasswordButton setImage:[UIImage imageNamed:@"show_eye_img"] forState:UIControlStateNormal];
//    [showPasswordButton setImage:[UIImage imageNamed:@"Passhide_eye_img"] forState:UIControlStateSelected];
//    [showPasswordButton addTarget:self action:@selector(touchShowPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.passwordLineView = [[UIView alloc]init];
//    [passwordBgView addSubview:self.passwordLineView];
//    [self.passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(1);
//    }];
    self.passwordLineView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *repasswordBgView = [[UIView alloc]init];
    repasswordBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:repasswordBgView];
    [repasswordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(passwordBgView.mas_bottom).offset(0);
        make.height.mas_equalTo(LENGTH_SIZE(48));
    }];
    
    UIView *repasswordBgLineView = [[UIView alloc]init];
    [repasswordBgView addSubview:repasswordBgLineView];
    [repasswordBgLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    repasswordBgLineView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    
    UILabel *repasswordImg = [[UILabel alloc]init];
    [repasswordBgView addSubview:repasswordImg];
    [repasswordImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.centerY.equalTo(repasswordBgView);
        make.width.mas_equalTo(LENGTH_SIZE(80));
    }];
//    repasswordImg.image = [UIImage imageNamed:@"password_img"];
    repasswordImg.text = @"确认密码";
    repasswordImg.textColor = [UIColor colorWithHexString:@"#333333"];
    repasswordImg.font = FONT_SIZE(16);
    
    UIView *repasswordImgLine = [[UIView alloc] init];
    [repasswordBgView addSubview:repasswordImgLine];
    [repasswordImgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneImg.mas_right).offset(0);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(22);
        make.centerY.equalTo(repasswordBgView);
    }];
    repasswordImgLine.backgroundColor = [UIColor colorWithHexString:@"#FF939393"];
    
    
    self.repasswordTextField = [[UITextField alloc]init];
    [repasswordBgView addSubview:self.repasswordTextField];
    [self.repasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(repasswordImgLine.mas_right).offset(0);
        make.right.mas_equalTo(LENGTH_SIZE(-13));
        make.height.mas_equalTo(LENGTH_SIZE(48));
        make.centerY.equalTo(repasswordBgView);
    }];
    self.repasswordTextField.delegate = self;
    self.repasswordTextField.placeholder = @"请再次输入新密码";
    self.repasswordTextField.tintColor = [UIColor baseColor];
    self.repasswordTextField.secureTextEntry = YES;
    self.repasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    
//    UIButton *showrePasswordButton = [[UIButton alloc]init];
//    [repasswordBgView addSubview:showrePasswordButton];
//    [showrePasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-15);
//        make.size.mas_equalTo(CGSizeMake(22, 16));
//        make.centerY.equalTo(repasswordBgView);
//    }];
//    [showrePasswordButton setImage:[UIImage imageNamed:@"show_eye_img"] forState:UIControlStateNormal];
//    [showrePasswordButton setImage:[UIImage imageNamed:@"Passhide_eye_img"] forState:UIControlStateSelected];
//    [showrePasswordButton addTarget:self action:@selector(touchShowrePasswordButton:) forControlEvents:UIControlEventTouchUpInside];
//
    
//    self.repasswordLineView = [[UIView alloc]init];
//    [repasswordBgView addSubview:self.repasswordLineView];
//    [self.repasswordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(1);
//    }];
//    self.repasswordLineView.backgroundColor = [UIColor lightGrayColor];
    
    
    if (@available(iOS 11.0, *)) {
        self.passwordTextField.textContentType = UITextContentTypePassword;
        self.repasswordTextField.textContentType = UITextContentTypePassword;
    }
    if (@available(iOS 12.0, *)) {
        self.passwordTextField.textContentType = UITextContentTypeNewPassword;
        self.repasswordTextField.textContentType = UITextContentTypeNewPassword;
    } else {
        // Fallback on earlier versions
    }
    
    if (self.Type == 0) {
        UIButton *ForgetBtn = [[UIButton alloc] init];
        [self.view addSubview:ForgetBtn];
        [ForgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(LENGTH_SIZE(-18));
            make.top.equalTo(repasswordBgView.mas_bottom).offset(LENGTH_SIZE(18));
        }];
        [ForgetBtn setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        [ForgetBtn setTitle:@"忘记旧密码？" forState:UIControlStateNormal];
        ForgetBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14)];
        [ForgetBtn addTarget:self action:@selector(touchForgetButton) forControlEvents:UIControlEventTouchUpInside];
    }


    
    UIButton *loginButton = [[UIButton alloc]init];
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(18));
        make.right.mas_equalTo(LENGTH_SIZE(-18));
        make.top.equalTo(repasswordBgView.mas_bottom).offset(LENGTH_SIZE(76));
        make.height.mas_equalTo(LENGTH_SIZE(48));
    }];
    [loginButton setTitle:@"确定" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(17)];
    loginButton.backgroundColor = [UIColor baseColor];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = LENGTH_SIZE(6);
    [loginButton addTarget:self action:@selector(touchLoginButton) forControlEvents:UIControlEventTouchUpInside];

}
#pragma mark - target
-(void)touchShowPasswordButton:(UIButton *)button{
    button.selected = !button.isSelected;
    self.passwordTextField.secureTextEntry = !button.isSelected;
}
-(void)touchShowrePasswordButton:(UIButton *)button{
    button.selected = !button.isSelected;
    self.repasswordTextField.secureTextEntry = !button.isSelected;
}

-(void)touchGetVerificationCodeButtonButton:(UIButton *)button{
    NSLog(@"获取验证码");
    self.phoneTextField.text = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (self.phoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.phoneTextField.text]) {
        [self.view showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self requestSendCode];
}

-(void)openCountdown{
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.getVerificationCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.getVerificationCodeButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
                self.getVerificationCodeButton.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.getVerificationCodeButton setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.getVerificationCodeButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
                self.getVerificationCodeButton.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.passwordTextField || textField == self.repasswordTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (textField.text.length >= 16) {
            textField.text = [textField.text substringToIndex:16];
            return NO;
        }
    }
    if (textField == self.phoneTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.phoneTextField.text.length >= 11 && self.Type == 1) {
            self.phoneTextField.text = [textField.text substringToIndex:11];
            return NO;
        } else if (self.phoneTextField.text.length >= 16 && self.Type == 0) {
            self.phoneTextField.text = [textField.text substringToIndex:16];
            return NO;
        }
    }
    
    if (textField == self.verificationCodeTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.verificationCodeTextField.text.length >= 6 && self.Type == 1) {
            self.verificationCodeTextField.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    
    return YES;
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.phoneTextField]) {
        self.phoneLineView.backgroundColor = [UIColor baseColor];
        self.passwordLineView.backgroundColor = [UIColor lightGrayColor];
        self.repasswordLineView.backgroundColor = [UIColor lightGrayColor];

    }else if ([textField isEqual:self.passwordTextField]) {
        self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
        self.passwordLineView.backgroundColor = [UIColor baseColor];
        self.repasswordLineView.backgroundColor = [UIColor lightGrayColor];
    }else {
        self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
        self.passwordLineView.backgroundColor = [UIColor lightGrayColor];
        self.repasswordLineView.backgroundColor = [UIColor baseColor];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
    self.passwordLineView.backgroundColor = [UIColor lightGrayColor];
    self.repasswordLineView.backgroundColor = [UIColor lightGrayColor];

}

#pragma mark - request
-(void)touchLoginButton{
    

    if (self.Type == 1) {
        self.phoneTextField.text = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.verificationCodeTextField.text = [self.verificationCodeTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

        if (self.phoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.phoneTextField.text]) {
            [self.view showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
            return;
        }
        
        if (self.token.length == 0) {
            [self.view showLoadingMeg:@"请获取验证码" time:MESSAGE_SHOW_TIME];
            return;
        }
        
        if (self.verificationCodeTextField.text.length <= 0) {
            [self.view showLoadingMeg:@"请输入验证码" time:MESSAGE_SHOW_TIME];
            return;
        }
        
        if (self.passwordTextField.text.length < 6) {
            [self.view showLoadingMeg:@"请输入6-16位新密码" time:MESSAGE_SHOW_TIME];
            return;
        }
        if (self.repasswordTextField.text.length < 6) {
            [self.view showLoadingMeg:@"请再次输6-16位新密码" time:MESSAGE_SHOW_TIME];
            return;
        }
        if (![self.passwordTextField.text isEqualToString:self.repasswordTextField.text]) {
            [self.view showLoadingMeg:@"两次输入的密码不一致" time:MESSAGE_SHOW_TIME];
            return;
        }
        

        
        
        if (![self.phoneTextField.text isEqualToString:self.phone]) {
            [self.view showLoadingMeg:@"手机号错误" time:MESSAGE_SHOW_TIME];
            return;
        }
        
        [self requestMateCode];
    }else{
        if (self.phoneTextField.text.length < 6) {
            [self.view showLoadingMeg:@"请输入正确的旧密码" time:MESSAGE_SHOW_TIME];
            return;
        }
        if (self.passwordTextField.text.length < 6) {
            [self.view showLoadingMeg:@"请输入6-16位新密码" time:MESSAGE_SHOW_TIME];
            return;
        }
        if (self.repasswordTextField.text.length < 6) {
            [self.view showLoadingMeg:@"请再次输6-16位新密码" time:MESSAGE_SHOW_TIME];
            return;
        }
        if (![self.passwordTextField.text isEqualToString:self.repasswordTextField.text]) {
            [self.view showLoadingMeg:@"两次输入的密码不一致" time:MESSAGE_SHOW_TIME];
            return;
        }
        [self requestModifyPswWithParam];
    }
}

-(void)touchForgetButton{
    LPChangePasswordVC *vc = [[LPChangePasswordVC alloc] init];
    vc.Type = 1;
    vc.UserPhone = kAppDelegate.userMaterialModel.data.userTel;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)requestModifyPswWithParam{
    NSString *phonemd5 = [self.phoneTextField.text md5];
    NSString *newphonemd5 = [[NSString stringWithFormat:@"%@lanpin123.com",phonemd5] md5];
    
    NSString *passwordmd5 = [self.passwordTextField.text md5];
    NSString *newPasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
    
    NSDictionary *dic = @{
                          @"newPsw":newPasswordmd5,
                          @"password":newphonemd5
                          };
    
    [NetApiManager requestModifyPswWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"密码修改成功" time:MESSAGE_SHOW_TIME];
                [LPTools UserDefaulatsRemove];
                [self requestSignout];
                [self.navigationController popToRootViewControllerAnimated:NO];
                
                kUserDefaultsSave(kUserDefaultsValue(LOGINID), OLDLOGINID);
                kUserDefaultsRemove(LOGINID);
                kUserDefaultsRemove(kLoginStatus);
                [kAppDelegate showLogin];
                
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : @"修改失败" time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestSetPswWithParam{
    
    
    NSString *passwordmd5 = [self.passwordTextField.text md5];
    NSString *newPasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
    
    NSDictionary *dic = @{
                          @"phone":self.phoneTextField.text,
                          @"password":newPasswordmd5
                          };
    
    [NetApiManager requestSetPswWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"密码修改成功" time:MESSAGE_SHOW_TIME];
                [LPTools UserDefaulatsRemove];
                [self requestSignout];
                [self.navigationController popToRootViewControllerAnimated:NO];
                
                kUserDefaultsSave(kUserDefaultsValue(LOGINID), OLDLOGINID);
                kUserDefaultsRemove(LOGINID);
                kUserDefaultsRemove(kLoginStatus);
                [kAppDelegate showLogin];
                
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : @"修改失败" time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



-(void)requestSignout{
    [NetApiManager requestSignoutWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
 
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestMateCode{
    NSDictionary *dic = @{
                          @"i":@(1),
                          @"phone":self.phoneTextField.text,
                          @"code":self.verificationCodeTextField.text,
                          @"token":self.token
                          };
    [NetApiManager requestMateCodeWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                [self requestSetPswWithParam];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestSendCode{
    NSDictionary *dic = @{
                          @"i":@(1),
                          @"phone":self.phoneTextField.text
                          };
    [NetApiManager requestSendCodeWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (responseObject[@"data"]) {
                    self.token = responseObject[@"data"];
                    self.phone = self.phoneTextField.text;
                }
                [self.view showLoadingMeg:@"验证码发送成功" time:MESSAGE_SHOW_TIME];
                [self openCountdown];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
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
