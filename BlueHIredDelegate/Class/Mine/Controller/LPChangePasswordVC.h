//
//  LPChangePasswordVC.h
//  BlueHired
//
//  Created by peng on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPChangePasswordVC : LPBaseViewController

//Type == 0 密码修改。 type == 1 忘记密码
@property (nonatomic,assign) NSInteger Type;

@end

NS_ASSUME_NONNULL_END
