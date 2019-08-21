//
//  LWInvitedRecordCell.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWShopAssistantManageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWInvitedRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *UserTel;
@property (weak, nonatomic) IBOutlet UILabel *InTime;
@property (weak, nonatomic) IBOutlet UILabel *UserStatus;

@property (nonatomic, strong) LWShopAssistantManageDataModel *model;

@end

NS_ASSUME_NONNULL_END
