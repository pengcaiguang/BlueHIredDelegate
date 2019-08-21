//
//  AddressPickerView.m
//  testUTF8
//
//  Created by rhcf_wujh on 16/7/14.
//  Copyright © 2016年 wjh. All rights reserved.
//

#import "AddressPickerView.h"
#import "AddressModel.h"

#define AddressProvinceIdxName @"AddressSelectProvince"
#define AddressCityIdxName @"AddressSelectCity"
#define AddressAreaIdxName @"AddressSelectArea"
#define SELFSIZE self.bounds.size
#define AD_SCREEN [UIScreen mainScreen].bounds.size
#define AD_iPhoneX ([UIScreen mainScreen].bounds.size.width == 375.f && [UIScreen mainScreen].bounds.size.height == 812.f ? YES : NO)




static CGFloat TITLEHEIGHT = 50.0;// 标题栏高度
static CGFloat TITLEBUTTONWIDTH = 75;// 按钮宽度
static CGFloat CONTENTHEIGHT = 215.0;// 标题栏+选择视图高度

@implementation AddressCity
- (instancetype)initWithName:(NSString *)name
                       areas:(NSArray *)areas{
    if (self = [super init]) {
        _cityName = name;
        _areas = areas;
    }
    return self;
}

+ (instancetype)cityWithName:(NSString *)cityName
                       areas:(NSArray *)areas{
    AddressCity * city = [[AddressCity alloc]initWithName:cityName
                                                    areas:areas];
    return city;
}
@end

@implementation AddressProvince
// 成员方法创建
- (instancetype)initWithName:(NSString *)name
                      cities:(NSArray *)cities
{
    if (self = [super init]) {
        _name = name;
        _cities = cities;
    }
    
    return self;
}
// 类方法创建
+ (instancetype)provinceWithName:(NSString *)name
                          cities:(NSArray *)cities{
    AddressProvince *p = [[AddressProvince alloc] initWithName:name
                                                        cities:cities];
    return p;
}
@end


@interface AddressPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic, strong) UIButton *backgroundBtn;/**< 背景点击消失*/

@property (nonatomic ,strong) UIView   * titleBackgroundView;/**< 标题栏背景*/
@property (nonatomic ,strong) UIButton * cancelBtn;/**< 取消按钮*/
@property (nonatomic, strong) UIButton * sureBtn;/**< 完成按钮*/

@property (nonatomic ,strong) UIPickerView   * addressPickerView;/**< 选择器*/

@property (nonatomic ,strong) NSMutableArray * pArr;/**< 地址选择器数据源,装省份模型,每个省份模型内包含城市模型*/

@property (nonatomic ,strong) NSDictionary   * dataDict;/**< 省市区数据源字典*/
@property (nonatomic ,strong) NSMutableArray * provincesArr;/**< 省份名称数组*/
@property (nonatomic ,strong) NSDictionary   * citysDict;/**< 所有城市的字典*/
@property (nonatomic ,strong) NSDictionary   * areasDict;/**< 所有地区的字典*/

@property(nonatomic, strong) UIView *maskingView;

@end
@implementation AddressPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (frame.size.height == 0 && frame.size.width == 0) {
        frame = CGRectMake(0, 0, AD_SCREEN.width, AD_SCREEN.height);
    }
    self = [super initWithFrame:frame];
    if (self) {
        //加载地址数据源
        [self loadAddressData];
        // 默认支持自动打开上次结果
        self.isAutoOpenLast = YES;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        return [self initWithFrame:CGRectZero];
    }
    return self;
}

- (void)loadUI {
    [self loadBackgroundBtn];
    //加载标题栏
    [self loadTitle];
    //加载选择器
    [self loadPickerView];
    if (AD_iPhoneX) {
        [self addSubview:self.maskingView];
        self.maskingView.frame = CGRectMake(0, self.addressPickerView.frame.origin.y + self.addressPickerView.frame.size.height, AD_SCREEN.width, 34);
    }
}

- (UIColor *)backMaskColor {
    if (!_backMaskColor) {
        _backMaskColor = [UIColor blackColor];
    }
    return _backMaskColor;
}

- (UIColor *)titleViewColor {
    if (!_titleViewColor) {
        _titleViewColor = [UIColor whiteColor];
    }
    return _titleViewColor;
}

- (UIColor *)titleColor {
    if (!_titleColor) {
        _titleColor = [UIColor baseColor];
    }
    return _titleColor;
}

- (UIColor *)pickerViewColor {
    if (!_pickerViewColor) {
        _pickerViewColor = [UIColor colorWithRed:239/255.f
                                           green:239/255.f
                                            blue:244.0/255.f
                                           alpha:1.0];
    }
    return _pickerViewColor;
}

- (CGFloat)backMaskAlpha {
    if (!_backMaskAlpha) {
        _backMaskAlpha = 0.6;
    }
    return _backMaskAlpha;
}

- (UIView *)maskingView {
    if (!_maskingView) {
        _maskingView = [[UIView alloc]initWithFrame:CGRectZero];
        _maskingView.backgroundColor = self.addressPickerView.backgroundColor;
    }
    return _maskingView;
}

- (UIButton *)backgroundBtn {
    if (!_backgroundBtn) {
        _backgroundBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, AD_SCREEN.width, AD_SCREEN.height)];
        _backgroundBtn.backgroundColor = self.backMaskColor;
        _backgroundBtn.alpha = self.backMaskAlpha;
        [_backgroundBtn addTarget:self
                       action:@selector(cancelBtnClicked)
             forControlEvents:UIControlEventTouchUpInside];
     }
    return _backgroundBtn;
}

- (UIView *)titleBackgroundView{
    if (!_titleBackgroundView) {
        _titleBackgroundView = [[UIView alloc]initWithFrame:
                                CGRectMake(0, AD_SCREEN.height, SELFSIZE.width, TITLEHEIGHT)];
        _titleBackgroundView.backgroundColor = self.titleViewColor;
    }
    return _titleBackgroundView;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame:
                      CGRectMake(0, 0, TITLEBUTTONWIDTH, TITLEHEIGHT)];
        [_cancelBtn setTitle:@"取消"
                    forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor]
                         forState:UIControlStateNormal];
        [_cancelBtn addTarget:self
                       action:@selector(cancelBtnClicked)
             forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]initWithFrame:
                    CGRectMake(SELFSIZE.width - TITLEBUTTONWIDTH, 0, TITLEBUTTONWIDTH, TITLEHEIGHT)];
        [_sureBtn setTitle:@"保存"
                  forState:UIControlStateNormal];
        [_sureBtn setTitleColor:self.titleColor
                       forState:UIControlStateNormal];
        [_sureBtn addTarget:self
                     action:@selector(sureBtnClicked)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIPickerView *)addressPickerView{
    if (!_addressPickerView) {
        _addressPickerView = [[UIPickerView alloc]initWithFrame:
                              CGRectMake(0, self.titleBackgroundView.frame.origin.y + TITLEHEIGHT, SELFSIZE.width, CONTENTHEIGHT - TITLEHEIGHT)];
//        _addressPickerView.backgroundColor = self.pickerViewColor;
        _addressPickerView.backgroundColor = [UIColor whiteColor];
        _addressPickerView.delegate = self;
        _addressPickerView.dataSource = self;
    }
    return _addressPickerView;
}

- (void)loadBackgroundBtn {
    [self addSubview:self.backgroundBtn];
}

#pragma mark - 加载标题栏
- (void)loadTitle{
    [self addSubview:self.titleBackgroundView];
    [self.titleBackgroundView addSubview:self.cancelBtn];
    [self.titleBackgroundView addSubview:self.sureBtn];
}

#pragma mark  加载PickerView
- (void)loadPickerView{
    [self addSubview:self.addressPickerView];
}

#pragma mark - 自动选择上次的结果
- (void)setIsAutoOpenLast:(BOOL)isAutoOpenLast {
    _isAutoOpenLast = isAutoOpenLast;
    if (isAutoOpenLast) {
        __weak __typeof(self)weakSelf = self;
        [self getIdx:^(NSInteger p, NSInteger c, NSInteger a) {
            [weakSelf.addressPickerView selectRow:p inComponent:0 animated:NO];
            [weakSelf.addressPickerView selectRow:c inComponent:1 animated:NO];
            [weakSelf.addressPickerView selectRow:a inComponent:2 animated:NO];
        }];
    } else {
        [self.addressPickerView selectRow:0 inComponent:0 animated:NO];
        [self.addressPickerView selectRow:0 inComponent:1 animated:NO];
        [self.addressPickerView selectRow:0 inComponent:2 animated:NO];
    }
}

#pragma mark - 加载地址数据
- (void)loadAddressData{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"province"
                                                          ofType:@"json"];

    NSError  * error;
    NSString * str22 = [NSString stringWithContentsOfFile:filePath
                                                 encoding:NSUTF8StringEncoding
                                                    error:&error];
    
    if (error) {
        return;
    }
    
 
    _pArr         = [ AddressModel mj_objectArrayWithKeyValuesArray:str22];
    
    if (_pArr.count>2) {
        [_pArr removeObjectsInRange:NSMakeRange(0, 2)];
    }
}

#pragma mark - UIPickerDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.isShowArea) {
        return 3;
    }
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    if (0 == component) {
        return _pArr.count;
    }else if (1 == component){
        NSInteger selectProvince = [pickerView selectedRowInComponent:0];
        AddressModel * p = self.pArr[selectProvince];
        return p.city.count;
    }else if (2 == component){
        NSInteger selectProvince = [pickerView selectedRowInComponent:0];
        NSInteger selectCity     = [pickerView selectedRowInComponent:1];
        AddressModel * p  = self.pArr[selectProvince];
        return p.city[selectCity].area.count;
    }
    
    return 0;
}

#pragma mark - UIPickerViewDelegate
#pragma mark 填充文字
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component{
    if (0 == component) {
        AddressModel * p = _pArr[row];
        return p.name;
    }else if (1 == component) {
        AddressModel * selectP = _pArr[[pickerView selectedRowInComponent:0]];
        if (row > selectP.city.count - 1) {
            return nil;
        }
        return selectP.city[row].name;
    }else if (2 == component) {
        NSInteger selectProvince = [pickerView selectedRowInComponent:0];
        NSInteger selectCity = [pickerView selectedRowInComponent:1];
        AddressModel  *p = _pArr[selectProvince];
        if (selectCity > p.city.count - 1) {
            return nil;
        }
        AddressModel * c = p.city[selectCity];
        if (row > c.area.count -1 ) {
            return nil;
        }
        return c.area[row];
    }
    return nil;
}

#pragma mark pickerView被选中
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component{
    if (0 == component) {
        NSInteger selectCity = [pickerView selectedRowInComponent:1];
        [pickerView reloadComponent:1];
        [pickerView selectRow:selectCity inComponent:1 animated:YES];
        if (self.isShowArea) {
            NSInteger selectCity = [pickerView selectedRowInComponent:2];
            [pickerView reloadComponent:2];
            [pickerView selectRow:selectCity inComponent:2 animated:YES];
        }
    }else if (1 == component){
        if (self.isShowArea) {
            NSInteger selectCity = [pickerView selectedRowInComponent:2];
            [pickerView reloadComponent:2];
            [pickerView selectRow:selectCity inComponent:2 animated:YES];
        }
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row forComponent:(NSInteger)component
           reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textColor = [UIColor colorWithRed:51.0/255
                                                green:51.0/255
                                                 blue:51.0/255
                                                alpha:1.0];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    
    pickerLabel.text = [self pickerView:pickerView
                            titleForRow:row
                           forComponent:component];
    return pickerLabel;
}

#pragma mark - 解析json

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData  * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * err;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClicked{
    if ([_delegate respondsToSelector:@selector(cancelBtnClick)]) {
        [_delegate cancelBtnClick];
    }
}

- (void)setTitleHeight:(CGFloat)titleHeight pickerViewHeight:(CGFloat)pickerHeight {
    TITLEHEIGHT = titleHeight;
    CONTENTHEIGHT = titleHeight + pickerHeight;
}

- (void)show {
    [self show:YES];
}

- (void)hide {
    [self hide:YES];
}

- (void)show:(BOOL)animation{
    [self showOrHide:YES animation:animation];
}

- (void)hide:(BOOL)animation{
    [self showOrHide:NO animation:animation];
}

- (void)showOrHide:(BOOL)isShow animation:(BOOL)animation{
    [self loadUI];
    self.userInteractionEnabled = isShow;
    
    CGFloat selfY = self.frame.origin.y;
    if (!animation) {
        if (isShow) {
            self.backgroundBtn.hidden = NO;
            selfY = AD_SCREEN.height - CONTENTHEIGHT - TITLEHEIGHT;
            if (AD_iPhoneX) {
                selfY -= 34.0f;
            }
        }
        else {
            self.backgroundBtn.hidden = YES;
            selfY = AD_SCREEN.height;
        }
        self.titleBackgroundView.frame = CGRectMake(0,selfY, self.bounds.size.width,TITLEHEIGHT);
        self.addressPickerView.frame = CGRectMake(0, self.titleBackgroundView.frame.origin.y + TITLEHEIGHT, AD_SCREEN.width, CONTENTHEIGHT - TITLEHEIGHT);
 
         if (AD_iPhoneX) {
            self.maskingView.frame = CGRectMake(0, self.addressPickerView.frame.origin.y + self.addressPickerView.frame.size.height, AD_SCREEN.width, 34);
        }
        return;
    }
    __block CGFloat selfkY = selfY;
    [UIView animateWithDuration:0.5 animations:^{
        
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationDelegate:self];
        //改变它的frame的x,y的值
        
        if (isShow) {
            self.backgroundBtn.hidden = NO;
            selfkY = AD_SCREEN.height - CONTENTHEIGHT;
            if (AD_iPhoneX) {
                selfkY -= 34.0f;
            }
        }
        else {
            self.backgroundBtn.hidden = YES;
            selfkY = AD_SCREEN.height;
        }
        self.titleBackgroundView.frame = CGRectMake(0,selfkY, self.bounds.size.width,TITLEHEIGHT);
        self.addressPickerView.frame = CGRectMake(0, self.titleBackgroundView.frame.origin.y + TITLEHEIGHT, AD_SCREEN.width, CONTENTHEIGHT - TITLEHEIGHT);
        
//        self.addressPickerView.frame = CGRectMake(0, selfkY,AD_SCREEN.width, CONTENTHEIGHT - TITLEHEIGHT);
//        self.titleBackgroundView.frame = CGRectMake(0,self.addressPickerView.frame.origin.y + self.addressPickerView.frame.size.height,  self.bounds.size.width,TITLEHEIGHT);
        
        if (AD_iPhoneX) {
            self.maskingView.frame = CGRectMake(0, self.addressPickerView.frame.origin.y + self.addressPickerView.frame.size.height, AD_SCREEN.width, 34);
        }
        [UIView commitAnimations];
    }];
}

- (void)sureBtnClicked{
    if ([_delegate respondsToSelector:@selector(sureBtnClickReturnProvince:City:Area:)]) {
        NSInteger selectProvince = [self.addressPickerView selectedRowInComponent:0];
        NSInteger selectCity     = [self.addressPickerView selectedRowInComponent:1];
        NSInteger selectArea  = 0;
        if (self.isShowArea) {
            selectArea = [self.addressPickerView selectedRowInComponent:2];
        }
        
        AddressModel * p = _pArr[selectProvince];
        //解决省市同时滑动未结束时点击完成按钮的数组越界问题
        if (selectCity > p.city.count - 1) {
            selectCity = p.city.count - 1;
        }
 
        AddressModel * c = p.city[selectCity];
        //解决省市区同时滑动未结束时点击完成按钮的数组越界问题
        [_delegate sureBtnClickReturnProvince:p.name
                                         City:c.name
                                         Area:c.area.count > selectArea ?c.area[selectArea]:@""];

//        [_delegate sureBtnClickReturnProvince:p.name
//                                         City:c.cityName
//                                         Area:@""];
    }
}

- (void)setProvinceIdx:(NSInteger)p cityIdx:(NSInteger)c areaIdx:(NSInteger)a {
    [[NSUserDefaults standardUserDefaults] setValue:@(p+1) forKey:AddressProvinceIdxName];
    [[NSUserDefaults standardUserDefaults] setValue:@(c+1) forKey:AddressCityIdxName];
    [[NSUserDefaults standardUserDefaults] setValue:@(a+1) forKey:AddressAreaIdxName];
}

typedef void(^lastIdxBlock)(NSInteger p, NSInteger c, NSInteger a);
- (void)getIdx:(lastIdxBlock)block {
    NSNumber *p = [[NSUserDefaults standardUserDefaults] valueForKey:AddressProvinceIdxName];
    NSNumber *c = [[NSUserDefaults standardUserDefaults] valueForKey:AddressCityIdxName];
    NSNumber *a = [[NSUserDefaults standardUserDefaults] valueForKey:AddressAreaIdxName];
    
    if (p.integerValue && c.integerValue && a.integerValue) {
        block(p.integerValue - 1, c.integerValue - 1, a.integerValue - 1);
    }
}



@end
