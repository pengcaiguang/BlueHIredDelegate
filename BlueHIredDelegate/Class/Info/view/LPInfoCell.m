//
//  LPInfoCell.m
//  BlueHired
//
//  Created by peng on 2018/9/21.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInfoCell.h"

@implementation LPInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
}

-(void)setModel:(LPInfoListDataModel *)model{
    _model = model;
    if ([model.status integerValue] == 0) {
        self.statusImgView.hidden = NO;
    }else{
        self.statusImgView.hidden = YES;
    }
    self.informationTitleLabel.text = model.informationTitle;
    self.informationDetailsLabel .text = model.informationDetails;
    self.timeLabel.text = [NSString convertStringToTimeYMD:[model.time stringValue]];
 
}

- (IBAction)touchSelectButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.selectBlock) {
        self.selectBlock(self.model);
    }
}

-(void)setSelectStatus:(BOOL)selectStatus{
    if (selectStatus) {
        self.img_contraint_width.constant = LENGTH_SIZE(60);
        self.selectButton.hidden = NO;
    }else{
        self.img_contraint_width.constant = LENGTH_SIZE(13);
        self.selectButton.hidden = YES;
    }
}
-(void)setSelectAll:(BOOL)selectAll{
    self.selectButton.selected = selectAll;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
