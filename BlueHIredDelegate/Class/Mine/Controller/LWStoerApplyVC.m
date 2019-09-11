//
//  LWStoerApplyVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/16.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWStoerApplyVC.h"
#import "AddressPickerView.h"
#import "LPDurationView.h"
#import "LWShopApplyModel.h"

@interface LWStoerApplyVC () <AddressPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UIButton *directBtn;

@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UIButton *noBtn;

@property (weak, nonatomic) IBOutlet UITextField *worksType;
@property (weak, nonatomic) IBOutlet UITextField *worksArea;
@property (weak, nonatomic) IBOutlet UITextField *storeAddress;
@property (weak, nonatomic) IBOutlet IQTextView  *Address;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_View_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_View_bottom;

@property (weak, nonatomic) IBOutlet UILabel *Time1;

@property (weak, nonatomic) IBOutlet UIView *InView2;
@property (weak, nonatomic) IBOutlet UIView *OutView2;
@property (weak, nonatomic) IBOutlet UIView *LineView;
@property (weak, nonatomic) IBOutlet UILabel *Title2;
@property (weak, nonatomic) IBOutlet UILabel *Time2;
//@property (weak, nonatomic) IBOutlet UILabel *TitleDetails2;

@property (weak, nonatomic) IBOutlet UILabel *shopTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *worksTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *AddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *againBtn;


@property (weak, nonatomic) IBOutlet UILabel *SubTitle;
@property (weak, nonatomic) IBOutlet UIView *AuditView;

@property (nonatomic ,strong) AddressPickerView * pickerView;
@property (nonatomic,strong) LPDurationView *durationView;
@property (nonatomic,strong) UITextField *SelectAreaTF;

@property (nonatomic,strong) NSArray *WorkTypeArr;

@property (nonatomic,strong) LWShopApplyModel *model;

@end

@implementation LWStoerApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"门店申请";
    self.Address.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.pickerView];
    [LPTools setViewShapeLayer:self.SubTitle CornerRadii:4 byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    //处理圆角
    for (UIView *v in self.Title2.superview.subviews) {
        if (v.tag == 1000) {
            v.layer.cornerRadius = LENGTH_SIZE(7.5);
        }else if (v.tag == 2000){
            v.layer.cornerRadius = LENGTH_SIZE(4);
        }
    }
    
    self.WorkTypeArr = @[@"学生工",@"社会工",@"农民工",@"少数民族",];
    self.worksType.delegate = self;
    self.worksArea.delegate = self;
    self.storeAddress.delegate = self;
    self.Address.delegate = self;

    self.Address.textContainer.lineFragmentPadding = 0.0;
    self.Address.textContainerInset = UIEdgeInsetsMake(LENGTH_SIZE(7), CGFLOAT_MIN, 0, 0);
    self.Address.placeholderTextColor =[[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    
    
    [self requestQueryShopApply];
    
}


- (void)textViewDidChange:(UITextView *)textField{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 30;
    if (self.Address == textField) {
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

 

- (IBAction)TouchisEntity:(UIButton *)sender {
    self.yesBtn.selected = NO;
    self.noBtn.selected = NO;
    sender.selected = YES;
    if (self.noBtn.selected == YES) {
        self.LayoutConstraint_View_height.constant = LENGTH_SIZE(50);
    }else{
        self.LayoutConstraint_View_height.constant = LENGTH_SIZE(169);
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)Touchisjoin:(UIButton *)sender {
    self.joinBtn.selected = NO;
    self.directBtn.selected = NO;
    sender.selected = YES;

}

//提交
- (IBAction)TouchVerify:(UIButton *)sender {
    if (self.worksType.text.length == 0) {
        [self.view showLoadingMeg:@"请选择主要招工类型" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.worksArea.text.length == 0) {
        [self.view showLoadingMeg:@"请选择主要招工区域" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.yesBtn.selected && self.storeAddress.text.length == 0) {
        [self.view showLoadingMeg:@"请选择门店地址" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    LWShopApplyDataModel *m = [[LWShopApplyDataModel alloc] init];
    m.shopType = self.joinBtn.selected ? @"1" : @"2";
    m.workType = [NSString stringWithFormat:@"%ld",(long)self.worksType.tag];
    m.workRange = self.worksArea.text;
    m.realShop = self.yesBtn.selected ? @"0" :@"1";
    
    if (self.yesBtn.selected) {
        m.shopAddress = self.storeAddress.text;
        m.extAddress = self.Address.text;

    }
    
    [self requestQueryInsetShopApply:m];
    
}

//重新申请
- (IBAction)TouchReapply:(UIButton *)sender {
    self.AuditView.hidden = YES;

}



#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //返回一个BOOL值，指定是否循序文本字段开始编辑
    if (textField == self.worksArea || textField == self.storeAddress) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        self.SelectAreaTF = textField;
        [self.pickerView show];
        return NO;

    }
    if (textField == self.worksType ) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
 
        self.durationView.titleString = @"请选择招工类型";
        self.durationView.typeArray = self.WorkTypeArr;
        WEAK_SELF()
        self.durationView.block = ^(NSInteger index) {
            weakSelf.worksType.text = weakSelf.WorkTypeArr[index];
            weakSelf.worksType.tag = index+1;
        };
        self.durationView.hidden = NO;
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
//        NSString *CityStr = [NSString stringWithFormat:@"%@%@",city,area];
//        self.SelectAreaTF.text = CityStr;
        if (self.storeAddress == self.SelectAreaTF  && [area isEqualToString:@"全市"]) {
            self.SelectAreaTF.text = [NSString stringWithFormat:@"%@",city];
        }else{
            self.SelectAreaTF.text = [NSString stringWithFormat:@"%@%@",city,area];
        }
    }else{
        if (self.storeAddress == self.SelectAreaTF  && [area isEqualToString:@"全市"]) {
            self.SelectAreaTF.text = [NSString stringWithFormat:@"%@%@",province,city];
        }else{
            self.SelectAreaTF.text = [NSString stringWithFormat:@"%@%@%@",province,city,area];
        }
    }
    
    [self.pickerView hide];
    
    //    [self btnClick:_addressBtn];
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
-(LPDurationView *)durationView{
    if (!_durationView) {
        _durationView = [[LPDurationView alloc]init];
    }
    return _durationView;
}


- (void)setModel:(LWShopApplyModel *)model{
    _model = model;
    if (model.data) {
        self.AuditView.hidden = NO;
        
        self.shopTypeLabel.text = model.data.shopType.integerValue == 1? @"加盟店":@"直营店";
        self.worksTypeLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",
                                    model.data.workType.integerValue>0?self.WorkTypeArr[model.data.workType.integerValue-1]:@"",
                                    model.data.workRange,
                                    model.data.realShop.integerValue==0?@"有实体门店":@"无实体门店"];
        if (model.data.shopAddress.length>0) {
            [self.AddressLabel setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
            [self.AddressLabel setTitle:[NSString stringWithFormat:@" %@%@",model.data.shopAddress,model.data.extAddress] forState:UIControlStateNormal];
            self.LayoutConstraint_View_bottom.constant = LENGTH_SIZE(47);
        }else{
            [self.AddressLabel setImage:[UIImage new] forState:UIControlStateNormal];
            [self.AddressLabel setTitle:@"" forState:UIControlStateNormal];
            self.LayoutConstraint_View_bottom.constant = LENGTH_SIZE(16);
        }
        self.Time1.text = [NSString convertStringToTime:model.data.time];
        
        
        if (model.data.status.integerValue == 0) {     //"status" //0待审核1审核通过2审核失败
            self.Title2.text = @"等待审核结果";
            self.Title2.textColor = [UIColor baseColor];
            self.againBtn.hidden = YES;
        }else if (model.data.status.integerValue == 1){
            self.Title2.text = @"审核通过";
            self.Title2.textColor = [UIColor baseColor];
            self.Time2.text = [NSString convertStringToTime:model.data.setTime];
            self.againBtn.hidden = YES;
            self.OutView2.backgroundColor = [UIColor colorWithHexString:@"#FF5353" alpha:0.0];

        }else if (model.data.status.integerValue == 2){
            if (model.data.remark.length>0) {
                self.Title2.text = [NSString stringWithFormat:@"审核失败（理由：%@）",[LPTools isNullToString:model.data.remark]];
                self.Title2.textColor = [UIColor colorWithHexString:@"#FF5353"];
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.Title2.text];
                [string addAttributes:@{NSFontAttributeName: FONT_SIZE(14)} range:NSMakeRange(4, self.Title2.text.length-4)];
                self.Title2.attributedText = string;
            }else{
                self.Title2.text = @"审核失败";
                self.Title2.textColor = [UIColor colorWithHexString:@"#FF5353"];
            }
            

            self.Time2.text = [NSString convertStringToTime:model.data.setTime];
            self.LineView.backgroundColor = [UIColor colorWithHexString:@"#FFCBCB"];
            self.InView2.backgroundColor = [UIColor colorWithHexString:@"#FF5353"];
            self.OutView2.backgroundColor = [UIColor colorWithHexString:@"#FF5353" alpha:0.0];
            self.againBtn.hidden = NO;

        }
    }
}

#pragma mark - request
-(void)requestQueryShopApply{
    NSDictionary *dic = @{};
    [NetApiManager requestQueryShopApply:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LWShopApplyModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"]  time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryInsetShopApply:(LWShopApplyDataModel *) Model{
    NSDictionary *dic = [Model mj_JSONObject];
    [NetApiManager requestQueryInsetShopApply:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [self.view showLoadingMeg:@"申请成功"  time:MESSAGE_SHOW_TIME];
                    [self requestQueryShopApply];
                }else{
                    [self.view showLoadingMeg:@"申请失败,请稍后再试"  time:MESSAGE_SHOW_TIME];
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
