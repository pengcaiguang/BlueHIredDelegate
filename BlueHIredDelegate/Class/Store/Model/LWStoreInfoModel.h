//
//  LWStoreInfoModel.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/18.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LWStoreInfoDataModel;

@interface LWStoreInfoModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LWStoreInfoDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LWStoreInfoDataModel : NSObject
@property (nonatomic, strong) NSString *authority;
@property (nonatomic, strong) NSString *delStatus;
@property (nonatomic, strong) NSString *enrollNum;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *roleName;
@property (nonatomic, strong) NSString *set_time;
@property (nonatomic, strong) NSString *shopLabourNum;
@property (nonatomic, strong) NSString *shopNum;
@property (nonatomic, strong) NSString *shopType;
@property (nonatomic, strong) NSString *shopUserNum;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *totalBonusMoney;
@property (nonatomic, strong) NSString *userCardNumber;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userTel;
@property (nonatomic, strong) NSString *userUrl;

@end
NS_ASSUME_NONNULL_END
