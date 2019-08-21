//
//  LWBatchAddWorkCell.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/23.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWBatchAddWorkCell.h"

@implementation LWBatchAddWorkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(LWWorkRecordListDataModel *)model{
    _model = model;
    self.Name.text = model.userName;
    if (model.userTel.length >0) {
        self.Tel.text = model.userTel;
    }else{
        self.Tel.text = @"未添加手机号";
    }
}

- (IBAction)TouchDelete:(id)sender {
 
    if (self.block) {
        self.block(self.model);
    }
}

@end
