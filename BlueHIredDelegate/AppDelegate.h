//
//  AppDelegate.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/4/22.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoninNet.h"
#import "WXApi.h"
#import "LPWXUserInfoModel.h"
#import "LPTabBarViewController.h"

@protocol LPWxLoginHBDelegate <NSObject>

- (void)LPWxLoginHBBack:(LPWXUserInfoModel *)wxUserInfo;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,TencentSessionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) MoninNet* moninNet;
@property (nonatomic,assign)id <LPWxLoginHBDelegate>WXdelegate;
@property (nonatomic, strong) LPTabBarViewController *mainTabBarController;
@property(nonatomic,strong) LPUserMaterialModel *userMaterialModel;

-(void)showTabVc:(NSInteger)tabIndex;
-(void)showLogin;
@end

