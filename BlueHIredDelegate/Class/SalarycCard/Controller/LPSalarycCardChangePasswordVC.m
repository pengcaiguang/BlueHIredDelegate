//
//  LPSalarycCardChangePasswordVC.m
//  BlueHired
//
//  Created by peng on 2018/9/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPSalarycCardChangePasswordVC.h"
#import "LPSalarycCardBindPhoneVC.h"


@interface LPSalarycCardChangePasswordVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UITextField *PassTF;
@property (weak, nonatomic) IBOutlet UITextField *SurePassTF;
@property(nonatomic,strong) NSString *oldPass;
@property (weak, nonatomic) IBOutlet UIView *oldPassView;

@property(nonatomic,assign) NSInteger errorTimes;

@property(nonatomic,strong) NSString *passNew;


@end

@implementation LPSalarycCardChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改提现密码";
    self.errorTimes = 0;
    self.completeButton.layer.cornerRadius = 6;
    
    if (self.Type == 1) {
        self.oldPassView.hidden = YES;
    }else{
        self.oldPassView.hidden = NO;
//        [self TouchOldPass:nil];
    }
    [self.PassTF addTarget:self action:@selector(fieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.SurePassTF addTarget:self action:@selector(fieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}


- (void)fieldTextDidChange:(UITextField *)textField
{
    static int kMaxLength = 6;

    
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
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



- (IBAction)TouchOldPass:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *string = [dateFormatter stringFromDate:[NSDate date]];
    
    if (kUserDefaultsValue(ERRORTIMES)) {
        NSString *errorString = kUserDefaultsValue(ERRORTIMES);
        if(errorString.length<17){
            kUserDefaultsRemove(ERRORTIMES);
        }else{
            NSString *d = [errorString substringToIndex:16];
            NSString *t = [errorString substringFromIndex:17];
            NSString *str = [LPTools dateTimeDifferenceWithStartTime:d endTime:string];
            self.errorTimes = [t integerValue];
            if ([t integerValue] >= 3 && [str integerValue] < 10) {
                GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"提现密码错误次数过多，请10分钟后再试" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                }];
                [alert show];
                return;
            }else{
                kUserDefaultsRemove(ERRORTIMES);
            }
        }
        
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"请先输入当前提现密码，完成身份验证"];
    GJAlertWithDrawPassword *alert = [[GJAlertWithDrawPassword alloc] initWithTitle:str
                                                                            message:@""
                                                                       buttonTitles:@[]
                                                                       buttonsColor:@[[UIColor baseColor]]
                                                                        buttonClick:^(NSInteger buttonIndex, NSString *string) {
                                                                            if (string.length==6) {
                                                                                
                                                                                [self requestUpdateDrawpwd:string];
                                                                            }else{
                                                                                LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
                                                                                                                                                                vc.Phone = self.phone;
                                                                                [self.navigationController pushViewController:vc animated:YES];
                                                                            }
                                                                            
                                                                        }];
    [alert show];
    
    
}

- (IBAction)textFieldChanged:(UITextField *)textField {
    if (textField.text.length > 6) {
        return;
    }
}

- (IBAction)touchCompleteButton:(id)sender {
 
    if (self.PassTF.text.length < 6) {
        [self.view showLoadingMeg:@"请输入6位提现密码" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.SurePassTF.text.length < 6) {
        [self.view showLoadingMeg:@"请再次输入6位提现密码" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (![self.PassTF.text isEqualToString:self.SurePassTF.text])
    {
        [self.view showLoadingMeg:@"两次密码输入不一致，从重新输入" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    [self requestUpdateNewDrawpwd];
}

#pragma mark - request
-(void)requestUpdateDrawpwd:(NSString *) Password{
    
    NSString *passwordmd5 = [Password md5];
    NSString *newpasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
    
    NSDictionary *dic = @{
                          @"type":@(1),
                          @"oldPwd":newpasswordmd5,
                          };
    [NetApiManager requestUpdateDrawpwdWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"code"]) {
                if ([responseObject[@"code"] integerValue] == 0 && [responseObject[@"data"] integerValue] == 1) {
                    self.oldPassView.hidden = YES;
                }else{
                    //                    [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
                    NSString *string = [dateFormatter stringFromDate:[NSDate date]];
                    
                    if (kUserDefaultsValue(ERRORTIMES)) {
                        NSString *errorString = kUserDefaultsValue(ERRORTIMES);
                        NSString *d = [errorString substringToIndex:16];
                        //                        if ([d isEqualToString:string]) {
                        NSString *t = [errorString substringFromIndex:17];
                        NSString *str = [LPTools dateTimeDifferenceWithStartTime:d endTime:string];
                        self.errorTimes = [t integerValue];
                        if ([t integerValue] >= 3&& [str integerValue] < 10) {
                            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"提现密码错误次数过多，请10分钟后再试"
                                                                                 message:nil
                                                                           textAlignment:NSTextAlignmentCenter
                                                                            buttonTitles:@[@"确定"]
                                                                            buttonsColor:@[[UIColor baseColor]]
                                                                 buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                                             buttonClick:^(NSInteger buttonIndex) {
                                                                             }];
                            [alert show];
                        }else{
                            NSString *s = [NSString stringWithFormat:@"密码错误，剩余%ld次机会",2-self.errorTimes];
                            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:s
                                                                                 message:nil
                                                                           textAlignment:NSTextAlignmentCenter
                                                                            buttonTitles:@[@"取消",@"重试"]
                                                                            buttonsColor:@[[UIColor lightGrayColor],[UIColor baseColor]]
                                                                 buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]]
                                                                             buttonClick:^(NSInteger buttonIndex) {
                                                                                 
                                                                                 if (buttonIndex == 1) {
                                                                                     [self TouchOldPass:nil];
                                                                                 }
                                                                             }];
                            [alert show];
                            self.errorTimes += 1;
                            NSString *str = [NSString stringWithFormat:@"%@-%ld",string,self.errorTimes];
                            kUserDefaultsSave(str, ERRORTIMES);
                        }
                        
                    }else{
                        if (self.errorTimes >2) {
                            self.errorTimes = 0;
                        }
                        NSString *s = [NSString stringWithFormat:@"密码错误，剩余%ld次机会",2-self.errorTimes];
                        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:s
                                                                             message:nil
                                                                       textAlignment:NSTextAlignmentCenter
                                                                        buttonTitles:@[@"取消",@"重试"]
                                                                        buttonsColor:@[[UIColor lightGrayColor],[UIColor baseColor]]
                                                             buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]]
                                                                         buttonClick:^(NSInteger buttonIndex) {
                                                                             if (buttonIndex == 1) {
                                                                                 [self TouchOldPass:nil];
                                                                             }
                                                                         }];
                        [alert show];
                        self.errorTimes += 1;
                        NSString *str = [NSString stringWithFormat:@"%@-%ld",string,self.errorTimes];
                        kUserDefaultsSave(str, ERRORTIMES);
                    }
                    //                    kUserDefaultsRemove(ERRORTIMES);
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestUpdateNewDrawpwd{        //验证新密码
    
    NSString *passwordmd5 = [self.PassTF.text md5];
    NSString *newpasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
    
    NSDictionary *dic = @{
                          @"type":@(2),
                          @"oldPwd":self.oldPass?self.oldPass:@"",
                          @"withdrawPwd":newpasswordmd5,
                          };
    [NetApiManager requestUpdateDrawpwdWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"code"]) {
                if ([responseObject[@"code"] integerValue] == 0 && [responseObject[@"data"] integerValue] == 1) {
                    
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"修改成功" time:MESSAGE_SHOW_TIME];
                    [self.navigationController popToRootViewControllerAnimated:YES];
 
                }else{
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
                    NSString *string = [dateFormatter stringFromDate:[NSDate date]];
                    
                    if (kUserDefaultsValue(ERRORTIMES)) {
                        NSString *errorString = kUserDefaultsValue(ERRORTIMES);
                        NSString *d = [errorString substringToIndex:16];
                        NSString *str = [LPTools dateTimeDifferenceWithStartTime:d endTime:string];
                        NSString *t = [errorString substringFromIndex:17];
                        self.errorTimes = [t integerValue];
                        if ([t integerValue] >= 3&& [str integerValue] < 10) {
                            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"提现密码错误次数过多，请10分钟后再试" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
                            [alert show];
                        }else{
                            [self.view showLoadingMeg:[NSString stringWithFormat:@"密码错误，剩余%ld次机会",2-self.errorTimes] time:MESSAGE_SHOW_TIME];
                            self.errorTimes += 1;
                            NSString *str = [NSString stringWithFormat:@"%@-%ld",string,self.errorTimes];
                            kUserDefaultsSave(str, ERRORTIMES);
                        }
                    }else{
                        [self.view showLoadingMeg:[NSString stringWithFormat:@"密码错误，剩余%ld次机会",2-self.errorTimes] time:MESSAGE_SHOW_TIME];
                        self.errorTimes += 1;
                        NSString *str = [NSString stringWithFormat:@"%@-%ld",string,self.errorTimes];
                        kUserDefaultsSave(str, ERRORTIMES);
                    }
                    //                    kUserDefaultsRemove(ERRORTIMES);
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
