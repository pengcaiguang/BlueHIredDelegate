//
//  LWInvitedRecordCell.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWInvitedRecordCell.h"

@implementation LWInvitedRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
     
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
 }


- (void)setModel:(LWShopAssistantManageDataModel *)model{
    _model = model;
    self.UserTel.text = model.userTel;
    self.InTime.text = [NSString stringWithFormat:@"邀请时间：%@",[NSString convertStringToTime:model.time]];
    
    if (model.status.integerValue == 0) {
        self.UserStatus.textColor = [UIColor baseColor];
        self.UserStatus.text = @"待同意";
    }else if (model.status.integerValue == 1){
        self.UserStatus.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
        self.UserStatus.text = @"已同意";
    }else if (model.status.integerValue == 2){
        self.UserStatus.textColor = [UIColor colorWithHexString:@"#FF5353"];
        self.UserStatus.text = @"已拒绝";
    }
    
}

@end
