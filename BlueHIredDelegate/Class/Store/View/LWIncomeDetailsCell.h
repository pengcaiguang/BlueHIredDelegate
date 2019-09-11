//
//  LWIncomeDetailsCell.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWIncomeDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWIncomeDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *UserType;
@property (weak, nonatomic) IBOutlet UILabel *Money;

@property (nonatomic,strong) LWIncomeDetailsDataModel *model;

@end

NS_ASSUME_NONNULL_END
