//
//  LWWorkTableView.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/22.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWWorkTableView.h"
#import "LWWorkRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWWorkTableView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,assign) NSInteger workStatus;
@property (nonatomic,strong) NSArray <UIButton *>*ArrBtn;
@property (nonatomic,strong) NSMutableArray <LWWorkRecordListDataModel *>*listArray;

@property (nonatomic,strong) NSMutableArray <LWWorkTableView *>*superViewArr;

-(void)NodataView;

-(void)GetWorkRecord;

@end

NS_ASSUME_NONNULL_END
