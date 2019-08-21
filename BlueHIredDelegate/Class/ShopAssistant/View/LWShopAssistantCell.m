//
//  LWShopAssistantCell.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWShopAssistantCell.h"
#import "LWAgencyFeeVC.h"

@implementation LWShopAssistantCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.LayOffBtn.layer.borderWidth = 1;
    self.LayOffBtn.layer.borderColor = [UIColor colorWithHexString:@"#808080"].CGColor;
    [self.LayOffBtn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
    self.LayOffBtn.layer.cornerRadius = LENGTH_SIZE(12);

    self.DetailsBtn.layer.borderWidth = 1;
    self.DetailsBtn.layer.borderColor = [UIColor baseColor].CGColor;
    [self.DetailsBtn setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    self.DetailsBtn.layer.cornerRadius = LENGTH_SIZE(12);
    
    self.UserImage.layer.cornerRadius = LENGTH_SIZE(17);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LWShopAssistantManageDataModel *)model{
    _model = model;
    self.isShow.selected = model.isShow;
    [self.UserImage yy_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholder:[UIImage imageNamed:@"Head_image"]];
    self.UserName.text = model.userName;
    self.UserTel.text = model.userTel;
    self.UserInTime.text = [NSString stringWithFormat:@"入职日期：%@",[NSString convertStringToYYYMMDD:model.setTime]];
    
}

- (IBAction)TouchPhone:(UIButton *)sender {
 
    sender.enabled = NO;
        NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.model.userTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}

- (IBAction)TouchDetailsBtn:(id)sender {
//    LWAgencyFeeVC *vc =[[LWAgencyFeeVC alloc] init];
//    vc.Type = 2;
//    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}

- (IBAction)TouchLayoffBtn:(id)sender {
    NSString *str1 = [NSString stringWithFormat:@"辞退店员\n\n确定辞退店员%@？",self.model.userName];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor baseColor] range:[str1 rangeOfString:self.model.userName]];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FontSize(17)] range:NSMakeRange(0,4)];

    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil IsShowhead:YES backDismiss:NO textAlignment:0 buttonTitles:@[@"取消",@"确定"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
        if (buttonIndex) {
            if (self.Block) {
                self.Block(self.model);
            }
        }
    }];
    [alert show];
 
    
}

@end
