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
 
    
    
    
}


-(void)setModel:(LWAgencyFeeDataModel *)model{
    _model = model;
    self.isShow.selected = model.isShow;
  
    self.UserName.text = model.staffName;
    self.Money.text = [NSString stringWithFormat:@"%.2f元",model.money.floatValue];
    
    NSString *Str = [NSString stringWithFormat:@"身份证号：%@\n入职企业：%@\n入职日期：%@      离职日期：%@\n%@\n%@\n%@%.2f%@       %@%ld%@",
                     model.staffCardNumber,
                     model.mechanismName,
                     model.workBeginTime,
                     model.workEndTime.length>0?model.workEndTime:@"-",
                     model.postType.integerValue == 1?[NSString stringWithFormat:@"平台所设管理费：%.2f元/时",model.manageMoney.floatValue]:[NSString stringWithFormat:@"平台所设管理费：%.2f元/月",model.manageMoney.floatValue],
                     model.postType.integerValue == 1?[NSString stringWithFormat:@"员工所得返费：%.2f元/时",model.reMoney.floatValue]:[NSString stringWithFormat:@"员工所得返费：%.2f元/月",model.reMoney.floatValue],
                     model.postType.integerValue == 1?@"提成单价：":@"提成基数：",
                     model.postType.integerValue == 1?model.commissionPrize.floatValue:model.commissionBase.floatValue,
                     model.postType.integerValue == 1?@"元/小时":@"元",
                     model.postType.integerValue == 1?@"计费工时：":@"计费天数：",
                     (long)(model.postType.integerValue == 1?model.workTime.integerValue:model.workDay.integerValue),
                     model.postType.integerValue == 1?@"小时":@"天"];
    
    NSArray *SubArr = [model.subsidyContent componentsSeparatedByString:@";"];
    for (NSString *ArrStr in SubArr) {
        if (ArrStr.length>0) {
            Str = [NSString stringWithFormat:@"%@\n%@元",Str,[ArrStr stringByReplacingOccurrencesOfString:@"-" withString:@"："]];
        }
    }
    
    self.DetailsLabel.text = Str;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:Str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = LENGTH_SIZE(6);
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, Str.length)];
    self.DetailsLabel.attributedText = string;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

 
}

@end
