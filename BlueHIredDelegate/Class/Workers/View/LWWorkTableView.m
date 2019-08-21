//
//  LWWorkTableView.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/22.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWWorkTableView.h"
#import "LWWorkerCell.h"
#import "LWWorkerInfoVC.h"

static NSString *LWWorkerCellID = @"LWWorkerCell";

@interface LWWorkTableView()

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) LWWorkRecordModel *model;

@end

@implementation LWWorkTableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableview];
        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
 
    }
    return self;
}

#pragma mark - TableViewDelegate & Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LENGTH_SIZE(50);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWWorkerCell *cell = [tableView dequeueReusableCellWithIdentifier:LWWorkerCellID];
    cell.model = self.listArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LWWorkerInfoVC *vc = [[LWWorkerInfoVC alloc] init];
    vc.workModel = self.listArray[indexPath.row];
    vc.superViewArr = self.superViewArr;
    vc.ArrBtn = self.ArrBtn;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
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
        [_tableview registerNib:[UINib nibWithNibName:LWWorkerCellID bundle:nil] forCellReuseIdentifier:LWWorkerCellID];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestGetWorkRecordList];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestGetWorkRecordList];
        }];
        
    }
    return _tableview;
}


- (void)setModel:(LWWorkRecordModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        
        UIButton *empNum  = self.ArrBtn[1];
        [empNum setTitle:[NSString stringWithFormat:@"在职(%ld人)",(long)model.data.empNum.integerValue] forState:UIControlStateNormal];
        
        UIButton *unEmpNum  = self.ArrBtn[2];
        [unEmpNum setTitle:[NSString stringWithFormat:@"待业(%ld人)",(long)model.data.unEmpNum.integerValue] forState:UIControlStateNormal];

        
        if (model.data.workRecordList.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:model.data.workRecordList];
            [self.tableview reloadData];
            if (model.data.workRecordList.count <20) {
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

-(void)NodataView{
    if (self.listArray.count == 0) {
        self.tableview.mj_footer.alpha = 0;
        [self addNodataViewHidden:NO];
    }else{
        self.tableview.mj_footer.alpha = 1;
        [self addNodataViewHidden:YES];
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
        noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
        [noDataView image:nil text:@"没有数据记录~"];
        noDataView.backgroundColor = [UIColor whiteColor];
        
        [self.tableview addSubview:noDataView];
        noDataView.hidden = hidden;
    }
    
}


-(void)GetWorkRecord{
    self.page = 1;
    [self requestGetWorkRecordList];
}

#pragma mark - request
-(void)requestGetWorkRecordList{
    
    NSDictionary *dic = @{@"workStatus":@(self.workStatus),
                          @"page":@(self.page)};
    
    [NetApiManager requestGetWorkRecordList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LWWorkRecordModel mj_objectWithKeyValues:responseObject];
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end


