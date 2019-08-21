//
//  LWAgencyFeeVC.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/16.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAgencyFeeVC : LPBaseViewController

//type=0 代理费明细。type = 1 个人业绩  type = 2 业绩详情
@property (nonatomic,assign) NSInteger Type;

@end

NS_ASSUME_NONNULL_END
