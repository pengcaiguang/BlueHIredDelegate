//
//  LWLoginRegisterVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/9.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWLoginRegisterVC.h"
#import "LWWXLoginVC.h"
#import "LPTabBarViewController.h"
#import "LPChangePasswordVC.h"
#import "LPRegisteredContentVC.h"

static NSString *WXAPPID = @"wx5d359cb71d81828c";
static NSString *PHONEUSERSAVE = @"PHONEUSERSAVE";
static NSString *PASSWORDUSERSAVE = @"PASSWORDUSERSAVE";
@interface LWLoginRegisterVC ()
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *RegisterBtn;

@property (weak, nonatomic) IBOutlet UIView *LoginView;
@property (weak, nonatomic) IBOutlet UIView *RegisterView;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *LphoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *LpasswordTextField;

@property (weak, nonatomic) IBOutlet UITextField *RphoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *RCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *RpasswordTextField1;
@property (weak, nonatomic) IBOutlet UITextField *RpasswordTextField2;

@property (weak, nonatomic) IBOutlet UILabel *userAgreementLabel;


@property (nonatomic,strong) dispatch_source_t DisTime;
@property(nonatomic,strong) NSString *token;
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,assign) BOOL keepPassword;

@end

@implementation LWLoginRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    kAppDelegate.WXdelegate = self;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = NO;
}

-(void)initView{
    [self.LoginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F2F2F2"]]
                             forState:UIControlStateNormal];
    [self.LoginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
                             forState:UIControlStateSelected];
    
    [LPTools setViewShapeLayer:self.LoginBtn CornerRadii:18.0 byRoundingCorners:UIRectCornerTopLeft ];

 
    [self.RegisterBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F2F2F2"]]
                                forState:UIControlStateNormal];
    [self.RegisterBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
                                forState:UIControlStateSelected];
    [LPTools setViewShapeLayer:self.RegisterBtn CornerRadii:18.0 byRoundingCorners:UIRectCornerTopRight ];

    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"点击注册即表示同意《用户注册协议》"];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor baseColor] range:[@"点击注册即表示同意《用户注册协议》" rangeOfString:@"《用户注册协议》"]];
    self.userAgreementLabel.attributedText = string;
    
    [self.userAgreementLabel yb_addAttributeTapActionWithStrings:@[@"《用户注册协议》"] tapClicked:^(UILabel *label,NSString *string, NSRange range, NSInteger index) {
        LPRegisteredContentVC *vc = [[LPRegisteredContentVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UIButton *keepPassWord = [[UIButton alloc]init];
    [self.LoginView addSubview:keepPassWord];
    
    [keepPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(27));
        make.top.equalTo(self.LpasswordTextField.mas_bottom).offset(LENGTH_SIZE(18));
        make.height.mas_offset(30);
    }];
    [keepPassWord setTitle:@"  记住密码" forState:UIControlStateNormal];
    [keepPassWord setImage:[UIImage imageNamed:@"Login_nor"] forState:UIControlStateNormal];
    [keepPassWord setImage:[UIImage imageNamed:@"Login_sel"] forState:UIControlStateSelected];
    keepPassWord.titleLabel.font = [UIFont systemFontOfSize:FontSize(15)];
    [keepPassWord setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [keepPassWord setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];

    [keepPassWord addTarget:self action:@selector(touchKeepPassWord:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *phone = kUserDefaultsValue(PHONEUSERSAVE);
    if (!kStringIsEmpty(phone)) {
        self.LphoneTextField.text = phone;
    }
    NSString *password = kUserDefaultsValue(PASSWORDUSERSAVE);
    if (!kStringIsEmpty(password)) {
        self.LpasswordTextField.text = password;
        keepPassWord.selected = YES;
        self.keepPassword = YES;
    }
    
    
}

-(void)touchKeepPassWord:(UIButton *)button{
    NSLog(@"记住密码");
    button.selected = !button.isSelected;
    self.keepPassword = button.isSelected;
}

- (IBAction)ForgetPasswordBtn:(UIButton *)sender {
    LPChangePasswordVC *vc = [[LPChangePasswordVC alloc] init];
    vc.Type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)TouchSwitchBtn:(UIButton *)sender {
    if (sender.selected == NO) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        if (sender == self.LoginBtn) {
            self.LoginBtn.selected = YES;
            self.RegisterBtn.selected = NO;
            self.LoginView.hidden = NO;
            self.RegisterView.hidden = YES;
        }else{
            self.LoginBtn.selected = NO;
            self.RegisterBtn.selected = YES;
            self.LoginView.hidden = YES;
            self.RegisterView.hidden = NO;
       
        }
    }
}
//登入
- (IBAction)TouchLogin:(UIButton *)sender {
    self.LphoneTextField.text = [self.LphoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.LphoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.LphoneTextField.text]) {
        [self.view showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.LpasswordTextField.text.length < 6) {
        [self.view showLoadingMeg:@"请输入6-16位密码" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    NSString *passwordmd5 = [self.LpasswordTextField.text md5];
    NSString *newPasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
    
    NSDictionary *dic = @{
                          @"type":@(1),
                          @"phone":self.LphoneTextField.text,
                          @"password":newPasswordmd5
                          };
    
    [NetApiManager requestQueryGetLogin:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] isEqualToString:@"null"]) {
                    [self.view showLoadingMeg:@"用户不存在" time:MESSAGE_SHOW_TIME];
                }else if ([responseObject[@"data"] isEqualToString:@"error"]) {
                    [self.view showLoadingMeg:@"密码错误" time:MESSAGE_SHOW_TIME];
                }else{
                    kUserDefaultsSave(responseObject[@"data"], LOGINID);
                    if ([kUserDefaultsValue(LOGINID) integerValue]  != [kUserDefaultsValue(OLDLOGINID) integerValue]) {
                        kUserDefaultsRemove(ERRORTIMES);
                    }
 
                    kUserDefaultsSave(@"1", kLoginStatus);
                    [kAppDelegate showTabVc:1];
                    
                    if (self.keepPassword) {
                        kUserDefaultsSave(self.LpasswordTextField.text, PASSWORDUSERSAVE);
                    }else{
                        kUserDefaultsSave(@"", PASSWORDUSERSAVE);
                    }
                    kUserDefaultsSave(self.LphoneTextField.text, PHONEUSERSAVE);

                    
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
    
}
//注册
- (IBAction)TouchRegister:(UIButton *)sender {
    self.RphoneTextField.text = [self.RphoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.RCodeTextField.text = [self.RCodeTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (self.RphoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.RphoneTextField.text]) {
        [self.view showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.token.length == 0) {
        [self.view showLoadingMeg:@"请获取验证码" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.RCodeTextField.text.length <= 0) {
        [self.view showLoadingMeg:@"请输入验证码" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.RpasswordTextField1.text.length < 6) {
        [self.view showLoadingMeg:@"请输入6-16位密码" time:MESSAGE_SHOW_TIME];
        return;
    }
 
    if (self.RpasswordTextField2.text.length < 6) {
        [self.view showLoadingMeg:@"请再次输入6-16位密码" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (![self.RpasswordTextField2.text isEqualToString:self.RpasswordTextField1.text]) {
        [self.view showLoadingMeg:@"密码输入不一致,请重新输入" time:MESSAGE_SHOW_TIME];
        return;
    }

    if (![self.RphoneTextField.text isEqualToString:self.phone]) {
        [self.view showLoadingMeg:@"手机号错误" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    
    [self requestMateCode];
}


- (IBAction)TouchWXLogin:(id)sender {
    if ([WXApi isWXAppInstalled]==NO) {
        //        [self.view showLoadingMeg:@"请安装微信" time:MESSAGE_SHOW_TIME];
        SendAuthReq* req =[[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"123x";
        [WXApi sendAuthReq:req viewController:self delegate:[WXApiManager sharedManager]];
        return;
    }
    [WXApiRequestHandler sendAuthRequestScope:@"snsapi_userinfo"
                                        State:@"123x"
                                       OpenID:WXAPPID
                             InViewController:self];
 
}


#pragma mark - LPWxLoginHBBack
- (void)LPWxLoginHBBack:(LPWXUserInfoModel *)wxUserInfo{
    NSDictionary *dic = @{@"openid":wxUserInfo.unionid};
    [NetApiManager requestQueryWXUserStatus:dic  withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 0) {
                    LWWXLoginVC *vc = [[LWWXLoginVC alloc] init];
                    vc.userModel = wxUserInfo;
                    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:NO];
                }else{
                    [[UIWindow visibleViewController].view showLoadingMeg:@"登录成功" time:MESSAGE_SHOW_TIME];
                    kUserDefaultsSave(responseObject[@"data"], LOGINID);
                    if ([kUserDefaultsValue(LOGINID) integerValue]  != [kUserDefaultsValue(OLDLOGINID) integerValue]) {
                        kUserDefaultsRemove(ERRORTIMES);
                    }
                    kUserDefaultsSave(@"1", kLoginStatus);
                    [kAppDelegate showTabVc:1];
                    
                 }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

//获取验证码
- (IBAction)touchGetVerificationCodeButtonButton:(UIButton *)sender {
 
    self.RphoneTextField.text = [self.RphoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (self.RphoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.RphoneTextField.text]) {
        [self.view showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    [self requestSendCode];

}

-(void)openCountdown{
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    self.DisTime = _timer;
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



- (IBAction)fieldTextDidChange:(UITextField *)textField
{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 6;
    if (textField == self.LphoneTextField ||
        textField == self.RphoneTextField) {
        kMaxLength = 11;
    }else if (textField == self.LpasswordTextField ||
              textField == self.RpasswordTextField1||
              textField == self.RpasswordTextField2){
        kMaxLength = 16;
    }else if (textField == self.RCodeTextField){
        kMaxLength = 6;
    }
    
    
    NSString *toBeString = textField.text;
    // 获取键盘输入模式
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
    // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮选择部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                // 截取子串
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        } else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            // 截取子串
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}


#pragma mark - request

-(void)requestAddUser{
    NSString *passwordmd5 = [self.RpasswordTextField1.text md5];
    NSString *newPasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
    NSDictionary *dic = @{
                          @"type":@(1),
                          @"phone":self.RphoneTextField.text,
                          @"password":newPasswordmd5
                          };
    [NetApiManager requestAddUserWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                [self.view showLoadingMeg:@"注册成功" time:MESSAGE_SHOW_TIME];
                
                self.RphoneTextField.text= @"";
                self.RCodeTextField.text= @"";
                self.RpasswordTextField1.text= @"";
                self.RpasswordTextField2.text= @"";
                
              
                dispatch_source_cancel(self.DisTime);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //设置按钮的样式
                    [self.getVerificationCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                    [self.getVerificationCodeButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
                    self.getVerificationCodeButton.userInteractionEnabled = YES;
                });
                [self TouchSwitchBtn:self.LoginBtn];
                
//                kUserDefaultsSave(responseObject[@"data"], LOGINID);
//                if ([kUserDefaultsValue(LOGINID) integerValue]  != [kUserDefaultsValue(OLDLOGINID) integerValue]) {
//                    kUserDefaultsRemove(ERRORTIMES);
//                }
//
//                kUserDefaultsSave(@"1", kLoginStatus);
//                [kAppDelegate showTabVc:1];
            
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : @"注册失败" time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestSendCode{
    NSDictionary *dic = @{
                          @"i":@(0),
                          @"phone":self.RphoneTextField.text,
                          };
    [NetApiManager requestSendCodeWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (responseObject[@"data"]) {
                    self.token = responseObject[@"data"];
                    self.phone = self.RphoneTextField.text;
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

-(void)requestMateCode{
    NSDictionary *dic = @{
                          @"i":@(0),
                          @"phone":self.RphoneTextField.text,
                          @"code":self.RCodeTextField.text,
                          @"token":self.token
                          };
    [NetApiManager requestMateCodeWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                [self requestAddUser];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
@end
