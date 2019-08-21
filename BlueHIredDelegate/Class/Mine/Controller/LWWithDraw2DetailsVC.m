//
//  LWWithDraw2DetailsVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/14.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWWithDraw2DetailsVC.h"
#import "LPBillrecordModel.h"

@interface LWWithDraw2DetailsVC ()
@property (weak, nonatomic) IBOutlet UILabel *TypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *MoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property(nonatomic,strong) LPBillrecordDataModel *model;

@end

@implementation LWWithDraw2DetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账单详情";
    
    [self requestQueryUpdateUserMater];

}

- (void)setModel:(LPBillrecordDataModel *)model{
    _model = model;
    if (model.type.integerValue == 0) {
        self.TypeLabel.text = @"其他";
    }else if (model.type.integerValue == 1){
        self.TypeLabel.text = @"门店收入";
    }else if (model.type.integerValue == 3){
        self.TypeLabel.text = @"代理费";
    }
    
    self.MoneyLabel.text = [NSString stringWithFormat:@"%.2f元",model.money.floatValue];
    self.statusLabel.text = @"已到蓝聘账户";
    self.TimeLabel.text = [NSString convertStringToYYYMMDD:model.set_time];

}

#pragma mark - request
-(void)requestQueryUpdateUserMater{
    NSDictionary *dic = @{@"id":self.DrawID,
                          @"type":@"1"
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
