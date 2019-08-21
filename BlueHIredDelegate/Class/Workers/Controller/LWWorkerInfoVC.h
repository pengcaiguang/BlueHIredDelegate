//
//  LWWorkerInfoVC.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/22.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWWorkTableView.h"
#import "LWWorkRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LWWorkerInfoVC : LPBaseViewController

//0 = 添加或者查看信息。1 = 批量查看
@property (nonatomic, assign) NSInteger Type;
@property (nonatomic, strong) LWWorkRecordListDataModel *workModel;
@property (nonatomic, strong) NSMutableArray <LWWorkTableView *>*superViewArr;
@property (nonatomic,strong) NSArray <UIButton *>*ArrBtn;

@end

NS_ASSUME_NONNULL_END
