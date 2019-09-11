//
//  LWEntryRecordCell.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/9/6.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWEntryRecordCell.h"

@implementation LWEntryRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LWEntryRecordDataModel *)model{
    _model = model;
    
    self.WorkName.text = model.mechanismName;
    self.Time.text = [NSString convertStringToTime:model.setTime];
    self.PostType.text = [NSString stringWithFormat:@"入职岗位：%@",model.workTypeName];
    if (model.status.integerValue == 0) {
        self.WorkStatus.text = @"面试预约中";
        self.WorkStatus.textColor = [UIColor colorWithHexString:@"#ffae3d"];
    }else if (model.status.integerValue == 1){
        self.WorkStatus.text = @"面试通过";
        self.WorkStatus.textColor = [UIColor baseColor];
    }else if (model.status.integerValue == 2){
        self.WorkStatus.text = @"面试失败";
        self.WorkStatus.textColor = [UIColor colorWithHexString:@"#ff5353"];
    }else if (model.status.integerValue == 4){
        self.WorkStatus.text = @"放弃入职";
        self.WorkStatus.textColor = [UIColor colorWithHexString:@"#ff5353"];
    }else if (model.status.integerValue == 5){
        self.WorkStatus.text = @"入职成功";
        self.WorkStatus.textColor = [UIColor baseColor];
    }else if (model.status.integerValue == 6){
        self.WorkStatus.text = @"离职";
        self.WorkStatus.textColor = [UIColor colorWithHexString:@"#ff5353"];
    }
 
    if (model.earnStatus.integerValue == 0) {
        self.earnStatus.hidden = YES;
    }else if (model.earnStatus.integerValue == 1){
        self.earnStatus.hidden = NO;
        self.earnStatusTitle.text = @"该员工自己通过平台入职，您可获取 邀请奖励";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.earnStatusTitle.text];
        [string addAttributes:@{NSForegroundColorAttributeName: [UIColor baseColor]} range:[self.earnStatusTitle.text rangeOfString:@"邀请奖励"]];
        self.earnStatusTitle.attributedText = string;
        
    }else if (model.earnStatus.integerValue == 2){
        self.earnStatus.hidden = NO;
        self.earnStatusTitle.text = @"该员工通过您的门店入职，您可获取 管理费奖励";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.earnStatusTitle.text];
        [string addAttributes:@{NSForegroundColorAttributeName: [UIColor baseColor]} range:[self.earnStatusTitle.text rangeOfString:@"管理费奖励"]];
        self.earnStatusTitle.attributedText = string;
    }else if (model.earnStatus.integerValue == 3){
        self.earnStatus.hidden = NO;
        self.earnStatusTitle.text = @"该员工通过他人邀请入职，不会产生任何奖励";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.earnStatusTitle.text];
        self.earnStatusTitle.attributedText = string;
    }
    
}




@end
