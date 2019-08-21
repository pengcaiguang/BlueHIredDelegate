//
//  LWMineVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/10.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWMineVC.h"
#import "LWMyMineCell.h"
#import "LWPersonalDataVC.h"
#import "LWSetVC.h"
#import "LWInfoVC.h"
#import "LPWithDrawalVC.h"
#import "LWAccountDetailsVC.h"
#import "LWSalarycCardVC.h"
#import "LPAccountManageVC.h"
#import "LWWorksRecommendVC.h"
#import "LWBankManageVC.h"
#import "LWAgencyFeeVC.h"
#import "LWStoerApplyVC.h"
#import "LWWorkerVC.h"
#import "LPSelectBindbankcardModel.h"

static  NSString *RSAPublickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDvh1MAVToAiuEVOFq9mo3IOJxN5aekgto1kyOh07qQ+1Wc+Uxk1wX2t6+HCA31ojcgaR/dZz/kQ5aZvzlB8odYHJXRtIcOAVQe/FKx828XFTzC8gp1zGh7vTzBCW3Ieuq+WRiq9cSzEZlNw9RcU38st9q9iBT8PhK0AkXE2hLbKQIDAQAB";
static NSString *RSAPrivateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAO+HUwBVOgCK4RU4Wr2ajcg4nE3lp6SC2jWTI6HTupD7VZz5TGTXBfa3r4cIDfWiNyBpH91nP+RDlpm/OUHyh1gcldG0hw4BVB78UrHzbxcVPMLyCnXMaHu9PMEJbch66r5ZGKr1xLMRmU3D1FxTfyy32r2IFPw+ErQCRcTaEtspAgMBAAECgYBSczN39t5LV4LZChf6Ehxh4lKzYa0OLNit/mMSjk43H7y9lvbb80QjQ+FQys37UoZFSspkLOlKSpWpgLBV6gT5/f5TXnmmIiouXXvgx4YEzlXgm52RvocSCvxL81WCAp4qTrp+whPfIjQ4RhfAT6N3t8ptP9rLgr0CNNHJ5EfGgQJBAP2Qkq7RjTxSssjTLaQCjj7FqEYq1f5l+huq6HYGepKU+BqYYLksycrSngp0y/9ufz0koKPgv1/phX73BmFWyhECQQDx1D3Gui7ODsX02rH4WlcEE5gSoLq7g74U1swbx2JVI0ybHVRozFNJ8C5DKSJT3QddNHMtt02iVu0a2V/uM6eZAkEAhvmce16k9gV3khuH4hRSL+v7hU5sFz2lg3DYyWrteHXAFDgk1K2YxVSUODCwHsptBNkogdOzS5T9MPbB+LLAYQJBAKOAknwIaZjcGC9ipa16txaEgO8nSNl7S0sfp0So2+0gPq0peWaZrz5wa3bxGsqEyHPWAIHKS20VRJ5AlkGhHxECQQDr18OZQkk0LDBZugahV6ejb+JIZdqA2cEQPZFzhA3csXgqkwOdNmdp4sPR1RBuvlVjjOE7tCiFLup/8TvRJDdr";

static NSString *LPMineCellID = @"LWMyMineCell";
@interface LWMineVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *TitleArr;
@property (weak, nonatomic) IBOutlet UIView *CardView;
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
@property (weak, nonatomic) IBOutlet UIImageView *UserSexImage;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UIButton *Certification;
@property (weak, nonatomic) IBOutlet UIButton *PersonalData;
@property (weak, nonatomic) IBOutlet UILabel *MoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *Withdraw;
@property (weak, nonatomic) IBOutlet UILabel *InfoNum;

@property (nonatomic,assign) BOOL OpenPhone;
@property(nonatomic,strong) LPUserMaterialModel *userMaterialModel;
@property(nonatomic,strong) LPSelectBindbankcardModel *BankcardModel;

@end



@implementation LWMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TitleArr = @[@"银行卡管理",@"账户管理",@"客服热线"];
    [self.view addSubview:self.tableview];
    self.tableview.clipsToBounds = YES;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.top.equalTo(self.CardView.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [LPTools setViewShapeLayer:self.Withdraw CornerRadii:12.5 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft ];
    
    self.UserImage.layer.cornerRadius = LENGTH_SIZE(30.0);
    self.UserImage.layer.borderWidth = LENGTH_SIZE(1);
    self.UserImage.layer.borderColor = [UIColor colorWithRed:220/255.0 green:235/255.0 blue:245/255.0 alpha:0.35].CGColor;
    
    self.InfoNum.layer.cornerRadius = LENGTH_SIZE(7.0);
    
    self.Certification.layer.cornerRadius = LENGTH_SIZE(9.0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.userMaterialModel = kAppDelegate.userMaterialModel;
    [self requestQueryInfounreadNum];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
 
}

#pragma mark - Touch
//系统设置
- (IBAction)TouchSysSet:(UIButton *)sender {
    LWSetVC *vc = [[LWSetVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//消息中心
- (IBAction)TouchInfo:(UIButton *)sender {
    LWInfoVC *vc = [[LWInfoVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//个人资料
- (IBAction)TouchPersonalData:(UIButton *)sender {
    LWPersonalDataVC *vc = [[LWPersonalDataVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userMaterialModel = self.userMaterialModel;
    [self.navigationController pushViewController:vc animated:YES];
}

//账户明细
- (IBAction)TouchAccountDetails:(UIButton *)sender {
    LWAccountDetailsVC *vc = [[LWAccountDetailsVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//提现
- (IBAction)TouchWithDraw:(UIButton *)sender {
    
    sender.enabled = NO;
    [self requestSelectBindbankcard];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });


}



-(void)setBankcardModel:(LPSelectBindbankcardModel *)BankcardModel{
    _BankcardModel = BankcardModel;
    NSString *bankNumberString = [RSAEncryptor decryptString:BankcardModel.data.bankNumber privateKey:RSAPrivateKey];
    
    if (BankcardModel.data && bankNumberString.length!=0) {
        
        LPWithDrawalVC *vc = [[LPWithDrawalVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.balance = self.userMaterialModel.data.money;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"您还未绑定工资卡，请先绑定再提现"];

        GJAlertMessage *alert = [[GJAlertMessage alloc]
                                 initWithTitle:str
                                 message:nil
                                 IsShowhead:YES
                                 backDismiss:YES
                                 textAlignment:NSTextAlignmentCenter
                                 buttonTitles:@[@"取消",@"去绑定"]
                                 buttonsColor:@[[UIColor colorWithHexString:@"#999999"],[UIColor baseColor]]
                                 buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]]
                                 buttonClick:^(NSInteger buttonIndex) {
                                     if (buttonIndex) {
                                         LWSalarycCardVC *vc = [[LWSalarycCardVC alloc] init];
                                         vc.model = self.BankcardModel;
                                         vc.hidesBottomBarWhenPushed = YES;
                                         [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                                     }
                                 }];
        [alert show];
    }
}



//招工记录
- (IBAction)TouchWorkers:(UIButton *)sender {
    LWWorkerVC *vc = [[LWWorkerVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//门店申请
- (IBAction)TouchStoreApply:(UIButton *)sender {
    LWStoerApplyVC *vc = [[LWStoerApplyVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//代理明细
- (IBAction)TouchAgency:(UIButton *)sender {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"此功能暂未开放"];
    
    GJAlertMessage *alert = [[GJAlertMessage alloc]
                             initWithTitle:str
                             message:nil
                             IsShowhead:YES
                             backDismiss:YES
                             textAlignment:NSTextAlignmentCenter
                             buttonTitles:@[@"确定"]
                             buttonsColor:@[[UIColor baseColor]]
                             buttonsBackgroundColors:@[[UIColor whiteColor]]
                             buttonClick:^(NSInteger buttonIndex) {
                                 
                             }];
    [alert show];
    
//    LWAgencyFeeVC *vc = [[LWAgencyFeeVC alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

//企业推荐
- (IBAction)TouchCompanies:(UIButton *)sender {
    LWWorksRecommendVC *vc = [[LWWorksRecommendVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TableViewDelegate & Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
 
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 ) {
         LWBankManageVC *vc = [[LWBankManageVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        LPAccountManageVC *vc = [[LPAccountManageVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        if (self.OpenPhone == NO) {
            self.OpenPhone = YES;
            NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.userMaterialModel.data.servicePhone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.OpenPhone = NO;
        });
    }
}

-(void)setUserMaterialModel:(LPUserMaterialModel *)userMaterialModel{
    _userMaterialModel = userMaterialModel;
    [LPUserDefaults  saveObject:userMaterialModel byFileName:USERINFO];
    kUserDefaultsSave(userMaterialModel.data.role, USERDATA);

    self.UserName.text =  [LPTools isNullToString:userMaterialModel.data.userName] ;
    
    [self.UserImage yy_setImageWithURL:[NSURL URLWithString:userMaterialModel.data.userUrl] placeholder:[UIImage imageNamed:@"Head_image"]];
    
    self.MoneyLabel.text = [NSString stringWithFormat:@"%.2f",userMaterialModel.data.money.floatValue];
    if ([userMaterialModel.data.userSex integerValue] == 0) {//0未知1男2女
        self.UserSexImage.hidden = YES;
    }else if ([userMaterialModel.data.userSex integerValue] == 1) {
        self.UserSexImage.hidden = NO;
        self.UserSexImage.image = [UIImage imageNamed:@"icon_men"];
    }else if ([userMaterialModel.data.userSex integerValue] == 2) {
        self.UserSexImage.hidden = NO;
        self.UserSexImage.image = [UIImage imageNamed:@"icon_women"];
    }
    
    if (userMaterialModel.data.isReal.integerValue) {
        [self.Certification setTitle:@"   已实名   " forState:UIControlStateNormal];
        [self.Certification setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        self.Certification.backgroundColor = [UIColor colorWithHexString:@"#3CAFFF" alpha:0.12];
        self.Certification.titleLabel.font = FONT_SIZE(11);
    }else{
        [self.Certification setTitle:@"未实名认证" forState:UIControlStateNormal];
        [self.Certification setTitleColor:[UIColor colorWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
        self.Certification.backgroundColor = [UIColor clearColor];
        self.Certification.titleLabel.font = FONT_SIZE(12);
    }
    
  
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


#pragma mark request
-(void)requestQueryInfounreadNum{
    NSDictionary *dic = @{@"type":@(1)
                          };
    [NetApiManager requestQueryUnreadNumWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                NSInteger num = [responseObject[@"data"] integerValue];
                if (num == 0) {
                    self.InfoNum.text = @"";
                    self.InfoNum.backgroundColor = [UIColor clearColor];
                }
                else if (num>9)
                {
                    self.InfoNum.text = @"9+";
                    self.InfoNum.backgroundColor = [UIColor redColor];
                }
                else
                {
                    self.InfoNum.text = [NSString stringWithFormat:@"%ld",(long)num];
                    self.InfoNum.backgroundColor = [UIColor redColor];
                          }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestSelectBindbankcard{
    [NetApiManager requestSelectBindbankcardWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.BankcardModel = [LPSelectBindbankcardModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
