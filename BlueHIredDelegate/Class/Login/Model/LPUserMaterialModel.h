//
//  LPUserMaterialModel.h
//  BlueHired
//
//  Created by peng on 2018/9/6.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LPUserMaterialDataModel;
@interface LPUserMaterialModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPUserMaterialDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPUserMaterialDataModel : NSObject

@property (nonatomic, copy) NSString *isReal;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *role;         //1直营店主2加盟店主 5代理 6店员
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *identity;
@property (nonatomic, copy) NSString *workStatus;
@property (nonatomic, copy) NSString *servicePhone;
@property (nonatomic, copy) NSString *isOpen;       //微信
@property (nonatomic, copy) NSString *isBank;       //绑定
@property (nonatomic, copy) NSString *shopType;       //绑定


@end
