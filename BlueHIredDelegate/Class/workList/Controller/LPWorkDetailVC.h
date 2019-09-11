//
//  LPWorkDetailVC.h
//  BlueHired
//
//  Created by peng on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWorklistModel.h"
#import "LWMainView.h"


@interface LPWorkDetailVC : LPBaseViewController

@property(nonatomic,strong) LPWorklistDataWorkListModel *workListModel;

@property(nonatomic,assign) BOOL isWorkOrder;


@property (nonatomic,strong) NSMutableArray <LWMainView *>*superViewArr;


@end
