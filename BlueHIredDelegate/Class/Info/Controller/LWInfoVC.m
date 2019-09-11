//
//  LWInfoVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/11.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWInfoVC.h"
#import "LPInfoCell.h"
#import "LPInfoListModel.h"
#import "LPInfoDetailVC.h"


static NSString *LPInfoCellID = @"LPInfoCell";

@interface LWInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong) LPInfoListModel *model;
@property (nonatomic, strong) NSMutableArray <LPInfoListDataModel *>*listArray;
@property (nonatomic, strong) NSMutableArray <LPInfoListDataModel *>*selectArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UILabel *NumLabel;
@property (nonatomic, strong) UIButton *AllBtn;
@property (nonatomic, strong) UIView *Deleteview;

@end

@implementation LWInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    self.listArray = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(LENGTH_SIZE(10));
        make.left.right.mas_offset(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.bottom.mas_offset(0);
        }
    }];
    
    [self initDeleteView];
    [self setNavigationButton];
    self.Deleteview.hidden = YES;
    
    self.page = 1;
    [self requestQueryInfolist];

}

-(void)initDeleteView{
    UIView *Deleteview = [[UIView alloc] init];
    [self.view addSubview:Deleteview];
    self.Deleteview = Deleteview;
    [Deleteview  mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.left.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(49));
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.bottom.mas_offset(0);
        }
    }];
    Deleteview.backgroundColor = [UIColor whiteColor];
    
    UIButton *AllBtn = [[UIButton alloc] init];
    self.AllBtn = AllBtn;
    [Deleteview addSubview:AllBtn];
    [AllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_offset(0);
        make.width.mas_offset(LENGTH_SIZE(108));
    }];
    [AllBtn setTitle:@"  全选" forState:UIControlStateNormal];
    [AllBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [AllBtn setImage:[UIImage imageNamed:@"nor"] forState:UIControlStateNormal];
    [AllBtn setImage:[UIImage imageNamed:@"sel"] forState:UIControlStateSelected];
    AllBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(16)];
    [AllBtn addTarget:self action:@selector(TouchAllSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *NumderLabel = [[UILabel alloc] init];
    self.NumLabel = NumderLabel;
    [Deleteview addSubview:NumderLabel];
    [NumderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.equalTo(AllBtn.mas_right).offset(0);
    }];
    NumderLabel.textColor = [UIColor baseColor];
    NumderLabel.font = FONT_SIZE(16);
    NumderLabel.text = @"已选0条";
    
    UIButton *DeleteBtn = [[UIButton alloc] init];
    [Deleteview addSubview:DeleteBtn];
    [DeleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_offset(0);
        make.width.mas_offset(LENGTH_SIZE(100));
    }];
    DeleteBtn.backgroundColor = [UIColor baseColor];
    [DeleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [DeleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    DeleteBtn.titleLabel.font = FONT_SIZE(16);
    [DeleteBtn addTarget:self action:@selector(TouchDelete:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)TouchAllSelect:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.selectArray removeAllObjects];
        [self.selectArray addObjectsFromArray:self.listArray];
        self.NumLabel.text = [NSString stringWithFormat:@"已选%lu条",(unsigned long)self.selectArray.count];
    }else{
        [self.selectArray removeAllObjects];
        self.NumLabel.text = @"已选0条";;
    }

    [self.tableview reloadData];
    
}

-(void)TouchDelete:(UIButton *)sender{
    [self requestDelInfos];
}

-(void)setNavigationButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(touchManagerButton)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor baseColor]];
}

-(void)touchManagerButton{
    if (self.Deleteview.hidden) {
        self.Deleteview.hidden = NO;
        [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
        [self.selectArray removeAllObjects];
        self.NumLabel.text = @"已选0条";;
        self.AllBtn.selected = NO;
    }else{
        self.Deleteview.hidden = YES;
        [self.navigationItem.rightBarButtonItem setTitle:@"删除"];
    }
    [self.tableview reloadData];

}


-(void)setModel:(LPInfoListModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data];
            [self.tableview reloadData];
            if (self.model.data.count < 20) {
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
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
        
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}

-(void)addNodataViewHidden:(BOOL)hidden{
    BOOL has = NO;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectZero];
        [noDataView image:[UIImage imageNamed:@"No_news"] text:@"抱歉！没有新的消息！"];
        [self.view addSubview:noDataView];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        noDataView.hidden = hidden;
    }
}


#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:LPInfoCellID];
    cell.model = self.listArray[indexPath.row];
    cell.selectStatus = !self.Deleteview.hidden;
    if ([self.selectArray containsObject:cell.model]) {
        cell.selectButton.selected = YES;
    }else{
        cell.selectButton.selected = NO;
    }
    
    WEAK_SELF()
    cell.selectBlock = ^(LPInfoListDataModel * _Nonnull model) {
        if ([weakSelf.selectArray containsObject:model]) {
            [weakSelf.selectArray removeObject:model];
        }else{
            [weakSelf.selectArray addObject:model];
        }
        
        weakSelf.NumLabel.text = [NSString stringWithFormat:@"已选%lu条",(unsigned long)self.selectArray.count];

        if (weakSelf.selectArray.count == weakSelf.listArray.count){
            self.AllBtn.selected = YES;
        }else{
             self.AllBtn.selected = NO;
        }
    };
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.Deleteview.hidden) {
        LPInfoListDataModel *modelData = self.listArray[indexPath.row];
        modelData.status = @(1);
        [self.tableview reloadData];
        LPInfoDetailVC *vc = [[LPInfoDetailVC alloc]init];
        vc.model = modelData;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }

    
}
#pragma mark - request
-(void)requestQueryInfolist{
    NSDictionary *dic = @{@"page":@(self.page)
                          };
    [NetApiManager requestQueryInfolistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPInfoListModel mj_objectWithKeyValues:responseObject];
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestDelInfos{
    NSMutableArray *array = [NSMutableArray array];
    for (LPInfoListDataModel *model in self.selectArray) {
        [array addObject:model.id];
    }
    NSString *string = [array componentsJoinedByString:@","];
    NSDictionary *dic = @{@"status":self.selectArray.count == self.listArray.count ?@"1":@"2",
                          @"infoId":string
                          };
    [NetApiManager requestDelInfosWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [self.listArray removeObjectsInArray:self.selectArray];
                    [self.tableview reloadData];
                    [self.selectArray removeAllObjects];
                    [[UIWindow visibleViewController].view showLoadingMeg:@"删除成功" time:MESSAGE_SHOW_TIME];
                    if (self.listArray.count == 0) {
                        [self addNodataViewHidden:NO];
                    }else{
                        [self addNodataViewHidden:YES];
                    }
                }else{
                    [[UIWindow visibleViewController].view showLoadingMeg:@"删除失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPInfoCellID bundle:nil] forCellReuseIdentifier:LPInfoCellID];
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            if (self.Deleteview.hidden) {
                self.page = 1;
                [self requestQueryInfolist];
            }else{
                [self.tableview.mj_header endRefreshing];
            }
            
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.Deleteview.hidden) {
                [self requestQueryInfolist];
            }else{
                [self.tableview.mj_footer endRefreshing];
            }
        }];
    }
    return _tableview;
}




@end
