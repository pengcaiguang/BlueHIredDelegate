//
//  LWAgencyFeeCell.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/16.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWAgencyFeeCell.h"

@implementation LWAgencyFeeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.WorksType.layer.cornerRadius = 2;
    self.WorksType.layer.borderWidth = 1;
    self.WorksType.layer.borderColor = [UIColor baseColor].CGColor;
    self.WorksType.textColor = [UIColor baseColor];
}


-(void)setModel:(LWAgencyFeeDataModel *)model{
    _model = model;
    self.isShow.selected = model.isShow;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

 
}

@end
