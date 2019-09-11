//
//  UIButton+LWBK.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/23.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (LWBK)
@property(nonatomic,assign)NSTimeInterval timeInterval;//用这个给重复点击加间隔

@property(nonatomic,assign)BOOL isIgnoreEvent;//YES不允许点击NO允许点击
@end

NS_ASSUME_NONNULL_END
