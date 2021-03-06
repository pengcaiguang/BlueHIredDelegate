//
//  LPWorkDetailModel.h
//  BlueHired
//
//  Created by peng on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPWorkDetailDataModel;

@interface LPWorkDetailModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPWorkDetailDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end


@interface LPWorkDetailDataModel : NSObject

@property (nonatomic, copy) NSNumber *applyNumber;
@property (nonatomic, copy) NSString *authority;
@property (nonatomic, copy) NSNumber *collectId;
@property (nonatomic, copy) NSNumber *cooperateMoney;
@property (nonatomic, copy) NSNumber *dismountType;
@property (nonatomic, copy) NSString *eatSleep;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSString *imageList;
@property (nonatomic, copy) NSString *interviewTime;
@property (nonatomic, copy) NSNumber *isApply;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSNumber *lendType;
@property (nonatomic, copy) NSString *manageMoney;
@property (nonatomic, copy) NSNumber *maxNumber;
@property (nonatomic, copy) NSString *mechanismAddress;
@property (nonatomic, copy) NSString *mechanismDetails;
@property (nonatomic, copy) NSNumber *mechanismId;
@property (nonatomic, copy) NSString *mechanismLogo;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSNumber *mechanismScore;
@property (nonatomic, copy) NSString *mechanismUrl;
@property (nonatomic, copy) NSString *postName;
@property (nonatomic, copy) NSNumber *postType;
@property (nonatomic, copy) NSNumber *reMoney;
@property (nonatomic, copy) NSNumber *reTime;
@property (nonatomic, copy) NSString *recruitAddress;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSNumber *status;
@property (nonatomic, copy) NSString *wageRange;
@property (nonatomic, copy) NSString *workDemand;
@property (nonatomic, copy) NSString *workKnow;
@property (nonatomic, copy) NSString *workMoney;
@property (nonatomic, copy) NSString *workSalary;
@property (nonatomic, copy) NSString *workTime;
@property (nonatomic, copy) NSString *workTypeName;
@property (nonatomic, copy) NSString *workUrl;
@property (nonatomic, copy) NSNumber *workWatchStatus;
@property (nonatomic, copy) NSString *reInstruction;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *x;
@property (nonatomic, copy) NSString *y;
@property (nonatomic, copy) NSString *teacherName;
@property (nonatomic, copy) NSString *teacherPhone;
@property (nonatomic, copy) NSString *addWorkMoney;
@property (nonatomic, copy) NSString *reStatus;
@property (nonatomic, copy) NSString *workHide;
@property (nonatomic, copy) NSString *shopReStatus;
@property (nonatomic, copy) NSString *shopReMoney;
@property (nonatomic, copy) NSString *shopAddWorkMoney;
@property (nonatomic, copy) NSString *maxAddWorkMoney;
@property (nonatomic, copy) NSString *maxReMoney;
@property (nonatomic, copy) NSString *maxReStatus;

@end
