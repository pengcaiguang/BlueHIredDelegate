//
//  LWStoreWorkDetailsCell.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWShopWorkDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWStoreWorkDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ShopNum;
@property (weak, nonatomic) IBOutlet UILabel *WorkNum;

@property (nonatomic, strong) LWShopWorkDetailDataModel *model;

@end

NS_ASSUME_NONNULL_END
