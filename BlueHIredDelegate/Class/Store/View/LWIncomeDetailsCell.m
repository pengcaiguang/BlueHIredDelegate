//
//  LWIncomeDetailsCell.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWIncomeDetailsCell.h"

@implementation LWIncomeDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(LWIncomeDetailsDataModel *)model{
    self.Money.text = [NSString stringWithFormat:@"%.2f元",model.money.floatValue];
    self.Name.text = model.userName;
    if (model.userType.integerValue == 1 || model.userType.integerValue == 2) {
        self.UserType.hidden = NO;
    }else{
        self.UserType.hidden = YES;
    }

}

@end
