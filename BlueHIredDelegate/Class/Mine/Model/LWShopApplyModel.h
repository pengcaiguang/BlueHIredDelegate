//
//  LWShopApplyModel.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/13.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LWShopApplyDataModel;
@interface LWShopApplyModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LWShopApplyDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LWShopApplyDataModel : NSObject
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *shopType;
@property(nonatomic,strong) NSString *workType;
@property(nonatomic,strong) NSString *workRange;
@property(nonatomic,strong) NSString *realShop;
@property(nonatomic,strong) NSString *shopAddress;
@property(nonatomic,strong) NSString *extAddress;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *remark;
@property(nonatomic,strong) NSString *time;
@property(nonatomic,strong) NSString *setTime;


@end
NS_ASSUME_NONNULL_END
