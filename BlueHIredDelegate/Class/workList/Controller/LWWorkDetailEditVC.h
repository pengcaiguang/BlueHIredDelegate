//
//  LWWorkDetailEditVC.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/9/5.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWorkDetailModel.h"
#import "LPWorklistModel.h"
#import "LWMainView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWWorkDetailEditVC : LPBaseViewController
@property(nonatomic,strong) LPWorkDetailModel *model;
@property(nonatomic,strong) LPWorklistDataWorkListModel *workListModel;

@property (nonatomic,strong) NSMutableArray <LWMainView *>*superViewArr;

@end

NS_ASSUME_NONNULL_END
