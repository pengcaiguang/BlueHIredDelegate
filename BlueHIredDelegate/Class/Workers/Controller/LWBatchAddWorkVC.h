//
//  LWBatchAddWorkVC.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/23.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWWorkRecordModel.h"
#import "LWWorkTableView.h"
NS_ASSUME_NONNULL_BEGIN

@interface LWBatchAddWorkVC : LPBaseViewController

@property (nonatomic,strong) LWWorkRecordListDataModel *model;
@property (nonatomic, strong) NSMutableArray <LWWorkTableView *>*superViewArr;

@end

NS_ASSUME_NONNULL_END
