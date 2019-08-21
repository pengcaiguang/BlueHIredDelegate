//
//  LWWorkerCell.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/22.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWWorkRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWWorkerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *PhoneBtn;

@property (nonatomic,strong) LWWorkRecordListDataModel *model;

@end

NS_ASSUME_NONNULL_END
