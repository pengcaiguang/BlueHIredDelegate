//
//  LPInfoDetailVC.m
//  BlueHired
//
//  Created by peng on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPInfoDetailVC.h"
#import "LPInfoDetailModel.h"
#import "LPSelectBindbankcardModel.h"
#import "LWSalarycCardVC.h"

static  NSString *RSAPublickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDvh1MAVToAiuEVOFq9mo3IOJxN5aekgto1kyOh07qQ+1Wc+Uxk1wX2t6+HCA31ojcgaR/dZz/kQ5aZvzlB8odYHJXRtIcOAVQe/FKx828XFTzC8gp1zGh7vTzBCW3Ieuq+WRiq9cSzEZlNw9RcU38st9q9iBT8PhK0AkXE2hLbKQIDAQAB";
static NSString *RSAPrivateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAO+HUwBVOgCK4RU4Wr2ajcg4nE3lp6SC2jWTI6HTupD7VZz5TGTXBfa3r4cIDfWiNyBpH91nP+RDlpm/OUHyh1gcldG0hw4BVB78UrHzbxcVPMLyCnXMaHu9PMEJbch66r5ZGKr1xLMRmU3D1FxTfyy32r2IFPw+ErQCRcTaEtspAgMBAAECgYBSczN39t5LV4LZChf6Ehxh4lKzYa0OLNit/mMSjk43H7y9lvbb80QjQ+FQys37UoZFSspkLOlKSpWpgLBV6gT5/f5TXnmmIiouXXvgx4YEzlXgm52RvocSCvxL81WCAp4qTrp+whPfIjQ4RhfAT6N3t8ptP9rLgr0CNNHJ5EfGgQJBAP2Qkq7RjTxSssjTLaQCjj7FqEYq1f5l+huq6HYGepKU+BqYYLksycrSngp0y/9ufz0koKPgv1/phX73BmFWyhECQQDx1D3Gui7ODsX02rH4WlcEE5gSoLq7g74U1swbx2JVI0ybHVRozFNJ8C5DKSJT3QddNHMtt02iVu0a2V/uM6eZAkEAhvmce16k9gV3khuH4hRSL+v7hU5sFz2lg3DYyWrteHXAFDgk1K2YxVSUODCwHsptBNkogdOzS5T9MPbB+LLAYQJBAKOAknwIaZjcGC9ipa16txaEgO8nSNl7S0sfp0So2+0gPq0peWaZrz5wa3bxGsqEyHPWAIHKS20VRJ5AlkGhHxECQQDr18OZQkk0LDBZugahV6ejb+JIZdqA2cEQPZFzhA3csXgqkwOdNmdp4sPR1RBuvlVjjOE7tCiFLup/8TvRJDdr";


@interface LPInfoDetailVC ()

@property(nonatomic,strong) LPInfoDetailModel *DetailModel;
@property(nonatomic,strong) UIButton *Agreedbutton;
@property(nonatomic,strong) LPSelectBindbankcardModel *BankcardModel;


@end


@implementation LPInfoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息详情";
    [self requestQueryInfodetail];
//    [self setupUI];
}




-(void)setupUI{
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.top.mas_equalTo(LENGTH_SIZE(13));
        make.right.mas_equalTo(LENGTH_SIZE(-13));
    }];
    titleLabel.text = self.DetailModel.informationTitle;
    titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(17)];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    [self.view addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.top.equalTo(titleLabel.mas_bottom).offset(LENGTH_SIZE(10));
        make.right.mas_equalTo(LENGTH_SIZE(-13));
    }];
    timeLabel.text = [NSString convertStringToTime:[self.DetailModel.time stringValue]];
    timeLabel.font = [UIFont systemFontOfSize:FontSize(13)];
    timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    
    UIView *view = [[UIView alloc]init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.top.equalTo(timeLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(0.0);
    }];
    view.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    [self.view addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.top.equalTo(timeLabel.mas_bottom).offset(LENGTH_SIZE(18));
        make.right.mas_equalTo(LENGTH_SIZE(-13));
    }];
    detailLabel.text = self.DetailModel.informationDetails;
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:FontSize(15)];
    detailLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    
    UIView *BGView = [[UIView alloc] init];
    [self.view addSubview:BGView];
    [BGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(detailLabel.mas_bottom).offset(LENGTH_SIZE(24));
    }];
    BGView.backgroundColor = [UIColor colorWithHexString:@"#F5F8FA"];
    
    UILabel *TLabel = [[UILabel alloc] init];
    [BGView addSubview:TLabel];
    [TLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(LENGTH_SIZE(10));
        make.left.mas_offset(0);
        make.width.mas_offset(LENGTH_SIZE(87));
        make.height.mas_offset(LENGTH_SIZE(24));
    }];
    TLabel.textColor = [UIColor whiteColor];
    TLabel.backgroundColor = [UIColor baseColor];
    TLabel.font = FONT_SIZE(15);
    TLabel.text = @"店员须知";
    TLabel.textAlignment = NSTextAlignmentCenter;
    [TLabel layoutIfNeeded];
    [LPTools setViewShapeLayer:TLabel CornerRadii:12 byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight ];
    
    
    UILabel *textView = [[UILabel alloc] init];
    [BGView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.right.mas_equalTo(LENGTH_SIZE(-13));
        make.top.mas_offset(LENGTH_SIZE(52));
        make.bottom.mas_offset(LENGTH_SIZE(-40));
     }];
    textView.numberOfLines = 0;
    textView.font = FONT_SIZE(15);
    textView.layer.cornerRadius = 10;
    textView.text = @"1、成为加盟店店员前,您邀请的员工仍归属您自己，相应的奖励金额请在个人中心的邀请奖励中查看。\n\n2、成为加盟店店员后,您邀请的员工都归属您加入的加盟店,您邀请员工将不再由本平台进行奖励，而是由您所在的加盟店店主进行发放，具体奖励额度请您与店主进行线下协商。本平台概不负责！\n\n3、若要成为加盟店的店员必须进行工资卡绑定！";
    textView.textColor = [UIColor colorWithHexString:@"#666666"];
    
    _Agreedbutton = [[UIButton alloc] init];
    [self.view addSubview:_Agreedbutton];
    [_Agreedbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BGView.mas_bottom).offset(LENGTH_SIZE(45));
        make.right.mas_equalTo(LENGTH_SIZE(-18));
        make.height.mas_equalTo(LENGTH_SIZE(48));
    }];
    
    _Agreedbutton.backgroundColor = [UIColor baseColor];
    [_Agreedbutton setTitle:@"同  意" forState:UIControlStateNormal];
    [_Agreedbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _Agreedbutton.layer.cornerRadius = LENGTH_SIZE(6);
    [_Agreedbutton addTarget:self action:@selector(TouchAgreedbutton) forControlEvents:UIControlEventTouchUpInside];

    UIButton *cancelbutton2 = [[UIButton alloc] init];
    [self.view addSubview:cancelbutton2];
    [cancelbutton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(18));
        make.right.equalTo(self.Agreedbutton.mas_left).offset(LENGTH_SIZE(-20));
        make.height.mas_equalTo(LENGTH_SIZE(48));
        make.centerY.equalTo(self.Agreedbutton);
        make.width.equalTo(self.Agreedbutton.mas_width);
    }];
    
    cancelbutton2.backgroundColor = [UIColor colorWithHexString:@"#FF5353"];
    cancelbutton2.layer.cornerRadius = LENGTH_SIZE(6);
    [cancelbutton2 setTitle:@"拒  绝" forState:UIControlStateNormal];
    [cancelbutton2 addTarget:self action:@selector(touchcancelButton) forControlEvents:UIControlEventTouchUpInside];
    [cancelbutton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BGView.mas_bottom).offset(LENGTH_SIZE(0));
        make.right.mas_offset(LENGTH_SIZE(-13));
    }];
    
    if (self.DetailModel.type.integerValue == 4) {
        if (self.DetailModel.inviteStatus.integerValue == 0) {
            BGView.hidden = NO;
            self.Agreedbutton.hidden = NO;
            cancelbutton2.hidden = NO;
            imageView.hidden = YES;
        }else if (self.DetailModel.inviteStatus.integerValue == 1){
            BGView.hidden = NO;
            self.Agreedbutton.hidden = YES;
            cancelbutton2.hidden = YES;
            imageView.hidden = NO;
            imageView.image = [UIImage imageNamed:@"icon_yes"];
        }else if (self.DetailModel.inviteStatus.integerValue == 2){
            BGView.hidden = NO;
            self.Agreedbutton.hidden = YES;
            cancelbutton2.hidden = YES;
            imageView.hidden = NO;
            imageView.image = [UIImage imageNamed:@"icon_no"];
        }
    }else{
        BGView.hidden = YES;
        self.Agreedbutton.hidden = YES;
        cancelbutton2.hidden = YES;
    }
    

}

-(void)TouchAgreedbutton{
    [self requestSelectBindbankcard];
//
   
}

-(void)touchcancelButton{
    [self requestQueryAccept_invite:NO];
}




-(void)setBankcardModel:(LPSelectBindbankcardModel *)BankcardModel{
    _BankcardModel = BankcardModel;
    NSString *bankNumberString = [RSAEncryptor decryptString:BankcardModel.data.bankNumber privateKey:RSAPrivateKey];
    
    if (BankcardModel.data && bankNumberString.length!=0) {
        [self requestQueryAccept_invite:YES];
    }else{
        NSString *str1 = [NSString stringWithFormat:@"温馨提示\n\n同意成为店员前，需绑定银行卡"];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor baseColor] range:[str1 rangeOfString:@"白婷婷"]];
        [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FontSize(17)] range:NSMakeRange(0,4)];
        
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil
                                                          IsShowhead:YES
                                                         backDismiss:YES
                                                       textAlignment:0
                                                        buttonTitles:@[@"取消",@"去绑定"]
                                                        buttonsColor:@[[UIColor colorWithHexString:@"#999999"],[UIColor baseColor]]
                                             buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
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





-(void)requestQueryInfodetail{
    NSDictionary *dic = @{
                          @"infoId":self.model.id
                          };
    [NetApiManager requestQueryInfodetailWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.DetailModel = [LPInfoDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
                [self setupUI];
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


-(void)requestQueryAccept_invite:(BOOL) status{
    
    NSDictionary *dic = @{
                          @"shopUserId":self.DetailModel.shopUserId,
                          @"status":status?@"1":@"2"
                          };

    [NetApiManager requestQueryAccept_invite:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0  ) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [self.view showLoadingMeg:@"操作成功" time:MESSAGE_SHOW_TIME];
                    [self.navigationController popViewControllerAnimated:YES];
                 }else{
                    [self.view showLoadingMeg:@"操作失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
@end
