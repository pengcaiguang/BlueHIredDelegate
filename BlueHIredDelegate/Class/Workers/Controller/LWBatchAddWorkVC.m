//
//  LWBatchAddWorkVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/23.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWBatchAddWorkVC.h"
#import "LWBatchAddWorkCell.h"

static NSString *LWBatchAddWorkCellID = @"LWBatchAddWorkCell";

@interface LWBatchAddWorkVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSMutableArray <LWWorkRecordListDataModel *>*ListArray;

@property (nonatomic,strong) CustomIOSAlertView *alertView;
@property (nonatomic,strong) UITextField *nameTF;
@property (nonatomic,strong) UITextField *TelTF;
@property (nonatomic,strong) UIButton *saveBtn;

@property (nonatomic,strong) UIButton *allBtn;


@end

@implementation LWBatchAddWorkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"批量添加招工信息";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.ListArray = [[NSMutableArray alloc] init];
    [self initView];
    
}


-(void)initView{
    
    
    UIButton *allBtn = [[UIButton alloc] init];
    [self.view addSubview:allBtn];
    self.allBtn = allBtn;
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(48));
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.bottom.mas_offset(0);
        }
    }];
//    allBtn.backgroundColor = [UIColor colorWithHexString:@"#3C93FF"];
    allBtn.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    [allBtn setTitle:@"录入完成" forState:UIControlStateNormal];
    [allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    allBtn.titleLabel.font = FONT_SIZE(17);
    [allBtn addTarget:self action:@selector(TouchAllBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addBtn = [[UIButton alloc] init];
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(48));
        make.left.equalTo(allBtn.mas_right).offset(0);
        make.width.equalTo(allBtn);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.bottom.mas_offset(0);
        }
    }];
    addBtn.backgroundColor = [UIColor baseColor];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = FONT_SIZE(17);
    [addBtn addTarget:self action:@selector(TouchAddBtn:) forControlEvents:UIControlEventTouchUpInside];
   
    
        [self.view addSubview:self.tableview];
        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.equalTo(addBtn.mas_top);
            make.top.mas_offset(LENGTH_SIZE(10));
        }];
    
    
}

-(void)TouchAllBtn:(UIButton *)sender{
    if (self.ListArray.count == 0 ) {
        return;
    }
    
    [self requestInsertWorkRecordList:[LWWorkRecordListDataModel mj_keyValuesArrayWithObjectArray:self.ListArray]];
 
}


-(void)TouchAddBtn:(UIButton *)sender{
    self.nameTF.text = @"";
    self.TelTF.text = @"";
    [self.alertView show];
}

-(void)Touchsave:(UIButton *)sender{
    self.nameTF.text = [self.nameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.TelTF.text = [self.TelTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.nameTF.text.length<=0) {
        [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"请输入员工姓名" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (![NSString isMobilePhoneNumber:self.TelTF.text] && self.TelTF.text.length!=0) {
        [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    LWWorkRecordListDataModel *m = [[LWWorkRecordListDataModel alloc] init] ;
    m.userName = self.nameTF.text;
    m.userTel = self.TelTF.text;
    
    m.feeType = self.model.feeType;
    m.feeMoney = self.model.feeMoney;
    m.carStatus = self.model.carStatus;
    m.carMoney = self.model.carMoney;
    m.workStatus = self.model.workStatus;
    m.workBeginTime = self.model.workBeginTime;
    m.workMechanism = self.model.workMechanism;
 
    
    [self.ListArray addObject:m];
    [self.tableview reloadData];
    if (self.ListArray.count>0) {
        [self.allBtn setTitle:[NSString stringWithFormat:@"录入完成(%lu)",(unsigned long)self.ListArray.count] forState:UIControlStateNormal];
        self.allBtn.backgroundColor = [UIColor colorWithHexString:@"#3C93FF"];

    }else{
        [self.allBtn setTitle:@"录入完成" forState:UIControlStateNormal];
        self.allBtn.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    }
    [self.alertView close];
}

-(void)TouchClose:(UIButton *)sender{
    [self.alertView close];
}

#pragma mark - fieldTextDidChange
- (void)fieldTextDidChange:(UITextField *)textField{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 5;
    if (textField == self.TelTF) {
        kMaxLength = 11;
    }else if (textField == self.nameTF ){
        kMaxLength = 5;
        if (self.nameTF.text.length == 0) {
            self.saveBtn.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
        }else{
            self.saveBtn.backgroundColor = [UIColor baseColor];
        }
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


#pragma mark - TableViewDelegate & Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LENGTH_SIZE(50);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ListArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWBatchAddWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:LWBatchAddWorkCellID];
    cell.model = self.ListArray[indexPath.row];
    
    WEAK_SELF()
    cell.block = ^(LWWorkRecordListDataModel * _Nonnull m) {
        [weakSelf.ListArray removeObject:m];
        [weakSelf.tableview reloadData];
        if (weakSelf.ListArray.count>0) {
            [weakSelf.allBtn setTitle:[NSString stringWithFormat:@"录入完成(%lu)",(unsigned long)weakSelf.ListArray.count] forState:UIControlStateNormal];
            weakSelf.allBtn.backgroundColor = [UIColor colorWithHexString:@"#3C93FF"];
        }else{
            weakSelf.allBtn.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
            [weakSelf.allBtn setTitle:@"录入完成" forState:UIControlStateNormal];
        }
    };
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [_tableview registerNib:[UINib nibWithNibName:LWBatchAddWorkCellID bundle:nil] forCellReuseIdentifier:LWBatchAddWorkCellID];
    }
    return _tableview;
}

- (CustomIOSAlertView *)alertView{
    if (!_alertView) {
        _alertView = [[CustomIOSAlertView alloc] init];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LENGTH_SIZE(300), LENGTH_SIZE(248))];
        view.backgroundColor = [UIColor whiteColor];
        
        UIButton *closeBtn = [[UIButton alloc] init];
        [view addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(LENGTH_SIZE(11));
            make.right.mas_offset(LENGTH_SIZE(-11));
            make.height.with.mas_offset(LENGTH_SIZE(18));
        }];
        [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(TouchClose:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel =[[UILabel alloc] init];
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.mas_offset(LENGTH_SIZE(22));
        }];
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(18)];
        titleLabel.text = @"员工录入";
        
        UITextField *NameTF = [[UITextField alloc] init];
        self.nameTF = NameTF;
        [view addSubview:NameTF];
        [NameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(LENGTH_SIZE(22));
            make.left.mas_offset(LENGTH_SIZE(20));
            make.right.mas_offset(LENGTH_SIZE(-20));
            make.height.mas_offset(LENGTH_SIZE(40));
        }];
        NameTF.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        NameTF.textAlignment = NSTextAlignmentCenter;
        NameTF.layer.cornerRadius = 6;
        NameTF.font = FONT_SIZE(16);
        NameTF.placeholder = @"请输入员工姓名(必填）";
        [NameTF addTarget:self action:@selector(fieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];

        UITextField *TelTF = [[UITextField alloc] init];
        self.TelTF = TelTF;
        [view addSubview:TelTF];
        [TelTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(NameTF.mas_bottom).offset(LENGTH_SIZE(10));
            make.left.mas_offset(LENGTH_SIZE(20));
            make.right.mas_offset(LENGTH_SIZE(-20));
            make.height.mas_offset(LENGTH_SIZE(40));
        }];
        TelTF.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        TelTF.textAlignment = NSTextAlignmentCenter;
        TelTF.layer.cornerRadius = 6;
        TelTF.font = FONT_SIZE(16);
        TelTF.placeholder = @"请输入员工联系方式";
        TelTF.delegate = self;
        TelTF.keyboardType = UIKeyboardTypeNumberPad;
        [TelTF addTarget:self action:@selector(fieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];

        UIButton *btn = [[UIButton alloc] init];
        [view addSubview:btn];
        self.saveBtn = btn;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(TelTF.mas_bottom).offset(LENGTH_SIZE(24));
            make.left.mas_offset(LENGTH_SIZE(20));
            make.right.mas_offset(LENGTH_SIZE(-20));
            make.height.mas_offset(LENGTH_SIZE(40));
        }];
        btn.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
        btn.layer.cornerRadius = 6;
        btn.titleLabel.font = FONT_SIZE(17);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(Touchsave:) forControlEvents:UIControlEventTouchUpInside];
        _alertView.containerView = view;
        _alertView.buttonTitles=@[];
        [_alertView setUseMotionEffects:true];
        [_alertView setCloseOnTouchUpOutside:true];
    }
    return _alertView;
}


#pragma mark - request
-(void)requestInsertWorkRecordList:(NSMutableArray *)model{
    
//    NSDictionary *dic = @{@"workRecordList":model};
    
    [NetApiManager requestInsertWorkRecordList:model withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"保存成功" time:MESSAGE_SHOW_TIME];
                    for (LWWorkTableView *v in self.superViewArr) {
                        [v GetWorkRecord];
                        [v.tableview reloadData];
                    }
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"保存失败,请稍后再试" time:MESSAGE_SHOW_TIME];
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
