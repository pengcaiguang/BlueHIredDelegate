//
//  AppDelegate.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/4/22.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "AppDelegate.h"
#import "LWLoginRegisterVC.h"


//微信
static NSString *WXAPPID = @"wx5d359cb71d81828c";
//QQ
static NSString *QQAPPID = @"1109696991";

static AFHTTPSessionManager * afHttpSessionMgr = NULL;

@interface AppDelegate ()
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, strong) NSString *version;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self startCheckNet];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    manager.keyboardDistanceFromTextField = LENGTH_SIZE(60);
    [WXApi registerApp:WXAPPID];
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAPPID andDelegate:self];
 
    if (AlreadyLogin) {
//
        [self  requestUserMaterial:1];
    }else{
       [self showLogin];
    }
    
    [self requestQueryDownload];
    return YES;
}

-(void)showLogin{
    
    RTRootNavigationController *navigationViewController=[[RTRootNavigationController alloc] initWithRootViewController:[LWLoginRegisterVC new]];
     typedef void (^Animation)(void);
    UIWindow* window = self.window;
    navigationViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [UIView transitionWithView:window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        self.window.rootViewController = navigationViewController;
                        [UIView setAnimationsEnabled:oldState];
                    } completion:nil];
    
}


-(void)showTabVc:(NSInteger)tabIndex{
    [self  requestUserMaterial:tabIndex];
    
}


//启动网络监控
-(void)startCheckNet{
    _moninNet = [[MoninNet alloc]init];
    [_moninNet startMoninNet];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - 微信
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    NSString *path = [url absoluteString];
    if ([path hasPrefix:@"tencent"]) {
 
    } else if([path hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    NSString *path = [url absoluteString];
    if ([path hasPrefix:@"tencent"]){
    }
    else if([path hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

 

-(void)onReq:(BaseReq *)req{
    
}

-(void)onResp:(BaseResp *)resp {
    NSLog(@"收到微信回调");
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *rep = (SendAuthResp *)resp;
        if (rep.errCode == 0) {
            NSString *secret = @"8ddf69126bc841fc195a4fc8ed11d45a";
           
            AFHTTPSessionManager *manager = [AppDelegate initHttpManager];
            NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAPPID,secret,rep.code];
            //            https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
            NSString *encodedUrl = [NSString stringWithString:[NSString StringToUTF8:url]];
            
            [manager GET:encodedUrl
              parameters:nil
                progress:^(NSProgress * _Nonnull downloadProgress) {
                    NSLog(@"收到微信回调 downloadProgress");
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"收到微信回调 responseObject %@",responseObject);
                    if (responseObject[@"unionid"]) {
                        
                        NSString *Infourl = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",responseObject[@"access_token"],responseObject[@"openid"]];
                        NSString *encodedInfourl = [NSString stringWithString:[NSString StringToUTF8:Infourl]];
                        
                        //获取用户信息
                        [manager GET:encodedInfourl
                          parameters:nil
                            progress:^(NSProgress * _Nonnull downloadProgress) {
                                NSLog(@"收到微信回调 downloadProgress");
                                
                            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                NSLog(@"收到微信回调 responseObject %@",responseObject);
                                if (responseObject[@"unionid"]) {
                                    LPWXUserInfoModel *UserModel = [LPWXUserInfoModel mj_objectWithKeyValues:responseObject];
                                    
                                    if ([self.WXdelegate respondsToSelector:@selector(LPWxLoginHBBack:)]) {
                                        [self.WXdelegate LPWxLoginHBBack:UserModel];
                                    }
                                    
                                }
                                
                                
                            }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                NSLog(@"收到微信回调 %@",error);
                                //打开可统一提示错误信息(考虑有的场景可能不需要,由自己去选择是否显示错误信息),
                                //错误信息已经过处理为NSString,可直接用于展示
                                //            [kKeyWindow showLoadingMeg:errorStr time:MESSAGESHOWTIME];
                                
                            }];
                        
                        
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"收到微信回调 %@",error);
                    //打开可统一提示错误信息(考虑有的场景可能不需要,由自己去选择是否显示错误信息),
                    //错误信息已经过处理为NSString,可直接用于展示
                    //            [kKeyWindow showLoadingMeg:errorStr time:MESSAGESHOWTIME];
                    
                }];
        }
    }
}
//AFHTTPSessionManager初始化
+(AFHTTPSessionManager *)initHttpManager {
    if(afHttpSessionMgr == NULL ){
        afHttpSessionMgr = [AFHTTPSessionManager manager];
        afHttpSessionMgr.responseSerializer = [AFJSONResponseSerializer serializer];
        afHttpSessionMgr.requestSerializer =[AFJSONRequestSerializer serializer];
        [afHttpSessionMgr.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
        afHttpSessionMgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        afHttpSessionMgr.requestSerializer.timeoutInterval = TimeOutIntervalSet;
        
    }
    
    return afHttpSessionMgr;
}

//版本
-(NSString *)version
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

#pragma mark - request

-(void)requestUserMaterial:(NSInteger) tabIndex{
    NSLog(@"userid = %@",kUserDefaultsValue(LOGINID));
    NSDictionary *dic = @{};
    [NetApiManager requestUserMaterialWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0  ) {
                self.userMaterialModel = [LPUserMaterialModel mj_objectWithKeyValues:responseObject];
                self.mainTabBarController = [[LPTabBarViewController alloc] init];
                [self.mainTabBarController setSelectedIndex:tabIndex];
                
                typedef void (^Animation)(void);
                UIWindow* window = self.window;
                self.mainTabBarController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                [UIView transitionWithView:window
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    BOOL oldState = [UIView areAnimationsEnabled];
                                    [UIView setAnimationsEnabled:NO];
                                    self.window.rootViewController = kAppDelegate.mainTabBarController;
                                    [self.window makeKeyAndVisible];
                                    [UIView setAnimationsEnabled:oldState];
                                } completion:nil];
            }else{              //返回不成功,清空
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                [self showLogin];
            }
        }else{
            [self showLogin];
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestQueryDownload{
    NSDictionary *dic = @{
                          @"type":@"2"
                          };
    [NetApiManager requestQueryDownload:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"code"] == 0) {
                if (responseObject[@"data"] != nil &&
                    [responseObject[@"data"][@"version"] length]>0) {
                    if (self.version.floatValue <  [responseObject[@"data"][@"version"] floatValue]  ) {
                        NSString *updateStr = [NSString stringWithFormat:@"发现新版本V%@\n为保证软件的正常运行\n请及时更新到最新版本",responseObject[@"data"][@"version"]];
                        [self creatAlterView:updateStr];
                    }
                }else{
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }
            }
            
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

//3. 弹框提示
-(void)creatAlterView:(NSString *)msg{
    UIAlertController *alertText = [UIAlertController alertControllerWithTitle:@"更新提醒" message:msg preferredStyle:UIAlertControllerStyleAlert];
    //增加按钮
    [alertText addAction:[UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [alertText addAction:[UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *str = @"itms-apps://itunes.apple.com/cn/app/id1441365926?mt=8"; //更换id即可
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }]];
    [[UIWindow visibleViewController] presentViewController:alertText animated:YES completion:nil];
}


@end
