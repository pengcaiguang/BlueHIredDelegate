//
//  LWSalarycCardVC.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPSelectBindbankcardModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LWSalarycCardBlock)(void);

@interface LWSalarycCardVC : LPBaseViewController
@property(nonatomic,strong) LPSelectBindbankcardModel *model;

@property(nonatomic,copy) LWSalarycCardBlock block;

@end

NS_ASSUME_NONNULL_END
