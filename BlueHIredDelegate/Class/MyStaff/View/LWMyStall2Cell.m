//
//  LWMyStall2Cell.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/9/6.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWMyStall2Cell.h"

@interface LWMyStall2Cell()
@property(nonatomic,strong) CustomIOSAlertView *CustomAlert;
@property(nonatomic,strong) UITextField *AlertTF;
@end

@implementation LWMyStall2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.UserImage.layer.cornerRadius = LENGTH_SIZE(17);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

     
}

- (void)setModel:(LWMyStaffDataModelV2 *)model{
    _model = model;
    [self.UserImage yy_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholder:[UIImage imageNamed:@"Head_image"]];
    self.Name.text = model.userName;
    if (model.earnStatus.integerValue == 0) {
        self.numberTitle.hidden = YES;
        self.number.hidden = YES;
        self.AwardType.text = @"无";
        self.AwardType.textColor = [UIColor colorWithHexString:@"#999999"];
        
    }else if (model.earnStatus.integerValue == 1){
        self.numberTitle.hidden = NO;
        self.number.hidden = NO;
        self.AwardType.text = @"邀请奖励";
        self.AwardType.textColor = [UIColor baseColor];
        self.number.text = [NSString stringWithFormat:@"%@人",model.num];

    }else if (model.earnStatus.integerValue == 2){
        self.numberTitle.hidden = YES;
        self.number.hidden = YES;
        self.AwardType.text = @"管理费奖励";
        self.AwardType.textColor = [UIColor colorWithHexString:@"#FFAE3D"];
    }
    self.remark.text = model.remark;

}
- (IBAction)TouchPhone:(UIButton *)sender {
    sender.enabled = NO;
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.model.userTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}

- (IBAction)TouchAddRemark:(id)sender {
    
    [self initRemarkAlertView];
    
}

- (void)initRemarkAlertView{
    CustomIOSAlertView *alertview = [[CustomIOSAlertView alloc] init];
    self.CustomAlert = alertview;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  LENGTH_SIZE(300), LENGTH_SIZE(177))];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] init];
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_offset(LENGTH_SIZE(22));
        make.left.right.mas_offset(0);
    }];
    title.textColor = [UIColor colorWithHexString:@"#333333"];
    title.font = [UIFont boldSystemFontOfSize:18];
    title.text = @"编辑备注";
    title.textAlignment = NSTextAlignmentCenter;
    
    UITextField *TF = [[UITextField alloc] init];
    self.AlertTF = TF;
    [view addSubview:TF];
    [TF mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_offset(LENGTH_SIZE(65));
        make.left.mas_offset(LENGTH_SIZE(20));
        make.right.mas_offset(LENGTH_SIZE(-20));
        make.height.mas_offset(LENGTH_SIZE(36));
    }];
    TF.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    TF.layer.borderWidth = 1;
    TF.layer.cornerRadius = 6;
    TF.placeholder = @"请输入备注";
    TF.text = self.model.remark;
    [TF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *button = [[UIButton alloc] init];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(TF.mas_bottom).offset(LENGTH_SIZE(15));
        make.left.mas_offset(LENGTH_SIZE(20));
        make.right.mas_offset(LENGTH_SIZE(-20));
        make.height.mas_offset(LENGTH_SIZE(40));
    }];
    button.layer.cornerRadius = 6;
    button.backgroundColor = [UIColor baseColor];
    [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [button setTitle:@"保  存" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(Touchremark:) forControlEvents:UIControlEventTouchUpInside];
    
    alertview.containerView = view;
    alertview.buttonTitles=@[];
    [alertview setUseMotionEffects:true];
    [alertview setCloseOnTouchUpOutside:true];
    [alertview show];
}


-(void)Touchremark:(UIButton *)sender{
    [self.CustomAlert close];
    [self requestQueryShopUpdateRemark];
}



#pragma mark textFieldChanged
-(void)textFieldChanged:(UITextField *)textField{
    //
    
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    int kMaxLength = 10;
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



-(void)requestQueryShopUpdateRemark{
    NSDictionary *dic = @{
                          @"id":self.model.id,
                          @"type":self.model.type,
                          @"remark":self.AlertTF.text
                          };
    
    [NetApiManager requestQueryShopUpdateRemark:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"编辑备注成功" time:MESSAGE_SHOW_TIME];
                    self.model.remark = self.AlertTF.text;
                    self.remark.text = self.model.remark;
                }else{
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"编辑备注失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

@end
