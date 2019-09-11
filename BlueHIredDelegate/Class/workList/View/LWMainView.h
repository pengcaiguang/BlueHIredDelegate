//
//  LWMainView.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/9/5.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWorklistModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWMainView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,assign) NSInteger workStatus;
@property (nonatomic,strong) NSArray <UIButton *>*ArrBtn;
@property (nonatomic,strong) NSMutableArray <LPWorklistDataWorkListModel *>*listArray;
@property(nonatomic,strong) NSString *mechanismAddress;

@property (nonatomic,strong) NSMutableArray <LWMainView *>*superViewArr;

-(void)NodataView;

-(void)GetMainViewData;

@end

NS_ASSUME_NONNULL_END
