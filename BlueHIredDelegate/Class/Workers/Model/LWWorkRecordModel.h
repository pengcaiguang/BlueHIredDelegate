//
//  LWWorkRecordModel.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/9.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LWWorkRecordDataModel;
@class LWWorkRecordListDataModel;

@interface LWWorkRecordModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LWWorkRecordDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LWWorkRecordDataModel : NSObject
@property (nonatomic, copy) NSString *empNum;
@property (nonatomic, copy) NSString *unEmpNum;
@property (nonatomic, strong) NSArray <LWWorkRecordListDataModel *> *workRecordList;
@end

@interface LWWorkRecordListDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *feeType;
@property (nonatomic, copy) NSString *feeMoney;
@property (nonatomic, copy) NSString *carStatus;
@property (nonatomic, copy) NSString *carMoney;
@property (nonatomic, copy) NSString *workStatus;
@property (nonatomic, copy) NSString *workBeginTime;
@property (nonatomic, copy) NSString *workMechanism;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;


@end


NS_ASSUME_NONNULL_END
