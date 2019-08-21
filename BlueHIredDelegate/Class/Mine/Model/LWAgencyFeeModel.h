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


@end
NS_ASSUME_NONNULL_END
