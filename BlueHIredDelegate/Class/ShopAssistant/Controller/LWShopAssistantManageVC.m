//
//  LWShopAssistantManageVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWShopAssistantManageVC.h"
#import "LWShopAssistantManageModel.h"
#import "LWShopAssistantCell.h"
#import "LWAddShopVC.h"
#import "LWInvitedRecordVC.h"

static NSString *LWShopAssistantCellID = @"LWShopAssistantCell";

@interface LWShopAssistantManageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray <LWShopAssistantManageDataModel *>*listArray;
@property (nonatomic,strong) LWShopAssistantManageModel *model;

@end

@implementation LWShopAssistantManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"店员管理";
    [self setViewinit];

    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"邀请记录"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(clickEvent)];
    self.navigationItem.rightBarButtonItem = myButton;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor baseColor]];
    
    self.page = 1;
    [self requestQueryGetShopUser];
    
}

- (void)clickEvent{
    LWInvitedRecordVC *vc = [[LWInvitedRecordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setViewinit{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    UIButton *AddShop = [[UIButton alloc] init];
    [self.view addSubview:AddShop];
    [AddShop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(48));
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.bottom.mas_offset(0);
        }
    }];
    AddShop.backgroundColor = [UIColor baseColor];
    [AddShop setTitle:@"  店员邀请" forState:UIControlStateNormal];
    [AddShop setImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
    [AddShop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    AddShop.titleLabel.font = FONT_SIZE(17);
    [AddShop addTarget:self action:@selector(TouchAddShop:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(AddShop.mas_top).offset(0);
        make.top.mas_equalTo(LENGTH_SIZE(10));
    }];
    
}


-(void)TouchAddShop:(UIButton *)sender{
    LWAddShopVC *vc = [[LWAddShopVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - TableViewDelegate & Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWShopAssistantManageDataModel *m = self.listArray[indexPath.row];
    if (m.isShow) {
        return LENGTH_SIZE(100);
    }
    return LENGTH_SIZE(50);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWShopAssistantCell *cell = [tableView dequeueReusableCellWithIdentifier:LWShopAssistantCellID];
    cell.model = self.listArray[indexPath.row];
    
    WEAK_SELF()
    cell.Block = ^(LWShopAssistantManageDataModel * _Nonnull m) {
        [weakSelf requestQuerydismissShopuser:m];
    };
    
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
        [_tableview registerNib:[UINib nibWithNibName:LWShopAssistantCellID bundle:nil] forCellReuseIdentifier:LWShopAssistantCellID];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestQueryGetShopUser];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestQueryGetShopUser];
        }];
        
    }
    return _tableview;
}

-(void)setModel:(LWShopAssistantManageModel *)model{
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
        [noDataView image:nil text:nil];
        [self.view addSubview:noDataView];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(LENGTH_SIZE(-48));
            } else {
                make.bottom.mas_offset(LENGTH_SIZE(-48));
            }
        }];
        noDataView.hidden = hidden;
    }
}


#pragma mark - request
-(void)requestQueryGetShopUser{
    
    NSDictionary *dic = @{@"page":@(self.page)};
    
    [NetApiManager requestQueryGetShopUser:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LWShopAssistantManageModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestQuerydismissShopuser:(LWShopAssistantManageDataModel *) M{
    
    
    NSDictionary *dic = @{@"id":M.id
                          };
    [NetApiManager requestQuerydismissShopuser:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0  ) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [self.view showLoadingMeg:@"辞退成功" time:MESSAGE_SHOW_TIME];
                    [self.listArray removeObject:M];
                    [self.tableview reloadData];
                }else{
                    [self.view showLoadingMeg:@"辞退失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



@end
