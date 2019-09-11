//
//  LWEntryRecordCell.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/9/6.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWEntryRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWEntryRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *WorkName;
@property (weak, nonatomic) IBOutlet UILabel *Time;
@property (weak, nonatomic) IBOutlet UILabel *PostType;
@property (weak, nonatomic) IBOutlet UILabel *WorkStatus;

@property (weak, nonatomic) IBOutlet UIView *earnStatus;
@property (weak, nonatomic) IBOutlet UILabel *earnStatusTitle;


@property (nonatomic, strong) LWEntryRecordDataModel *model;

@end

NS_ASSUME_NONNULL_END
