//
//  LWAccountDetailsCell.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/11.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPBillrecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWAccountDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *InType;
@property (weak, nonatomic) IBOutlet UILabel *Money;
@property (weak, nonatomic) IBOutlet UILabel *TimeDate;
@property (weak, nonatomic) IBOutlet UILabel *Status;

@property (nonatomic,strong) LPBillrecordDataModel *model;

@end

NS_ASSUME_NONNULL_END
