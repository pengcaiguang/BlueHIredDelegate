//
//  LPWorkDetailVC.m
//  BlueHired
//
//  Created by peng on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPWorkDetailVC.h"
#import "LPWorkDetailModel.h"
#import "LPWorkDetailHeadCell.h"
#import "LPWorkDetailTextCell.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import "LWWorkDetailEditVC.h"

static NSString *LPWorkDetailHeadCellID = @"LPWorkDetailHeadCell";
static NSString *LPWorkDetailTextCellID = @"LPWorkDetailTextCell";


@interface LPWorkDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) LPWorkDetailModel *model;

@property(nonatomic,strong) NSMutableArray <UIButton *>*buttonArray;
@property(nonatomic,strong) UIView *lineView;

@property(nonatomic,strong) NSArray *textArray;
@property(nonatomic,strong) NSMutableArray <UIButton *> *bottomButtonArray;
@property(nonatomic,strong) UIButton *signUpButton;

@property(nonatomic,strong) NSString *userName;

@property(nonatomic,strong)CustomIOSAlertView *CustomAlert;

@property(nonatomic,strong) NSArray <LPWorklistDataWorkListModel *> *RecommendList;

@property(nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;  //!< 要导航的坐标

@property (nonatomic,strong) UITextField *NameTextField;

@property (nonatomic,strong) UILabel *ishidden;


@end

@implementation LPWorkDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"招聘详情";
//    self.navigationController.navigationBar.hidden = YES;

 


    self.buttonArray = [NSMutableArray array];
    self.bottomButtonArray = [NSMutableArray array];
    self.textArray = @[@"入职要求",@"薪资福利",@"食宿条件",@"工作时间",@"面试资料",@"其他说明"];

    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.mas_equalTo(-kNavBarHeight);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(-48);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(LENGTH_SIZE(-48));
        } else {
           make.bottom.mas_equalTo(LENGTH_SIZE(-48));
        }
    }];
    if ((kAppDelegate.userMaterialModel.data.role.integerValue == 1 ||
        kAppDelegate.userMaterialModel.data.role.integerValue == 2) && kAppDelegate.userMaterialModel.data.shopType.integerValue == 2) {
         [self setBottomView2];
    }else{
         [self setBottomView];
    }
    
    UILabel *ishidden = [[UILabel alloc] init];
    [self.view addSubview:ishidden];
    self.ishidden = ishidden;
    [ishidden mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(36));
    }];
    ishidden.backgroundColor = [UIColor colorWithHexString:@"#FFEDD4"];
    ishidden.textColor = [UIColor colorWithHexString:@"#FFA82E"];
    ishidden.layer.borderColor = [UIColor colorWithHexString:@"#F8C988"].CGColor;
    ishidden.layer.borderWidth = 1;
    ishidden.textAlignment = NSTextAlignmentCenter;
    ishidden.font = FONT_SIZE(14);
    ishidden.text = @"该职位已隐藏";
    ishidden.hidden = YES;
    
    if (kAppDelegate.userMaterialModel.data.shopType.integerValue == 2) {
        [self requestWork2Detail];
    }else{
        [self requestWorkDetail];
    }
 
 
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor clearColor], NSForegroundColorAttributeName, nil]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
    });
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.NBackBT setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0] forState:UIControlStateNormal];

}


-(void)setBottomView2{
    
    UIView *bottomBgView = [[UIView alloc]init];
    [self.view addSubview:bottomBgView];
    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(LENGTH_SIZE(-142));
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(LENGTH_SIZE(48));
    }];
    
    self.signUpButton = [[UIButton alloc]init];
    [self.view addSubview:self.signUpButton];
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(LENGTH_SIZE(48));
        make.width.mas_equalTo(LENGTH_SIZE(142));
    }];
    [self.signUpButton setTitle:@"设为隐藏" forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.signUpButton.backgroundColor = [UIColor baseColor];
    self.signUpButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(18)];
    [self.signUpButton addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventTouchUpInside];
 
    
    NSArray *imgArray = @[@"service",@"share",@"edit"];
    NSArray *titleArray = @[@"咨询",@"分享",@"编辑"];
    for (int i =0; i<titleArray.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        [bottomBgView addSubview:button];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:FontSize(11)];
        button.tag = i;
        button.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
        button.layer.borderWidth = 0.5;
        [button addTarget:self action:@selector(touchBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomButtonArray addObject:button];
    }
    [self.bottomButtonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [self.bottomButtonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-0);
    }];
    
    for (UIButton *button in self.bottomButtonArray) {
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width, -button.imageView.frame.size.height, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.intrinsicContentSize.height, 0, 0, -button.titleLabel.intrinsicContentSize.width);
    }
    
}


-(void)setBottomView{

    UIView *bottomBgView = [[UIView alloc]init];
    [self.view addSubview:bottomBgView];
    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(LENGTH_SIZE(48));
    }];
 

    NSArray *titleArray = @[@"咨询",@"分享"];
    for (int i =0; i<titleArray.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        [bottomBgView addSubview:button];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            button.backgroundColor =[UIColor whiteColor];
        }else if (i == 1){
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor =[UIColor baseColor];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:FontSize(17)];
        button.tag = i;
        [button addTarget:self action:@selector(touchBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomButtonArray addObject:button];
    }
    [self.bottomButtonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [self.bottomButtonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-0);
    }];
    
}

 

-(void)touchBottomButton:(UIButton *)button{
    if (button.tag == 0) {
        NSLog(@"咨询");
        NSString *name = self.model.data.teacherName;
        NSString *number = self.model.data.teacherPhone;
 
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
        self.CustomAlert = alertView;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LENGTH_SIZE(300), LENGTH_SIZE(250))];
        view.layer.cornerRadius = LENGTH_SIZE(6);
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *titlelabel = [[UILabel alloc] init];
        [view addSubview:titlelabel];
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.left.mas_offset(0);
            make.top.mas_offset(LENGTH_SIZE(24));
        }];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        titlelabel.font = [UIFont boldSystemFontOfSize:FontSize(18)];
        titlelabel.text = @"驻厂联系方式";
        
        UILabel *titlelabel2 = [[UILabel alloc] init];
        [view addSubview:titlelabel2];
        [titlelabel2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.left.mas_offset(0);
            make.top.equalTo(titlelabel.mas_bottom).offset(LENGTH_SIZE(12));
        }];
        titlelabel2.textAlignment = NSTextAlignmentCenter;
        titlelabel2.font = [UIFont systemFontOfSize:FontSize(14)];
        titlelabel2.text = @"微信搜索号码即可添加驻厂微信";
        titlelabel2.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
        
        UIView *SubView = [[UIView alloc] init];
        [view addSubview:SubView];
        [SubView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(titlelabel2.mas_bottom).offset(LENGTH_SIZE(19));
            make.left.mas_offset(LENGTH_SIZE(20));
            make.right.mas_offset(LENGTH_SIZE(-20));
            make.height.mas_offset(LENGTH_SIZE(75));
        }];
        SubView.layer.cornerRadius = LENGTH_SIZE(4);
        SubView.backgroundColor = [UIColor colorWithHexString:@"#F5F7FA"];
        
        
        UILabel *SubLabel1 = [[UILabel alloc] init];
        [SubView addSubview:SubLabel1];
        [SubLabel1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_offset(LENGTH_SIZE(13));
            make.left.mas_offset(LENGTH_SIZE(16));
            make.right.mas_offset(LENGTH_SIZE(-16));
        }];
        SubLabel1.textColor = [UIColor colorWithHexString:@"#666666"];
        SubLabel1.font = [UIFont systemFontOfSize:FontSize(15)];
        SubLabel1.text = [NSString stringWithFormat:@"姓名：%@ ",name];
        
        UILabel *SubLabel2 = [[UILabel alloc] init];
        [SubView addSubview:SubLabel2];
        [SubLabel2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(SubLabel1.mas_bottom).offset(LENGTH_SIZE(12));
            make.left.mas_offset(LENGTH_SIZE(16));
        }];
        SubLabel2.textColor = [UIColor colorWithHexString:@"#666666"];
        SubLabel2.font = [UIFont systemFontOfSize:FontSize(15)];
        SubLabel2.text = [NSString stringWithFormat:@"电话：%@ ",number];
        
        UIButton *CopyBt = [[UIButton alloc] init];
        [SubView addSubview:CopyBt];
        [CopyBt mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.mas_offset(LENGTH_SIZE(-16));
            make.centerY.equalTo(SubLabel2);
        }];
        CopyBt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14)];
        [CopyBt setTitle:@"复制号码" forState:UIControlStateNormal];
        [CopyBt setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        [CopyBt addTarget:self action:@selector(TouchCopyBt) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *dialBt = [[UIButton alloc] init];
        [view addSubview:dialBt];
        [dialBt mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(SubView.mas_bottom).offset(LENGTH_SIZE(24));
            make.right.mas_offset(LENGTH_SIZE(-20));
            make.left.mas_offset(LENGTH_SIZE(20));
            make.height.mas_offset(LENGTH_SIZE(40));
        }];
        [dialBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dialBt setTitle:@"立即拨打" forState:UIControlStateNormal];
        dialBt.layer.cornerRadius = LENGTH_SIZE(6);
        dialBt.backgroundColor = [UIColor baseColor];
        [dialBt addTarget:self action:@selector(TouchDialBt:) forControlEvents:UIControlEventTouchUpInside];
        
        alertView.containerView = view;
        alertView.buttonTitles=@[];
        [alertView setUseMotionEffects:true];
        [alertView setCloseOnTouchUpOutside:true];
        [alertView show];
        
        return;
    }
    else if (button.tag == 1)
    {
        
        NSString *url = @"";
        if (kAppDelegate.userMaterialModel.data.shopType.integerValue == 2) {
            url = [NSString stringWithFormat:@"%@resident/#/proxyworkdetail?workId=%@&identity=%@&origin=proxyV2&backIcon=1",
                   BaseRequestWeiXiURL,self.workListModel.id,kUserDefaultsValue(USERIDENTIY)];
        }else{
            url = [NSString stringWithFormat:@"%@resident/#/recruitdetail?id=%@&identity=%@&origin=proxy",
                   BaseRequestWeiXiURL,self.workListModel.id,kUserDefaultsValue(USERIDENTIY)];
        }
        // http://192.168.0.152:8070/#/recruitdetail?id=29
        
        NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [LPTools ClickShare:encodedUrl Title:[NSString stringWithFormat:@"您的好友通过蓝聘平台给您推荐了%@，快来看看吧！",_model.data.mechanismName]];
        return;

    }else if (button.tag == 2){
        if ((self.model.data.reTime.integerValue>0 &&
             self.model.data.maxReMoney.integerValue>0 &&
             self.model.data.maxReStatus.integerValue == 1 &&
             [self.model.data.postType integerValue] == 0 )||
            (self.model.data.reTime.integerValue>0 &&
             self.model.data.maxAddWorkMoney.floatValue>0.0 &&
             self.model.data.maxReStatus.integerValue == 1&&
             [self.model.data.postType integerValue] == 1)) {
                LWWorkDetailEditVC *vc = [[LWWorkDetailEditVC alloc] init];
                vc.superViewArr = self.superViewArr;
                vc.workListModel = self.workListModel;
                vc.model = self.model;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                if ([self.model.data.postType integerValue] == 1) {
                    [self.view showLoadingMeg:@"该企业暂无奖励工价，不能进行编辑" time:MESSAGE_SHOW_TIME];

                }else{
                    [self.view showLoadingMeg:@"该企业暂无返费，不能进行编辑" time:MESSAGE_SHOW_TIME];

                }
            }
        
        return;
    }
    
    
}

-(void)TouchCopyBt{
    [self.CustomAlert close];

    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.data.teacherPhone;
    [self.view showLoadingMeg:@"复制成功" time:MESSAGE_SHOW_TIME];
}

-(void)TouchDialBt:(UIButton *)sender{
    [self.CustomAlert close];

    sender.enabled = NO;
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.model.data.teacherPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}
#pragma mark - 设为隐藏
- (void)preventFlicker:(UIButton *)button {
    [self requestUpdateShopWork];
}


#pragma mark - setdata
-(void)setModel:(LPWorkDetailModel *)model{
    _model = model;

    if ([model.data.workHide integerValue] == 1) {
        [self.signUpButton setTitle:@"取消隐藏" forState:UIControlStateNormal];
    }else{
        [self.signUpButton setTitle:@"设为隐藏" forState:UIControlStateNormal];
    }

//    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
//    });
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat reOffset = scrollView.contentOffset.y + (SCREEN_HEIGHT - kNavBarHeight) * 0.2;
    CGFloat alpha = reOffset / ((SCREEN_HEIGHT - kNavBarHeight) * 0.2);
    if (alpha <= 1)//下拉永不显示导航栏
    {
        alpha = 0;
    }
    else//上划前一个导航栏的长度是渐变的
    {
        alpha -= 1;
    }
 
    [self.NBackBT setImage:[UIImage imageNamed:@"BackBttonImage"] forState:UIControlStateNormal];
 
    // 设置导航条的背景图片 其透明度随  alpha 值 而改变
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:alpha]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0 green:0 blue:0 alpha:alpha], NSForegroundColorAttributeName, nil]];
    [self.NBackBT setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:alpha] forState:UIControlStateNormal];
    
    if (scrollView.contentOffset.y+kNavBarHeight>LENGTH_SIZE(280)
        && self.model.data.workHide.integerValue && kAppDelegate.userMaterialModel.data.shopType.integerValue == 2) {
        self.ishidden.hidden =   NO ;
    }else{
        self.ishidden.hidden =   YES ;
    }

}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else if (section == 1){
         return 10.0;
    }else{
        return 10.0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 6;
    }else {
        return 3;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
    if (section == 1 || section == 2) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        return view;
    }
    
    return nil;
}




-(void)selectButtonAtIndex:(NSInteger)index{
    for (UIButton *button in self.buttonArray) {
        button.selected = NO;
    }
    self.buttonArray[index].selected = YES;;
    CGSize size = CGSizeMake(100, MAXFLOAT);//设置高度宽度的最大限度
    CGRect rect = [self.buttonArray[index].titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
    CGFloat btnx = CGRectGetMinX(self.buttonArray[index].frame);
    CGFloat btnw = CGRectGetWidth(self.buttonArray[index].frame);
    CGFloat x = (btnw - rect.size.width)/2;
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.frame = CGRectMake(btnx + x-5, 42, rect.size.width+10, 2);
    }];
    
}
-(void)scrollToItenIndex:(NSInteger)index{
    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *strbackmoney = [self removeHTML2:self.model.data.reInstruction];
        CGFloat KeyHeight = [self calculateKeyHeight:self.model.data.key];
        
//        if (self.model.data.key.length == 0 && ![self.model.data.lendType integerValue]) {
//            KeyHeight = 0;
//        }
        CGFloat workHideHeight = self.model.data.workHide.integerValue &&
        kAppDelegate.userMaterialModel.data.shopType.integerValue == 2?
        LENGTH_SIZE(36):0;
        
        if ((strbackmoney.length>0 &&
             self.model.data.reTime.integerValue>0 &&
             self.model.data.reMoney.integerValue>0 &&
             self.model.data.reStatus.integerValue == 1 &&
             [self.model.data.postType integerValue] == 0 )||
            (strbackmoney.length>0 &&
             self.model.data.reTime.integerValue>0 &&
             self.model.data.addWorkMoney.floatValue>0.0 &&
             self.model.data.reStatus.integerValue == 1&&
             [self.model.data.postType integerValue] == 1)) {
            CGFloat BackMoneyHeight = [LPTools calculateRowHeight:strbackmoney fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(26)];
             return LENGTH_SIZE(280 + 128 + 36 + 20)  + BackMoneyHeight + KeyHeight + workHideHeight;
        }else{
            return LENGTH_SIZE(280 + 128 ) + KeyHeight + workHideHeight;
        }
    }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                CGFloat Height = [LPTools calculateRowHeight:[self removeHTML2:self.model.data.workDemand] fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(28)];
                return LENGTH_SIZE(51)+Height;
            }else if (indexPath.row == 1){
                CGFloat Height = [LPTools calculateRowHeight:[self removeHTML2:self.model.data.workSalary] fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(28)];
                return LENGTH_SIZE(51)+Height;
            }else if (indexPath.row == 2){
                CGFloat Height = [LPTools calculateRowHeight:[self removeHTML2:self.model.data.eatSleep ] fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(28)];
                return LENGTH_SIZE(51)+Height;
            }else if (indexPath.row == 3){
                CGFloat Height = [LPTools calculateRowHeight:[self removeHTML2:self.model.data.workTime ] fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(28)];
                return LENGTH_SIZE(51)+Height;
            }else if (indexPath.row == 4){
                CGFloat Height = [LPTools calculateRowHeight:[self removeHTML2:self.model.data.workKnow] fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(28)];
                return LENGTH_SIZE(51)+Height;
            }else if (indexPath.row == 5){
                CGFloat Height = [LPTools calculateRowHeight:[self removeHTML2:self.model.data.remarks] fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(28)];
                return LENGTH_SIZE(66)+Height;
            }
    }else{
        if (indexPath.row == 0) {
            CGFloat Height = [LPTools calculateRowHeight:[self removeHTML2:self.model.data.mechanismDetails ] fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(28)];
            return LENGTH_SIZE(51)+Height;
        }else if (indexPath.row == 1){
            CGFloat Height = [LPTools calculateRowHeight:[NSString stringWithFormat:@"企业地址:%@\n面试地址:%@",self.model.data.mechanismAddress,self.model.data.recruitAddress] fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(28)];
            return LENGTH_SIZE(66)+Height;
        }else if (indexPath.row == 2){
            return LENGTH_SIZE(44.0);
        }
    }
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LPWorkDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailHeadCellID];
        cell.model = self.model;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }else if (indexPath.section == 1){
 
        LPWorkDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailTextCellID];
        cell.detailTitleLabel.text = [NSString stringWithFormat:@"%@:",self.textArray[indexPath.row]];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (indexPath.row == 0) {
            NSString *string=[self removeHTML2:self.model.data.workDemand ];
            cell.detailLabel.text = string;
//            cell.detailLabel.text = [self.model.data.workDemand htmlUnescapedString];
        }else if (indexPath.row == 1){
            NSString *string=[self removeHTML2:self.model.data.workSalary ];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 2){
            NSString *string=[self removeHTML2:self.model.data.eatSleep ];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 3){
            NSString *string=[self removeHTML2:self.model.data.workTime ];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 4){
            NSString *string=[self removeHTML2:self.model.data.workKnow ];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 5){
            NSString *string=[self removeHTML2:self.model.data.remarks ];
            cell.detailLabel.text = string;
        }
        
        return cell;
    }else{
        if (indexPath.row == 0) {
            LPWorkDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailTextCellID];
            cell.detailTitleLabel.text = @"企业简介:";
            cell.detailLabel.text = [self removeHTML2:self.model.data.mechanismDetails ];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cell;
        }else if (indexPath.row == 1){

            LPWorkDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailTextCellID];
            cell.detailTitleLabel.text = @"企业地址:";
            cell.detailLabel.text = [NSString stringWithFormat:@"企业地址:%@\n面试地址:%@",self.model.data.mechanismAddress,self.model.data.recruitAddress];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cell;
        }else{
            static NSString *rid=@"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
            if(cell == nil){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
                UIView *LineV = [[UIView alloc] init];
                [cell.contentView addSubview:LineV];
                [LineV mas_makeConstraints:^(MASConstraintMaker *make){
                    make.left.top.mas_offset(0);
                    make.height.mas_offset(1);
                    make.width.mas_offset(SCREEN_WIDTH);
                }];
                LineV.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor = [UIColor baseColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = @"导航查看面试地址";
            cell.imageView.image = [UIImage imageNamed:@"guide"];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cell;
        }
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && indexPath.row == 2){
        NSDecimalNumber *XNumber = [NSDecimalNumber decimalNumberWithString:self.model.data.x];
        NSDecimalNumber *YNumber = [NSDecimalNumber decimalNumberWithString:self.model.data.y];
        
        CLLocationCoordinate2D pt2 = {[XNumber doubleValue],[YNumber doubleValue]};
        
        self.coordinate = [self GCJ02FromBD09:pt2];
        
        [self ToNavMap];
    }
}


#pragma mark - request
-(void)requestWorkDetail{
    NSDictionary *dic = @{
                          @"workId":self.workListModel.id
                          };
    [NetApiManager requestWorkDetailWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPWorkDetailModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



-(void)requestWork2Detail{
    NSDictionary *dic = @{
                          @"workId":self.workListModel.id
                          };
    [NetApiManager requestWorkDetail2WithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPWorkDetailModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

 

- (void)requestUpdateShopWork{
    
    NSDictionary *dic = @{
                          @"workId":self.model.data.id,
                          @"workHide":self.model.data.workHide.integerValue?@"0":@"1",
                          };

    [NetApiManager requestUpdateShopWork:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    if (self.superViewArr.count>=2) {
                        LWMainView *V1 = self.superViewArr[0];
                        LWMainView *V2 = self.superViewArr[1];
                        if (self.model.data.workHide.integerValue == 1) {
                            for (LPWorklistDataWorkListModel *m in V2.listArray) {
                                if (m.id.integerValue == self.workListModel.id.integerValue) {
                                    [V2.listArray removeObject:m];
                                    break;
                                }
                            }
                            [V1.listArray insertObject:self.workListModel atIndex:0];
                        }else{
                            for (LPWorklistDataWorkListModel *m in V1.listArray) {
                                if (m.id.integerValue == self.workListModel.id.integerValue) {
                                    [V1.listArray removeObject:m];
                                    break;
                                }
                            }
                            [V2.listArray insertObject:self.workListModel atIndex:0];
                        }
                        [V1 NodataView];
                        [V2 NodataView];
                        [V1.tableview reloadData];
                        [V2.tableview reloadData];
                    }
                    
                    self.model.data.workHide = self.model.data.workHide.integerValue?@"0":@"1";
                    self.workListModel.workHide = self.model.data.workHide;
                    [self setModel:self.model];
                    [self.view showLoadingMeg:@"修改成功" time:MESSAGE_SHOW_TIME];
                }else{
                    [self.view showLoadingMeg:@"修改失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 0;

        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPWorkDetailHeadCellID bundle:nil] forCellReuseIdentifier:LPWorkDetailHeadCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPWorkDetailTextCellID bundle:nil] forCellReuseIdentifier:LPWorkDetailTextCellID];
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(10))];
        footView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        _tableview.tableFooterView = footView;


    }
    return _tableview;
}


//计算标签高度
-(CGFloat)calculateKeyHeight:(NSString *) Key{
    if (Key.length == 0) {
        return LENGTH_SIZE(17);
    }
    Key = [Key stringByReplacingOccurrencesOfString:@"丨" withString:@"|"];

    NSArray * tagArr = [Key componentsSeparatedByString:@"|"];
    CGFloat tagBtnX = 0;
    CGFloat tagBtnY = 0;
    for (int i= 0; i<tagArr.count; i++) {
        CGSize tagTextSize = [tagArr[i] sizeWithFont:[UIFont systemFontOfSize:FontSize(12)] maxSize:CGSizeMake(SCREEN_WIDTH-LENGTH_SIZE(73), LENGTH_SIZE(17))];
        if (tagBtnX+tagTextSize.width+14 > SCREEN_WIDTH-LENGTH_SIZE(73)) {
            tagBtnX = 0;
            tagBtnY += LENGTH_SIZE(17)+8;
        }
        tagBtnX = tagBtnX + tagTextSize.width + LENGTH_SIZE(4);
    }
    return tagBtnY + LENGTH_SIZE(17) ;
}

//计算Cell标签高度
-(CGFloat)calculateKeyHeightCell:(NSString *) Key{
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

- (NSString *)removeHTML2:(NSString *)html{
//    NSArray *components = [html componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    NSMutableArray *componentsToKeep = [NSMutableArray array];
//    for (int i = 0; i < [components count]; i = i + 2) {
//        [componentsToKeep addObject:[components objectAtIndex:i]];
//    }
//    NSString *plainText = [componentsToKeep componentsJoinedByString:@"\n"];
//    return plainText;
    
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSString *string = [attrStr.string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    return string;
 
    
}



-(void)ToNavMap
{
    //系统版本高于8.0，使用UIAlertController
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"导航到设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //自带地图
    [alertController addAction:[UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"alertController -- 自带地图");
        
        //使用自带地图导航
        MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:nil]];
        
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                   MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
        
        
    }]];
    
    //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 高德地图");
            NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2&dname=%@",self.coordinate.latitude,self.coordinate.longitude,self.model.data.recruitAddress]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 百度地图");
            NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02&title=%@",self.coordinate.latitude,self.coordinate.longitude,self.model.data.recruitAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 腾讯地图");
            
            NSString *urlsting =[[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&to=%@&type=drive&tocoord=%f,%f&coord_type=1&referer={ios.blackfish.XHY}",self.model.data.recruitAddress,self.coordinate.latitude,self.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    
    
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    //显示alertController
    [[UIWindow visibleViewController] presentViewController:alertController animated:YES completion:nil];
    
}


-(CLLocationCoordinate2D)GCJ02FromBD09:(CLLocationCoordinate2D)coor
{
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coor.longitude - 0.0065, y = coor.latitude - 0.006;
    CLLocationDegrees z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    CLLocationDegrees gg_lon = z * cos(theta);
    CLLocationDegrees gg_lat = z * sin(theta);
    return CLLocationCoordinate2DMake(gg_lat, gg_lon);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
