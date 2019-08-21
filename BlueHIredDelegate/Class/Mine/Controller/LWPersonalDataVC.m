//
//  LWPersonalDataVC.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/7/10.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "LWPersonalDataVC.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
@interface LWPersonalDataVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UILabel *UserSex;


@end

@implementation LWPersonalDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人资料";
    self.UserImage.layer.cornerRadius = LENGTH_SIZE(30.0);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tuchHeadImgView)];
    self.UserImage.userInteractionEnabled = YES;
    [self.UserImage addGestureRecognizer:tap];
    
    self.UserName.text =  [LPTools isNullToString:self.userMaterialModel.data.userName] ;
    [self.UserImage yy_setImageWithURL:[NSURL URLWithString:self.userMaterialModel.data.userUrl] placeholder:[UIImage imageNamed:@"Head_image"]];
    if ([self.userMaterialModel.data.userSex integerValue] == 0) {//0未知1男2女
        self.UserSex.text = @"";
    }else if ([self.userMaterialModel.data.userSex integerValue] == 1) {
        self.UserSex.text = @"男";
    }else if ([self.userMaterialModel.data.userSex integerValue] == 2) {
        self.UserSex.text = @"女";
    }
}

- (IBAction)TouchSave:(id)sender {
    [self requestQueryUpdateUserMater];
}

- (IBAction)TouchSex:(id)sender {
    UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *Alert1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.UserSex.text = @"男";
    }];
    UIAlertAction *Alert2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.UserSex.text = @"女";
    }];
    UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"取  消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
//    [Alert1 setValue:[UIColor colorWithHexString:@"#333333"] forKey:@"titleTextColor"];
//    [Alert2 setValue:[UIColor colorWithHexString:@"#333333"] forKey:@"titleTextColor"];
//    [Cancel setValue:[UIColor colorWithHexString:@"#999999"] forKey:@"titleTextColor"];

    
    [AlertController addAction:Alert1];
    [AlertController addAction:Alert2];
    [AlertController addAction:Cancel];

    [self presentViewController:AlertController animated:YES completion:^{}];
}


- (IBAction)fieldTextDidChange:(UITextField *)textField
{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 12;
    
    
    
    NSString *toBeString = textField.text;
    // 获取键盘输入模式
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
    // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮选择部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                // 截取子串
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        } else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            // 截取子串
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}



#pragma mark - UIImagePickerControllerDelegate

-(void)tuchHeadImgView{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
#if (TARGET_IPHONE_SIMULATOR)
                                                          
#else
                                                          [self takePhoto];
#endif
                                                          
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选择"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self choosePhoto];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
-(void)takePhoto{
    
    //#if (TARGET_IPHONE_SIMULATOR)
    //
    //#else
    //    [self startDevice];
    //#endif
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请进入设置-隐私-相机-中打开相机权限"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            nil;
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        return;
    }
    
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
-(void)choosePhoto{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
 
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"headImage.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
 
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *headImage = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    [self updateHeadImage:headImage];
}
// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - updateImage
-(void)updateHeadImage:(UIImage *)image{
    [NetApiManager avartarChangeWithParamDict:nil singleImage:image singleImageName:@"file" withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"data"]) {
                self.userMaterialModel.data.userUrl = responseObject[@"data"];
                [self.UserImage yy_setImageWithURL:[NSURL URLWithString:self.userMaterialModel.data.userUrl] placeholder:[UIImage imageNamed:@"Head_image"]];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

#pragma mark - request
-(void)requestQueryUpdateUserMater{
    NSString *name =  [self.UserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *sex = @"0";
    if ([self.UserSex.text isEqualToString:@""]) {
        sex = @"0";
    }else if ([self.UserSex.text isEqualToString:@"男"]){
        sex = @"1";
    }else if ([self.UserSex.text isEqualToString:@"女"]){
        sex = @"2";
    }
  
    self.userMaterialModel.data.userName = name;
    self.userMaterialModel.data.userSex = sex;

    NSDictionary *dic = @{@"userName":name,
                          @"userUrl":self.userMaterialModel.data.userUrl,
                          @"userSex":sex
                          };
     [NetApiManager requestQueryUpdateUserMater:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0) {
                    [self.navigationController  popViewControllerAnimated:YES];
                    [self.view showLoadingMeg:@"修改成功" time:MESSAGE_SHOW_TIME];
                }else{
                    [self.view showLoadingMeg:@"修改失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

 @end
