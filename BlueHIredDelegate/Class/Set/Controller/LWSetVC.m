//
//  LWSetVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/11.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWSetVC.h"
#import "LWMyAppVC.h"
#import "LPFeedBackVC.h"

@interface LWSetVC ()

@end

@implementation LWSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
 }

- (IBAction)TouchBtn:(UIButton *)sender {
    if (sender.tag == 1000) {               //意见反馈
        LPFeedBackVC *vc = [[LPFeedBackVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1001){          //关于我们
        LWMyAppVC *vc = [[LWMyAppVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1002){          //退出登入
        [self requestSignout];
    }
}


#pragma mark - request
-(void)requestSignout{
    [NetApiManager requestSignoutWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                kUserDefaultsSave(kUserDefaultsValue(LOGINID), OLDLOGINID);
                kUserDefaultsRemove(LOGINID);
                kUserDefaultsRemove(kLoginStatus);
                [kAppDelegate showLogin];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
@end
