//
//  LPMainSearchVC.m
//  BlueHired
//
//  Created by peng on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPMainSearchVC.h"
#import "LPSearchBar.h"
#import "LPWorklistModel.h"
#import "LPWorkDetailVC.h"
#import "LPMain2Cell.h"
#import "LPMainCell.h"
#import "LWMyStaffModel.h"
#import "LWMyStallCell.h"
#import "LWMyStall2Cell.h"
#import "LWMyStaffModelV2.h"
#import "LWEntryRecordVC.h"

static NSString *MainSearchHistory = @"MainSearchHistory";
static NSString *MyStaffSearchHistory = @"MyStaffSearchHistory";
static NSString *MainSearch2History = @"MainSearch2History";
static NSString *MyStaffSearch2History = @"MyStaffSearch2History";

static NSString *LPMain2CellID = @"LPMainCell";
static NSString *LPMainCellID = @"LPMain2Cell";
static NSString *LWMyStallCellID = @"LWMyStallCell";
static NSString *LWMyStallCell2ID = @"LWMyStall2Cell";

@interface LPMainSearchVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)UITableView *Resulttableview;

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) LPWorklistModel *model;
@property(nonatomic,strong) LPWorklistModel *model2;
@property(nonatomic,strong) LWMyStaffModel *Mymodel;
@property (nonatomic,strong) LWMyStaffModelV2 *MymodelV2;

@property(nonatomic,strong) NSMutableArray <LPWorklistDataWorkListModel *>*listArray;
@property(nonatomic,strong) NSMutableArray <LPWorklistDataWorkListModel *>*list2Array;
@property(nonatomic,strong) NSMutableArray <LWMyStaffDataModel *>*MylistArray;
@property (nonatomic,strong) NSMutableArray <LWMyStaffDataModelV2 *>*MylistArrayV2;

@property(nonatomic,copy) NSArray *textArray;
@property(nonatomic,copy) NSString *searchWord;

@property(nonatomic,strong)LPSearchBar *SearchBar;

@end

@implementation LPMainSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setSearchView];
    [self setSearchButton];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.Resulttableview];
    [self.Resulttableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.Resulttableview.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.type == 1) {
        self.textArray = (NSArray *)kUserDefaultsValue(MyStaffSearchHistory);
    }else if (self.type == 2){
        self.textArray = (NSArray *)kUserDefaultsValue(MainSearch2History);
    }else if (self.type == 3){
        self.textArray = (NSArray *)kUserDefaultsValue(MyStaffSearch2History);
    }else{
        self.textArray = (NSArray *)kUserDefaultsValue(MainSearchHistory);
    }
    [self.tableview reloadData];
    [self.Resulttableview reloadData];

}

-(void)setSearchView{
    LPSearchBar *searchBar = [self addSearchBarWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 2 * 44 - 0 * 15 - 44 -5 , 44)];
    self.SearchBar = searchBar;
    [searchBar becomeFirstResponder];
    UIView *wrapView = [[UIView alloc] initWithFrame:searchBar.frame];
    [wrapView addSubview:searchBar];
    self.navigationItem.titleView = wrapView;
}
- (LPSearchBar *)addSearchBarWithFrame:(CGRect)frame {
    
    self.definesPresentationContext = YES;
    
    LPSearchBar *searchBar = [[LPSearchBar alloc]initWithFrame:frame];
    searchBar.delegate = self;
    if (self.type == 1) {
        searchBar.placeholder = @"请输入关键字";
    } else if (self.type == 2){
        searchBar.placeholder = @"请输入企业名称或关键字";
    } else if (self.type == 3){
        searchBar.placeholder = @"请输入姓名或联系方式";
    } else{
        searchBar.placeholder = @"请输入企业名称或关键字";
    }
    [searchBar setShowsCancelButton:NO];
    [searchBar setTintColor:[UIColor lightGrayColor]];
//    searchBar.backgroundColor = [UIColor blueColor];
    
    UITextField *searchField = [searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[UIColor colorWithHexString:@"#F2F1F0"]];
        searchField.layer.cornerRadius = 15;
        searchField.layer.masksToBounds = YES;
        searchField.font = [UIFont systemFontOfSize:13];
    }
    if (YES) {
        CGFloat height = searchBar.bounds.size.height;
        CGFloat top = (height - 30.0) / 2.0;
        CGFloat bottom = top;
        searchBar.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    }
    return searchBar;
}

#pragma mark - UITextFieldDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if (self.Resulttableview.hidden == NO) {
        self.Resulttableview.hidden = YES;
        if (self.type == 1) {
            self.textArray = (NSArray *)kUserDefaultsValue(MyStaffSearchHistory);
        } else if (self.type == 2){
            self.textArray = (NSArray *)kUserDefaultsValue(MainSearch2History);
        } else if (self.type == 3){
            self.textArray = (NSArray *)kUserDefaultsValue(MyStaffSearch2History);
        } else{
            self.textArray = (NSArray *)kUserDefaultsValue(MainSearchHistory);
        }
        [self.tableview reloadData];
    }
    return YES;
}


-(void)setSearchButton{
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 47, 28);
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
//    button.layer.masksToBounds = YES;
//    button.layer.cornerRadius = 14;
//    [button setBackgroundImage:[UIImage imageNamed:@"search_btn_bgView"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchSearchButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
//    button.backgroundColor = [UIColor redColor];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchWord = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self touchSearchButton];
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"-%@",searchBar.text);
    self.searchWord = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
-(void)touchSearchButton{
    if (self.searchWord.length > 0) {
        [self saveWords];
        [self search:self.searchWord];
    }
    else
    {
        if (self.type == 1) {
            [self.view showLoadingMeg:@"请输入关键字" time:MESSAGE_SHOW_TIME];
        } else if (self.type == 2){
            [self.view showLoadingMeg:@"请输入企业名称或关键字" time:MESSAGE_SHOW_TIME];
        } else if (self.type == 3){
            [self.view showLoadingMeg:@"请输入姓名或联系方式" time:MESSAGE_SHOW_TIME];
        } else{
            [self.view showLoadingMeg:@"请输入企业名称或关键字" time:MESSAGE_SHOW_TIME];
        }

    }
}

-(void)saveWords{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.textArray];
    if (![array containsObject:self.searchWord]) {
        [array insertObject:self.searchWord atIndex:0];
        if (self.type == 1) {
            kUserDefaultsSave([array copy], MyStaffSearchHistory);
        }else if(self.type == 2){
            kUserDefaultsSave([array copy], MainSearch2History);
        }else if(self.type == 3){
            kUserDefaultsSave([array copy], MyStaffSearch2History);
        }else{
            kUserDefaultsSave([array copy], MainSearchHistory);
        }
    }
}

-(void)search:(NSString *)string{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    self.Resulttableview.hidden = NO;
    self.page = 1;
    if (self.type == 1) {
        [self requestQueryGetStaffList];
    }else if (self.type == 2){
        [self request2];
    }else if (self.type == 3){
        [self requestQueryGetStaffListV2];
    } else{
        [self request];
    }
 
}

-(void)clearHistory{
    if (self.type == 1) {
        kUserDefaultsRemove(MyStaffSearchHistory);
    }else if (self.type == 2){
        kUserDefaultsRemove(MainSearch2History);
    }else if (self.type == 3){
        kUserDefaultsRemove(MyStaffSearch2History);
    }else{
        kUserDefaultsRemove(MainSearchHistory);
    }
    self.textArray = nil;
    [self.tableview reloadData];
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableview) {
        if (self.textArray.count>5) {
            return 5;
        }
        return self.textArray.count;
    }else{
        if (self.type == 1) {
            return self.MylistArray.count;
        }else if (self.type == 2){
            return self.list2Array.count;
        }else if (self.type == 3){
            return self.MylistArrayV2.count;
        }
        return self.listArray.count;
    }

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"#F2F1F0"];
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.equalTo(view);
    }];
    if (tableView == self.tableview) {
        label.text = @"历史搜索";
    }else{
        label.text = @"搜索结果";
    }
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"#999999"];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.Resulttableview) {
        if (self.type == 1) {
            LWMyStaffDataModel *m = self.MylistArray[indexPath.row];
            if (m.isShow) {
                return LENGTH_SIZE(126) ;
            }
            return LENGTH_SIZE(66) ;
        }else if (self.type == 2){
            if (kAppDelegate.userMaterialModel.data.shopType.integerValue == 2 && (kAppDelegate.userMaterialModel.data.role.integerValue == 1 || kAppDelegate.userMaterialModel.data.role.integerValue == 1 )) {
                return LENGTH_SIZE(111);
            }
            return LENGTH_SIZE(91);
        }else if (self.type == 3){
            return LENGTH_SIZE(126) ;
        } else{
            LPWorklistDataWorkListModel *m = self.listArray[indexPath.row];
            if (m.key.length == 0) {
                return LENGTH_SIZE(120) ;
            }
            return LENGTH_SIZE(140) ;
        }
        

    }
    return 44.0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.tableview) {
        return 30;
    }
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.tableview) {
        if (self.textArray.count <= 0) {
            UIView *view = [[UIView alloc]init];
            return view;
        }
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]init];
        [view addSubview:button];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 10.0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.equalTo(view);
            make.width.mas_equalTo(120);
        }];
        [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setImage:[UIImage imageNamed:@"delete_search"] forState:UIControlStateNormal];
        [button setTitle:@"清空历史记录" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }else{
        return nil;
    }

}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableview) {
        static NSString *rid=@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
            UIView *LineV = [[UIView alloc] init];
            [cell.contentView addSubview:LineV];
            [LineV mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.mas_offset(12);
                make.right.bottom.mas_offset(0);
                make.height.mas_offset(1);
            }];
            LineV.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        cell.textLabel.text = self.textArray[indexPath.row];
        return cell;
    }else{
        if (self.type == 1) {
            LWMyStallCell *cell = [tableView dequeueReusableCellWithIdentifier:LWMyStallCellID];
            cell.model = self.MylistArray[indexPath.row];
            return cell;
        }else if (self.type == 2){
            LPMainCell *cell = [tableView dequeueReusableCellWithIdentifier:LPMain2CellID];
            if(cell == nil){
                cell = [[LPMainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMain2CellID];
            }
            cell.model = self.list2Array[indexPath.row];
            return cell;
        } else if (self.type == 3){
            LWMyStall2Cell *cell = [tableView dequeueReusableCellWithIdentifier:LWMyStallCell2ID];
            if(cell == nil){
                cell = [[LWMyStall2Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LWMyStallCell2ID];
            }
            cell.model = self.MylistArrayV2[indexPath.row];
            return cell;
        } else{
            LPMain2Cell *cell = [tableView dequeueReusableCellWithIdentifier:LPMainCellID];
            if(cell == nil){
                cell = [[LPMain2Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMainCellID];
            }
            cell.model = self.listArray[indexPath.row];
            return cell;
        }

    }

  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableview) {
        self.searchWord = self.textArray[indexPath.row];
        self.SearchBar.text = self.textArray[indexPath.row];
        [self search:self.textArray[indexPath.row]];
    }else{
        if (self.type == 1) {
            if (self.MylistArray[indexPath.row].workStatus.integerValue == 1 ||
                self.MylistArray[indexPath.row].workStatus.integerValue == 2) {
                self.MylistArray[indexPath.row].isShow = !self.MylistArray[indexPath.row].isShow;
                [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }else if (self.type == 2){
            LPWorkDetailVC *vc = [[LPWorkDetailVC alloc]init];
            vc.superViewArr = self.superViewArr;
            vc.workListModel = self.list2Array[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.type == 3){
            LWEntryRecordVC *vc = [[LWEntryRecordVC alloc] init];
            vc.Listmodel = self.MylistArrayV2[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        } else{
            LPWorkDetailVC *vc = [[LPWorkDetailVC alloc]init];
            vc.workListModel = self.listArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

}
#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 30;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableview;
}

- (UITableView *)Resulttableview{
    if (!_Resulttableview) {
        _Resulttableview = [[UITableView alloc]init];
        _Resulttableview.delegate = self;
        _Resulttableview.dataSource = self;
        _Resulttableview.tableFooterView = [[UIView alloc]init];
        _Resulttableview.rowHeight = UITableViewAutomaticDimension;
        _Resulttableview.estimatedRowHeight = 0;
        
        _Resulttableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _Resulttableview.separatorColor = [UIColor colorWithHexString:@"#E6E6E6"];
        _Resulttableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_Resulttableview registerNib:[UINib nibWithNibName:LPMainCellID bundle:nil] forCellReuseIdentifier:LPMainCellID];
        [_Resulttableview registerNib:[UINib nibWithNibName:LWMyStallCellID bundle:nil] forCellReuseIdentifier:LWMyStallCellID];
        [_Resulttableview registerNib:[UINib nibWithNibName:LPMain2CellID bundle:nil] forCellReuseIdentifier:LPMain2CellID];
        [_Resulttableview registerNib:[UINib nibWithNibName:LWMyStallCell2ID bundle:nil] forCellReuseIdentifier:LWMyStallCell2ID];

        _Resulttableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            if (self.type == 1) {
                [self requestQueryGetStaffList];
            }else if (self.type == 2){
                [self request2];
            } else if (self.type == 3){
                [self requestQueryGetStaffListV2];
            }else{
                 [self request];
            }
            
        }];
        _Resulttableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.type == 1) {
                [self requestQueryGetStaffList];
            }else if (self.type == 2){
                [self request2];
            }else if (self.type == 3){
                [self requestQueryGetStaffListV2];
            }else{
               [self request];
            }
            
        }];
    }
    return _Resulttableview;
}

- (void)setMymodel:(LWMyStaffModel *)Mymodel{
    _Mymodel = Mymodel;
    //    [self addNodataView];
    if ([self.Mymodel.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.MylistArray = [NSMutableArray array];
        }
        if (self.Mymodel.data.count > 0) {
            self.page += 1;
            [self.MylistArray addObjectsFromArray:self.Mymodel.data];
            [self.Resulttableview reloadData];
            if (Mymodel.data.count <20) {
                self.tableview.mj_footer.hidden = self.MylistArray.count<20?YES:NO;
                [self.Resulttableview.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            if (self.page == 1) {
                [self.Resulttableview reloadData];
            }else{
                [self.Resulttableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        if (self.MylistArray.count == 0) {
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
        
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}

-(void)setModel:(LPWorklistModel *)model{
    _model = model;
    //    [self addNodataView];
    if ([self.model.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.workList.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data.workList];
            [self.Resulttableview reloadData];
            if (self.model.data.workList.count < 20) {
                [self.Resulttableview.mj_footer endRefreshingWithNoMoreData];
                self.tableview.mj_footer.hidden = self.listArray.count<20?YES:NO;
            }
        }else{
            if (self.page == 1) {
                [self.Resulttableview reloadData];
            }else{
                [self.Resulttableview.mj_footer endRefreshingWithNoMoreData];
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

- (void)setModel2:(LPWorklistModel *)model2{
    _model2 = model2;
    if ([self.model2.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.list2Array = [NSMutableArray array];
        }
        if (self.model2.data.workList.count > 0) {
            self.page += 1;
            [self.list2Array addObjectsFromArray:self.model2.data.workList];
            [self.Resulttableview reloadData];
            if (self.model2.data.workList.count < 20) {
                [self.Resulttableview.mj_footer endRefreshingWithNoMoreData];
                self.tableview.mj_footer.hidden = self.list2Array.count<20?YES:NO;
            }
        }else{
            if (self.page == 1) {
                [self.Resulttableview reloadData];
            }else{
                [self.Resulttableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        if (self.list2Array.count == 0) {
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
        
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
    
}

- (void)setMymodelV2:(LWMyStaffModelV2 *)MymodelV2{
    _MymodelV2 = MymodelV2;
    if ([self.MymodelV2.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.MylistArrayV2 = [NSMutableArray array];
        }
        if (self.MymodelV2.data.count > 0) {
            self.page += 1;
            [self.MylistArrayV2 addObjectsFromArray:self.MymodelV2.data];
            [self.Resulttableview reloadData];
            if (_MymodelV2.data.count <20) {
                self.tableview.mj_footer.hidden = self.MylistArrayV2.count<20?YES:NO;
                [self.Resulttableview.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            if (self.page == 1) {
                [self.Resulttableview reloadData];
            }else{
                [self.Resulttableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        if (self.MylistArrayV2.count == 0) {
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
    for (UIView *view in self.Resulttableview.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT-30-kNavBarHeight-kBottomBarHeight)];
        if (self.type == 1) {
            [noDataView image:nil text:@"搜索尚无结果"];
        }else{
             [noDataView image:nil text:@"搜索尚无结果\n更多企业正在洽谈中,敬请期待!"];
        }
       
        [self.Resulttableview addSubview:noDataView];
 
        noDataView.hidden = hidden;
    }
    
    
//    LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [noDataView image:nil text:@"搜索尚无结果\n更多企业正在洽谈中,敬请期待!"];
//    [self.Resulttableview addSubview:noDataView];
//    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.Resulttableview);
//    }];
}


#pragma mark - request
-(void)requestQueryGetStaffList{
    NSDictionary *dic = @{
                          @"type":@(0),
                          @"userName":self.searchWord,
                          @"page":@(self.page)
                          };
    [NetApiManager requestQueryGetStaffList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.Resulttableview.mj_header endRefreshing];
        [self.Resulttableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.Mymodel = [LWMyStaffModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)request{
    NSDictionary *dic = @{
                          @"type":@(0),
                          @"mechanismName":self.searchWord,
                          @"mechanismAddress":self.mechanismAddress ? self.mechanismAddress : @"china",
                          @"page":@(self.page)
                          };
    [NetApiManager requestWorklistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.Resulttableview.mj_header endRefreshing];
        [self.Resulttableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                 self.model = [LPWorklistModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)request2{
    NSDictionary *dic ;
    if (kAppDelegate.userMaterialModel.data.role.integerValue ==1 ||
        kAppDelegate.userMaterialModel.data.role.integerValue ==2) {
        dic = @{@"mechanismName":self.searchWord,
                @"mechanismAddress":self.mechanismAddress ? self.mechanismAddress : @"china",
                @"page":@(self.page),
                @"type":@(2)
                };
    }else{
        dic = @{@"mechanismName":self.searchWord,
                @"mechanismAddress":self.mechanismAddress ? self.mechanismAddress : @"china",
                @"page":@(self.page),
                @"type":@(0)
                };
    }
    [NetApiManager requestShopWorklistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.Resulttableview.mj_header endRefreshing];
        [self.Resulttableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model2 = [LPWorklistModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryGetStaffListV2{
    NSDictionary *dic = @{@"key":self.searchWord,
                          @"page":@(self.page)};
    [NetApiManager requestQueryGetStaffListV2:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.Resulttableview.mj_header endRefreshing];
        [self.Resulttableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.MymodelV2 = [LWMyStaffModelV2 mj_objectWithKeyValues:responseObject];
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



//计算标签高度
-(CGFloat)calculateKeyHeight:(NSString *) Key{
    if (Key.length == 0) {
        return 0;
    }
    Key = [Key stringByReplacingOccurrencesOfString:@"丨" withString:@"|"];

    NSArray * tagArr = [Key componentsSeparatedByString:@"|"];
    CGFloat tagBtnX = 0;
    CGFloat tagBtnY = 0;
    for (int i= 0; i<tagArr.count; i++) {
        CGSize tagTextSize = [tagArr[i] sizeWithFont:[UIFont systemFontOfSize:FontSize(12)] maxSize:CGSizeMake(SCREEN_WIDTH-LENGTH_SIZE(116), LENGTH_SIZE(17))];
        if (tagBtnX+tagTextSize.width+14 > SCREEN_WIDTH-LENGTH_SIZE(116)) {
            tagBtnX = 0;
            tagBtnY += LENGTH_SIZE(17)+8;
        }
        tagBtnX = tagBtnX + tagTextSize.width + LENGTH_SIZE(4);
    }
    return tagBtnY + LENGTH_SIZE(17);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
