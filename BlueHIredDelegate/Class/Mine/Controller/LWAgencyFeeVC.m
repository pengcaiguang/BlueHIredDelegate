//
//  LWAgencyFeeVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/16.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWAgencyFeeVC.h"
#import "LWAgencyFeeCell.h"
#import "LWAgencyFeeModel.h"
static NSString *LWAgencyFeeCellID = @"LWAgencyFeeCell";

@interface LWAgencyFeeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) UIButton *timeButton;
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) LWAgencyFeeModel *model;
@property (nonatomic,strong) NSMutableArray <LWAgencyFeeDataModel *>*listArray;

@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;

@end

@implementation LWAgencyFeeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.Type == 0) {
        self.navigationItem.title = @"代理费明细";
    }else if (self.Type == 1){
        self.navigationItem.title = @"个人业绩";
    }else if (self.Type == 2){
        self.navigationItem.title = @"业绩详情";
    }

    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.currentDateString  = [DataTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM"];
    [self setupUI];
    
    self.page = 1;
    [self requestQueryGetPerDetailList];
    
}


-(void)setupUI{
//    UIView *bgView = [[UIView alloc]init];
//    [self.view addSubview:bgView];
//    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.top.mas_equalTo(0);
//        make.height.mas_equalTo(LENGTH_SIZE(0));
//    }];
//    bgView.backgroundColor = [UIColor baseColor];
//    bgView.clipsToBounds = YES;
//
//
//    self.timeButton = [[UIButton alloc]init];
//    [bgView addSubview:self.timeButton];
//
//    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(bgView);
//    }];
//    self.timeButton.titleLabel.font = FONT_SIZE(16);
//    [self.timeButton setTitle:self.currentDateString forState:UIControlStateNormal];
//    [self.timeButton addTarget:self action:@selector(chooseMonth) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *leftImgView = [[UIButton alloc]init];
//    [bgView addSubview:leftImgView];
//    self.leftButton = leftImgView;
//
//    [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(LENGTH_SIZE(44), LENGTH_SIZE(44)));
//        make.centerY.equalTo(self.timeButton);
//        make.right.equalTo(self.timeButton.mas_left).offset(-10);
//    }];
//    [leftImgView setImage:[UIImage imageNamed:@"account_left"] forState:UIControlStateNormal];
//    leftImgView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [leftImgView addTarget:self action:@selector(TouchLeftBt:) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *rightImgView = [[UIButton alloc]init];
//    [bgView addSubview:rightImgView];
//    self.rightButton = rightImgView;
//
//    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(LENGTH_SIZE(44), LENGTH_SIZE(44)));
//        make.centerY.equalTo(self.timeButton);
//        make.left.equalTo(self.timeButton.mas_right).offset(10);
//    }];
//    [rightImgView setImage:[UIImage imageNamed:@"account_right"] forState:UIControlStateNormal];
//    rightImgView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [rightImgView addTarget:self action:@selector(TouchrightBt:) forControlEvents:UIControlEventTouchUpInside];
//
    UILabel *Income = [[UILabel alloc] init];
    [self.view addSubview:Income];
    [Income mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(LENGTH_SIZE(0));
        make.left.mas_offset(LENGTH_SIZE(13));
        make.height.mas_offset(LENGTH_SIZE(10));
    }];
    Income.textColor = [UIColor colorWithHexString:@"#999999"];
    Income.font = FONT_SIZE(13);
 
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(Income.mas_bottom);
    }];
}
//
//-(void)TouchLeftBt:(UIButton *)sender{
//
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSCalendarUnit unit = NSCalendarUnitMonth;//只比较天数差异
//    NSDateComponents *delta = [calendar components:unit fromDate:[DataTimeTool dateFromString:self.currentDateString DateFormat:@"yyyy-MM"] toDate:[DataTimeTool dateFromString:@"2018-01" DateFormat:@"yyyy-MM"] options:0];
//
//
//    if (delta.month>=0) {
//        return;
//    }
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM"];
//    NSDate *date = [dateFormatter dateFromString:self.currentDateString];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [comps setMonth:-1];
//    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDate *StartDate = [calender dateByAddingComponents:comps toDate:date options:0];
//    self.currentDateString = [dateFormatter stringFromDate:StartDate];
//    [self.timeButton setTitle:self.currentDateString forState:UIControlStateNormal];
//        [self requestQuerySalarylist];
//}
//
//-(void)TouchrightBt:(UIButton *)sender{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSCalendarUnit unit = NSCalendarUnitMonth;//只比较天数差异
//    NSDateComponents *delta = [calendar components:unit fromDate:[DataTimeTool dateFromString:self.currentDateString DateFormat:@"yyyy-MM"] toDate:[NSDate date] options:0];
//
//
//    if (delta.month<=0) {
//        return;
//    }
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM"];
//    NSDate *date = [dateFormatter dateFromString:self.currentDateString];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [comps setMonth:1];
//    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDate *StartDate = [calender dateByAddingComponents:comps toDate:date options:0];
//    self.currentDateString = [dateFormatter stringFromDate:StartDate];
//    [self.timeButton setTitle:self.currentDateString forState:UIControlStateNormal];
//        [self requestQuerySalarylist];
//}
//
//-(void)chooseMonth{
//
//    NSComparisonResult sCOM= [[NSDate date] compare:[DataTimeTool dateFromString:@"2018-01" DateFormat:@"yyyy-MM"]];
//
//    if (sCOM == NSOrderedAscending) {
//
//        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"系统时间不对,请前往设置修改时间" message:nil textAlignment:0 buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
//
//            [self.navigationController popViewControllerAnimated:YES];
//
//        }];
//        [alert show];
//        return;
//    }
//
//    QFDatePickerView *datePickerView = [[QFDatePickerView  alloc]initDatePackerWith:[DataTimeTool dateFromString:self.currentDateString DateFormat:@"yyyy-MM"]
//                                                                            minDate:[DataTimeTool dateFromString:@"2018-01" DateFormat:@"yyyy-MM"]
//                                                                            maxDate:[NSDate date]
//                                                                           Response:^(NSString *str) {
//                                                                               NSLog(@"str = %@", str);
//                                                                               [self.timeButton setTitle:str forState:UIControlStateNormal];
//                                                                               self.currentDateString = self.timeButton.titleLabel.text;
//                                                                                                                                                              [self requestQuerySalarylist];
//                                                                           }];
//
//    [datePickerView show];
//
//}

#pragma mark - TableViewDelegate & Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWAgencyFeeDataModel *m = self.listArray[indexPath.row];
    CGFloat height = [self calculateRowHeight:[self PinDetailText:m] fontSize:FontSize(13) Width:SCREEN_WIDTH - LENGTH_SIZE(26)];
    if (m.isShow) {
        return LENGTH_SIZE(50+16)+height;
    }
    return LENGTH_SIZE(50);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWAgencyFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:LWAgencyFeeCellID];
    cell.model = self.listArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.listArray[indexPath.row].isShow = !self.listArray[indexPath.row].isShow;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

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
        [_tableview registerNib:[UINib nibWithNibName:LWAgencyFeeCellID bundle:nil] forCellReuseIdentifier:LWAgencyFeeCellID];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestQueryGetPerDetailList];
        }];
        
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestQueryGetPerDetailList];
        }];
    }
    return _tableview;
}



- (void)setModel:(LWAgencyFeeModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:model.data];
            [self.tableview reloadData];
            if (model.data.count < 20) {
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
                self.tableview.mj_footer.hidden = self.listArray.count<20?YES:NO;
            }
        }else{
            if (self.page == 1) {
                [self.tableview reloadData];
            }else{
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        if (self.listArray.count == 0) {
            self.tableview.mj_footer.alpha = 0;
            [self addNodataViewHidden:NO];
        }else{
            self.tableview.mj_footer.alpha = 1;
            [self addNodataViewHidden:YES];
        }
    }else{
        [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}



-(void)addNodataViewHidden:(BOOL)hidden {
    BOOL has = NO;
    LPNoDataView *noDataView ;
    for (UIView *view in self.tableview.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            noDataView = (LPNoDataView *)view;
            has = YES;
        }
    }
    if (!has) {
        noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableview.frame.size.height)];
        [noDataView image:nil text:@"没有数据记录~"];
        noDataView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        
        [self.tableview addSubview:noDataView];
        noDataView.hidden = hidden;
    }
    
}



#pragma mark - request
-(void)requestQueryGetPerDetailList{
    NSDictionary *dic = @{@"page":@(self.page),
                          @"time":self.currentDateString,
                          @"userId":self.ListModel.userId
                          };
    
    [NetApiManager requestQueryGetPerDetailList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LWAgencyFeeModel mj_objectWithKeyValues:responseObject];
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize Width:(CGFloat) W
{
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle01.lineSpacing = LENGTH_SIZE(6);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paraStyle01};
    /*计算高度要先指定宽度*/
    CGRect rect = [string boundingRectWithSize:CGSizeMake(W, 0) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return ceil(rect.size.height);
    
}

- (NSString *)PinDetailText:(LWAgencyFeeDataModel *) m{
    NSString *Str = [NSString stringWithFormat:@"身份证号：%@\n入职企业：%@\n入职日期：%@      离职日期：%@\n%@\n%@\n%@%.2f%@       %@%ld%@",
                     m.staffCardNumber,
                     m.mechanismName,
                     m.workBeginTime,
                     m.workEndTime.length>0?m.workEndTime:@"-",
                     m.postType.integerValue == 1?[NSString stringWithFormat:@"平台所设管理费：%.2f元/时",m.manageMoney.floatValue]:[NSString stringWithFormat:@"平台所设管理费：%.2f元/月",m.manageMoney.floatValue],
                     m.postType.integerValue == 1?[NSString stringWithFormat:@"员工所得返费：%.2f元/时",m.reMoney.floatValue]:[NSString stringWithFormat:@"员工所得返费：%.2f元/月",m.reMoney.floatValue],
                     m.postType.integerValue == 1?@"提成单价：":@"提成基数：",
                     m.postType.integerValue == 1?m.commissionPrize.floatValue:m.commissionBase.floatValue,
                     m.postType.integerValue == 1?@"元/小时":@"元",
                     m.postType.integerValue == 1?@"计费工时：":@"计费天数：",
                     (long)(m.postType.integerValue == 1?m.workTime.integerValue:m.workDay.integerValue),
                     m.postType.integerValue == 1?@"小时":@"天"];
    
    NSArray *SubArr = [m.subsidyContent componentsSeparatedByString:@";"];
    for (NSString *ArrStr in SubArr) {
        if (ArrStr.length>0) {
            Str = [NSString stringWithFormat:@"%@\n%@元",Str,[ArrStr stringByReplacingOccurrencesOfString:@"-" withString:@"："]];
        }
    }
    
    return Str;
}


@end
