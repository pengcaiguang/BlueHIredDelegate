//
//  LWStoreWorkDetailsVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWStoreWorkDetailsVC.h"
#import "LWStoreWorkDetailsCell.h"
#import "LWShopWorkDetailModel.h"
static NSString *LWStoreWorkDetailsCellID = @"LWStoreWorkDetailsCell";


@interface LWStoreWorkDetailsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray <UILabel *> *LabelArr;
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) UIButton *DateBtn;
@property (nonatomic,strong) UIButton *CloseBtn;
@property (nonatomic,strong) NSMutableArray <LWShopWorkDetailDataModel *>*listArray;
@property (nonatomic,strong) LWShopWorkDetailModel *model;
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSString *DateStr;

@end

@implementation LWStoreWorkDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"门店招工详情";
    self.DateStr = @"";
    
    [self setViewInit];
    self.page = 1;
    if (kAppDelegate.userMaterialModel.data.shopType.integerValue == 2) {
        [self requestQueryShopWorkDetailV2];
    }else{
        [self requestQueryShopWorkDetail];
    }
    
    
}


-(void)setViewInit{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    UIView *headView = [[UIView alloc] init];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(44));
    }];
    headView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:self.DateBtn];
    
    UIButton *CloseBtn = [[UIButton alloc] init];
    [headView addSubview:CloseBtn];
    self.CloseBtn = CloseBtn;
    [CloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView);
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
    
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(33))];
    
    self.LabelArr = [[NSMutableArray alloc] init];
    NSArray *Title = @[@"店员",@"员工人数"];
    for (NSInteger i = 0 ;i <2 ; i++) {
        UILabel *label = [[UILabel alloc] init];
        [titleView addSubview:label];
        [self.LabelArr addObject:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(LENGTH_SIZE(36));
            make.top.mas_offset(LENGTH_SIZE(0));
        }];
        label.text = Title[i];
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = FONT_SIZE(13);
        label.tag = i ;
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    [self.LabelArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    UIView *BottomView = [[UIView alloc] init];
    [self.view addSubview:BottomView];
    [BottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.bottom.mas_offset(0);
        }
        make.left.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(0));
    }];
    BottomView.backgroundColor = [UIColor whiteColor];
    BottomView.clipsToBounds = YES;
    UILabel *CountTitle = [[UILabel alloc] init];
    [BottomView addSubview:CountTitle];
    [CountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(BottomView);
        make.left.mas_offset(LENGTH_SIZE(13));
    }];
    CountTitle.textColor = [UIColor colorWithHexString:@"#333333"];
    CountTitle.font = FONT_SIZE(16);
    CountTitle.text = @"门店人数总计：";
    
    UILabel *number = [[UILabel alloc] init];
    [BottomView addSubview:number];
    self.numberLabel = number;
    [number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(BottomView);
        make.left.equalTo(CountTitle.mas_right).offset(0) ;
    }];
    number.textColor = [UIColor baseColor];
    number.font = [UIFont boldSystemFontOfSize:FontSize(18)];
    number.text = @"0人";
    
    
    UILabel *prompt = [[UILabel alloc] init];
    [BottomView addSubview:prompt];
    [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(BottomView);
        make.left.equalTo(number.mas_right).offset(LENGTH_SIZE(13)) ;
    }];
    prompt.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
    prompt.font = FONT_SIZE(14);
    prompt.text = @"";
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(BottomView.mas_top);
        make.top.mas_offset(LENGTH_SIZE(44));
    }];
    
    self.tableview.tableHeaderView = titleView;
    
}
-(void)touchCloseBtn:(UIButton *)button{
    self.DateStr = @"";
    [self.DateBtn setTitle:@"全部月份" forState:UIControlStateNormal];
    [self.DateBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    button.hidden = YES;
    self.page =1 ;
    
    if (kAppDelegate.userMaterialModel.data.shopType.integerValue == 2) {
        [self requestQueryShopWorkDetailV2];
    }else{
        [self requestQueryShopWorkDetail];
    }
}

#pragma mark - TableViewDelegate & Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LENGTH_SIZE(50);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWStoreWorkDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:LWStoreWorkDetailsCellID];
    cell.model = self.listArray[indexPath.row];
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
        [_tableview registerNib:[UINib nibWithNibName:LWStoreWorkDetailsCellID bundle:nil] forCellReuseIdentifier:LWStoreWorkDetailsCellID];
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            if (kAppDelegate.userMaterialModel.data.shopType.integerValue == 2) {
                [self requestQueryShopWorkDetailV2];
            }else{
                [self requestQueryShopWorkDetail];
            }
        }];
        
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (kAppDelegate.userMaterialModel.data.shopType.integerValue == 2) {
                [self requestQueryShopWorkDetailV2];
            }else{
                [self requestQueryShopWorkDetail];
            }
        }];
        
    }
    return _tableview;
}


-(UIButton *)DateBtn{
    if (!_DateBtn) {
        _DateBtn = [[UIButton alloc]init];
        _DateBtn.frame = CGRectMake(LENGTH_SIZE(13) , 0,LENGTH_SIZE(85),LENGTH_SIZE(44));
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

-(void)touchDateSelect:(UIButton *)sender{
    QFDatePickerView *datePickerView = [[QFDatePickerView  alloc]initDatePackerWith:[NSDate date]
                                                                            minDate:[DataTimeTool dateFromString:@"2018-01" DateFormat:@"yyyy-MM"]
                                                                            maxDate:[NSDate date]
                                                                           Response:^(NSString *str) {
                                                                               NSLog(@"str = %@", str);
                                                                               [sender setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
                                                                               [sender setTitle:str forState:UIControlStateNormal];
                                                                               self.DateStr = str;
                                                                               self.page = 1;                                                         if (kAppDelegate.userMaterialModel.data.shopType.integerValue == 2) {
                                                                                   [self requestQueryShopWorkDetailV2];
                                                                               }else{
                                                                                   [self requestQueryShopWorkDetail];
                                                                               }
                                                                               self.CloseBtn.hidden = NO;
                                                                           }];
    
    [datePickerView show];
}




- (void)setModel:(LWShopWorkDetailModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
        
        self.LabelArr[0].text = [NSString stringWithFormat:@"店员(%@人)",model.data.shopUserNum];
        self.LabelArr[1].text = [NSString stringWithFormat:@"员工人数(%@人)",model.data.shopWorkNum];
        self.numberLabel.text = [NSString stringWithFormat:@"%ld人",model.data.shopUserNum.integerValue + model.data.shopWorkNum.integerValue +1];
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (model.data.shopWorkDetailList.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:model.data.shopWorkDetailList];
            [self.tableview reloadData];
            if (model.data.shopWorkDetailList.count < 20) {
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



#pragma mark request
-(void)requestQueryShopWorkDetail{
    
    NSDictionary *dic = @{@"page":@(self.page),
                          @"time":self.DateStr
                          };
    
    [NetApiManager requestQueryShopWorkDetail:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LWShopWorkDetailModel mj_objectWithKeyValues:responseObject];
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryShopWorkDetailV2{
    
    NSDictionary *dic = @{@"page":@(self.page),
                          @"time":self.DateStr
                          };
    
    [NetApiManager requestQueryShopWorkDetailV2:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LWShopWorkDetailModel mj_objectWithKeyValues:responseObject];
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



@end
