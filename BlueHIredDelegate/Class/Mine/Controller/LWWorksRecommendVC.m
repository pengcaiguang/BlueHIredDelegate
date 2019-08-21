//
//  LWWorksRecommendVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/15.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWWorksRecommendVC.h"
#import "AddressPickerView.h"

@interface LWWorksRecommendVC ()<AddressPickerViewDelegate,UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic ,strong) AddressPickerView * pickerView;
@property (weak, nonatomic) IBOutlet UITextField *WorkName;
@property (weak, nonatomic) IBOutlet UITextField *WorkPost;
@property (weak, nonatomic) IBOutlet UITextField *WorkAddress;
@property (weak, nonatomic) IBOutlet IQTextView *WorkDetailsAdd;
@property (weak, nonatomic) IBOutlet IQTextView *remark;

@end

@implementation LWWorksRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"企业推荐";
        [self.view addSubview:self.pickerView];
    
    self.WorkDetailsAdd.delegate = self;
    self.remark.delegate = self;
    self.WorkAddress.delegate = self;
    
}

- (IBAction)touchSave:(id)sender {
    if (self.WorkName.text.length == 0) {
        [self.view showLoadingMeg:@"请输入企业名称" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.WorkPost.text.length == 0) {
        [self.view showLoadingMeg:@"请输入招聘岗位" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.WorkAddress.text.length == 0) {
        [self.view showLoadingMeg:@"请选择企业地址" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.WorkDetailsAdd.text.length == 0) {
        [self.view showLoadingMeg:@"请输入详细地址" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self requestQueryJobInsertJob];
}



- (void)textViewDidChange:(UITextView *)textField{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 150;
    if (self.WorkDetailsAdd == textField) {
        kMaxLength = 30;
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


- (IBAction)fieldTextDidChange:(UITextField *)textField
{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 12;
    if (textField == self.WorkName) {
        kMaxLength = 30;
    }else if (textField == self.WorkPost){
        kMaxLength = 15;
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


#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //返回一个BOOL值，指定是否循序文本字段开始编辑
    if (textField == self.WorkAddress ) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self.pickerView show];
        return NO;
        
    }
    
    return YES;
}

#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick{
    NSLog(@"点击了取消按钮");
    [self.pickerView hide];
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    NSString *strCity = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    if ([province isEqualToString:strCity]) {
        if ([area isEqualToString:@"全市"]) {
            self.WorkAddress.text = [NSString stringWithFormat:@"%@",city];
        }else{
            self.WorkAddress.text = [NSString stringWithFormat:@"%@%@",city,area];
        }
    }else{
        if ([area isEqualToString:@"全市"]) {
            self.WorkAddress.text = [NSString stringWithFormat:@"%@%@",province,city];
        }else{
            self.WorkAddress.text = [NSString stringWithFormat:@"%@%@%@",province,city,area];
        }
    }
    
    [self.pickerView hide];

    
}

- (AddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc]init];
        _pickerView.delegate = self;
        [_pickerView setTitleHeight:30 pickerViewHeight:276];
        _pickerView.isShowArea = YES;
        // 关闭默认支持打开上次的结果
        //        _pickerView.isAutoOpenLast = NO;
    }
    return _pickerView;
}



#pragma mark - request
-(void)requestQueryJobInsertJob{
    NSDictionary *dic = @{@"mechanismName":self.WorkName.text,
                          @"workPost":self.WorkPost.text,
                          @"mechanismAddress":self.WorkAddress.text,
                          @"extAddress":self.WorkDetailsAdd.text,
                          @"remark":self.remark.text};
    [NetApiManager requestQueryJobInsertJob:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"推荐成功"  time:MESSAGE_SHOW_TIME];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self.view showLoadingMeg:@"推荐失败,请稍后再试"  time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"]  time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
