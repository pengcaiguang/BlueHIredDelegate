//
//  LPMainCell.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/9/4.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWorklistModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPMainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *HiddenImageView;

@property (weak, nonatomic) IBOutlet UIImageView *mechanismUrlImageView;
@property (weak, nonatomic) IBOutlet UILabel *mechanismNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lendTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *wageRangeLabel;

@property (weak, nonatomic) IBOutlet UIButton *reMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *reMoneyImage;

@property (weak, nonatomic) IBOutlet UILabel *maxNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *AgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ManageMoney;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyLabel_constraint_right;

@property(nonatomic,strong) LPWorklistDataWorkListModel *model;

@end

NS_ASSUME_NONNULL_END
