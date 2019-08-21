//
//  LWWorkerVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/22.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWWorkerVC.h"
#import "LWWorkTableView.h"
#import "LWWorkerInfoVC.h"

@interface LWWorkerVC ()<UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray <UIButton *>*TypeArr;
@property (nonatomic,strong) UIButton *selectTypeBtn;
@property (nonatomic,strong) UIView *LineV;
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) NSMutableArray <LWWorkTableView *>*WorkViewArr;

@end

@implementation LWWorkerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"招工记录";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.TypeArr = [[NSMutableArray alloc] init];
    self.WorkViewArr = [[NSMutableArray alloc] init];
    [self initView];

}

-(void)initView{
    UIView *SelectView = [[UIView alloc] init];
    [self.view addSubview:SelectView];
    [SelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(44));
    }];
    SelectView.backgroundColor =[UIColor whiteColor];
    NSArray *arr = @[@"全部",@"在职",@"待业"];

    for (NSInteger i =0 ; i < 3 ; i++) {
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
    
    [self.TypeArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
//    [self.TypeArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:SCREEN_WIDTH/3 leadSpacing:0 tailSpacing:0];
    [self.TypeArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
    }];
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

    
    UIButton *allBtn = [[UIButton alloc] init];
    [self.view addSubview:allBtn];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            // Fallback on earlier versions
            make.bottom.mas_offset(0);
        }
        make.left.mas_offset(0);

        make.height.mas_offset(LENGTH_SIZE(48));
    }];
    allBtn.backgroundColor = [UIColor colorWithHexString:@"#3C93FF"];
    [allBtn setTitle:@"批量添加" forState:UIControlStateNormal];
    [allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    allBtn.titleLabel.font = FONT_SIZE(17);
    [allBtn addTarget:self action:@selector(TouchAllBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addBtn = [[UIButton alloc] init];
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            // Fallback on earlier versions
            make.bottom.left.mas_offset(0);
        }
        make.height.mas_offset(LENGTH_SIZE(48));
        make.left.equalTo(allBtn.mas_right).offset(0);
        make.width.equalTo(allBtn);
    }];
    addBtn.backgroundColor = [UIColor baseColor];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = FONT_SIZE(17);
    [addBtn addTarget:self action:@selector(TouchAddBtn:) forControlEvents:UIControlEventTouchUpInside];

    self.scrollview = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollview];
//    [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.equalTo(addBtn.mas_top);
//        make.top.equalTo(SelectView.mas_bottom).offset(10);
//    }];
    self.scrollview.frame = CGRectMake(0,
                                           LENGTH_SIZE(54),
                                           Screen_Width,
                                           SCREEN_HEIGHT - LENGTH_SIZE(54+48) - kNavBarHeight -kBottomBarHeight);

    self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH*3,SCREEN_HEIGHT - LENGTH_SIZE(54+48) - kNavBarHeight -kBottomBarHeight);
    self.scrollview.pagingEnabled = YES;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.delegate = self;
 
    for (NSInteger i =0 ; i < 3 ; i++) {
        LWWorkTableView *view = [[LWWorkTableView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH,
                                                                                  0,
                                                                                  SCREEN_WIDTH,
                                                                                  SCREEN_HEIGHT - LENGTH_SIZE(54+48)- kNavBarHeight)];
        view.workStatus = i;
        view.ArrBtn = self.TypeArr;
        view.superViewArr = self.WorkViewArr;
        [view GetWorkRecord];
        [self.WorkViewArr addObject:view];
        [self.scrollview addSubview:view];
    }
    
//    [self.view addSubview:self.tableview];
//    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.equalTo(addBtn.mas_top);
//        make.top.equalTo(SelectView.mas_bottom).offset(10);
//    }];
    
    
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



-(void)TouchAllBtn:(UIButton *)sender{
    LWWorkerInfoVC *vc = [[LWWorkerInfoVC alloc] init];
    vc.Type = 1;
    vc.superViewArr = self.WorkViewArr;
    vc.ArrBtn = self.TypeArr;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)TouchAddBtn:(UIButton *)sender{
    LWWorkerInfoVC *vc = [[LWWorkerInfoVC alloc] init];
    vc.superViewArr = self.WorkViewArr;
    vc.ArrBtn = self.TypeArr;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - ScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self TouchTypeBtn:self.TypeArr[page]];
}




@end
