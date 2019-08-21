//
//  LWWorkerCell.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/22.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWWorkerCell.h"

@implementation LWWorkerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.StatusLabel.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
 
}

- (void)setModel:(LWWorkRecordListDataModel *)model{
    _model = model;
    self.NameLabel.text = model.userName;
    if (model.workStatus.integerValue == 1) {
        self.StatusLabel.layer.borderColor = [UIColor colorWithHexString:@"#FFA63D"].CGColor;
        self.StatusLabel.layer.borderWidth = 1;
        self.StatusLabel.textColor = [UIColor colorWithHexString:@"#FFA63D"];
        self.StatusLabel.text = @"待业";
    }else{
        self.StatusLabel.layer.borderColor = [UIColor baseColor].CGColor;
        self.StatusLabel.layer.borderWidth = 1;
        self.StatusLabel.textColor = [UIColor baseColor];
        self.StatusLabel.text = @"在职";
    }
    
    if (model.userTel.length) {
        [self.PhoneBtn setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
        [self.PhoneBtn setTitle:@"" forState:UIControlStateNormal];
        self.PhoneBtn.enabled = YES;
    }else{
        [self.PhoneBtn setImage:[UIImage new] forState:UIControlStateNormal];
        [self.PhoneBtn setTitle:@"未添加手机号" forState:UIControlStateNormal];
        self.PhoneBtn.enabled = NO;

    }
    
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
