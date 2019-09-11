//
//  LWIncomeDetailsModel.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/9/4.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LWIncomeDetailsDataModel;
@class LWIncomeDetailsListModel;

@interface LWIncomeDetailsModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LWIncomeDetailsListModel  *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LWIncomeDetailsListModel : NSObject
@property (nonatomic, copy) NSString *allMoney;
@property (nonatomic, strong) NSArray <LWIncomeDetailsDataModel *>  *performanceList;

@end

@interface LWIncomeDetailsDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *shopNum;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userType;
@property (nonatomic, copy) NSString *userCardNumber;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *staffName;
@property (nonatomic, copy) NSString *staffCardNumber;
@property (nonatomic, copy) NSString *workMechanismId;
@property (nonatomic, copy) NSString *workBeginTime;
@property (nonatomic, copy) NSString *workEndTime;
@property (nonatomic, copy) NSString *commissionBase;
@property (nonatomic, copy) NSString *workDay;
@property (nonatomic, copy) NSString *commissionPrize;
@property (nonatomic, copy) NSString *workTime;
@property (nonatomic, copy) NSString *postType;
@property (nonatomic, copy) NSString *subsidyContent;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *allMoney;
@property (nonatomic, copy) NSString *mechanismName;
 
@end
NS_ASSUME_NONNULL_END
