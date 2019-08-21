//
//  LWMyStallCell.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWMyStallCell.h"

@implementation LWMyStallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.userStatus.layer.cornerRadius = 2;
    self.userStatus.layer.borderWidth = 0.5;
    
    self.UserImage.layer.cornerRadius = LENGTH_SIZE(17);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LWMyStaffDataModel *)model{
    _model = model;
    self.isShow.selected = model.isShow;

    [self.UserImage yy_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholder:[UIImage imageNamed:@"Head_image"]];
    self.Name.text = model.userName;
    self.userEarnings.text = model.status.integerValue == 1 ? @"已产生门店收益" : @"未产生门店收益";
    self.userEarnings.textColor = model.status.integerValue == 1 ? [UIColor colorWithHexString:@"#999999"] :[UIColor colorWithHexString:@"#CCCCCC"];
    
    self.userStatus.hidden = YES;
    if (model.workStatus.integerValue == 1) {
        self.userStatus.hidden = NO;
        self.userStatus.layer.borderColor = [UIColor baseColor].CGColor;
        self.userStatus.textColor = [UIColor baseColor];
        self.userStatus.text = @"在职";

    }else if (model.workStatus.integerValue == 2){
        self.userStatus.hidden = NO;
        self.userStatus.layer.borderColor = [UIColor colorWithHexString:@"#FFA63D"].CGColor;
        self.userStatus.textColor = [UIColor colorWithHexString:@"#FFA63D"];
        self.userStatus.text = @"离职";
    }
    
    self.InWork.text = [NSString stringWithFormat:@"入职企业：%@",[LPTools isNullToString:model.mechanismName]];
    self.InTime.text = [NSString stringWithFormat:@"入职日期：%@",model.beginTime.length ? [NSString convertStringToYYYMMDD:model.beginTime] : @""];
    
    
}

- (IBAction)TouchPhone:(UIButton *)sender {
    if (self.model.userTel.length) {
        sender.enabled = NO;
        NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.model.userTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            sender.enabled = YES;
        });
    }
}


@end
