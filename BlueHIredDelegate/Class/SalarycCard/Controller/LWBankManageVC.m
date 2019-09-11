//
//  LWBankManageVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/15.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWBankManageVC.h"
#import "LPSalarycCardChangePasswordVC.h"
#import "LWSalarycCardVC.h"
#import "LPSelectBindbankcardModel.h"


static  NSString *RSAPublickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDvh1MAVToAiuEVOFq9mo3IOJxN5aekgto1kyOh07qQ+1Wc+Uxk1wX2t6+HCA31ojcgaR/dZz/kQ5aZvzlB8odYHJXRtIcOAVQe/FKx828XFTzC8gp1zGh7vTzBCW3Ieuq+WRiq9cSzEZlNw9RcU38st9q9iBT8PhK0AkXE2hLbKQIDAQAB";
static NSString *RSAPrivateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAO+HUwBVOgCK4RU4Wr2ajcg4nE3lp6SC2jWTI6HTupD7VZz5TGTXBfa3r4cIDfWiNyBpH91nP+RDlpm/OUHyh1gcldG0hw4BVB78UrHzbxcVPMLyCnXMaHu9PMEJbch66r5ZGKr1xLMRmU3D1FxTfyy32r2IFPw+ErQCRcTaEtspAgMBAAECgYBSczN39t5LV4LZChf6Ehxh4lKzYa0OLNit/mMSjk43H7y9lvbb80QjQ+FQys37UoZFSspkLOlKSpWpgLBV6gT5/f5TXnmmIiouXXvgx4YEzlXgm52RvocSCvxL81WCAp4qTrp+whPfIjQ4RhfAT6N3t8ptP9rLgr0CNNHJ5EfGgQJBAP2Qkq7RjTxSssjTLaQCjj7FqEYq1f5l+huq6HYGepKU+BqYYLksycrSngp0y/9ufz0koKPgv1/phX73BmFWyhECQQDx1D3Gui7ODsX02rH4WlcEE5gSoLq7g74U1swbx2JVI0ybHVRozFNJ8C5DKSJT3QddNHMtt02iVu0a2V/uM6eZAkEAhvmce16k9gV3khuH4hRSL+v7hU5sFz2lg3DYyWrteHXAFDgk1K2YxVSUODCwHsptBNkogdOzS5T9MPbB+LLAYQJBAKOAknwIaZjcGC9ipa16txaEgO8nSNl7S0sfp0So2+0gPq0peWaZrz5wa3bxGsqEyHPWAIHKS20VRJ5AlkGhHxECQQDr18OZQkk0LDBZugahV6ejb+JIZdqA2cEQPZFzhA3csXgqkwOdNmdp4sPR1RBuvlVjjOE7tCiFLup/8TvRJDdr";

@interface LWBankManageVC ()
@property (weak, nonatomic) IBOutlet UILabel *BankName;
@property (weak, nonatomic) IBOutlet UILabel *BankNum;

@property(nonatomic,strong) LPSelectBindbankcardModel *model;

@end

@implementation LWBankManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"银行卡管理";
    [DSBaActivityView showActiviTy];
    [self requestSelectBindbankcard];
    
}

- (IBAction)TouchBtn:(UIButton *)sender {
    if (sender.tag == 1000) {       //修改提现密码
        LPSalarycCardChangePasswordVC *vc = [[LPSalarycCardChangePasswordVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.phone = self.model.data.phone;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1001){      //换绑
        LWSalarycCardVC *vc = [[LWSalarycCardVC alloc] init];
        vc.model = self.model;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        WEAK_SELF()
        vc.block = ^{
            [weakSelf requestSelectBindbankcard];
        };
    }
}



-(void)setModel:(LPSelectBindbankcardModel *)model{
    _model = model;
    NSString *bankNumberString = [RSAEncryptor decryptString:model.data.bankNumber privateKey:RSAPrivateKey];

    if (model.data && bankNumberString.length!=0) {
        self.BankName.text = model.data.bankName;
        if (bankNumberString.length>4) {
            NSString *BankFoot = [bankNumberString substringWithRange:NSMakeRange(bankNumberString.length - 4, 4)];
            self.BankNum.text = [NSString stringWithFormat:@"尾号%@%@",BankFoot,model.data.cardType];
        }
    }else{
        LWSalarycCardVC *vc = [[LWSalarycCardVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.model = self.model;
        
        NSMutableArray *naviVCsArr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        for (UIViewController *vc in naviVCsArr) {
            if ([vc isKindOfClass:[self class]]) {
                [naviVCsArr removeObject:vc];
                break;
            }
        }
        [naviVCsArr addObject:vc];
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController  setViewControllers:naviVCsArr animated:NO];
        
        
    }
    [DSBaActivityView hideActiviTy];

}


#pragma mark - request
-(void)requestSelectBindbankcard{
    [NetApiManager requestSelectBindbankcardWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPSelectBindbankcardModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

@end
