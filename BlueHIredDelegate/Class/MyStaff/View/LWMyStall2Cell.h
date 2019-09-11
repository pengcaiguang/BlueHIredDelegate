//
//  LWMyStall2Cell.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/9/6.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWMyStaffModelV2.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWMyStall2Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *AwardType;
@property (weak, nonatomic) IBOutlet UILabel *numberTitle;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *remark;

@property (nonatomic,strong) LWMyStaffDataModelV2 *model;

@end

NS_ASSUME_NONNULL_END
