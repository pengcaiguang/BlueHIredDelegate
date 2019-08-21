//
//  LWWithdrawDetailsVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/11.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWWithdrawDetailsVC.h"
#import "LPBillrecordModel.h"

@interface LWWithdrawDetailsVC ()
@property (weak, nonatomic) IBOutlet UILabel *BankName;
@property (weak, nonatomic) IBOutlet UILabel *BankNum;
@property (weak, nonatomic) IBOutlet UILabel *BankmMoney;
@property (weak, nonatomic) IBOutlet UILabel *chargeMoney;
@property (weak, nonatomic) IBOutlet UILabel *realityMoney;

@property (weak, nonatomic) IBOutlet UILabel *SubTitle;

@property (weak, nonatomic) IBOutlet UILabel *Time1;
@property (weak, nonatomic) IBOutlet UIView *LineV;



@property (weak, nonatomic) IBOutlet UIView *InView3;
@property (weak, nonatomic) IBOutlet UIView *OutView3;
@property (weak, nonatomic) IBOutlet UILabel *Title3;
@property (weak, nonatomic) IBOutlet UILabel *Time3;
@property(nonatomic,strong) LPBillrecordDataModel *model;

@end

@implementation LWWithdrawDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现详情";
    
    [LPTools setViewShapeLayer:self.SubTitle CornerRadii:4 byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    //处理圆角
    for (UIView *v in self.Title3.superview.subviews) {
        if (v.tag == 1000) {
            v.layer.cornerRadius = LENGTH_SIZE(7.5);
        }else if (v.tag == 2000){
            v.layer.cornerRadius = LENGTH_SIZE(4);
        }
    }
    [self requestQueryUpdateUserMater];
}


- (void)setModel:(LPBillrecordDataModel *)model{
    _model = model;
    self.BankName.text = model.bankName;
    self.BankNum.text = [NSString stringWithFormat:@"尾号%@%@",model.bankNum,model.cardType];
    self.BankmMoney.text = [NSString stringWithFormat:@"￥%.2f",model.money.floatValue+model.chargeMoney.floatValue];
    self.chargeMoney.text = [NSString stringWithFormat:@"手续费：%.2f元",model.chargeMoney.floatValue];
    self.realityMoney.text = [NSString stringWithFormat:@" 实际到账：%.2f元",model.money.floatValue];
    //1提现申请2银行接受处理3银行处理成功4银行转账失败
    self.Time1.text = [NSString convertStringToTime:[model.time stringValue]];
    
    if (model.status.integerValue == 3){
        self.LineV.backgroundColor = [UIColor baseColor];
        self.OutView3.hidden = NO;
        self.Title3.text = @"提现成功";
        self.Title3.textColor = [UIColor baseColor];
        self.Time3.text = [NSString convertStringToTime:[model.set_time stringValue]];

    }else if (model.status.integerValue == 4){
        self.LineV.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
        self.OutView3.hidden = YES;
        self.InView3.backgroundColor = [UIColor colorWithHexString:@"#FF5353"];
        self.Title3.text = [NSString stringWithFormat:@"提现失败   %@",[LPTools isNullToString:model.errorRemark]];
        self.Title3.textColor = [UIColor colorWithHexString:@"#FF5353"];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.Title3.text];
        [string addAttributes:@{NSFontAttributeName: FONT_SIZE(12)} range:NSMakeRange(4, self.Title3.text.length-4)];
        self.Title3.attributedText = string;
        self.Time3.text = [NSString convertStringToTime:[model.set_time stringValue]];
    }
    
}

#pragma mark - request
-(void)requestQueryUpdateUserMater{
    NSDictionary *dic = @{@"id":self.DrawID,
                          @"type":@"2"
                          };
    [NetApiManager requestWorkqueryWithDrawRecord:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPBillrecordDataModel mj_objectWithKeyValues:responseObject[@"data"]];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

@end
