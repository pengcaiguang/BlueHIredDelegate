//
//  LPMainCell.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/9/4.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LPMainCell.h"

@implementation LPMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lendTypeLabel.layer.cornerRadius = LENGTH_SIZE(2);
    
    self.reMoneyLabel.layer.cornerRadius = LENGTH_SIZE(10.5);
    self.reMoneyLabel.layer.borderWidth = LENGTH_SIZE(1);
    self.reMoneyLabel.layer.borderColor = [UIColor colorWithHexString:@"#FFD291"].CGColor;
    
    self.AgeLabel.layer.cornerRadius = 2;
    self.AgeLabel.layer.borderColor = [UIColor baseColor].CGColor;
    self.AgeLabel.layer.borderWidth = 0.5;
    self.AgeLabel.textColor = [UIColor baseColor];
    
    self.mechanismUrlImageView.layer.cornerRadius = LENGTH_SIZE(6);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void)setModel:(LPWorklistDataWorkListModel *)model{
    _model = model;

    if (model.age.length ) {
        self.AgeLabel.text = [NSString stringWithFormat:@" %@ ", model.age];
        self.AgeLabel.hidden = NO;
    }else{
        self.AgeLabel.hidden = YES;
    }
    
    
    self.HiddenImageView.hidden = !model.workHide.integerValue;
    
    self.mechanismNameLabel.text = model.mechanismName;
    self.lendTypeLabel.hidden = ![model.lendType integerValue];
    [self.mechanismUrlImageView sd_setImageWithURL:[NSURL URLWithString:model.mechanismUrl]];

    if (kAppDelegate.userMaterialModel.data.shopType.integerValue == 2 && (kAppDelegate.userMaterialModel.data.role.integerValue == 1 || kAppDelegate.userMaterialModel.data.role.integerValue == 1 )) {
        if ([model.postType integerValue] == 1) {
            self.ManageMoney.text = [NSString stringWithFormat:@"管理费：%@元/时",reviseString(model.manageMoney)];
        }else{
            self.ManageMoney.text = [NSString stringWithFormat:@"管理费：%@元/月",reviseString(model.manageMoney)];
        }
    }else{
        self.ManageMoney.text = @"";
    }
    
    
    if ([model.postType integerValue] == 1) {
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/时",reviseString(model.workMoney)];
    }else{
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/月",model.wageRange];
    }
    
    self.maxNumberLabel.text = [NSString stringWithFormat:@"%@",model.workTypeName];
    
    
    
    if ([model.postType integerValue] == 1) {
        if (model.addWorkMoney.floatValue>0.0 && model.reStatus.integerValue == 1 && model.reTime.integerValue>0) {
            self.reMoneyLabel.hidden = NO;
            self.reMoneyImage.hidden = NO;
            self.reMoneyImage.image = [UIImage imageNamed:@"reward"];
            
            NSString *str = [NSString stringWithFormat:@"     %.1f元/时  ",model.addWorkMoney.floatValue];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
            [string addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FontSize(12)]} range:[str rangeOfString:@"元/时"]];
            [self.reMoneyLabel setAttributedTitle:string forState:UIControlStateNormal];
            
            CGFloat ReMoneyWidth = [LPTools widthForString:str fontSize:FontSize(13) andHeight:LENGTH_SIZE(21)];
            self.keyLabel_constraint_right.constant = LENGTH_SIZE(13.0) + ReMoneyWidth + LENGTH_SIZE(10);
            
        }else{
            self.reMoneyLabel.hidden = YES;
            self.reMoneyImage.hidden = YES;
            self.keyLabel_constraint_right.constant = LENGTH_SIZE(13);
            
        }
    }else{
        if (model.reMoney.integerValue>0 && model.reStatus.integerValue == 1 && model.reTime.integerValue>0) {
            self.reMoneyLabel.hidden = NO;
            self.reMoneyImage.hidden = NO;
            
            self.reMoneyImage.image = [UIImage imageNamed:@"reward"];
            
            self.reMoneyImage.image = [UIImage imageNamed:@"return"];
            NSString *str = [NSString stringWithFormat:@"     %@元  ",model.reMoney];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
            [string addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FontSize(12)]} range:[str rangeOfString:@"元"]];
            [self.reMoneyLabel setAttributedTitle:string forState:UIControlStateNormal];
            
            CGFloat ReMoneyWidth = [LPTools widthForString:str fontSize:FontSize(13) andHeight:LENGTH_SIZE(21)];
            self.keyLabel_constraint_right.constant = LENGTH_SIZE(13.0) + ReMoneyWidth + LENGTH_SIZE(10);
            
        }else{
            self.reMoneyLabel.hidden = YES;
            self.reMoneyImage.hidden = YES;
            self.keyLabel_constraint_right.constant = LENGTH_SIZE(13);
            
        }
    }
    
 
}


@end
