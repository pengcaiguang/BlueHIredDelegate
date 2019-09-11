//
//  LPMainSearchVC.h
//  BlueHired
//
//  Created by peng on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWMainView.h"

@interface LPMainSearchVC : LPBaseViewController

// type0 = 招聘 type1 = 我的员工  type2 = 模式二招聘   type3 = 模式二我的员工
@property (nonatomic,assign) NSInteger type;

@property(nonatomic,strong) NSString *mechanismAddress;

@property (nonatomic,strong) NSMutableArray <LWMainView *>*superViewArr;

@end
