//
//  LWEntryRecordModel.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/9/9.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWEntryRecordModel.h"

@implementation LWEntryRecordModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"data": @"LWEntryRecordDataModel",
             };
}
@end
@implementation LWEntryRecordDataModel
@end
