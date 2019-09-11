//
//  LWWorkDetailEditVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/9/5.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWWorkDetailEditVC.h"

@interface LWWorkDetailEditVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mechanismUrlImageView;
@property (weak, nonatomic) IBOutlet UILabel *mechanismNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lendTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *wageRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *AgeLabel;

@property (weak, nonatomic) IBOutlet UILabel *reMoneyTitle;

@property (weak, nonatomic) IBOutlet UIButton *reMoneyBtnYes;
@property (weak, nonatomic) IBOutlet UIButton *reMoneyBtnNO;
@property (weak, nonatomic) IBOutlet UITextField *reMoneyTF;
@property (weak, nonatomic) IBOutlet UILabel *reMoneyTFUnits;
@property (weak, nonatomic) IBOutlet UILabel *ManageMoney;
@property (weak, nonatomic) IBOutlet UILabel *MoneyTitle;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_Height;

@end

@implementation LWWorkDetailEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"编辑招聘信息";
    self.reMoneyTF.delegate = self;
    
    [self.reMoneyTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    self.AgeLabel.layer.cornerRadius = 2;
    self.AgeLabel.layer.borderColor = [UIColor baseColor].CGColor;
    self.AgeLabel.layer.borderWidth = 0.5;
    self.AgeLabel.textColor = [UIColor baseColor];
    [self initView];
}


- (void)initView{
    if (self.model.data.age.length ) {
        self.AgeLabel.text = [NSString stringWithFormat:@" %@ ", self.model.data.age];
        self.AgeLabel.hidden = NO;
    }else{
        self.AgeLabel.hidden = YES;
    }
    
    self.mechanismNameLabel.text = self.model.data.mechanismName;
    self.lendTypeLabel.hidden = ![self.model.data.lendType integerValue];
    [self.mechanismUrlImageView sd_setImageWithURL:[NSURL URLWithString:self.model.data.mechanismUrl]];
    
    if ([self.model.data.postType integerValue] == 1) {
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/时",reviseString(self.model.data.workMoney)];
        self.reMoneyTitle.text = [NSString stringWithFormat:@"不得高于平台奖励工价(%@元/时)",self.model.data.maxAddWorkMoney];
        self.reMoneyTFUnits.text = @"元/时";
        self.MoneyTitle.text = @"奖励工价";
        self.ManageMoney.text = [NSString stringWithFormat:@"管理费：%@元/时",reviseString(self.model.data.manageMoney)];
        self.reMoneyTF.keyboardType =  UIKeyboardTypeDecimalPad;
    }else{
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/月",self.model.data.wageRange];
        self.reMoneyTitle.text = [NSString stringWithFormat:@"不得高于平台返费(%@元/月)",self.model.data.maxReMoney];
        self.reMoneyTFUnits.text = @"元/月";
        self.reMoneyTF.keyboardType =  UIKeyboardTypeNumberPad;
        self.MoneyTitle.text = @"每月返费";
        self.ManageMoney.text = [NSString stringWithFormat:@"管理费：%@元/月",reviseString(self.model.data.manageMoney)];

    }
    self.maxNumberLabel.text = [NSString stringWithFormat:@"%@",self.model.data.workTypeName];
 

    if (self.model.data.reStatus.integerValue == 1) {
        self.reMoneyBtnYes.selected = YES;
        self.reMoneyBtnNO.selected = NO;
        self.LayoutConstraint_Height.constant = LENGTH_SIZE(100);
        if ([self.model.data.postType integerValue] == 1) {
            self.reMoneyTF.text = [NSString stringWithFormat:@"%.2f",self.model.data.addWorkMoney.floatValue];
        }else{
            self.reMoneyTF.text = [NSString stringWithFormat:@"%.0f", self.model.data.reMoney.floatValue/self.model.data.reTime.floatValue];
        }

    }else{
        self.reMoneyBtnYes.selected = NO;
        self.reMoneyBtnNO.selected = YES;
        self.LayoutConstraint_Height.constant = LENGTH_SIZE(50);
    }
    
}
- (IBAction)TouchReMoney:(UIButton *)sender {
    if (sender.selected == NO) {
        self.reMoneyBtnNO.selected = NO;
        self.reMoneyBtnYes.selected = NO;
        sender.selected = YES;
        if (sender == self.reMoneyBtnYes) {
            [self textFieldChanged:self.reMoneyTF];
        }else{
            self.reMoneyTitle.hidden = YES;
            self.saveBtn.backgroundColor = [UIColor baseColor];
        }
    }
    if (sender == self.reMoneyBtnYes) {
        self.LayoutConstraint_Height.constant = LENGTH_SIZE(100);
    }else{
        self.LayoutConstraint_Height.constant = LENGTH_SIZE(50);
    }
    [UIView animateWithDuration:0.3 animations:^{
        [sender.superview.superview layoutIfNeeded];
    }];
}

//保存
- (IBAction)Touchsave:(UIButton *)sender {
    if (self.reMoneyBtnYes.selected) {
        
        if (self.model.data.postType.integerValue == 1) {
            if (self.reMoneyTF.text.floatValue == 0.0) {
                [self.view showLoadingMeg:@"奖励工价不能为空" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (self.reMoneyTF.text.floatValue>self.model.data.maxAddWorkMoney.floatValue) {
                return;
            }
        }else{
            if (self.reMoneyTF.text.floatValue == 0.0) {
                [self.view showLoadingMeg:@"每月返费不能为空" time:MESSAGE_SHOW_TIME];
                return;
            }
            if (self.reMoneyTF.text.floatValue>self.model.data.maxReMoney.floatValue) {
                return;
            }
        }
    }else{
        self.reMoneyTF.text = @"";
    }
    
    
    [self requestUpdateShopWork];
}

#pragma mark TextViewDelegate
- (IBAction)fieldTextDidChange:(UITextField *)textField
{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 7;
    
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


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if (textField == self.reMoneyTF) {
        // 控制金额输入格式
        NSString * str = [NSString stringWithFormat:@"%@%@",textField.text,string];
        //匹配以0开头的数字
        NSPredicate * predicate0 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0][0-9]+$"];
        //匹配两位小数、整数
        NSPredicate * predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(([1-9]{1}[0-9]*|[0])\.?[0-9]{0,1})$"];
        
        if (!(![predicate0 evaluateWithObject:str] && [predicate1 evaluateWithObject:str])) {
            return NO;
        }
    }
    
    return YES;
}



-(void)textFieldChanged:(UITextField *)textField{
    
    
    
    if (self.model.data.postType.integerValue == 1) {
        if (textField.text.floatValue>self.model.data.maxAddWorkMoney.floatValue) {
            self.saveBtn.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
            self.reMoneyTitle.text = [NSString stringWithFormat:@"不得高于平台奖励工价(%@元/时)",self.model.data.maxAddWorkMoney];
            self.reMoneyTitle.hidden = NO;
        }else{
            self.reMoneyTitle.hidden = YES;
            self.saveBtn.backgroundColor = [UIColor baseColor];
        }
    }else{
        if (textField.text.floatValue>self.model.data.maxReMoney.floatValue) {
            self.saveBtn.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
            self.reMoneyTitle.text = [NSString stringWithFormat:@"不得高于平台返费(%@元/月)",self.model.data.maxReMoney];
            self.reMoneyTitle.hidden = NO;
        }else{
            self.saveBtn.backgroundColor = [UIColor baseColor];
            self.reMoneyTitle.hidden = YES;
        }
    }
   

}


#pragma mark - request
- (void)requestUpdateShopWork{
    
    NSDictionary *dic;
    
    if (self.model.data.postType.integerValue == 1) {
        dic = @{@"workId":self.model.data.id,
                @"reStatus":self.reMoneyBtnYes.selected?@"1":@"0",
                @"addWorkMoney":self.reMoneyTF.text
                };
    }else{
        dic = @{@"workId":self.model.data.id,
                @"reStatus":self.reMoneyBtnYes.selected?@"1":@"0",
                @"reMoney":self.reMoneyTF.text
                };
    }
    
    
    [NetApiManager requestUpdateShopWork:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    if (self.model.data.postType.integerValue == 1) {
                        self.model.data.addWorkMoney = self.reMoneyTF.text;
                        self.model.data.shopAddWorkMoney = self.reMoneyTF.text;
                    }else{
                        self.model.data.reMoney = @(self.reMoneyTF.text.floatValue*self.model.data.reTime.floatValue);
                        self.model.data.shopReMoney = self.reMoneyTF.text;
                    }
                    self.model.data.shopReStatus = self.reMoneyBtnYes.selected?@"1":@"0";
                    self.model.data.reStatus = self.reMoneyBtnYes.selected?@"1":@"0";
                    
                    self.workListModel.addWorkMoney = self.model.data.addWorkMoney;
                    self.workListModel.shopAddWorkMoney = self.model.data.shopAddWorkMoney;
                    self.workListModel.reMoney = self.model.data.reMoney;
                    self.workListModel.shopReMoney = self.model.data.shopReMoney;
                    self.workListModel.reStatus = self.model.data.reStatus;
                    self.workListModel.shopReStatus = self.model.data.shopReStatus;

                    if (self.superViewArr.count>=2) {
                        LWMainView *V1 = self.superViewArr[0];
                        LWMainView *V2 = self.superViewArr[1];
                        
                        for (NSInteger i =0 ; i < V1.listArray.count; i++) {
                            if (V1.listArray[i].id.integerValue == self.workListModel.id.integerValue) {
                                V1.listArray[i] = self.workListModel;
                                break;
                            }
                        }
                        for (NSInteger i =0 ; i < V2.listArray.count; i++) {
                            if (V2.listArray[i].id.integerValue == self.workListModel.id.integerValue) {
                                V2.listArray[i] = self.workListModel;
                                break;
                            }
                        }
                        
                        
                        [V1.tableview reloadData];
                        [V2.tableview reloadData];
                    }
             
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"修改成功" time:MESSAGE_SHOW_TIME];
                }else{
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"修改失败,请稍后再试" time:MESSAGE_SHOW_TIME];
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
