//
//  LPMainVC.m
//  BlueHired
//
//  Created by peng on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//



#import "LPMainVC.h"
#import "LPSearchBar.h"

#import "LPWorklistModel.h"
#import "LPMechanismlistModel.h"
#import "SDCycleScrollView.h"
#import "LPMainSortAlertView.h"
#import "LPMainSearchVC.h"
#import "LPWorkDetailVC.h"
#import "LPSelectCityVC.h"
#import "LPMain2Cell.h"
#import "UIImage+GIF.h"


#define OPERATIONFORKEY @"operationGuidePage"

static NSString *LPMainCellID = @"LPMain2Cell";

@interface LPMainVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,LPMainSortAlertViewDelegate,LPSelectCityVCDelegate,UITabBarDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UILabel *cityLabel;
@property(nonatomic,strong) UIButton *sortButton;
@property(nonatomic,strong) UIButton *screenButton;
@property(nonatomic,strong) UIButton *screenTypeButton;
@property(nonatomic,strong) UIView *screenView;

@property(nonatomic,strong) LPMainSortAlertView *sortAlertView;

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) LPWorklistModel *model;
@property(nonatomic,strong) NSMutableArray <LPWorklistDataWorkListModel *>*listArray;

@property(nonatomic,strong) LPMechanismlistModel *mechanismlistModel;

@property(nonatomic,strong) NSString *orderType;
@property(nonatomic,strong) NSString *mechanismAddress;
@property(nonatomic,strong) UIView *ButtonView;
@property(nonatomic,strong) NSMutableArray <UIButton *>*ButtonArr;



@end

@implementation LPMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
//    [self.view addSubview:self.ButtonView];
//    [self.view addSubview:self.screenView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.mas_offset(LENGTH_SIZE(10));
        make.left.right.bottom.mas_offset(0);
    
    }];
 
    [self requestMechanismlist];

    self.page = 1;
    [self request];
    [self setSearchView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
 }




-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.sortAlertView.touchButton.selected) {
        [self.sortAlertView close];
    }
}


- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"BackBttonImage"] forState:UIControlStateNormal];
    [btn setTitle:@" " forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}


-(void)setSearchView{
    LPSearchBar *searchBar = [self addSearchBar];
    UIView *wrapView = [[UIView alloc]init];
    wrapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 32);
//    wrapView.layer.cornerRadius = 16;
//    wrapView.layer.masksToBounds = YES;
    wrapView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = wrapView;
//    wrapView.backgroundColor = [UIColor redColor];
    
    searchBar.layer.cornerRadius = 16;
    searchBar.layer.masksToBounds = YES;

    
    UIView *leftBarButtonView = [[UIView alloc]init];
    //    leftBarButtonView.backgroundColor = [UIColor redColor];
    [wrapView addSubview:leftBarButtonView];
    [leftBarButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.navigationController.navigationBar.frame.size.height);
        make.left.top.mas_offset(0);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchSelectCityButton)];
    leftBarButtonView.userInteractionEnabled = YES;
    [leftBarButtonView addGestureRecognizer:tap];
    
    UIImageView *pimageView = [[UIImageView alloc]init];
    [leftBarButtonView addSubview:pimageView];
    [pimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(wrapView);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    pimageView.image = [UIImage imageNamed:@"location"];
    
    self.cityLabel = [[UILabel alloc]init];
    [leftBarButtonView addSubview:self.cityLabel];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pimageView.mas_right).offset(3);
        make.right.mas_offset(0);
        make.centerY.mas_equalTo(pimageView);
    }];
    self.cityLabel.text = @"全国";
    self.cityLabel.font = [UIFont systemFontOfSize:15];
    self.cityLabel.textColor = [UIColor colorWithHexString:@"#666666"];
 
    
    [wrapView addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBarButtonView.mas_right).offset(4);
        make.right.mas_equalTo(0);
        make.centerY.equalTo(wrapView);
        make.height.mas_offset(32);
    }];

}

- (LPSearchBar *)addSearchBar{
    
    self.definesPresentationContext = YES;
    
    LPSearchBar *searchBar = [[LPSearchBar alloc]init];
    
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入企业名称或关键字";
    [searchBar setShowsCancelButton:NO];
    [searchBar setTintColor:[UIColor lightGrayColor]];
    
    UITextField *searchField = [searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[UIColor colorWithHexString:@"#F2F1F0"]];
        searchField.layer.cornerRadius = 14;
        searchField.layer.masksToBounds = YES;
        searchField.font = [UIFont systemFontOfSize:13];
    }
    if (YES) {
        CGFloat height = searchBar.bounds.size.height;
        CGFloat top = (height - 28.0) / 2.0;
        CGFloat bottom = top;
        searchBar.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    }
    return searchBar;
}

#pragma mark - search
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    LPMainSearchVC *vc = [[LPMainSearchVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.mechanismAddress = self.mechanismAddress;
    [self.navigationController pushViewController:vc animated:YES];
    
    return NO;
}

#pragma mark - setter
-(void)setMechanismlistModel:(LPMechanismlistModel *)mechanismlistModel{
    _mechanismlistModel = mechanismlistModel;

}
-(void)setModel:(LPWorklistModel *)model{
    _model = model;
    if ([self.model.code integerValue] == 0) {
        NSMutableArray *array = [NSMutableArray array];
        for (LPWorklistDataWorkListModel *model in self.model.data.slideshowList) {
            [array addObject:model.mechanismUrl];
        }

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
//                self.tableview.mj_footer
              
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
    for (UIView *view in self.tableview.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0,
                                                                                 LENGTH_SIZE(0) ,
                                                                                 SCREEN_WIDTH,
                                                                                 SCREEN_HEIGHT-kNavBarHeight-kBottomBarHeight-LENGTH_SIZE(80))];
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        [self.tableview addSubview:noDataView];
        noDataView.hidden = hidden;
    }
}



-(void)touchSelectCityButton{
    NSLog(@"touchSelectCityButton");
    LPSelectCityVC *vc = [[LPSelectCityVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
 
}

#pragma mark - LPSelectCityVCDelegate
-(void)selectCity:(LPCityModel *)model{
    if ([model.c_name isEqualToString:@"全国"]) {
        self.mechanismAddress = @"china";
    }else{
        self.mechanismAddress = model.c_name;
    }
    if (model.c_name.length>3) {
        self.cityLabel.text = [NSString stringWithFormat:@"%@…",[model.c_name substringToIndex:3]];
    }else{
        self.cityLabel.text = model.c_name;
    }
    
    self.page = 1;
    [self request];
}

#pragma mark - LPMainSortAlertViewDelegate
-(void)touchTableView:(NSInteger)index{
    
    if (self.sortAlertView.touchButton == self.screenTypeButton) {
        //        self.orderType = [NSString stringWithFormat:@"%ld",(long)index];
        if (index == 0) {
            self.mechanismTypeId = @"";
            [self.screenTypeButton setTitle:@"全部企业" forState:UIControlStateNormal];
        }else{
            self.mechanismTypeId =[NSString stringWithFormat:@"%@", self.mechanismlistModel.data.mechanismTypeList[index-1].id];
            [self.screenTypeButton setTitle:self.mechanismlistModel.data.mechanismTypeList[index-1].mechanismTypeName forState:UIControlStateNormal];
        }
        
        
        
        self.screenTypeButton.tag = index;
        self.page = 1;
        [self request];
    }else if (self.sortAlertView.touchButton == self.screenButton){
        if (index == 0) {
            self.workType = @"";
            [self.screenButton setTitle:@"全部工种" forState:UIControlStateNormal];
        }else if (index == 1){
            self.workType = @"1";
            [self.screenButton setTitle:@"小时工" forState:UIControlStateNormal];
        }else if (index == 2){
            self.workType = @"0";
            [self.screenButton setTitle:@"正式工" forState:UIControlStateNormal];
        }
        self.screenButton.tag = index;
        self.page = 1;
        [self request];
    }
    
}


#pragma mark - TableViewDelegate & Datasource

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return LENGTH_SIZE(80);
//}
//
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor whiteColor];
//    [view addSubview:self.ButtonView];
//    [view addSubview:self.screenView];
//    return view;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPWorklistDataWorkListModel *m = self.listArray[indexPath.row];
    if (m.key.length == 0) {
        return LENGTH_SIZE(120) ;
    }
    return LENGTH_SIZE(140) ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPMain2Cell *cell = [tableView dequeueReusableCellWithIdentifier:LPMainCellID];
    if(cell == nil){
        cell = [[LPMain2Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMainCellID];
    }
    cell.model = self.listArray[indexPath.row];
//    WEAK_SELF()
//    cell.block = ^(void) {
//        weakSelf.page = 1;
//        [weakSelf request];
//    };

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPWorkDetailVC *vc = [[LPWorkDetailVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.workListModel = self.listArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
 
}







-(void)touchScreenButton:(UIButton *)button{
 
    dispatch_async(dispatch_get_main_queue(), ^{
        if (button == self.screenButton) {
            self.screenTypeButton.selected = NO;
            self.sortAlertView.titleArray  = @[@"全部工种",@"小时工",@"正式工"];
            button.selected = !button.isSelected;
            self.sortAlertView.touchButton = button;
            self.sortAlertView.selectTitle = button.tag;
            self.sortAlertView.hidden = !button.isSelected;
        }else if (button == self.screenTypeButton){
            NSMutableArray *Array = [[NSMutableArray alloc] init];
            [Array addObject:@"全部企业"];
            for (int i = 0; i < self.mechanismlistModel.data.mechanismTypeList.count; i++) {
                [Array addObject:self.mechanismlistModel.data.mechanismTypeList[i].mechanismTypeName];
            }
            self.screenButton.selected = NO;

            self.sortAlertView.titleArray  = Array;
            button.selected = !button.isSelected;
            self.sortAlertView.selectTitle = button.tag;
            self.sortAlertView.touchButton = button;
            self.sortAlertView.hidden = !button.isSelected;
        }
    });

}
 
#pragma mark - request
-(void)request{
    NSDictionary *dic = @{
                          @"type":@(0),
                          @"page":@(self.page),
                          @"orderType":self.orderType ? self.orderType : @"",
                          @"mechanismAddress":self.mechanismAddress ? self.mechanismAddress : @"china",
                          @"mechanismTypeId":self.mechanismTypeId ? self.mechanismTypeId : @"",
                          @"workType":self.workType ? self.workType : @""
                          };
    [NetApiManager requestWorklistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
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

-(void)requestMechanismlist{
    [NetApiManager requestMechanismlistWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.mechanismlistModel = [LPMechanismlistModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
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
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#E6E6E6"];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
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
-(UIButton *)sortButton{
    if (!_sortButton) {
        _sortButton = [[UIButton alloc]init];
        _sortButton.frame = CGRectMake(LENGTH_SIZE(13), 0, LENGTH_SIZE(70), LENGTH_SIZE(40));
        [_sortButton setTitle:@"企业列表" forState:UIControlStateNormal];
 
        [_sortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         _sortButton.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
        _sortButton.enabled = NO;
    }
    return _sortButton;
}
-(UIButton *)screenButton{
    if (!_screenButton) {
        _screenButton = [[UIButton alloc]init];
        _screenButton.frame = CGRectMake(SCREEN_WIDTH-LENGTH_SIZE(75+13) , 0,LENGTH_SIZE(75), LENGTH_SIZE(40));
        [_screenButton setTitle:@"全部工种" forState:UIControlStateNormal];
        [_screenButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [_screenButton setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];
        [_screenButton setImage:[UIImage imageNamed:@"drop_down"] forState:UIControlStateNormal];
        [_screenButton setImage:[UIImage imageNamed:@"drop_up"] forState:UIControlStateSelected];
        _screenButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

        _screenButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(13)];
        _screenButton.titleEdgeInsets = UIEdgeInsetsMake(0, -_screenButton.imageView.frame.size.width - _screenButton.frame.size.width + _screenButton.titleLabel.intrinsicContentSize.width, 0,LENGTH_SIZE(20));
        _screenButton.imageEdgeInsets = UIEdgeInsetsMake(0,LENGTH_SIZE(55+8) , 0, 0);
        [_screenButton addTarget:self action:@selector(touchScreenButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenButton;
}

-(UIButton *)screenTypeButton{
    if (!_screenTypeButton) {
        _screenTypeButton = [[UIButton alloc]init];
        _screenTypeButton.frame = CGRectMake(SCREEN_WIDTH-LENGTH_SIZE(75+13 + 80 + 10) , 0,LENGTH_SIZE(75),LENGTH_SIZE(40));
        [_screenTypeButton setTitle:@"全部企业" forState:UIControlStateNormal];
        [_screenTypeButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [_screenTypeButton setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];
        [_screenTypeButton setImage:[UIImage imageNamed:@"drop_down"] forState:UIControlStateNormal];
        [_screenTypeButton setImage:[UIImage imageNamed:@"drop_up"] forState:UIControlStateSelected];

        _screenTypeButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(13)];
        _screenTypeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

        _screenTypeButton.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                             -_screenTypeButton.imageView.frame.size.width - _screenTypeButton.frame.size.width + _screenTypeButton.titleLabel.intrinsicContentSize.width,
                                                             0,
                                                             LENGTH_SIZE(20));
        
        _screenTypeButton.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                             LENGTH_SIZE(55+8),
                                                             0,
                                                             0);
        [_screenTypeButton addTarget:self action:@selector(touchScreenButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenTypeButton;
}

- (UIView *)screenView{
     if (!_screenView) {
         _screenView = [[UIView alloc] initWithFrame:CGRectMake(0, LENGTH_SIZE(0) , SCREEN_WIDTH, LENGTH_SIZE(40))];
         _screenView.tag = 2000;
         _screenView.backgroundColor = [UIColor whiteColor];

         [_screenView addSubview:self.screenButton];
         [_screenView addSubview:self.screenTypeButton];
         [_screenView addSubview:self.sortButton];
     }
    return _screenView;
}


-(LPMainSortAlertView *)sortAlertView{
    if (!_sortAlertView) {
        _sortAlertView = [[LPMainSortAlertView alloc]init];
        _sortAlertView.touchButton = self.sortButton;
        _sortAlertView.delegate = self;
    }
    return _sortAlertView;
}




- (UIView *)ButtonView{
    if (!_ButtonView) {
        _ButtonView = [[UIView alloc] initWithFrame:CGRectMake(LENGTH_SIZE(0),LENGTH_SIZE(40) ,SCREEN_WIDTH , LENGTH_SIZE(42))];
        _ButtonView.tag = 1000;
        _ButtonView.backgroundColor = [UIColor whiteColor];
        NSArray *arr = @[@"在招企业",@"高薪企业",@"有返费",@"可借支"];
        self.ButtonArr = [[NSMutableArray alloc] init];
        for (int i = 0; i<arr.count; i++) {
            UIButton *Bt = [[UIButton alloc] init];
            [_ButtonView addSubview:Bt];
            [Bt setTitle:arr[i] forState:UIControlStateNormal];
            [Bt setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F2F2F2"]] forState:UIControlStateNormal];
            [Bt setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#E4F4FF"]] forState:UIControlStateSelected];
            [Bt setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            [Bt setTitleColor:[UIColor colorWithHexString:@"#3CAFFF"] forState:UIControlStateSelected];
            Bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(13)];
            Bt.layer.cornerRadius =LENGTH_SIZE(4);
            Bt.clipsToBounds = YES;
            [Bt addTarget:self action:@selector(TouchBt:) forControlEvents:UIControlEventTouchUpInside];
            [self.ButtonArr addObject:Bt];
        }
        
        [self.ButtonArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:LENGTH_SIZE(7) leadSpacing:LENGTH_SIZE(13) tailSpacing:LENGTH_SIZE(13)];
        [self.ButtonArr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(LENGTH_SIZE(6));
            make.height.mas_equalTo(LENGTH_SIZE(30));
        }];
    }
    return _ButtonView;
}
-(void)TouchBt:(UIButton *) sender{
    
    if (self.tableview.contentOffset.y < LENGTH_SIZE(216)) {
        CGPoint bottomOffset = CGPointMake(0, LENGTH_SIZE(216));
        [self.tableview setContentOffset:bottomOffset animated:NO];
    }
    
    if (sender.selected == YES) {
        self.orderType = @"";
        sender.selected = NO;
        self.page = 1;
        [self request];
        return;
    }
  

    for (UIButton *bt in self.ButtonArr) {
        bt.selected = NO;
    }
    sender.selected = YES;
    if ([sender.currentTitle isEqualToString:@"默认排序"]) {
        self.orderType = @"";
    }else if ([sender.currentTitle isEqualToString:@"在招企业"]){
        self.orderType = @"10";
    }else if ([sender.currentTitle isEqualToString:@"高薪企业"]){
        self.orderType = @"8";
    }else if ([sender.currentTitle isEqualToString:@"有返费"]){
        self.orderType = @"9";
    }else if ([sender.currentTitle isEqualToString:@"可借支"]){
        self.orderType = @"4";
    }
    self.page = 1;
    [self request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 

@end
