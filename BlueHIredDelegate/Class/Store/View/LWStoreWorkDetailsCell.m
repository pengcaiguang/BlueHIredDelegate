//
//  LWStoreWorkDetailsCell.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWStoreWorkDetailsCell.h"

@implementation LWStoreWorkDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LWShopWorkDetailDataModel *)model{
    _model = model;
    self.NameLabel.text = model.userName;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.NameLabel.text];
    
    [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#999999"]} range:[self.NameLabel.text rangeOfString:@"(店主)"]];
    
    self.NameLabel.attributedText = string;    
    self.ShopNum.text = model.shopLabourNum;
}

@end
