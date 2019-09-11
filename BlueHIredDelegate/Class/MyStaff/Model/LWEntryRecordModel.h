//
//  LWEntryRecordModel.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/9/9.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LWEntryRecordDataModel;

@interface LWEntryRecordModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) NSArray <LWEntryRecordDataModel *>  *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LWEntryRecordDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *upUserId;
@property (nonatomic, copy) NSString *shopUserId;
@property (nonatomic, copy) NSString *workTypeName;
@property (nonatomic, copy) NSString *earnStatus;
@property (nonatomic, copy) NSString *status;

@end
NS_ASSUME_NONNULL_END
