//
//  LWWXLoginVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/10.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWWXLoginVC.h"
#import "LPRegisteredContentVC.h"

@interface LWWXLoginVC ()
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *CodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField1;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField2;
@property (weak, nonatomic) IBOutlet UILabel *userAgreementLabel;

@property(nonatomic,strong) NSString *token;
@property(nonatomic,strong) NSString *phone;

@end

@implementation LWWXLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"绑定手机号";
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"点击确定即表示同意《用户注册协议》"];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor baseColor] range:[@"点击确定即表示同意《用户注册协议》" rangeOfString:@"《用户注册协议》"]];
    self.userAgreementLabel.attributedText = string;
    
    [self.userAgreementLabel yb_addAttributeTapActionWithStrings:@[@"《用户注册协议》"] tapClicked:^(UILabel *label,NSString *string, NSRange range, NSInteger index) {
        NSLog(@"%@",string);
        LPRegisteredContentVC *vc = [[LPRegisteredContentVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}

- (IBAction)TouchLogin:(UIButton *)sender {
    self.phoneTextField.text = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.CodeTextField.text = [self.CodeTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (self.phoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.phoneTextField.text]) {
        [self.view showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.token.length == 0) {
        [self.view showLoadingMeg:@"请获取验证码" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.CodeTextField.text.length <= 0) {
        [self.view showLoadingMeg:@"请输入验证码" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.passwordTextField1.text.length < 6) {
        [self.view showLoadingMeg:@"请输入6-16位密码" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.passwordTextField2.text.length < 6) {
        [self.view showLoadingMeg:@"请再次输入6-16位密码" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (![self.passwordTextField1.text isEqualToString:self.passwordTextField2.text]) {
        [self.view showLoadingMeg:@"密码输入不一致,请重新输入" time:MESSAGE_SHOW_TIME];
        return;
    }
    
 
    
    if (![self.phoneTextField.text isEqualToString:self.phone]) {
        [self.view showLoadingMeg:@"手机号错误" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    
    [self requestMateCode];
}

//获取验证码
- (IBAction)touchGetVerificationCodeButtonButton:(UIButton *)sender {
    
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

- (IBAction)fieldTextDidChange:(UITextField *)textField
{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 6;
    if (textField == self.phoneTextField ) {
        kMaxLength = 11;
    }else if (textField == self.passwordTextField1||
              textField == self.passwordTextField2){
        kMaxLength = 16;
    }else if (textField == self.CodeTextField){
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
    NSString *passwordmd5 = [self.passwordTextField1.text md5];
    NSString *newPasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
    NSDictionary *dic = @{@"wxOpenId":[LPTools isNullToString:self.userModel.openid],
                          @"sgin":[LPTools isNullToString:self.userModel.unionid],
                          @"phone":self.phoneTextField.text,
                          @"password":newPasswordmd5,
                          @"userUrl":[LPTools isNullToString:self.userModel.headimgurl],
                          @"userName":@"0fc23ce3bc0e1ee5e5e"
                          };
    [NetApiManager requestQueryWXSetPhone:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0) {
                    kUserDefaultsSave(responseObject[@"data"], LOGINID);
                    if ([kUserDefaultsValue(LOGINID) integerValue]  != [kUserDefaultsValue(OLDLOGINID) integerValue]) {
                        kUserDefaultsRemove(ERRORTIMES);
                    }
                    
                    kUserDefaultsSave(@"1", kLoginStatus);
                    [kAppDelegate showTabVc:1];
                }else{
                    [self.view showLoadingMeg:@"注册失败" time:MESSAGE_SHOW_TIME];
                }
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
                          @"i":@(6),
                          @"phone":self.phoneTextField.text,
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
-(void)requestMateCode{
    NSDictionary *dic = @{
                          @"i":@(6),
                          @"phone":self.phoneTextField.text,
                          @"code":self.CodeTextField.text,
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
