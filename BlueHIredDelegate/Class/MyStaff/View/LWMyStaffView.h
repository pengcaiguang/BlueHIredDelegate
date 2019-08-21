//
//  LWMyStaffView.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWMyStaffView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) NSArray <UIButton *>*ArrBtn;


-(void)GetWorkRecord;
@end

NS_ASSUME_NONNULL_END
