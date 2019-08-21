//
//  LWAccountDetailsVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/11.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWAccountDetailsVC.h"
#import "LWAccountDetailsCell.h"
#import "LWWithdrawDetailsVC.h"
#import "LPBillrecordModel.h"
#import "LWWithDraw2DetailsVC.h"

static NSString *LWAccountDetailsCellID = @"LWAccountDetailsCell";

@interface LWAccountDetailsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIButton *timeButton;
@property(nonatomic,strong) NSString *currentDateString;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) LPBillrecordModel *model;
@property(nonatomic,strong) NSMutableArray <LPBillrecordDataModel *>*listArray;

@property (nonatomic,strong) UILabel *Income;
@property (nonatomic,strong) UILabel *Withdraw;

@end

@implementation LWAccountDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账户明细";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.currentDateString  = [DataTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM"];
    [self setupUI];
    self.page = 1;
    [self requestQueryBillrecord];
}


-(void)setupUI{
    UIView *bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(LENGTH_SIZE(44));
    }];
    bgView.backgroundColor = [UIColor baseColor];
    
    //    UIImageView *imgView = [[UIImageView alloc]init];
    //    [bgView addSubview:imgView];
    //    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(14);
    //        make.centerY.equalTo(bgView);
    //        make.size.mas_equalTo(CGSizeMake(19, 20));
    //    }];
    //    imgView.image = [UIImage imageNamed:@"calendar"];
    
    self.timeButton = [[UIButton alloc]init];
    [bgView addSubview:self.timeButton];
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgView);
    }];
    self.timeButton.titleLabel.font = FONT_SIZE(16);
    [self.timeButton setTitle:self.currentDateString forState:UIControlStateNormal];
    [self.timeButton addTarget:self action:@selector(chooseMonth) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *leftImgView = [[UIButton alloc]init];
    [bgView addSubview:leftImgView];
    self.leftButton = leftImgView;

    [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(LENGTH_SIZE(44), LENGTH_SIZE(44)));
        make.centerY.equalTo(self.timeButton);
        make.right.equalTo(self.timeButton.mas_left).offset(-10);
    }];
    [leftImgView setImage:[UIImage imageNamed:@"account_left"] forState:UIControlStateNormal];
    leftImgView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [leftImgView addTarget:self action:@selector(TouchLeftBt:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightImgView = [[UIButton alloc]init];
    [bgView addSubview:rightImgView];
    self.rightButton = rightImgView;

    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(LENGTH_SIZE(44), LENGTH_SIZE(44)));
        make.centerY.equalTo(self.timeButton);
        make.left.equalTo(self.timeButton.mas_right).offset(10);
    }];
    [rightImgView setImage:[UIImage imageNamed:@"account_right"] forState:UIControlStateNormal];
    rightImgView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [rightImgView addTarget:self action:@selector(TouchrightBt:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *Income = [[UILabel alloc] init];
    [self.view addSubview:Income];
    self.Income = Income;
    [Income mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(0);
        make.left.mas_offset(LENGTH_SIZE(13));
        make.height.mas_offset(LENGTH_SIZE(36));
    }];
    Income.textColor = [UIColor colorWithHexString:@"#999999"];
    Income.font = FONT_SIZE(13);
    Income.text = @"总收入：0.0元";
    
    
    UILabel *Withdraw = [[UILabel alloc] init];
    [self.view addSubview:Withdraw];
    self.Withdraw = Withdraw;

    [Withdraw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(0);
        make.right.mas_offset(LENGTH_SIZE(-13));
        make.height.mas_offset(LENGTH_SIZE(36));
    }];
    Withdraw.textColor = [UIColor colorWithHexString:@"#999999"];
    Withdraw.font = FONT_SIZE(13);
    Withdraw.text = @"总提现：0.0元";
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(Withdraw.mas_bottom);
    }];
}

-(void)TouchLeftBt:(UIButton *)sender{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitMonth;//只比较天数差异
    NSDateComponents *delta = [calendar components:unit fromDate:[DataTimeTool dateFromString:self.currentDateString DateFormat:@"yyyy-MM"] toDate:[DataTimeTool dateFromString:@"2018-01" DateFormat:@"yyyy-MM"] options:0];
    
    
    if (delta.month>=0) {
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [dateFormatter dateFromString:self.currentDateString];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:-1];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *StartDate = [calender dateByAddingComponents:comps toDate:date options:0];
    self.currentDateString = [dateFormatter stringFromDate:StartDate];
    [self.timeButton setTitle:self.currentDateString forState:UIControlStateNormal];
    self.page = 1;
    [self requestQueryBillrecord];
}

-(void)TouchrightBt:(UIButton *)sender{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitMonth;//只比较天数差异
    NSDateComponents *delta = [calendar components:unit fromDate:[DataTimeTool dateFromString:self.currentDateString DateFormat:@"yyyy-MM"] toDate:[NSDate date] options:0];
    
    
    if (delta.month<=0) {
        return;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [dateFormatter dateFromString:self.currentDateString];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *StartDate = [calender dateByAddingComponents:comps toDate:date options:0];
    self.currentDateString = [dateFormatter stringFromDate:StartDate];
    [self.timeButton setTitle:self.currentDateString forState:UIControlStateNormal];
    
    self.page = 1;
    [self requestQueryBillrecord];
}

-(void)chooseMonth{
    
    NSComparisonResult sCOM= [[NSDate date] compare:[DataTimeTool dateFromString:@"2018-01" DateFormat:@"yyyy-MM"]];
    
    if (sCOM == NSOrderedAscending) {
        
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"系统时间不对,请前往设置修改时间" message:nil textAlignment:0 buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        [alert show];
        return;
    }
    
    QFDatePickerView *datePickerView = [[QFDatePickerView  alloc]initDatePackerWith:[DataTimeTool dateFromString:self.currentDateString DateFormat:@"yyyy-MM"]
                                                                            minDate:[DataTimeTool dateFromString:@"2018-01" DateFormat:@"yyyy-MM"]
                                                                            maxDate:[NSDate date]
                                                                           Response:^(NSString *str) {
                                                                               NSLog(@"str = %@", str);
                                                                               [self.timeButton setTitle:str forState:UIControlStateNormal];
                                                                               self.currentDateString = self.timeButton.titleLabel.text;
                                                                                self.page = 1;
                                                                               [self requestQueryBillrecord];
                                                                           }];
    
    [datePickerView show];
 
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWAccountDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:LWAccountDetailsCellID];
    cell.model = self.listArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.listArray[indexPath.row].billType.integerValue == 2) {
        LWWithdrawDetailsVC *vc = [[LWWithdrawDetailsVC alloc]init];
        vc.DrawID = self.listArray[indexPath.row].id;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        LWWithDraw2DetailsVC *vc = [[LWWithDraw2DetailsVC alloc] init];
        vc.DrawID = self.listArray[indexPath.row].id;
        [self.navigationController pushViewController:vc animated:YES];
    }

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
        [_tableview registerNib:[UINib nibWithNibName:LWAccountDetailsCellID bundle:nil] forCellReuseIdentifier:LWAccountDetailsCellID];
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestQueryBillrecord];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestQueryBillrecord];
        }];
        
        
        
    }
    return _tableview;
}





- (void)setModel:(LPBillrecordModel *)model{
    _model = model;
    if ([self.model.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data];
            [self.tableview reloadData];
            if (model.data.count <20) {
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            if (self.page == 1) {
                [self.tableview reloadData];
            }else{
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        if (self.listArray.count == 0) {
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
        
        if (self.listArray.count>0) {
            LPBillrecordDataModel *m = self.listArray[0];
            self.Income.text = [NSString stringWithFormat:@"总收入：%.2f元",m.allMoney.floatValue];
            self.Withdraw.text =[NSString stringWithFormat:@"总提现：%.2f元",m.billMoney.floatValue];

        }
        
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
    
}
-(void)addNodataViewHidden:(BOOL)hidden{
    BOOL has = NO;
    for (UIView *view in self.tableview.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableview.frame.size.height)];
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        [self.tableview addSubview:noDataView];
     
        noDataView.hidden = hidden;
    }
}



#pragma mark - request
-(void)requestQueryBillrecord{
    self.leftButton.enabled = YES;
    self.rightButton.enabled = YES;
    if ([self.currentDateString isEqualToString:[DataTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM"]]) {
        self.rightButton.enabled = NO;
    }else if ([self.currentDateString isEqualToString:@"2018-01"]){
        self.leftButton.enabled = NO;
    }
    
    
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"time":self.currentDateString
                          };
    [NetApiManager requestQueryBillrecordWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPBillrecordModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

@end
