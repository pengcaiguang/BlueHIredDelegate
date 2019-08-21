//
//  LWMyStallCell.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWMyStaffModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface LWMyStallCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *userStatus;
@property (weak, nonatomic) IBOutlet UILabel *userEarnings;

@property (weak, nonatomic) IBOutlet UILabel *InWork;
@property (weak, nonatomic) IBOutlet UILabel *InTime;
@property (weak, nonatomic) IBOutlet UIButton *isShow;

@property (nonatomic, strong) LWMyStaffDataModel *model;

@end

NS_ASSUME_NONNULL_END
