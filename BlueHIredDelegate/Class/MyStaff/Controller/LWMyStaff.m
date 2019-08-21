//
//  LWMyStaff.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWMyStaff.h"
#import "LWMyStaffView.h"
#import "LPMainSortAlertView.h"
#import "LWMyStallCell.h"
#import "LWMyStaffModel.h"
#import "LPMainSearchVC.h"

static NSString *LWMyStallCellID = @"LWMyStallCell";

@interface LWMyStaff ()<LPMainSortAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIButton *TypeBtn;
@property (nonatomic,strong) UIButton *DateBtn;
@property (nonatomic,strong) UIButton *CloseBtn;
@property (nonatomic,strong) UILabel *NumberLabel;

@property(nonatomic,strong) LPMainSortAlertView *sortAlertView;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSMutableArray <LWMyStaffDataModel *>*listArray;
@property (nonatomic,strong) LWMyStaffModel *model;
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSString *DateStr;
@property (nonatomic,strong) NSString *workStatus;

@end

@implementation LWMyStaff

- (void)viewDidLoad {
    [super viewDidLoad];
    self.workStatus = @"0";
    self.DateStr = @"";
    if (self.Type == 0) {
        self.navigationItem.title = @"我的员工";
    }else if (self.Type == 1){
        self.navigationItem.title = @"报名员工管理";
    }

    [self setViewinit];
    self.page = 1;
    [self requestQueryGetStaffList];
}

-(void)setViewinit{
    
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search2"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(clickEvent)];
    self.navigationItem.rightBarButtonItem = myButton;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor baseColor]];
    
    
    UIView *HeadView = [[UIView alloc] init];
    [self.view addSubview:HeadView];
    [HeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(44));
    }];
    
    [HeadView addSubview:self.TypeBtn];
    [HeadView addSubview:self.DateBtn];
    
    UIButton *CloseBtn = [[UIButton alloc] init];
    [HeadView addSubview:CloseBtn];
    self.CloseBtn = CloseBtn;
    [CloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(HeadView);
        make.right.mas_offset(LENGTH_SIZE(-13));
        make.width.mas_offset(LENGTH_SIZE(90));
        make.height.mas_offset(LENGTH_SIZE(22));
    }];
    CloseBtn.backgroundColor = [UIColor colorWithHexString:@"#EBF7FF"];
    [CloseBtn setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [CloseBtn setTitle:@"清空筛选条件" forState:UIControlStateNormal];
    CloseBtn.clipsToBounds = YES;
    CloseBtn.layer.cornerRadius = LENGTH_SIZE(11);
    CloseBtn.titleLabel.font = FONT_SIZE(12);
    [CloseBtn addTarget:self action:@selector(touchCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    CloseBtn.hidden = YES;

    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(HeadView.mas_bottom).offset(0);
        make.left.right.mas_offset(LENGTH_SIZE(0));
        make.bottom.mas_offset(0);
    }];
    
    
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    self.tableview.tableHeaderView = tableHeader;

    UILabel *label = [[UILabel alloc] init];
    [tableHeader addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.right.mas_offset(LENGTH_SIZE(-13));
    }];
    self.NumberLabel = label;
    label.textColor = [UIColor colorWithHexString:@"#999999"];
    label.textAlignment = NSTextAlignmentRight;
    label.font = FONT_SIZE(13);
    label.text = @"人数：0人";
    
}

 #pragma mark Touch
- (void)clickEvent{
    LPMainSearchVC *vc = [[LPMainSearchVC alloc] init];
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)touchCloseBtn:(UIButton *)button{
    
    self.workStatus = @"0";
    [self.TypeBtn setTitle:@"全部员工" forState:UIControlStateNormal];
    
    self.DateStr = @"";
    [_DateBtn setTitle:@"全部月份" forState:UIControlStateNormal];
    [_DateBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    _DateBtn.selected = NO;
    
    button.hidden = YES;
    self.page = 1;
    [self requestQueryGetStaffList];
    
}

-(void)touchScreenButton:(UIButton *)button{
    
    dispatch_async(dispatch_get_main_queue(), ^{
            self.TypeBtn.selected = NO;
            self.sortAlertView.titleArray  = @[@"全部员工",@"在职",@"离职"];
            button.selected = !button.isSelected;
            self.sortAlertView.touchButton = button;
            self.sortAlertView.selectTitle = button.tag;
            self.sortAlertView.hidden = !button.isSelected;
    });
    
}

-(void)touchDateSelect:(UIButton *)sender{
    sender.selected = YES;
    QFDatePickerView *datePickerView = [[QFDatePickerView  alloc]initDatePackerWith:[NSDate date]
                                                                            minDate:[DataTimeTool dateFromString:@"2018-01" DateFormat:@"yyyy-MM"]
                                                                            maxDate:[NSDate date]
                                                                           Response:^(NSString *str) {
                                                                               NSLog(@"str = %@", str);
                                                                               [sender setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
                                                                               [sender setTitle:str forState:UIControlStateNormal];
                                                                               sender.selected = NO;
                                                                               self.DateStr = str;
                                                                               self.page = 1;
                                                                                [self requestQueryGetStaffList];
                                                                           }];
    
    [datePickerView show];
}

#pragma mark - LPMainSortAlertViewDelegate
-(void)touchTableView:(NSInteger)index{

        if (index == 0) {
            self.workStatus = @"0";
            [self.TypeBtn setTitle:@"全部员工" forState:UIControlStateNormal];
        }else if (index == 1){
            self.workStatus = @"1";
            [self.TypeBtn setTitle:@"在职" forState:UIControlStateNormal];
        }else if (index == 2){
            self.workStatus = @"2";
            [self.TypeBtn setTitle:@"离职" forState:UIControlStateNormal];
        }
        self.TypeBtn.tag = index;
        self.page = 1;
        [self requestQueryGetStaffList];
   
    
}



#pragma mark - TableViewDelegate & Datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (self.listArray[indexPath.row].isShow) {
        return LENGTH_SIZE(126);
    }
    return LENGTH_SIZE(66);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWMyStallCell *cell = [tableView dequeueReusableCellWithIdentifier:LWMyStallCellID];
    cell.model = self.listArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (self.listArray[indexPath.row].workStatus.integerValue == 1 ||
//        self.listArray[indexPath.row].workStatus.integerValue == 2) {
        self.listArray[indexPath.row].isShow = !self.listArray[indexPath.row].isShow;
        [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }

}



- (void)setModel:(LWMyStaffModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (model.data.count > 0) {
            self.NumberLabel.text = [NSString stringWithFormat:@"人数：%ld人",(long)model.data[0].num.integerValue];
            
            self.page += 1;
            [self.listArray addObjectsFromArray:model.data];
            [self.tableview reloadData];
            if (model.data.count < 20) {
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
        [_tableview registerNib:[UINib nibWithNibName:LWMyStallCellID bundle:nil] forCellReuseIdentifier:LWMyStallCellID];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
                self.page = 1;
                [self requestQueryGetStaffList];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [self requestQueryGetStaffList];
        }];
        
    }
    return _tableview;
}


-(UIButton *)TypeBtn{
    if (!_TypeBtn) {
        _TypeBtn = [[UIButton alloc]init];
        _TypeBtn.frame = CGRectMake(LENGTH_SIZE(13) , 0,LENGTH_SIZE(85), LENGTH_SIZE(44));
        [_TypeBtn setTitle:@"全部员工" forState:UIControlStateNormal];
        [_TypeBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_TypeBtn setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];
        [_TypeBtn setImage:[UIImage imageNamed:@"drop_down"] forState:UIControlStateNormal];
        [_TypeBtn setImage:[UIImage imageNamed:@"drop_up"] forState:UIControlStateSelected];
        _TypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        _TypeBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(15)];
        _TypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_TypeBtn.imageView.frame.size.width - _TypeBtn.frame.size.width + _TypeBtn.titleLabel.intrinsicContentSize.width, 0,LENGTH_SIZE(27));
        _TypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0,LENGTH_SIZE(55+8) , 0, 0);
        [_TypeBtn addTarget:self action:@selector(touchScreenButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _TypeBtn;
}

-(UIButton *)DateBtn{
    if (!_DateBtn) {
        _DateBtn = [[UIButton alloc]init];
        _DateBtn.frame = CGRectMake(LENGTH_SIZE(104) , 0,LENGTH_SIZE(85),LENGTH_SIZE(44));
        [_DateBtn setTitle:@"全部月份" forState:UIControlStateNormal];
        [_DateBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_DateBtn setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];
        [_DateBtn setImage:[UIImage imageNamed:@"drop_down"] forState:UIControlStateNormal];
        [_DateBtn setImage:[UIImage imageNamed:@"drop_up"] forState:UIControlStateSelected];
        
        _DateBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(15)];
        _DateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        _DateBtn.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                             -_DateBtn.imageView.frame.size.width - _DateBtn.frame.size.width + _DateBtn.titleLabel.intrinsicContentSize.width,
                                                             0,
                                                             LENGTH_SIZE(27));
        
        _DateBtn.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                             LENGTH_SIZE(55+8),
                                                             0,
                                                             0);
        [_DateBtn addTarget:self action:@selector(touchDateSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _DateBtn;
}

-(LPMainSortAlertView *)sortAlertView{
    if (!_sortAlertView) {
        _sortAlertView = [[LPMainSortAlertView alloc]init];
        _sortAlertView.touchButton = self.TypeBtn;
        _sortAlertView.delegate = self;
    }
    return _sortAlertView;
}

#pragma mark request
-(void)requestQueryGetStaffList{
    
    if ([self.DateStr isEqualToString:@""]  && [self.workStatus isEqualToString:@"0"]) {
        self.CloseBtn.hidden = YES;
    }else{
        self.CloseBtn.hidden = NO;
    }
    
    NSDictionary *dic = @{@"page":@(self.page),
                          @"time":self.DateStr,
                          @"workStatus":self.workStatus
                          };
    
    [NetApiManager requestQueryGetStaffList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LWMyStaffModel mj_objectWithKeyValues:responseObject];
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

@end
