//
//  LWMyAppVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/11.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWMyAppVC.h"

@interface LWMyAppVC ()
@property (weak, nonatomic) IBOutlet UILabel *VersionLabel;

@end

@implementation LWMyAppVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.VersionLabel = [NSString stringWithFormat:@"当前版本 V%@",app_Version];
}



@end
