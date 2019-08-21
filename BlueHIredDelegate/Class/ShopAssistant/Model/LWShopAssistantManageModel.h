//
//  LWShopAssistantManageModel.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LWShopAssistantManageDataModel;
@interface LWShopAssistantManageModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LWShopAssistantManageDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LWShopAssistantManageDataModel : NSObject
@property (nonatomic, strong) NSString *certNo;
@property (nonatomic, strong) NSString *delStatus;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *mechanismName;
@property (nonatomic, strong) NSString *platReMoney;
@property (nonatomic, strong) NSString *reMoney;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *setTime;
@property (nonatomic, strong) NSString *shopNum;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *totalBonusMoney;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userSex;
@property (nonatomic, strong) NSString *userTel;
@property (nonatomic, strong) NSString *userUrl;
@property (nonatomic, strong) NSString *workAddress;
@property (nonatomic, strong) NSString *workBeginTime;
@property (nonatomic, strong) NSString *workId;
@property (nonatomic, strong) NSString *workNum;


@property (nonatomic, assign) BOOL isShow;

@end

NS_ASSUME_NONNULL_END
