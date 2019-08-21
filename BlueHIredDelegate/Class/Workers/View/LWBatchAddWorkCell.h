//
//  LWBatchAddWorkCell.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/23.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWWorkRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LWBatchAddWorkBlock)( LWWorkRecordListDataModel *m);;

@interface LWBatchAddWorkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *Tel;

@property (nonatomic,copy) LWBatchAddWorkBlock block;


@property (nonatomic,strong) LWWorkRecordListDataModel *model;

@end

NS_ASSUME_NONNULL_END
