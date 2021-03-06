//
//  LPBillrecordModel.h
//  BlueHired
//
//  Created by peng on 2018/9/30.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPBillrecordDataModel;
@interface LPBillrecordModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPBillrecordDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPBillrecordDataModel : NSObject
@property (nonatomic, strong) NSString *billType;
@property (nonatomic, strong) NSString *delStatus;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSNumber *set_time;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *errorRemark;
@property (nonatomic, strong) NSString *allMoney;
@property (nonatomic, strong) NSString *billMoney;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *chargeMoney;
@property (nonatomic, strong) NSString *bankNum;
@property (nonatomic, strong) NSString *cardType;



@end

NS_ASSUME_NONNULL_END
