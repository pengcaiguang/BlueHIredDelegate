//
//  LWAgencyFeeCell.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/16.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWAgencyFeeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWAgencyFeeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *WorksType;
@property (weak, nonatomic) IBOutlet UIButton *isShow;


@property (nonatomic, strong) LWAgencyFeeDataModel *model;

@end

NS_ASSUME_NONNULL_END
