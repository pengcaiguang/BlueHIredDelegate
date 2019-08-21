//
//  LWShopWorkDetailModel.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/16.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LWShopWorkDetailDataModel;
@class LWShopWorkDetailData;
@interface LWShopWorkDetailModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LWShopWorkDetailData  *data;
@property (nonatomic, copy) NSString *msg;
@end
@interface LWShopWorkDetailData : NSObject
@property (nonatomic, copy) NSString *shopUserNum;
@property (nonatomic, copy) NSString *shopWorkNum;
@property (nonatomic, strong) NSArray <LWShopWorkDetailDataModel *> *shopWorkDetailList;
@end

@interface LWShopWorkDetailDataModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *shopNum;
@property (nonatomic, copy) NSString *shopType;
@property (nonatomic, copy) NSString *authority;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSString *shopUserNum;
@property (nonatomic, copy) NSString *shopLabourNum;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *roleName;
@property (nonatomic, copy) NSString *totalBonusMoney;
@property (nonatomic, copy) NSString *userCardNumber;
@property (nonatomic, copy) NSString *enrollNum;

@end

NS_ASSUME_NONNULL_END
