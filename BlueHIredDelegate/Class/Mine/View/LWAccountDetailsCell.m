//
//  LWAccountDetailsCell.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/11.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWAccountDetailsCell.h"

@implementation LWAccountDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LPBillrecordDataModel *)model{
    _model = model;
    self.TimeDate.text = [NSString convertStringToTime:[model.set_time stringValue]];
    if (model.billType.integerValue == 2) {
        self.Money.text = [NSString stringWithFormat:@"-%.2f元",model.money.floatValue];
        self.Money.textColor = [UIColor colorWithHexString:@"#FF5454"];
        self.InType.text = @"提现";
        if (model.status.integerValue == 1) {
            self.Status.text = @"提现申请";
        }else if (model.status.integerValue == 2){
            self.Status.text = @"银行接受处理";
        }else if (model.status.integerValue == 3){
            self.Status.text = @"银行处理成功";
        }else if (model.status.integerValue == 4){
            self.Status.text = @"银行转账失败";
        }
        
    }else{
        self.Money.text = [NSString stringWithFormat:@"%.2f元",model.money.floatValue];
        self.Money.textColor = [UIColor baseColor];
        if (model.type.integerValue == 0) {
            self.InType.text = @"其他";
        }else if (model.type.integerValue == 1){
            self.InType.text = @"门店收入";
        }else if (model.type.integerValue == 3){
            self.InType.text = @"代理费";
        }
        
        self.Status.text = @"已到账";

        
    }
    
}

@end
