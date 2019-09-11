//
//  LWAgencyFeeModel.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/16.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LWAgencyFeeDataModel;

@interface LWAgencyFeeModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LWAgencyFeeDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LWAgencyFeeDataModel : NSObject
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *shopNum;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *userCardNumber;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *staffName;
@property (nonatomic, strong) NSString *staffCardNumber;
@property (nonatomic, strong) NSString *workMechanismId;
@property (nonatomic, strong) NSString *workBeginTime;
@property (nonatomic, strong) NSString *workEndTime;
@property (nonatomic, strong) NSString *commissionBase;
@property (nonatomic, strong) NSString *workDay;
@property (nonatomic, strong) NSString *commissionPrize;
@property (nonatomic, strong) NSString *workTime;
@property (nonatomic, strong) NSString *postType;
@property (nonatomic, strong) NSString *subsidyContent;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *delStatus;
@property (nonatomic, strong) NSString *setTime;
@property (nonatomic, strong) NSString *allMoney;
@property (nonatomic, strong) NSString *mechanismName;
@property (nonatomic, strong) NSString *reMoney;
@property (nonatomic, strong) NSString *manageMoney;

@end
NS_ASSUME_NONNULL_END
