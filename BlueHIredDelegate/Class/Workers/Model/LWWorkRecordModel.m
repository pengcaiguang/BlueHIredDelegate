//
//  LWWorkRecordModel.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/9.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWWorkRecordModel.h"

@implementation LWWorkRecordModel

@end

@implementation LWWorkRecordDataModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"workRecordList": @"LWWorkRecordListDataModel",
             };
}
@end

@implementation LWWorkRecordListDataModel

@end
