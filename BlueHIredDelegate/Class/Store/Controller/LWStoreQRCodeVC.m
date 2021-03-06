//
//  LWStoreQRCodeVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/12.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWStoreQRCodeVC.h"
#import "WHActivityView.h"

@interface LWStoreQRCodeVC ()
{
    WHActivityView  *activityView;//分享界面
}
@property(nonatomic,strong)CustomIOSAlertView *CustomAlert;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *RuleBtn;


@end

@implementation LWStoreQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"门店二维码";
    [LPTools setViewShapeLayer:self.RuleBtn CornerRadii:15 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft];
 
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT) ;
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#1EDDFF"].CGColor,
                  (__bridge id)[UIColor colorWithHexString:@"#1B82F0"].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [self.view.layer insertSublayer:gl atIndex:0];
    
    
    LPUserMaterialModel *user = kAppDelegate.userMaterialModel;
    
  
    [self.headImageView yy_setImageWithURL:[NSURL URLWithString:user.data.userUrl] placeholder:[UIImage imageNamed:@"logo_app"]];
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.cornerRadius = 4;

 
    NSString *strutl = @"";
    
    if (kAppDelegate.userMaterialModel.data.shopType.integerValue == 2) {
        strutl = [NSString stringWithFormat:@"%@resident/#/proxywork?identity=%@&origin=proxyV2",BaseRequestWeiXiURL,user.data.identity];
    }else{
        strutl = [NSString stringWithFormat:@"%@login?identity=%@&origin=proxy",BaseRequestWeiXiURLTWO,user.data.identity];
    }
    
    //1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSString *urlStr = strutl;
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    self.imageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:240];//重绘二维码,使其显示清晰
    self.imageView.layer.borderWidth = 4;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
}



- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

-(void)touchManagerButton
{
    
    //    NSString *url = [NSString stringWithFormat:@"%@bluehired/login.html?identity=%@",BaseRequestWeiXiURL,st];
    //    NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //    [LPTools ClickShare:encodedUrl Title:_model.data.essayName];
    [self btnClickShare];
}

- (IBAction)TouchShrae:(UIButton *)sender {
    [self share:sender.tag-1000+1];//QQ好友
}



-(void)btnClickShare{
    //更多。用于分享及编辑
    for (UIView *sub in [activityView subviews]) {
        [sub removeFromSuperview];
    }
    [activityView removeFromSuperview];
    activityView=nil;
    if (!activityView)
    {
        activityView = [[WHActivityView alloc]initWithTitle:nil referView:[[UIWindow visibleViewController].view window] isNeed:YES];
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        activityView.numberOfButtonPerLine = 4;
        activityView.titleLabel.text = @"请选择分享平台";
        __weak __typeof(self) weakSelf = self;
        ButtonView *bv = [[ButtonView alloc]initWithText:@"QQ" image:[UIImage imageNamed:@"QQLogo"] handler:^(ButtonView *buttonView){
            [weakSelf share:1];//QQ好友
        }];
        [activityView addButtonView:bv];
        bv = [[ButtonView alloc]initWithText:@"QQ空间"  image:[UIImage imageNamed:@"QQSpace"] handler:^(ButtonView *buttonView){
            [weakSelf share:2];//QQ空间
        }];
        [activityView addButtonView:bv];
        bv = [[ButtonView alloc]initWithText:@"微信"  image:[UIImage imageNamed:@"weixinLogo"] handler:^(ButtonView *buttonView){
            [weakSelf share:3];//微信
        }];
        [activityView addButtonView:bv];
        bv = [[ButtonView alloc]initWithText:@"朋友圈"  image:[UIImage imageNamed:@"WXSpace"] handler:^(ButtonView *buttonView){
            [weakSelf share:4];//微信朋友圈
        }];
        [activityView addButtonView:bv];
        
        [activityView show];
    }
}


-(void)share:(NSInteger)type{
 
    LPUserMaterialModel *user = kAppDelegate.userMaterialModel;

    NSString *url = @"";
    
    if (kAppDelegate.userMaterialModel.data.shopType.integerValue == 2) {
        url = [NSString stringWithFormat:@"%@resident/#/proxywork?identity=%@&origin=proxyV2",BaseRequestWeiXiURL,user.data.identity];
    }else{
        url = [NSString stringWithFormat:@"%@login?identity=%@&origin=proxy",BaseRequestWeiXiURLTWO,user.data.identity];
    }
    
    NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    UIImage *WxImage = [self addImage:self.imageView.image withImage:self.headImageView.image];
    //分享代码；
    if (type == 1) {        //qq
        if (![QQApiInterface isSupportShareToQQ])
        {
            [LPTools AlertMessageView:@"请安装QQ" dismiss:1.0];
            return;
        }
        NSString *title = @"蓝聘";
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImagePNGRepresentation(WxImage)
                                                   previewImageData:UIImagePNGRepresentation(WxImage)
                                                              title:title
                                                        description:nil];
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        
    }else if (type == 2){      //QQ空间
        if (![QQApiInterface isSupportShareToQQ])
        {
            [LPTools AlertMessageView:@"请安装QQ" dismiss:1.0];
            return;
        }
        NSString *title = @"蓝聘";
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImagePNGRepresentation(WxImage)
                                                   previewImageData:UIImagePNGRepresentation(WxImage)
                                                              title:title
                                                        description:nil];
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        
    }else if (type == 3){       //  wx
        if ([WXApi isWXAppInstalled]==NO) {
            [LPTools AlertMessageView:@"请安装微信" dismiss:1.0];
            return;
        }
        // 用于微信终端和第三方程序之间传递消息的多媒体消息内容
        WXMediaMessage *message = [WXMediaMessage message];
        // 多媒体消息中包含的图片数据对象
        WXImageObject *imageObject = [WXImageObject object];
        // 图片真实数据内容
        imageObject.imageData =  UIImagePNGRepresentation(WxImage);
        // 多媒体数据对象，可以为WXImageObject，WXMusicObject，WXVideoObject，WXWebpageObject等。
        message.mediaObject = imageObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;// 分享到朋友圈
        [WXApi sendReq:req];
    }else if (type == 4){       //朋友圈
        if ([WXApi isWXAppInstalled]==NO) {
            [LPTools AlertMessageView:@"请安装微信" dismiss:1.0];
            return;
        }
        
        // 用于微信终端和第三方程序之间传递消息的多媒体消息内容
        WXMediaMessage *message = [WXMediaMessage message];
        // 多媒体消息中包含的图片数据对象
        WXImageObject *imageObject = [WXImageObject object];
        // 图片真实数据内容
        imageObject.imageData =  UIImagePNGRepresentation(WxImage);
        // 多媒体数据对象，可以为WXImageObject，WXMusicObject，WXVideoObject，WXWebpageObject等。
        message.mediaObject = imageObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;// 分享到朋友圈
        [WXApi sendReq:req];
    }
}


- (UIImage *)addImage:(UIImage *)imageName1 withImage:(UIImage *)imageName2 {
    
    UIImage *image1 = imageName1;
    UIImage *image2 = imageName2;
    
    UIGraphicsBeginImageContext(image1.size);
    
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    [image2 drawInRect:CGRectMake((image1.size.width - 50)/2,(image1.size.height - 50)/2, 50, 50)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}



- (NSString *)URLDecodedString:(NSString *)str
{
    NSString *result = [str stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [result stringByRemovingPercentEncoding];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}





@end
