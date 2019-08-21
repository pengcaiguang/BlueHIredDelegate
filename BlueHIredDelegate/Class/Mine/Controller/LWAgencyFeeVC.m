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
@property (nonatomic,strong) NSString *currentDateString;
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
    self.listArray = [[NSMutableArray alloc] init];
    for (int i= 0 ; i<5; i++) {
        LWAgencyFeeDataModel *m = [[LWAgencyFeeDataModel alloc] init];
        [_listArray addObject:m];
    }
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
    [Income mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(0);
        make.left.mas_offset(LENGTH_SIZE(13));
        make.height.mas_offset(LENGTH_SIZE(36));
    }];
    Income.textColor = [UIColor colorWithHexString:@"#999999"];
    Income.font = FONT_SIZE(13);
    if (self.Type == 0) {
        Income.text = @"代理费总计：0.0元";
    }else if (self.Type == 1){
        Income.text = @"总业绩：0.0元";
    }else if (self.Type == 2){
        Income.text = @"总业绩：0.0元";
    }
 
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(Income.mas_bottom);
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
        [self requestQuerySalarylist];
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
        [self requestQuerySalarylist];
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
                                                                                                                                                              [self requestQuerySalarylist];
                                                                           }];
    
    [datePickerView show];
    
}

#pragma mark - TableViewDelegate & Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWAgencyFeeDataModel *m = self.listArray[indexPath.row];
    if (m.isShow) {
        return LENGTH_SIZE(130);
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
    }
    return _tableview;
}

#pragma mark - request
-(void)requestQuerySalarylist{
    self.leftButton.enabled = YES;
    self.rightButton.enabled = YES;
    if ([self.currentDateString isEqualToString:[DataTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM"]]) {
        self.rightButton.enabled = NO;
    }else if ([self.currentDateString isEqualToString:@"2018-01"]){
        self.leftButton.enabled = NO;
    }
}

@end
