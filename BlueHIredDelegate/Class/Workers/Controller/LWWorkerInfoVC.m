//
//  LWWorkerInfoVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/22.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWWorkerInfoVC.h"
#import "LWWorkRecordModel.h"
#import "LWBatchAddWorkVC.h"

@interface LWWorkerInfoVC ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *Name;
@property (weak, nonatomic) IBOutlet UITextField *tel;
@property (weak, nonatomic) IBOutlet UITextField *DLunit;
@property (weak, nonatomic) IBOutlet UITextField *SubsidyMoney;

@property (weak, nonatomic) IBOutlet UITextField *Indate;
@property (weak, nonatomic) IBOutlet UITextField *InCompany;
@property (weak, nonatomic) IBOutlet IQTextView *remark;

@property (weak, nonatomic) IBOutlet UIButton *DLBtn1;
@property (weak, nonatomic) IBOutlet UIButton *DLBtn2;
@property (weak, nonatomic) IBOutlet UILabel *DLUnitLabel;

@property (weak, nonatomic) IBOutlet UIButton *SubsidyBtn1;
@property (weak, nonatomic) IBOutlet UIButton *SubsidyBtn2;

@property (weak, nonatomic) IBOutlet UIButton *WorkStatus1;
@property (weak, nonatomic) IBOutlet UIButton *WorkStatus2;

@property (weak, nonatomic) IBOutlet UIButton *DeleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Layoutconstraint_View1_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Layoutconstraint_View2_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Layoutconstraint_View3_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Layoutconstraint_View4_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Layoutconstraint_saveBtn_Width;


@property (nonatomic,strong) UIView *popView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIDatePicker *datePicker;

@property (nonatomic,strong) LWWorkRecordListDataModel *model;

@end

@implementation LWWorkerInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"招工信息";
//    [self.saveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.remark.mas_bottom).offset(LENGTH_SIZE(36));
//        make.right.mas_offset(LENGTH_SIZE(-18));
//        make.height.mas_offset(LENGTH_SIZE(48));
//        make.width.mas_offset(LENGTH_SIZE(160));
//    }];
    self.DeleteBtn.hidden = YES;
    self.Layoutconstraint_saveBtn_Width.constant = LENGTH_SIZE(339);
    
    if (self.Type == 1) {
        self.navigationItem.title = @"批量添加招工信息";
        self.Layoutconstraint_View1_height.constant = 0;
        self.Layoutconstraint_View4_height.constant = 0;
        self.nextBtn.hidden = NO;
    }
 

    self.SubsidyMoney.delegate = self;
    self.DLunit.delegate = self;
    self.remark.delegate = self;
    self.Indate.delegate = self;
    
    if (self.workModel.id.integerValue >0) {
        [self requestGetWorkRecord];
        self.DeleteBtn.hidden = NO;
        self.Layoutconstraint_saveBtn_Width.constant = LENGTH_SIZE(160);
       
        
    }
    
}

#pragma mark -Touch-
- (IBAction)TouchDLMoney:(UIButton *)sender {
    self.DLBtn1.selected = NO;
    self.DLBtn2.selected = NO;
    sender.selected = YES;
    if (sender == self.DLBtn2) {
        self.DLUnitLabel.text = @"元/小时";
    }else{
        self.DLUnitLabel.text = @"元/天";
    }

    
}


- (IBAction)TouchSubsidy:(UIButton *)sender {
    self.SubsidyBtn1.selected = NO;
    self.SubsidyBtn2.selected = NO;
    sender.selected = YES;
    if (sender == self.SubsidyBtn2) {
        self.Layoutconstraint_View2_height.constant = LENGTH_SIZE(160);
    }else{
        self.Layoutconstraint_View2_height.constant = LENGTH_SIZE(210);
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.SubsidyBtn2.superview.superview layoutIfNeeded];
    }];
}

- (IBAction)TouchWorkStatus:(UIButton *)sender {
    self.WorkStatus1.selected = NO;
    self.WorkStatus2.selected = NO;
    sender.selected = YES;
    if (sender == self.WorkStatus2) {
        self.Layoutconstraint_View3_height.constant = LENGTH_SIZE(60);
    }else{
        self.Layoutconstraint_View3_height.constant = LENGTH_SIZE(160);
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.WorkStatus2.superview.superview layoutIfNeeded];
    }];
}

//删除员工
- (IBAction)TouchDelete:(UIButton *)sender {
    [self requestDeleteWorkRecordList];
}
//保存
- (IBAction)Touchsave:(UIButton *)sender {
    if (self.Type == 0) {
        self.Name.text = [self.Name.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.tel.text = [self.tel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (self.Name.text.length<=0) {
            [self.view showLoadingMeg:@"请输入员工姓名" time:MESSAGE_SHOW_TIME];
            return;
        }
//        if (self.tel.text.length<=0 ) {
//            [self.view showLoadingMeg:@"请输入员工联系方式" time:MESSAGE_SHOW_TIME];
//            return;
//        }
        
        if (![NSString isMobilePhoneNumber:self.tel.text] && self.tel.text.length!=0) {
            [self.view showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
            return;
        }
        
        if (self.DLunit.text.floatValue<=0.0) {
            [self.view showLoadingMeg:@"请输入代理单价" time:MESSAGE_SHOW_TIME];
            return;
        }
  
        
        if (self.SubsidyBtn1.selected == YES && self.SubsidyMoney.text.floatValue <= 0.0) {
            [self.view showLoadingMeg:@"请输入车补费用" time:MESSAGE_SHOW_TIME];
            return;
        }
        
        if (self.WorkStatus1.selected == YES && self.Indate.text.length <= 0) {
            [self.view showLoadingMeg:@"请选择入职日期" time:MESSAGE_SHOW_TIME];
            return;
        }
        
        if (self.WorkStatus1.selected == YES && self.InCompany.text.length <= 0) {
            [self.view showLoadingMeg:@"请输入入职企业" time:MESSAGE_SHOW_TIME];
            return;
        }
        
        LWWorkRecordListDataModel *m = [[LWWorkRecordListDataModel alloc] init];
        m.userName = self.Name.text;
        m.userTel = self.tel.text;
        m.feeType = self.DLBtn1.selected ? @"0" : @"1";
        m.feeMoney = [NSString stringWithFormat:@"%.2f",self.DLunit.text.floatValue];
        m.carStatus = self.SubsidyBtn1.selected ? @"0" : @"1";
        m.carMoney = self.SubsidyBtn1.selected ? [NSString stringWithFormat:@"%.2f",self.SubsidyMoney.text.floatValue] : nil;
        m.workStatus = self.WorkStatus1.selected ? @"0" : @"1";
        if (self.WorkStatus1.selected) {
            m.workBeginTime = self.Indate.text;
            m.workMechanism = self.InCompany.text;
        }
        m.remark = self.remark.text;
        
        if (self.workModel.id.integerValue > 0) {
            m.id = self.workModel.id;
            [self requestUpdateWorkRecordList:m];
        }else{
            [self requestInsertWorkRecordList:[LWWorkRecordListDataModel mj_keyValuesArrayWithObjectArray:@[m]]];
        }
    }
}
//下一步
- (IBAction)TouchNextBtn:(UIButton *)sender {
    if (self.Type == 1) {
 
        if (self.DLunit.text.floatValue<=0.0) {
            [self.view showLoadingMeg:@"请输入代理单价" time:MESSAGE_SHOW_TIME];
            return;
        }
 
        
        if (self.SubsidyBtn1.selected == YES && self.SubsidyMoney.text.floatValue <= 0.0) {
            [self.view showLoadingMeg:@"请输入车补费用" time:MESSAGE_SHOW_TIME];
            return;
        }
        
        if (self.WorkStatus1.selected == YES && self.Indate.text.length <= 0) {
            [self.view showLoadingMeg:@"请选择入职日期" time:MESSAGE_SHOW_TIME];
            return;
        }
        
        if (self.WorkStatus1.selected == YES && self.InCompany.text.length <= 0) {
            [self.view showLoadingMeg:@"请输入入职企业" time:MESSAGE_SHOW_TIME];
            return;
        }
        
        LWWorkRecordListDataModel *m = [[LWWorkRecordListDataModel alloc] init];
        m.feeType = self.DLBtn1.selected ? @"0" : @"1";
        m.feeMoney = [NSString stringWithFormat:@"%.2f",self.DLunit.text.floatValue];
        m.carStatus = self.SubsidyBtn1.selected ? @"0" : @"1";
        m.carMoney = self.SubsidyBtn1.selected ? [NSString stringWithFormat:@"%.2f",self.SubsidyMoney.text.floatValue] : nil;
        m.workStatus = self.WorkStatus1.selected ? @"0" : @"1";
        if (self.WorkStatus1.selected) {
            m.workBeginTime = self.Indate.text;
            m.workMechanism = self.InCompany.text;
        }
 
        LWBatchAddWorkVC *vc = [[LWBatchAddWorkVC alloc] init];
        vc.superViewArr = self.superViewArr;
        vc.model = m;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark TextViewDelegate
- (IBAction)fieldTextDidChange:(UITextField *)textField
{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 6;
    if (textField == self.tel ) {
        kMaxLength = 11;
    }else if (textField == self.DLunit||
              textField == self.SubsidyMoney){
        kMaxLength = 7;
    }else if (textField == self.Name){
        kMaxLength = 5;
    }else if (textField == self.InCompany){
        kMaxLength = 20;
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


-(void)textViewDidChange:(UITextView *)textView
{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 50;
    
    NSString *toBeString = textView.text;
    // 获取键盘输入模式
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
    // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮选择部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                // 截取子串
                textView.text = [toBeString substringToIndex:kMaxLength];
            }
        } else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            // 截取子串
            textView.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.DLunit || textField == self.SubsidyMoney) {
        // 控制金额输入格式
        NSString * str = [NSString stringWithFormat:@"%@%@",textField.text,string];
        //匹配以0开头的数字
        NSPredicate * predicate0 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0][0-9]+$"];
        //匹配两位小数、整数
        NSPredicate * predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(([1-9]{1}[0-9]*|[0])\.?[0-9]{0,2})$"];
        
        if (!(![predicate0 evaluateWithObject:str] && [predicate1 evaluateWithObject:str])) {
            return NO;
        }
    }

    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //返回一个BOOL值，指定是否循序文本字段开始编辑
 
    if (textField == self.Indate  ) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self alertView:0];
        return NO;
    }
    return YES;
}



#pragma mark 时间选择器
-(void)alertView:(NSInteger)index{
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgView.backgroundColor = [UIColor lightGrayColor];
    self.bgView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    [self.bgView addGestureRecognizer:tap];
    
    self.popView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    self.popView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 10, SCREEN_WIDTH, 20);
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    //    [self.popView addSubview:label];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0,  10, SCREEN_WIDTH/2, 20)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self.popView addSubview:cancelButton];
    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2,  10, SCREEN_WIDTH/2, 20)];
    confirmButton.tag = index;
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmBirthday:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    confirmButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [self.popView addSubview:confirmButton];
    
    
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT/3-30)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.minimumDate = [DataTimeTool dateFromString:@"2018-01-01" DateFormat:@"yyyy-MM-dd"];
    _datePicker.maximumDate = [NSDate date];
    [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    //    _datePicker.locale = [NSLocale systemLocale];
    _datePicker.date = [NSDate date];
    [self.popView addSubview:_datePicker];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.popView.frame = CGRectMake(0, SCREEN_HEIGHT - self.popView.frame.size.height, SCREEN_HEIGHT, SCREEN_HEIGHT/3);
        self.bgView.alpha = 0.3;
    } completion:^(BOOL finished) {
        nil;
    }];
}
-(void)removeView{
    [UIView animateWithDuration:0.5 animations:^{
        self.popView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_HEIGHT, SCREEN_HEIGHT/3);
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.popView removeFromSuperview];
        [self.bgView removeFromSuperview];
        
    }];
}

-(void)confirmBirthday:(UIButton *)sender{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    [dateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    NSString *dateString = [dateFormat stringFromDate:_datePicker.date];
    
    self.Indate.text = dateString;
   
    [self removeView];
}

- (void)setModel:(LWWorkRecordListDataModel *)model{
    _model = model;
    self.Name.text = model.userName;
    self.tel.text = model.userTel;
    
    if (model.feeType.integerValue == 1) {
        [self TouchDLMoney:self.DLBtn2];
    }else{
        [self TouchDLMoney:self.DLBtn1];
    }
    self.DLunit.text = [NSString stringWithFormat:@"%.2f",model.feeMoney.floatValue];
    
    if (model.carStatus.integerValue == 1) {
        [self TouchSubsidy:self.SubsidyBtn2];
        self.SubsidyMoney.text = @"";
    }else{
        [self TouchSubsidy:self.SubsidyBtn1];
        self.SubsidyMoney.text = [NSString stringWithFormat:@"%.2f",model.carMoney.floatValue];
    }
   
    if (model.workStatus.integerValue == 1) {
        [self TouchWorkStatus:self.WorkStatus2];
    }else{
        [self TouchWorkStatus:self.WorkStatus1];
        self.Indate.text = model.workBeginTime;
        self.InCompany.text = model.workMechanism;
    }
    
    self.remark.text = model.remark;
 
 
    
}


#pragma mark - request
- (void)requestInsertWorkRecordList:(NSMutableArray *)model{
    
//    NSDictionary *dic = @{@"":model};
    
    [NetApiManager requestInsertWorkRecordList:model  withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"添加成功" time:MESSAGE_SHOW_TIME];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    for (LWWorkTableView *v in self.superViewArr) {
                        [v GetWorkRecord];
                        [v.tableview reloadData];
                    }
                    
                }else{
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"添加失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



- (void)requestGetWorkRecord{
    
    NSDictionary *dic = @{@"workRecordId":self.workModel.id};
    
    [NetApiManager requestGetWorkRecord:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LWWorkRecordListDataModel mj_objectWithKeyValues:responseObject[@"data"]];
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

- (void)requestDeleteWorkRecordList{
    
    NSDictionary *dic = @{@"delStatus":@"1",
                          @"id":self.workModel.id
                          };
    
    [NetApiManager requestUpdateWorkRecordList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"删除成功" time:MESSAGE_SHOW_TIME];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    for (LWWorkTableView *v in self.superViewArr) {
                        for (NSInteger i = 0; i<v.listArray.count; i++) {
                            if (v.listArray[i].id == self.workModel.id) {
                                [v.listArray removeObjectAtIndex:i];
                                break;
                            }
                        }
                        [v NodataView];
                        [v.tableview reloadData];
                    }
                    if (self.workModel.workStatus.integerValue == 1) {
                        NSString *str = self.ArrBtn[2].currentTitle;
                        NSString *Num = [str substringWithRange:NSMakeRange(3, str.length - 5)];
                        if (Num.integerValue > 0) {
                            [self.ArrBtn[2] setTitle:[NSString stringWithFormat:@"待业(%ld人)",Num.integerValue-1] forState:UIControlStateNormal];
                        }
                    }else{
                        NSString *str = self.ArrBtn[1].currentTitle;
                        NSString *Num = [str substringWithRange:NSMakeRange(3, str.length - 5)];
                        if (Num.integerValue > 0) {
                            [self.ArrBtn[1] setTitle:[NSString stringWithFormat:@"在职(%ld人)",Num.integerValue-1] forState:UIControlStateNormal];
                        }
                    }
                    
                }else{
                    [self.view showLoadingMeg:@"删除失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


- (void)requestUpdateWorkRecordList:(LWWorkRecordListDataModel *) Model{
    
    NSDictionary *dic =  [Model mj_keyValues];
    
    [NetApiManager requestUpdateWorkRecordList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"保存成功" time:MESSAGE_SHOW_TIME];
                    [self.navigationController popViewControllerAnimated:YES];
                    for (LWWorkTableView *v in self.superViewArr) {
//                    LWWorkTableView *v1 = self.superViewArr[0];
                        for (NSInteger i = 0; i<v.listArray.count; i++) {
                            if (v.listArray[i].id == Model.id) {
                                v.listArray[i] = Model;
                                break;
                            }
                        }
                        [v.tableview reloadData];
                    }
                   
                    
                    
                    //有没有改变在职状态
                    if (self.workModel.workStatus.integerValue == Model.workStatus.integerValue) {
                        LWWorkTableView *v2 = self.superViewArr[Model == 0 ? 1:2];     //在职 workStatus = 0
                        for (NSInteger i = 0; i<v2.listArray.count; i++) {
                            LWWorkRecordListDataModel *m = v2.listArray[i];
                            if (m.id == Model.id) {
                                m = Model;
                                break;
                            }
                        }
                        [v2.tableview reloadData];
                    }else {
                        
                        if (Model.workStatus.integerValue == 0) {   //在职 workStatus = 0
                            LWWorkTableView *v3 = self.superViewArr[2];
                            
                            for (NSInteger i =0; i<v3.listArray.count; i++) {
                                if (v3.listArray[i].id == self.workModel.id) {
                                    [v3.listArray removeObjectAtIndex:i];
                                    break;
                                }
                            }
                            [v3 NodataView];
                            [v3.tableview reloadData];
                            
                            LWWorkTableView *v2 = self.superViewArr[1];
                            [v2.listArray addObject:Model];
                            [v2 NodataView];
                            [v2.tableview reloadData];
                            
                            NSString *str = self.ArrBtn[1].currentTitle;
                            NSString *Num = [str substringWithRange:NSMakeRange(3, str.length - 5)];
                            [self.ArrBtn[1] setTitle:[NSString stringWithFormat:@"在职(%ld人)",Num.integerValue+1] forState:UIControlStateNormal];
                            
                            NSString *str2 = self.ArrBtn[2].currentTitle;
                            NSString *Num2 = [str2 substringWithRange:NSMakeRange(3, str2.length - 5)];
                            if (Num2.integerValue > 0) {
                                [self.ArrBtn[2] setTitle:[NSString stringWithFormat:@"待业(%ld人)",Num2.integerValue-1] forState:UIControlStateNormal];
                            }
                            
                            
                        }else if (Model.workStatus.integerValue == 1){      //待业 workStatus = 1
                            LWWorkTableView *v3 = self.superViewArr[2];
                            [v3.listArray addObject:Model];
                            [v3 NodataView];
                            [v3.tableview reloadData];
                            
                            LWWorkTableView *v2 = self.superViewArr[1];
                            for (NSInteger i =0; i<v2.listArray.count; i++) {
                                if (v2.listArray[i].id == self.workModel.id) {
                                    [v2.listArray removeObjectAtIndex:i];
                                    break;
                                }
                            }
                            [v2 NodataView];
                            [v2.tableview reloadData];
                            
                            NSString *str = self.ArrBtn[1].currentTitle;
                            NSString *Num = [str substringWithRange:NSMakeRange(3, str.length - 5)];
                            if (Num.integerValue > 0) {
                            [self.ArrBtn[1] setTitle:[NSString stringWithFormat:@"在职(%ld人)",Num.integerValue-1] forState:UIControlStateNormal];
                             }
                            
                            NSString *str2 = self.ArrBtn[2].currentTitle;
                            NSString *Num2 = [str2 substringWithRange:NSMakeRange(3, str2.length - 5)];
                            
                            [self.ArrBtn[2] setTitle:[NSString stringWithFormat:@"待业(%ld人)",Num2.integerValue+1] forState:UIControlStateNormal];
                            
                        }
                     

                    }
                }else{
                    [self.view showLoadingMeg:@"保存失败,请稍后再试" time:MESSAGE_SHOW_TIME];
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
