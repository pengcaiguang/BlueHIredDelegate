//
//  LWSalarycCardVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWSalarycCardVC.h"
#import "LPSalarycCardBindPhoneVC.h"
#import "AddressPickerView.h"
#import "LPDurationView.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>


static  NSString *RSAPublickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDvh1MAVToAiuEVOFq9mo3IOJxN5aekgto1kyOh07qQ+1Wc+Uxk1wX2t6+HCA31ojcgaR/dZz/kQ5aZvzlB8odYHJXRtIcOAVQe/FKx828XFTzC8gp1zGh7vTzBCW3Ieuq+WRiq9cSzEZlNw9RcU38st9q9iBT8PhK0AkXE2hLbKQIDAQAB";
static NSString *RSAPrivateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAO+HUwBVOgCK4RU4Wr2ajcg4nE3lp6SC2jWTI6HTupD7VZz5TGTXBfa3r4cIDfWiNyBpH91nP+RDlpm/OUHyh1gcldG0hw4BVB78UrHzbxcVPMLyCnXMaHu9PMEJbch66r5ZGKr1xLMRmU3D1FxTfyy32r2IFPw+ErQCRcTaEtspAgMBAAECgYBSczN39t5LV4LZChf6Ehxh4lKzYa0OLNit/mMSjk43H7y9lvbb80QjQ+FQys37UoZFSspkLOlKSpWpgLBV6gT5/f5TXnmmIiouXXvgx4YEzlXgm52RvocSCvxL81WCAp4qTrp+whPfIjQ4RhfAT6N3t8ptP9rLgr0CNNHJ5EfGgQJBAP2Qkq7RjTxSssjTLaQCjj7FqEYq1f5l+huq6HYGepKU+BqYYLksycrSngp0y/9ufz0koKPgv1/phX73BmFWyhECQQDx1D3Gui7ODsX02rH4WlcEE5gSoLq7g74U1swbx2JVI0ybHVRozFNJ8C5DKSJT3QddNHMtt02iVu0a2V/uM6eZAkEAhvmce16k9gV3khuH4hRSL+v7hU5sFz2lg3DYyWrteHXAFDgk1K2YxVSUODCwHsptBNkogdOzS5T9MPbB+LLAYQJBAKOAknwIaZjcGC9ipa16txaEgO8nSNl7S0sfp0So2+0gPq0peWaZrz5wa3bxGsqEyHPWAIHKS20VRJ5AlkGhHxECQQDr18OZQkk0LDBZugahV6ejb+JIZdqA2cEQPZFzhA3csXgqkwOdNmdp4sPR1RBuvlVjjOE7tCiFLup/8TvRJDdr";

@interface LWSalarycCardVC ()<UITextFieldDelegate,AddressPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *PlanImage;
@property (weak, nonatomic) IBOutlet UILabel *ScanTitle1;
@property (weak, nonatomic) IBOutlet UILabel *ScanTitle2;


@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *CardLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *RealLabel;
@property (weak, nonatomic) IBOutlet UILabel *RealNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *RealCardLabel;

@property (weak, nonatomic) IBOutlet UIImageView *NameTF_Arrows;

@property (weak, nonatomic) IBOutlet UITextField *NameTF;
@property (weak, nonatomic) IBOutlet UITextField *CardTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_PlanImage_High;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_CardView_High;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_TFView_High;

@property (weak, nonatomic) IBOutlet UIView *BarterView;
@property (weak, nonatomic) IBOutlet UIView *SucceedView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *ServerPhone;
@property (weak, nonatomic) IBOutlet UIButton *ScanningBtn;


@property (nonatomic ,strong) AddressPickerView * pickerView;
@property(nonatomic,strong) LPDurationView *durationView;
@property(nonatomic,strong) NSArray *TypeArray;

@property(nonatomic,assign) NSInteger errorTimes;
@property (nonatomic,assign) NSInteger IntStep;
@property (nonatomic,assign) NSInteger ClassType;

@property (nonatomic,assign) CardType CardType;


@end

@implementation LWSalarycCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"银行卡绑定";
    
    self.TypeArray = @[@"招商银行",@"兴业银行",@"中国建设银行"];
    [self.view addSubview:self.pickerView];

    [LPTools setViewShapeLayer:self.RealLabel
                   CornerRadii:4
             byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight];

    
    self.NameTF.delegate = self;
    self.CardTF.delegate = self;
    self.addressTF.delegate = self;
    [self.NameTF addTarget:self action:@selector(fieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.CardTF addTarget:self action:@selector(fieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self setinitModel];
}

-(void)setinitModel{
    
    if (self.model.data) {
//        NSString *identityNoString = [RSAEncryptor decryptString:self.model.data.identityNo privateKey:RSAPrivateKey];
        NSString *bankNumberString = [RSAEncryptor decryptString:self.model.data.bankNumber privateKey:RSAPrivateKey];
        if (bankNumberString.length!=0) {           //换绑
             self.ClassType = 2;
        }
        else        //绑定
        {
             self.ClassType = 1;
        }
    }else{      //绑定
         self.model.data = [[LPSelectBindbankcardDataModel alloc] init];
        self.ClassType = 0;
    }
 
 
    [self InitView:self.ClassType intStep:self.IntStep];
    
}


//更新UI
-(void)InitView:(NSInteger) Type intStep:(NSInteger) intStep{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    self.ServerPhone.hidden = YES;
    self.NameTF_Arrows.hidden = YES;
    
    if (Type == 0) {
        if (self.IntStep == 0) {
 
        }else if (self.IntStep == 1){
            self.PlanImage.image = [UIImage imageNamed:@"progress02"];
            self.ScanTitle1.text = @"扫描银行卡信息";
            self.ScanTitle2.text = @"无原件，可手动输入银行卡信息";
            self.LayoutConstraint_TFView_High.constant = LENGTH_SIZE(154);
            self.NameTF_Arrows.hidden = NO;

            self.NameLabel.text = @"银行名称";
            self.CardLabel.text = @"银行卡号";
            self.NameTF.placeholder = @"请选择银行名称";
            self.CardTF.placeholder = @"请输入正确的银行卡号码";
            self.NameTF.text = @"";
            self.CardTF.text = @"";
            self.NameTF.keyboardType = UIKeyboardTypeNumberPad;
            self.CardTF.keyboardType = UIKeyboardTypeNumberPad;
        }else if (self.IntStep == 2){
            self.PlanImage.image = [UIImage imageNamed:@"progress03"];
            self.LayoutConstraint_CardView_High.constant = LENGTH_SIZE(0);
            self.LayoutConstraint_TFView_High.constant = LENGTH_SIZE(106);
            
            self.NameLabel.text = @"提现密码";
            self.CardLabel.text = @"确认密码";
            self.NameTF.placeholder = @"请设置6位提现密码";
            self.CardTF.placeholder = @"请再次输入提现密码";
            self.NameTF.text = @"";
            self.CardTF.text = @"";
            

        }else if (self.IntStep == 3){
            self.PlanImage.image = [UIImage imageNamed:@"progress04"];
            self.SucceedView.hidden = NO;
        }
    }else if (Type == 1){
        if (self.IntStep == 0) {
            self.ServerPhone.hidden = NO;

            self.LayoutConstraint_CardView_High.constant = 0;
            self.NameLabel.superview.hidden = YES;
            self.LayoutConstraint_TFView_High.constant = LENGTH_SIZE(110);
            self.RealLabel.superview.hidden = NO;
            NSMutableAttributedString *RealNamestring = [[NSMutableAttributedString alloc]
                                                         initWithString: [NSString stringWithFormat:@"真实姓名：%@",self.model.data.userName]];
            [RealNamestring addAttributes:@{NSForegroundColorAttributeName:
                                                [UIColor colorWithHexString:@"#999999"]}
                                    range:NSMakeRange(0, 5)];
            self.RealNameLabel.attributedText = RealNamestring;
            
            
            NSMutableAttributedString *RealCardstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"身份证号：%@",[RSAEncryptor decryptString:self.model.data.identityNo privateKey:RSAPrivateKey]]];
            [RealCardstring addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#999999"]} range:NSMakeRange(0, 5)];
            self.RealCardLabel.attributedText = RealCardstring;
            
        }else if (self.IntStep == 1){
            self.LayoutConstraint_CardView_High.constant = LENGTH_SIZE(221);
            self.NameLabel.superview.hidden = NO;
            self.RealLabel.superview.hidden = YES;
            self.NameTF_Arrows.hidden = NO;

            self.PlanImage.image = [UIImage imageNamed:@"progress02"];
            self.ScanTitle1.text = @"扫描银行卡信息";
            self.ScanTitle2.text = @"无原件，可手动输入银行卡信息";
            self.LayoutConstraint_TFView_High.constant = LENGTH_SIZE(154);
            self.NameLabel.text = @"银行名称";
            self.CardLabel.text = @"银行卡号";
            self.NameTF.placeholder = @"请选择银行名称";
            self.CardTF.placeholder = @"请输入正确的银行卡号码";
            self.NameTF.text = @"";
            self.CardTF.text = @"";
            self.addressTF.text = @"";
            self.NameTF.keyboardType = UIKeyboardTypeNumberPad;
            self.CardTF.keyboardType = UIKeyboardTypeNumberPad;
        }else if (self.IntStep == 2){
            self.PlanImage.image = [UIImage imageNamed:@"progress03"];
            self.LayoutConstraint_CardView_High.constant = LENGTH_SIZE(0);
            self.LayoutConstraint_TFView_High.constant = LENGTH_SIZE(106);
            
            self.NameLabel.text = @"提现密码";
            self.CardLabel.text = @"确认密码";
            self.NameTF.placeholder = @"请设置6位提现密码";
            self.CardTF.placeholder = @"请再次输入提现密码";
            self.NameTF.text = @"";
            self.CardTF.text = @"";
        }else if (self.IntStep == 3){
            self.PlanImage.image = [UIImage imageNamed:@"progress04"];
            self.SucceedView.hidden = NO;
        }
    }else if (Type == 2){           //换绑
        if (self.IntStep == 0) {
//            [self TouchBarterBtn:nil];
            self.navigationItem.title = @"银行卡换绑";
            self.BarterView.hidden = NO;

        }else if (self.IntStep == 1){
            self.BarterView.hidden = YES;
            self.NameTF_Arrows.hidden = NO;
            
            self.LayoutConstraint_PlanImage_High.constant = 0;
            self.ScanTitle1.text = @"扫描银行卡信息";
            self.ScanTitle2.text = @"无原件，可手动输入银行卡信息";
            self.NameLabel.text = @"银行名称";
            self.CardLabel.text = @"银行卡号";
            self.NameTF.placeholder = @"请选择银行名称";
            self.CardTF.placeholder = @"请输入正确的银行卡号码";
            self.NameTF.text = self.model.data.bankName;
            self.CardTF.text = [RSAEncryptor decryptString:self.model.data.bankNumber privateKey:RSAPrivateKey];
            self.addressTF.text = self.model.data.openBankAddr;
            
            self.LayoutConstraint_TFView_High.constant = LENGTH_SIZE(154);
            [self.nextBtn setTitle:@"更  绑" forState:UIControlStateNormal];
            self.NameTF.keyboardType = UIKeyboardTypeNumberPad;
            self.CardTF.keyboardType = UIKeyboardTypeNumberPad;
        }else if (self.IntStep == 2){
            self.PlanImage.image = [UIImage imageNamed:@"progress04"];
            self.SucceedView.hidden = NO;
        }

    }
}


- (IBAction)TouchNextBtn:(id)sender {
    if (self.ClassType == 0) {
        if (self.IntStep == 0) {
            if (self.NameTF.text.length <= 0 ) {
                [self.view showLoadingMeg:@"请输入真实姓名" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (self.CardTF.text.length <= 0 || ![NSString isIdentityCard:self.CardTF.text]) {
                [self.view showLoadingMeg:@"请输入正确的身份证号" time:MESSAGE_SHOW_TIME];
                return;
            }
            self.model.data.identityNo =[RSAEncryptor encryptString:self.CardTF.text publicKey:RSAPublickKey];
            self.model.data.userName =[LPTools removeSpaceAndNewline: self.NameTF.text];
            [self requestCardNOoccupy];
            return;
        }else if (self.IntStep == 1){
            if (self.NameTF.text.length <= 0 ) {
                [self.view showLoadingMeg:@"请选择银行名称" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (self.CardTF.text.length <= 0 || ![NSString isBankCard:self.CardTF.text]) {
                [self.view showLoadingMeg:@"请输入正确的银行卡号" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (self.addressTF.text.length <= 0 ) {
                [self.view showLoadingMeg:@"请选择银行卡归属地" time:MESSAGE_SHOW_TIME];
                return;
            }
            self.model.data.bankNumber = [RSAEncryptor encryptString:self.CardTF.text publicKey:RSAPublickKey];
            self.model.data.openBankAddr = self.addressTF.text;
        }else if (self.IntStep == 2){
            if (self.NameTF.text.length < 6) {
                [self.view showLoadingMeg:@"请输入提现密码" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (self.CardTF.text.length < 6) {
                [self.view showLoadingMeg:@"请输入确认密码" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (![self.NameTF.text isEqualToString:self.CardTF.text]) {
                [self.view showLoadingMeg:@"两次密码不一致,请重新输入" time:MESSAGE_SHOW_TIME];
                return;
            }
            
            self.model.data.moneyPassword = [[NSString stringWithFormat:@"%@lanpin123.com",[self.NameTF.text md5]] md5];
            [self requestBindunbindBankcard];
            return;
        }
        
    }else if (self.ClassType == 1){
        if (self.IntStep == 0) {
            
        }else if (self.IntStep == 1){
            if (self.NameTF.text.length <= 0 ) {
                [self.view showLoadingMeg:@"请选择银行名称" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (self.CardTF.text.length <= 0 || ![NSString isBankCard:self.CardTF.text]) {
                [self.view showLoadingMeg:@"请输入正确的银行卡号" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (self.addressTF.text.length <= 0 ) {
                [self.view showLoadingMeg:@"请选择银行卡归属地" time:MESSAGE_SHOW_TIME];
                return;
            }
            self.model.data.bankNumber = [RSAEncryptor encryptString:self.CardTF.text publicKey:RSAPublickKey];
            self.model.data.openBankAddr = self.addressTF.text;
        }else if (self.IntStep == 2){
            if (self.NameTF.text.length < 6) {
                [self.view showLoadingMeg:@"请输入提现密码" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (self.CardTF.text.length < 6) {
                [self.view showLoadingMeg:@"请输入确认密码" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (![self.NameTF.text isEqualToString:self.CardTF.text]) {
                [self.view showLoadingMeg:@"两次密码不一致,请重新输入" time:MESSAGE_SHOW_TIME];
                return;
            }
            self.model.data.moneyPassword = [[NSString stringWithFormat:@"%@lanpin123.com",[self.NameTF.text md5]] md5];
            [self requestBindunbindBankcard];
            return;
        }
    }else if (self.ClassType == 2){
        if (self.CardTF.text.length <= 0 || ![NSString isBankCard:self.CardTF.text]) {
            [self.view showLoadingMeg:@"请输入正确的银行卡号" time:MESSAGE_SHOW_TIME];
            return;
        }
        if (self.addressTF.text.length <= 0 ) {
            [self.view showLoadingMeg:@"请选择银行卡归属地" time:MESSAGE_SHOW_TIME];
            return;
        }
        self.model.data.bankNumber = [RSAEncryptor encryptString:self.CardTF.text publicKey:RSAPublickKey];
        self.model.data.openBankAddr = self.addressTF.text;
        [self requestBindunbindBankcard];
        return;
    }
    self.IntStep++;
    [self InitView:self.ClassType intStep:self.IntStep];
}

- (void)fieldTextDidChange:(UITextField *)textField
{
    static int kMaxLength = 60;

    if (textField == self.NameTF) {
        if (self.IntStep == 0 || self.IntStep == 2) {
            kMaxLength = 6;
        }
    }
    if (textField == self.CardTF) {
        if (self.ClassType == 0 && self.IntStep == 0){
            kMaxLength = 18;
        }else if (self.IntStep == 1){
            kMaxLength = 19;
        }else if (self.IntStep == 2){
            kMaxLength = 6;
        }
    }
    
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

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //返回一个BOOL值，指定是否循序文本字段开始编辑
    if (textField == self.addressTF && self.IntStep == 1) {
//        if ((self.IntStep == 1 && self.self.ClassType == 0 )||
//            (self.IntStep == 1 && self.self.ClassType == 1 )||
//            (self.IntStep == 0 && self.self.ClassType == 2 )) {
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            [self.pickerView show];
            return NO;
//        }

    }
    if (textField == self.NameTF && self.IntStep == 1) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

//        if ((self.IntStep == 1 && self.self.ClassType == 0 )||
//            (self.IntStep == 1 && self.self.ClassType == 1 )||
//            (self.IntStep == 0 && self.self.ClassType == 2 )) {
            self.durationView.titleString = @"请选择银行名称";
            self.durationView.typeArray = self.TypeArray;
            WEAK_SELF()
            self.durationView.block = ^(NSInteger index) {
                weakSelf.NameTF.text = weakSelf.TypeArray[index];
                weakSelf.model.data.bankName = weakSelf.TypeArray[index];
            };
            self.durationView.hidden = NO;
            return NO;
//        }
       
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.CardTF && self.ClassType == 0 && self.IntStep == 0) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.NameTF.text.length >= 18) {
            self.NameTF.text = [textField.text substringToIndex:18];
            return NO;
        }
        return [self validateNumber:string];
    }
    return YES;
}
- (BOOL)validateNumber:(NSString*)number
{
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789X"];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}
- (IBAction)TouchToPhone:(UIButton *)sender {
    sender.enabled = NO;
    LPUserMaterialModel *userMaterialModel = [LPUserDefaults getObjectByFileName:USERINFO];
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",userMaterialModel.data.servicePhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}

//成功返回
- (IBAction)TouchSucceed:(id)sender {
    if (self.ClassType == 0 ||self.ClassType == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        if (self.block) {
            self.block();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//立即验证
- (IBAction)TouchBarterBtn:(id)sender {
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
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"换绑银行卡，请先输入提现密码，完成身份验证"];
    GJAlertWithDrawPassword *alert = [[GJAlertWithDrawPassword alloc] initWithTitle:str
                                                                            message:@""
                                                                       buttonTitles:@[]
                                                                       buttonsColor:@[[UIColor baseColor]]
                                                                        buttonClick:^(NSInteger buttonIndex, NSString *string) {
                                                                            if (string.length==6) {
                                                                                [self requestUpdateDrawpwd:string];
                                                                            }else{
                                                                                LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
                                                                                vc.Phone = self.model.data.phone;
                                                                                [self.navigationController pushViewController:vc animated:YES];
                                                                            }
                                                                            
                                                                        }];
    [alert show];
    
    
}



- (IBAction)bankCardOCROnline{
#if !TARGET_IPHONE_SIMULATOR
    if ((self.IntStep == 0 && self.ClassType == 0)) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请进入设置-隐私-相机-中打开相机权限"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                nil;
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alert addAction:action1];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            return;
        }
        
        self.CardType = CardTypeIdCardFont;
        UIViewController * vc =
        [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardFont
                                               Title:@""
                                     andImageHandler:^(UIImage *image) {
                                         [self requestQueryGetBiaduBankAccessToken:image];
                                         
                                         //                                         [[AipOcrService shardService] detectIdCardFrontFromImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
                                         
                                     }];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ((self.ClassType == 1 && self.IntStep == 1) ||
              (self.ClassType == 2 && self.IntStep == 0) ||
              (self.ClassType == 0 && self.IntStep == 1)) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请进入设置-隐私-相机-中打开相机权限"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                nil;
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alert addAction:action1];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            return;
        }
        
        self.CardType = CardTypeBankCard;
        UIViewController * vc =
        [AipCaptureCardVC ViewControllerWithCardType:CardTypeBankCard
                                               Title:@""
                                     andImageHandler:^(UIImage *image) {
                                         [self requestQueryGetBiaduBankAccessToken:image];
                                         
                                         //                                         [[AipOcrService shardService] detectBankCardFromImage:image  successHandler:_successHandler failHandler:_failHandler];
                                         
                                     }];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
#endif
    
}




#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick{
    NSLog(@"点击了取消按钮");
    [self.pickerView hide];
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    NSString *strCity = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];

    if ([province isEqualToString:strCity]) {
        NSString *CityStr = [NSString stringWithFormat:@"%@",city];
        self.addressTF.text = CityStr;
    }else{
        NSString *CityStr = [NSString stringWithFormat:@"%@%@",province,city];
        self.addressTF.text = CityStr;
    }
    
    [self.pickerView hide];
    
    //    [self btnClick:_addressBtn];
}

- (AddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc]init];
        _pickerView.delegate = self;
        [_pickerView setTitleHeight:30 pickerViewHeight:276];
        // 关闭默认支持打开上次的结果
        //        _pickerView.isAutoOpenLast = NO;
    }
    return _pickerView;
}
-(LPDurationView *)durationView{
    if (!_durationView) {
        _durationView = [[LPDurationView alloc]init];
    }
    return _durationView;
}


- (NSData *)jpgDataWithImage:(UIImage *)image sizeLimit:(NSUInteger)maxSize {
    CGFloat compressionQuality = 1.0;
    NSData *imageData = nil;
    
    int i = 0;
    do{
        imageData = UIImageJPEGRepresentation(image, compressionQuality);
        compressionQuality -= 0.1;
        i += 1;
    }while(i < 3 && imageData.length > maxSize);
    return imageData;
}

#pragma mark - AipOcr


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
                    self.IntStep++;
                    [self InitView:self.ClassType intStep:self.IntStep];
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
                                                                                     [self TouchBarterBtn:nil];
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
                                [self TouchBarterBtn:nil];
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

-(void)requestQueryGetBiaduBankAccessToken:(UIImage *) Image{
    WEAK_SELF()
    [NetApiManager requestQueryGetBiaduBankAccessToken:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (responseObject[@"data"]) {
                    [weakSelf requestQueryGetBiaduUserBankScan:Image Token:responseObject[@"data"]];
                }else{
                    [self.view showLoadingMeg:@"获取Token失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestQueryGetBiaduUserBankScan:(UIImage *) Image Token:(NSString *) token{
    
    
    NSString *virValue = [DataTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM-dd-HH-mm"];
    NSString *virValueData = [NSString stringWithFormat:@"%@-%@-lp",virValue,kUserDefaultsValue(LOGINID)];
    
    NSData *imageData = [self jpgDataWithImage:Image sizeLimit:512000];
    NSLog(@"imageData = %lu",(unsigned long)imageData.length);
    
    NSDictionary *dic = @{@"image":[imageData base64EncodedStringWithOptions:0],
                          @"id_card_side":@"front",
                          @"accessToken":[RSAEncryptor decryptString:token privateKey:RSAPrivateKey],
                          @"deviceType":@(1),
                          @"virValue":[RSAEncryptor encryptString:virValueData publicKey:RSAPublickKey]
                          };
    NSString * appendURLString = [NSString stringWithFormat:@"userbank/scan?type=%@",self.CardType == CardTypeIdCardFont?@"1":@"2"];
    
    WEAK_SELF()
    [NetApiManager requestQueryGetBiaduUserBankScan:dic  URLString:appendURLString withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            if ([responseObject[@"code"] integerValue] == 0) {
                if (responseObject[@"data"]) {
                    if (weakSelf.CardType == CardTypeIdCardFont) {      //身份证
                        
                        NSString *Identity = responseObject[@"data"][@"IdCard"][@"words"];
                        NSString *IdentityName = responseObject[@"data"][@"name"][@"words"];
                        
                        if (Identity.length || IdentityName.length ) {
                            weakSelf.model.data.identityNo =[RSAEncryptor encryptString:Identity publicKey:RSAPublickKey];
                            weakSelf.model.data.userName = IdentityName;
                            self.NameTF.text = IdentityName;
                            self.CardTF.text = Identity;
                        }else{
                            [weakSelf.view showLoadingMeg:@"扫描失败，请重新扫描！" time:MESSAGE_SHOW_TIME];
                        }
                    }else{
                        NSString *strBank = [responseObject[@"data"][@"result"][@"bank_card_number"] stringByReplacingOccurrencesOfString:@" " withString:@""];
                        NSLog(@"%@",strBank);
                        if (strBank.length) {
                            if ([responseObject[@"data"][@"result"][@"bank_card_type"] integerValue] == 1) {
                                
                                //判断银行卡
                                NSString *name =responseObject[@"data"][@"result"][@"bank_name"];
                                if ([name containsString:@"建设"]) {
                                    weakSelf.model.data.bankName = @"中国建设银行";
                                }else if ([name containsString:@"招商"]){
                                    weakSelf.model.data.bankName = @"招商银行";
                                }else if ([name containsString:@"兴业"]){
                                    weakSelf.model.data.bankName = @"兴业银行";
                                }else{
                                    GJAlertMessage *alert = [[GJAlertMessage alloc] initWithTitle:@"本平台工资卡绑定仅支持中国建设银行、招商银行或者兴业银行的银行卡，若没有此三种银行卡，请联系驻厂老师或者客服人员为您办理。"
                                                                                          message:nil
                                                                                    textAlignment:NSTextAlignmentCenter
                                                                                     buttonTitles:@[@"确定"]
                                                                                     buttonsColor:@[[UIColor baseColor]]
                                                                          buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                                                      buttonClick:^(NSInteger buttonIndex) {
                                                                                      }];
                                    [alert show];
                                    return ;
                                }
                                
                                weakSelf.model.data.bankNumber = [RSAEncryptor encryptString:strBank publicKey:RSAPublickKey];
                                self.NameTF.text = weakSelf.model.data.bankName;
                                self.CardTF.text = strBank;
                            }else{
                                [weakSelf.view showLoadingMeg:@"工资卡必须为借记卡！" time:MESSAGE_SHOW_TIME];
                            }
                        }else{
                            [weakSelf.view showLoadingMeg:@"扫描失败，请重新扫描！" time:MESSAGE_SHOW_TIME];
                        }
                    }
                }else{
                    [self.view showLoadingMeg:@"图像识别失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                if ([responseObject[@"code"] integerValue] == 10000 ||
                    [responseObject[@"code"] integerValue] == 20055 ||
                    [responseObject[@"code"] integerValue] == 10002 ||
                    [responseObject[@"code"] integerValue] == 10004 ) {
                    [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }else{
                    if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                        [self.view showLoadingMeg:responseObject[@"data"][@"error_msg"] time:MESSAGE_SHOW_TIME];
                    }else{
                        [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                    }
                }
            }
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestBindunbindBankcard{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    
    //    NSString *identityNoString = [RSAEncryptor encryptString:self.model.data.identityNo publicKey:RSAPublickKey];
    //    NSString *bankNumberString = [RSAEncryptor encryptString:self.model.data.bankNumber publicKey:RSAPublickKey];
    NSString *identityNoString = self.model.data.identityNo;
    NSString *bankNumberString = self.model.data.bankNumber;
//    NSString *passwordString = [[NSString stringWithFormat:@"%@lanpin123.com",[self.passwordTextField.text md5]] md5];
    
    NSDictionary *dic ;
    if (self.ClassType == 0 ) {
        dic =  @{
                 @"userName":self.model.data.userName,
                 @"identityNo":identityNoString,
                 @"bankNumber":bankNumberString,
                 @"openBankAddr":self.model.data.openBankAddr,
                 @"moneyPassword":[LPTools isNullToString:self.model.data.moneyPassword],
                 @"bankName":self.model.data.bankName,
                 @"type":@"1", //1绑定 2变更
                 };
    }
    else if (self.ClassType == 2  ){
        dic =  @{
                 @"userName":self.model.data.userName,
                 @"identityNo":identityNoString,
                 @"bankNumber":bankNumberString,
                 @"openBankAddr":self.model.data.openBankAddr,
                 @"bankName":self.model.data.bankName,
                 @"type":@"2", //1绑定 2变更
                 };
    }else if (self.ClassType == 1){
        dic =  @{
                 @"userName":self.model.data.userName,
                 @"identityNo":identityNoString,
                 @"bankNumber":bankNumberString,
                 @"openBankAddr":self.model.data.openBankAddr,
                 @"moneyPassword":[LPTools isNullToString:self.model.data.moneyPassword],
                 @"bankName":self.model.data.bankName,
                 @"type":@"2", //1绑定 2变更
                 };
    }
    WEAK_SELF()
    [NetApiManager requestBindunbindBankcardWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"][@"res_code"] integerValue] == 0) {
                        self.IntStep++;
                        [self InitView:self.ClassType intStep:self.IntStep];
                    return ;
                }else{
                    //                        [self.view showLoadingMeg:responseObject[@"data"][@"res_msg"] time:MESSAGE_SHOW_TIME];
                    if ([responseObject[@"data"][@"res_error_num"] integerValue]) {
                        GJAlertMessage *alert = [[GJAlertMessage alloc] initWithTitle:[NSString stringWithFormat:@"您今日还剩%ld次绑定机会，请仔细核对您的信息！(%@)",(long)[responseObject[@"data"][@"res_error_num"] integerValue],responseObject[@"data"][@"res_msg"]]
                                                                              message:nil
                                                                        textAlignment:NSTextAlignmentCenter
                                                                         buttonTitles:@[@"确定"]
                                                                         buttonsColor:@[[UIColor whiteColor]]
                                                              buttonsBackgroundColors:@[[UIColor baseColor]]
                                                                          buttonClick:^(NSInteger buttonIndex) {
                                                                          }];
                        [alert show];
                    }else{
                        GJAlertMessage *alert = [[GJAlertMessage alloc] initWithTitle:responseObject[@"data"][@"res_msg"]
                                                                              message:nil
                                                                        textAlignment:NSTextAlignmentCenter
                                                                         buttonTitles:@[@"确定"]
                                                                         buttonsColor:@[[UIColor whiteColor]]
                                                              buttonsBackgroundColors:@[[UIColor baseColor]]
                                                                          buttonClick:^(NSInteger buttonIndex) {
                                                                              [self.navigationController popViewControllerAnimated:YES];
                                                                          }];
                        [alert show];
                    }
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestCardNOoccupy{
 
    NSDictionary *dic = @{@"identityNo":self.model.data.identityNo};
    [NetApiManager requestCardNOoccupy:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 20026) {
                GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:responseObject[@"msg"]
                                                                     message:nil
                                                               textAlignment:NSTextAlignmentCenter
                                                                buttonTitles:@[@"确定"]
                                                                buttonsColor:@[[UIColor blackColor]]
                                                     buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                                 buttonClick:^(NSInteger buttonIndex) {
                                                                     //                    if (buttonIndex) {
                                                                     //                        self.IntStep++;
                                                                     //                        [self UpdateHeadViewColor];
                                                                     //                    }
                                                                 }];
                [alert show];
            }else{
                if ([responseObject[@"code"] integerValue] == 0 && [responseObject[@"data"] integerValue] == 1) {
                    self.IntStep++;
                    [self InitView:self.ClassType intStep:self.IntStep];
                    
                }else{
                    [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
