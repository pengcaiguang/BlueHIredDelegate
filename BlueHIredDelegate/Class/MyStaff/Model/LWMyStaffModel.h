//
//  LWMyStaffModel.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LWMyStaffDataModel;

@interface LWMyStaffModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) NSArray <LWMyStaffDataModel *>  *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LWMyStaffDataModel : NSObject

@property (nonatomic, assign) BOOL isShow;
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


@end

NS_ASSUME_NONNULL_END
