//
//  LWMainView.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/9/5.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWMainView.h"
#import "LPMainCell.h"
#import "LPWorkDetailVC.h"
static NSString *LPMainCellID = @"LPMainCell";

@interface LWMainView()
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) LPWorklistModel *model;
@end

@implementation LWMainView

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
    if (kAppDelegate.userMaterialModel.data.shopType.integerValue == 2 && (kAppDelegate.userMaterialModel.data.role.integerValue == 1 || kAppDelegate.userMaterialModel.data.role.integerValue == 1 )) {
        return LENGTH_SIZE(111);
    }
    return LENGTH_SIZE(91);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPMainCell *cell = [tableView dequeueReusableCellWithIdentifier:LPMainCellID];
    cell.model = self.listArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPWorkDetailVC *vc = [[LPWorkDetailVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.superViewArr = self.superViewArr;
    vc.workListModel = self.listArray[indexPath.row];
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
        [_tableview registerNib:[UINib nibWithNibName:LPMainCellID bundle:nil] forCellReuseIdentifier:LPMainCellID];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self request];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self request];
        }];
        
    }
    return _tableview;
}

-(void)setModel:(LPWorklistModel *)model{
    _model = model;
    if ([self.model.code integerValue] == 0) {
 
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.workList.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data.workList];
            [self.tableview reloadData];
            self.tableview.mj_footer.hidden = NO;
            if (self.model.data.workList.count < 20) {
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


-(void)GetMainViewData{
    self.page = 1;
    [self request];
}

#pragma mark - request
-(void)request{
    NSDictionary *dic = @{
                          @"page":@(self.page),
                          @"mechanismAddress":self.mechanismAddress ? self.mechanismAddress : @"china",
                          @"type":[NSString stringWithFormat:@"%ld",(long)self.workStatus]
                          };
    [NetApiManager requestShopWorklistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPWorklistModel mj_objectWithKeyValues:responseObject];
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



@end
