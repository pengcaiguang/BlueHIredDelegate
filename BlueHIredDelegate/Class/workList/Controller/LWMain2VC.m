//
//  LWMain2VC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/9/4.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWMain2VC.h"
#import "LPSelectCityVC.h"
#import "LPSearchBar.h"
#import "LPMainSearchVC.h"
#import "LWMainView.h"

@interface LWMain2VC ()<UISearchBarDelegate,LPSelectCityVCDelegate,UIScrollViewDelegate>
@property(nonatomic,strong) UILabel *cityLabel;
@property(nonatomic,strong) NSString *mechanismAddress;

@property (nonatomic,strong) NSMutableArray <UIButton *>*TypeArr;
@property (nonatomic,strong) UIButton *selectTypeBtn;
@property (nonatomic,strong) UIView *LineV;
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) NSMutableArray <LWMainView *>*MainViewArr;

@end

@implementation LWMain2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TypeArr = [[NSMutableArray alloc] init];
    self.MainViewArr = [[NSMutableArray alloc] init];
    self.mechanismAddress = @"china";
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self setSearchView];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
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
 
    wrapView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = wrapView;
    
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
    
    CGFloat SelectViewHeight = 0;
    NSArray *arr = @[@"发布中",@"隐藏中"];

    if (kAppDelegate.userMaterialModel.data.role.integerValue == 1||
        kAppDelegate.userMaterialModel.data.role.integerValue == 2) {
        SelectViewHeight = 44;
    }else if (kAppDelegate.userMaterialModel.data.role.integerValue == 6){
        SelectViewHeight = 0;
        arr = @[@"发布中"];
    }
    
    UIView *SelectView = [[UIView alloc] init];
    [self.view addSubview:SelectView];
    [SelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(SelectViewHeight));
    }];
    SelectView.backgroundColor =[UIColor whiteColor];
    SelectView.clipsToBounds = YES;
    
    for (NSInteger i =0 ; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [SelectView addSubview:btn];
        [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(TouchTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = FONT_SIZE(16);
        btn.tag = i;
        [self.TypeArr addObject:btn];
    }
    if (kAppDelegate.userMaterialModel.data.role.integerValue == 1||
        kAppDelegate.userMaterialModel.data.role.integerValue == 2) {
        [self.TypeArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        //    [self.TypeArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:SCREEN_WIDTH/3 leadSpacing:0 tailSpacing:0];
        [self.TypeArr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
        }];
    }
    
    self.TypeArr[0].selected = YES;
    self.selectTypeBtn = self.TypeArr[0];
    
    self.LineV = [[UIView alloc] init];
    [SelectView addSubview:self.LineV];
    [self.LineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(LENGTH_SIZE(30));
        make.height.mas_offset(LENGTH_SIZE(3));
        make.bottom.mas_offset(0);
        make.centerX.equalTo(self.TypeArr[0]);
    }];
    self.LineV.backgroundColor = [UIColor baseColor];

    self.scrollview = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollview];
 
    self.scrollview.frame = CGRectMake(0,
                                       LENGTH_SIZE(10+SelectViewHeight),
                                       Screen_Width,
                                       SCREEN_HEIGHT - LENGTH_SIZE(10+SelectViewHeight) - kNavBarHeight );
    
    self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH*arr.count,SCREEN_HEIGHT - LENGTH_SIZE(10+SelectViewHeight) - kNavBarHeight );
    self.scrollview.pagingEnabled = YES;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.delegate = self;
    
    for (NSInteger i =0 ; i < arr.count; i++) {
        LWMainView *view = [[LWMainView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH,
                                                                                  0,
                                                                                  SCREEN_WIDTH,
                                                                                  SCREEN_HEIGHT - LENGTH_SIZE(10+SelectViewHeight)- kNavBarHeight)];
        view.workStatus = i;
        view.ArrBtn = self.TypeArr;
        view.superViewArr = self.MainViewArr;
        view.mechanismAddress = self.mechanismAddress;
        [view GetMainViewData];
        [self.MainViewArr addObject:view];
        [self.scrollview addSubview:view];
    }
    
    
    
}

#pragma mark - Touch -

-(void)TouchTypeBtn:(UIButton *)sender{
    if (!sender.selected) {
        for (UIButton *btn in self.TypeArr) {
            btn.selected = NO;
        }
        sender.selected = YES;
        self.selectTypeBtn = sender;
        [self.LineV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(LENGTH_SIZE(30));
            make.height.mas_offset(LENGTH_SIZE(3));
            make.bottom.mas_offset(0);
            make.centerX.equalTo(sender);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self.LineV.superview layoutIfNeeded];
        }];
        [self.scrollview setContentOffset:CGPointMake(SCREEN_WIDTH*sender.tag,0 )animated:YES];
    }
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
    vc.type = 2;
    vc.mechanismAddress = self.mechanismAddress;
    vc.superViewArr = self.MainViewArr;
    [self.navigationController pushViewController:vc animated:YES];
    
    return NO;
}

-(void)touchSelectCityButton{
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
    for (LWMainView *view in self.MainViewArr) {
        view.mechanismAddress = self.mechanismAddress;
        [view GetMainViewData];
    }
 
}


#pragma mark - ScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self TouchTypeBtn:self.TypeArr[page]];
}



@end
