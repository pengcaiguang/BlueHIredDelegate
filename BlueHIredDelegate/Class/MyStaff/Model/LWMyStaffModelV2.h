//
//  LWMyStaffModelV2.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/9/9.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LWMyStaffDataModelV2;
@class workOrderVOList;

@interface LWMyStaffModelV2 : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) NSArray <LWMyStaffDataModelV2 *>  *data;
@property (nonatomic, copy) NSString *msg;
@end


@interface LWMyStaffDataModelV2 : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *workStatus;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *earnStatus;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *allNum;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, strong) NSArray <workOrderVOList *> *workOrderVOList;

@end
@interface workOrderVOList : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *upUserId;
@property (nonatomic, copy) NSString *shopUserId;
@property (nonatomic, copy) NSString *workTypeName;
@property (nonatomic, copy) NSString *earnStatus;

@end
NS_ASSUME_NONNULL_END
