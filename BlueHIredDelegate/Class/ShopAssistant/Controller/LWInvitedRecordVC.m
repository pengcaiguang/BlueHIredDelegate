//
//  LWInvitedRecordVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWInvitedRecordVC.h"
#import "LWInvitedRecordCell.h"
#import "LWShopAssistantManageModel.h"


static NSString *LWInvitedRecordCellID = @"LWInvitedRecordCell";
@interface LWInvitedRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray <LWShopAssistantManageDataModel *>*listArray;
@property (nonatomic, strong) LWShopAssistantManageModel *model;

@end

@implementation LWInvitedRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邀请记录";
    UIBarButtonItem *RightBar = [[UIBarButtonItem alloc] initWithTitle:@"清空已处理"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(touchClose)];
    self.navigationItem.rightBarButtonItem = RightBar;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor baseColor]];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.page = 1;
    [self requestQueryHandleShopUser];
    
}

-(void)touchClose{
    NSString *str1 = [NSString stringWithFormat:@"温馨提示\n\n确定清空已处理的邀请记录？"];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor baseColor] range:[str1 rangeOfString:@"白婷婷"]];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FontSize(17)] range:NSMakeRange(0,4)];
    
    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil IsShowhead:YES backDismiss:YES textAlignment:0 buttonTitles:@[@"取消",@"确定"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
        if (buttonIndex) {
            [self requestQueryDeleteHandleShopUser];
        }
    }];
    [alert show];
    
}


#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
 
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return LENGTH_SIZE(60);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWInvitedRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:LWInvitedRecordCellID];
    cell.model = self.listArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
}


#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [_tableview registerNib:[UINib nibWithNibName:LWInvitedRecordCellID bundle:nil] forCellReuseIdentifier:LWInvitedRecordCellID];
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestQueryHandleShopUser];
        }];
        
        _tableview.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
            [self requestQueryHandleShopUser];
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
            [self.listArray addObjectsFromArray:model.data];
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
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
            } else {
                make.bottom.mas_offset(0);
            }
        }];
        noDataView.hidden = hidden;
    }
}




#pragma mark - request
-(void)requestQueryHandleShopUser{
    
    NSDictionary *dic = @{@"page":@(self.page)};
    
    [NetApiManager requestQueryHandleShopUser:dic withHandle:^(BOOL isSuccess, id responseObject) {
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

-(void)requestQueryDeleteHandleShopUser{
    
    NSDictionary *dic = @{};
    
    [NetApiManager requestQueryDeleteHandleShopUser:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [self.view showLoadingMeg:@"清空成功" time:MESSAGE_SHOW_TIME];
                    self.page = 1;
                    [self requestQueryHandleShopUser];
                }else {
                    [self.view showLoadingMeg:@"清空失败,请稍后再试" time:MESSAGE_SHOW_TIME];
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
