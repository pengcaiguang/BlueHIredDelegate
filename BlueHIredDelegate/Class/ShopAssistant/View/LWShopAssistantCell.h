//
//  LWShopAssistantCell.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWShopAssistantManageModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^LWShopAssistantCellBlock)(LWShopAssistantManageDataModel *m);

@interface LWShopAssistantCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UILabel *UserTel;
@property (weak, nonatomic) IBOutlet UILabel *UserInTime;

@property (weak, nonatomic) IBOutlet UIButton *LayOffBtn;
@property (weak, nonatomic) IBOutlet UIButton *DetailsBtn;
@property (weak, nonatomic) IBOutlet UIButton *isShow;

@property (nonatomic, copy) LWShopAssistantCellBlock Block;

@property (nonatomic,strong) LWShopAssistantManageDataModel *model;
@end

NS_ASSUME_NONNULL_END
