//
//  LPAccountManageVC.m
//  BlueHired
//
//  Created by iMac on 2019/4/18.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPAccountManageVC.h"
#import "LPChangePhoneVC.h"
#import "LPChangePasswordVC.h"
#import "AppDelegate.h"

#import "LPUserProblemModel.h"



@interface LPAccountManageVC ()<LPWxLoginHBDelegate>
@property (weak, nonatomic) IBOutlet UILabel *WXLabel;

@property (nonatomic,strong) LPUserMaterialModel *userData;
@property (nonatomic,strong) LPUserProblemModel *model;

@end

@implementation LPAccountManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.WXdelegate = self;
    
    LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
    self.userData = user;
    
    self.navigationItem.title = @"账号管理";
    if (user.data.isOpen.integerValue == 0) {
        self.WXLabel.text = @"未绑定";
    }else{
        self.WXLabel.text = @"已绑定";
    }
 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
}

- (IBAction)TouchBT:(UIButton *)sender {
    if (sender.tag == 1001) {   //手机号修改
        LPChangePhoneVC *vc = [[LPChangePhoneVC alloc]init];
        vc.type = 2;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1002){      //密码修改
        LPChangePasswordVC *vc = [[LPChangePasswordVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.Type = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1003){      //密保问题修改

        LPChangePhoneVC *vc = [[LPChangePhoneVC alloc]init];
        vc.type = 1;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }else if (sender.tag == 1004){      //微信绑定
        LPChangePhoneVC *vc = [[LPChangePhoneVC alloc]init];
        vc.type = 4;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    
}


- (void)setModel:(LPUserProblemModel *)model{
    _model = model;
    if (model.data.count == 0) {
        NSString *str1 = @"为了您的账号安全，请先设置密保问题。";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
        WEAK_SELF()
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil IsShowhead:YES textAlignment:0 buttonTitles:@[@"去设置"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                LPChangePhoneVC *vc = [[LPChangePhoneVC alloc]init];
                vc.type = 1;

//                [self.navigationController pushViewController:vc animated:YES];
                NSMutableArray *naviVCsArr = [[NSMutableArray alloc]initWithArray:weakSelf.navigationController.viewControllers];
                for (UIViewController *vc in naviVCsArr) {
                    if ([vc isKindOfClass:[weakSelf class]]) {
                        [naviVCsArr removeObject:vc];
                        break;
                    }
                }
                [naviVCsArr addObject:vc];
                vc.hidesBottomBarWhenPushed = YES;

                [weakSelf.navigationController  setViewControllers:naviVCsArr animated:YES];

            }
        }];
        [alert show];
    }
}

 
@end
