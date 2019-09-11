//
//  LWMyStaffModelV2.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/9/9.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWMyStaffModelV2.h"

@implementation LWMyStaffModelV2
+ (NSDictionary *)objectClassInArray {
    return @{
             @"data": @"LWMyStaffDataModelV2",
             };
}

@end
@implementation LWMyStaffDataModelV2
+ (NSDictionary *)objectClassInArray {
    return @{
             @"workOrderVOList": @"workOrderVOList",
             };
}
@end

@implementation workOrderVOList
@end
