//
//  LWMyStore.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/10.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWMyStore.h"
#import "LWMyMineCell.h"
#import "LWStoreInfoModel.h"
#import "LWStoreQRCodeVC.h"
#import "LWStoreWorkDetailsVC.h"
#import "LWIncomeDetailsVC.h"
#import "LWShopAssistantManageVC.h"
#import "LWMyStaff.h"
#import "LPMainVC.h"
#import "LWMain2VC.h"
#import "LWStoerApplyVC.h"

static NSString *LPMineCellID = @"LWMyMineCell";
@interface LWMyStore ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *ApplyView;
@property (weak, nonatomic) IBOutlet UILabel *StoreType;
@property (weak, nonatomic) IBOutlet UILabel *StoreNumber;
@property (weak, nonatomic) IBOutlet UILabel *StoreTime;
@property (weak, nonatomic) IBOutlet UIView *StoreSalesclerk;

@property (weak, nonatomic) IBOutlet UILabel *SalesclerkLabel;
@property (weak, nonatomic) IBOutlet UIButton *StoreCount;
@property (weak, nonatomic) IBOutlet UIButton *SalesclerkCount;
@property (weak, nonatomic) IBOutlet UIButton *ApplyCount;

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *TitleArr;

@property (nonatomic,strong) LWStoreInfoModel *InfoModel;

@property (nonatomic,strong) CustomIOSAlertView *SuperAlertViewInfo;

@end

@implementation LWMyStore

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TitleArr = @[];
   
    [self.view addSubview:self.tableview];
    self.tableview.clipsToBounds = YES;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.top.equalTo(self.StoreSalesclerk.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.view bringSubviewToFront:self.ApplyView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (kAppDelegate.userMaterialModel.data.role.integerValue == 5) {
       self.ApplyView.hidden = NO;
    }
    [self requestShopInfo];
}

//门店申请
- (IBAction)TouchStoreApplyFor:(id)sender {
    if (kAppDelegate.userMaterialModel.data.isReal.integerValue == 0) {
        [self.view showLoadingMeg:@"您还未实名认证,不能进行门店申请" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    LWStoerApplyVC *vc = [[LWStoerApplyVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//店员
- (IBAction)TouchSalesclerk:(id)sender {
    if (kAppDelegate.userMaterialModel.data.role.integerValue == 1 ||
        kAppDelegate.userMaterialModel.data.role.integerValue == 2) {
        LWShopAssistantManageVC *vc = [[LWShopAssistantManageVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (kAppDelegate.userMaterialModel.data.role.integerValue == 6){
        [self.SuperAlertViewInfo show];
    }

}

//我的员工
- (IBAction)TouchMySalesclerk:(id)sender {
    LWMyStaff *vc = [[LWMyStaff alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}
//报名员工
- (IBAction)TouchApplyForSalesclerk:(id)sender {
    LWMyStaff *vc = [[LWMyStaff alloc] init];
    vc.Type = 1;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TableViewDelegate & Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    return v;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.TitleArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LENGTH_SIZE(50);
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWMyMineCell *cell = [tableView dequeueReusableCellWithIdentifier:LPMineCellID];
    if(cell == nil){
        cell = [[LWMyMineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMineCellID];
    }
    cell.titleLabel.text = self.TitleArr[indexPath.row];
    if ([cell.titleLabel.text isEqualToString:@"门店二维码"]) {
        cell.RightImage2.hidden = NO;
    }else{
        cell.RightImage2.hidden = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    //@[@"门店二维码",@"门店招工详情",@"招聘企业"]
    if (kAppDelegate.userMaterialModel.data.role.integerValue == 1 ||
        kAppDelegate.userMaterialModel.data.role.integerValue == 2) {
        if (kAppDelegate.userMaterialModel.data.shopType.integerValue == 2) {
            if (indexPath.row == 0) {
                LWStoreQRCodeVC *vc = [[LWStoreQRCodeVC alloc] init];
                vc.InfoModel = self.InfoModel;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (indexPath.row == 1){
                LWIncomeDetailsVC *vc = [[LWIncomeDetailsVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (indexPath.row == 2){
                LWStoreWorkDetailsVC *vc = [[LWStoreWorkDetailsVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (indexPath.row == 3){
                LWMain2VC *vc =[[LWMain2VC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            
            if (indexPath.row == 0) {
                LWStoreQRCodeVC *vc = [[LWStoreQRCodeVC alloc] init];
                vc.InfoModel = self.InfoModel;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (indexPath.row == 1){
                LWStoreWorkDetailsVC *vc = [[LWStoreWorkDetailsVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (indexPath.row == 2){
                LPMainVC *vc =[[LPMainVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
    }else if (kAppDelegate.userMaterialModel.data.role.integerValue == 6){  //self.TitleArr = @[@"门店二维码",@"招聘企业"];
        if (indexPath.row == 0) {
            LWStoreQRCodeVC *vc = [[LWStoreQRCodeVC alloc] init];
            vc.InfoModel = self.InfoModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            if (kAppDelegate.userMaterialModel.data.shopType.integerValue == 2) {
                LWMain2VC *vc =[[LWMain2VC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                LPMainVC *vc =[[LPMainVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }

    }
    
}

-(void)setInfoModel:(LWStoreInfoModel *)InfoModel{
    _InfoModel = InfoModel;
    
    self.SuperAlertViewInfo = nil;
    
    self.ApplyView.hidden = YES;
    self.StoreNumber.text = [NSString stringWithFormat:@"门店编号：%@",InfoModel.data.shopNum];
    [self.SalesclerkCount setTitle:[NSString stringWithFormat:@"%ld人",(long)InfoModel.data.shopLabourNum.integerValue] forState:UIControlStateNormal];
    [self.ApplyCount setTitle:[NSString stringWithFormat:@"%ld人",(long)InfoModel.data.enrollNum.integerValue] forState:UIControlStateNormal];
    if (kAppDelegate.userMaterialModel.data.role.integerValue == 1 ||       //店主
        kAppDelegate.userMaterialModel.data.role.integerValue == 2) {
        [self.StoreCount setTitle:[NSString stringWithFormat:@"%ld人",(long)InfoModel.data.shopUserNum.integerValue] forState:UIControlStateNormal];
        [self.StoreCount setImage:nil forState:UIControlStateNormal];
        self.SalesclerkLabel.text = @"店员";
        if (kAppDelegate.userMaterialModel.data.shopType.integerValue == 2) {
            self.TitleArr = @[@"门店二维码",@"门店收入明细",@"门店招工详情",@"招聘企业"];
        }else{
            self.TitleArr = @[@"门店二维码",@"门店招工详情",@"招聘企业"];
        }
//        self.TitleArr = @[@"门店二维码",@"门店招工详情",@"招聘企业"];
        self.StoreType.text = [NSString stringWithFormat:@"%@(店主)",[LPTools isNullToString:InfoModel.data.userName]];
        self.StoreTime.text = [NSString stringWithFormat:@"注册时间：%@",[NSString convertStringToYYYMMDD:InfoModel.data.time]];
    }else if (kAppDelegate.userMaterialModel.data.role.integerValue == 6){      //店员
        [self.StoreCount setTitle:@"" forState:UIControlStateNormal];
        [self.StoreCount setImage:[UIImage imageNamed:@"manager"] forState:UIControlStateNormal];
        self.SalesclerkLabel.text = @"店主信息";
        self.TitleArr = @[@"门店二维码",@"招聘企业"];
        self.StoreType.text = [NSString stringWithFormat:@"%@(店员)",[LPTools isNullToString:InfoModel.data.userName]];
        self.StoreTime.text = [NSString stringWithFormat:@"入店时间：%@",[NSString convertStringToYYYMMDD:InfoModel.data.time]];

    }
    [self.tableview reloadData];
}

#pragma mark - request

-(void)requestShopInfo{
    if (kAppDelegate.userMaterialModel.data.role.integerValue == 5) {
        return;
    }
    NSDictionary *dic = @{@"type":kAppDelegate.userMaterialModel.data.role};
    [NetApiManager requestShopInfo:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0  ) {
                self.InfoModel = [LWStoreInfoModel mj_objectWithKeyValues:responseObject];
            }else{              //返回不成功,清空
           
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
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F2F2F2"];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPMineCellID bundle:nil] forCellReuseIdentifier:LPMineCellID];
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.scrollEnabled = NO;
        //        _tableview.sectionHeaderHeight = CGFLOAT_MIN;
        //        _tableview.sectionFooterHeight = 10;
        //        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        
    }
    return _tableview;
}

-(CustomIOSAlertView *)SuperAlertViewInfo{
    if (!_SuperAlertViewInfo) {
        _SuperAlertViewInfo = [[CustomIOSAlertView alloc] init];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LENGTH_SIZE(300), LENGTH_SIZE(180))];
        view.backgroundColor = [UIColor whiteColor];
        UIImageView *userImage = [[UIImageView alloc] init];
        [view addSubview:userImage];
        [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.mas_offset(LENGTH_SIZE(24));
            make.width.height.mas_offset(LENGTH_SIZE(60));
        }];
        userImage.layer.cornerRadius = LENGTH_SIZE(30);
        [userImage yy_setImageWithURL:[NSURL URLWithString:self.InfoModel.data.userUrl] placeholder:[UIImage imageNamed:@"Head_image"]];
        userImage.clipsToBounds = YES;
        userImage.contentMode = UIViewContentModeScaleAspectFill;
        
        
        UIButton *delete = [[UIButton alloc] init];
        [view addSubview:delete];
        [delete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(LENGTH_SIZE(11));
            make.right.mas_offset(LENGTH_SIZE(-11));
        }];
        [delete setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(AlertViewClose:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *userName = [[UILabel alloc] init];
        [view addSubview:userName];
        [userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(userImage.mas_bottom).offset(LENGTH_SIZE(18));
            make.centerX.equalTo(view);
        }];
        userName.text = self.InfoModel.data.userName;
        userName.textColor = [UIColor colorWithHexString:@"#333333"];
        userName.font = [UIFont boldSystemFontOfSize:FontSize(18)];
        
        UIButton *userTel = [[UIButton alloc] init];
        [view addSubview:userTel];
        [userTel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(userName.mas_bottom).offset(LENGTH_SIZE(13));
        }];
        [userTel setTitle:[NSString stringWithFormat:@"  %@",self.InfoModel.data.userTel] forState:UIControlStateNormal];
        [userTel setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
        [userTel setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        userTel.titleLabel.font = FONT_SIZE(16);
        
        [_SuperAlertViewInfo setContainerView:view];
        [_SuperAlertViewInfo setButtonTitles:@[]];
        [_SuperAlertViewInfo setCloseOnTouchUpOutside:YES];
    }
    return _SuperAlertViewInfo;
}

-(void)AlertViewClose:(UIButton *)sender{
    [self.SuperAlertViewInfo close];
}

@end
