//
//  UCEScanViewController.m
//  BMS
//
//  Created by ws on 2017/5/26.
//  Copyright © 2017年 余尚祥. All rights reserved.
//

#import "UCEScanViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "UCEScanView.h"
#import "NSString+JKTrims.h"
#import "CustomPasswordAlter.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define DefaultRectColor [UIColor colorWithRed:47.0f/255.0 green:234.0f/255.0 blue:51.0f/255.0 alpha:1.0f]
#define kQRCodeScanSide (kScreenW - 80)
#define kBarCodeScanWidth (kScreenW - 40)
#define kBarCodeScanHeight 100

const CGFloat kScanAnimationDuration = 2.0f;

@interface UCEScanViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIToolbarDelegate,AVCaptureMetadataOutputObjectsDelegate,AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>

{
    NSTimer *_timer;
    BOOL isLightOn;
    NSURL *_successVoiceURL;
    NSURL *_errorVoiceURL;
    UILabel *_scanNumLabel;
    NSUInteger _scanNum;
    NSString *_tmpScanCode;
}

@property (strong,nonatomic) AVCaptureSession * session; // 二维码生成的绘画
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *previewLayer;  // 二维码生成图层
@property (strong,nonatomic) UIImageView * codeLine;
@property (nonatomic, strong)  UCEScanView * scanView;
@property (nonatomic, weak)  UIButton * lightOnOff;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) NSURL *successVoiceURL;
@property (nonatomic, strong) NSURL *errorVoiceURL;
@property (nonatomic, strong) UILabel *scanNumLabel;
@property (nonatomic, assign) NSUInteger scanNum;
@property (nonatomic, copy) NSString *tmpScanCode;

@property (nonatomic, strong) UILabel * infoLabel;

@end

@implementation UCEScanViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    // 6. 启动会话
    [self.session startRunning];
    [self createTimer];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
    [self stopTimer];//停止timer
    [self.session stopRunning];//停止运行
    [self.lightOnOff setTitle:@"开灯" forState:UIControlStateNormal];//恢复开灯按钮
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)initialize{
   
    self.view.backgroundColor=[UIColor whiteColor];
    
    if (!self.customInfo) {
//         self.customInfo = Prompt_Scanning;
    }
   
    if ([self validateCameraFromSource:UIImagePickerControllerSourceTypeCamera]) {
        [self readCode];
    }
    [self addTitleView];
    [self addBackView];
    self.titleLabel.center = CGPointMake(self.view.center.x, 41);
    [self.view addSubview:self.titleLabel];
    [self addRightButton];

    self.successVoiceURL = [[NSBundle mainBundle] URLForResource:@"success" withExtension:@"wav"];
    self.errorVoiceURL = [[NSBundle mainBundle] URLForResource:@"error" withExtension:@"wav"];
    self.scanNum = 0;
}

- (void)addBackView {
    UIButton *back = [[UIButton alloc]init];
    back.frame = CGRectMake(10, IPHONEX_SAFEAREA, 44, 44);
    [back setImage:[UIImage imageNamed:@"icon_fanhui"] forState:UIControlStateNormal];
    [back addTarget:self
             action:@selector(back:)
   forControlEvents:UIControlEventTouchUpInside];
    [self.scanView addSubview:back];
}

- (void)addTitleView {
    UIView *navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IPHONEX_SAFE_AREA_TOP_HEIGHT_88)];
    navBgView.backgroundColor = [UIColor blackColor];//RGBA(236,127,13, 1);
    [self.scanView addSubview:navBgView];
}

- (void)addRightButton {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80, IPHONEX_SAFEAREA, 60, 44)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [button setTitle:@"开灯" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.tag = 1;
    [button addTarget:self action:@selector(toolbarItemAction:) forControlEvents:UIControlEventTouchUpInside];
    _lightOnOff = button;
    [self.scanView addSubview:button];
}

#pragma mark - private

/**
 连续扫描间隔
 */
- (void)intervalScan {
    [self.session stopRunning];
    [NSThread sleepForTimeInterval:1.0];
    [self.session startRunning];
    
    if ([_lightOnOff.titleLabel.text isEqualToString:@"关灯"]) {
        [self setLightOnOffTitleWithState:YES];
    }
}

- (void)intervalOtherScan {
    [self.session stopRunning];
}

- (void)startScan {
    [self.session startRunning];
    if ([_lightOnOff.titleLabel.text isEqualToString:@"关灯"]) {
        [self setLightOnOffTitleWithState:YES];
    }
}

- (void)showVoice:(BOOL)isSuccess {
    
    if (isSuccess) {
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)self.successVoiceURL, &soundID);
        AudioServicesPlayAlertSound(soundID);
    }else {
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)self.errorVoiceURL, &soundID);
        AudioServicesPlayAlertSound(soundID);
    }
}

/**
 *  验证相机状态
 */
- (BOOL)validateCameraFromSource:(UIImagePickerControllerSourceType)sourceType {
    //相机访问被关闭
    BOOL isCameraValid = YES;
    if (([[[UIDevice currentDevice]systemVersion]floatValue]>7.0) &&
        ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]))
    {//拍照权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if ((authStatus == AVAuthorizationStatusDenied)||
            (authStatus == AVAuthorizationStatusRestricted)){
            isCameraValid=NO;
        }
    }
    NSArray *mediaTypes=@[(NSString *)kUTTypeImage];//相册不需要判断权限，系统会自动提示，这里是获取是否设备支持
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]||
        ([mediaTypes count] <= 0)) {
        isCameraValid=NO;
    }
    if (!isCameraValid) {
       
        UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(15, 40, 50, 50);
        [closeButton setImage:[UIImage imageNamed:@"close_nav"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeButton];
        
        //未授权界面自己去画 这里给个demo
//        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-250)/2, self.view.frame.size.height/2+80, 250, 40)];
//        label.text=@"获取相机授权方可进行扫描哦~";
//        label.textColor=[UIColor orangeColor];
//        [self.view addSubview:label];
//        
//        UIButton *adminBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        adminBtn.frame=CGRectMake((self.view.frame.size.width-100)/2, self.view.frame.size.height/2+70+80, 100, 40);
//        adminBtn.backgroundColor=[UIColor orangeColor];
//        [adminBtn setTitle:@"怎么授权" forState:UIControlStateNormal];
//        [adminBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [adminBtn addTarget:self action:@selector(doAdmin:) forControlEvents:UIControlEventTouchUpInside];
//        adminBtn.layer.cornerRadius=5.0f;
//        [self.view addSubview:adminBtn];
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"打开相机授权才可进行扫描" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去授权", nil];
        alertView.delegate = self;
        [alertView show];
        
    }
    return isCameraValid;
}

#pragma mark - UCEDigitalOrderInputViewDelegate

//- (void)digitalOrderInputView:(UCEDigitalOrderInputView *)digitalOrderInputView didComfirmWithWaybillNo:(NSString *)billCode {
//
//    billCode = [billCode uppercaseString];
//    _complete(billCode);
//}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:true completion:nil];
        [self doAdmin];
    }else {
        [self closeController];
    }
}

#pragma mark -
#pragma mark - event response

-(void)doAdmin {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)closeController{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:true completion:nil];
    }else
        [self.navigationController popViewControllerAnimated:true];
}

// 读取二维码
- (void)readCode {
    // 1. 摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2. 设置输入
    // 因为模拟器是没有摄像头的，因此在此最好做一个判断
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        return;
    }
    
    // 3. 设置输出(Metadata元数据)
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 3.1 设置输出的代理
    // 说明：使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //    [output setMetadataObjectsDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    // 4. 拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    // 添加session的输入和输出
    [session addInput:input];
    [session addOutput:output];
    // 4.1 设置输出的格式
    // 提示：一定要先设置会话的输出为output之后，再指定输出的元数据类型！
    
    if (self.scanCodeType == ScanCodeTypeBarcode) {//条码
        [output setMetadataObjectTypes:@[
                                         AVMetadataObjectTypeCode39Code,
                                         AVMetadataObjectTypeCode128Code,
                                         AVMetadataObjectTypeCode39Mod43Code,
                                         AVMetadataObjectTypeEAN13Code,
                                         AVMetadataObjectTypeEAN8Code,
                                         AVMetadataObjectTypeCode93Code]];
    }else if (self.scanCodeType == ScanCodeTypeQRcode) {//二维码
        [output setMetadataObjectTypes:@[
                                         AVMetadataObjectTypeQRCode,
                                        ]];
    }else { //两种都可以
        [output setMetadataObjectTypes:@[
                                         AVMetadataObjectTypeQRCode,
                                         AVMetadataObjectTypeCode39Code,
                                         AVMetadataObjectTypeCode128Code,
                                         AVMetadataObjectTypeCode39Mod43Code,
                                         AVMetadataObjectTypeEAN13Code,
                                         AVMetadataObjectTypeEAN8Code,
                                         AVMetadataObjectTypeCode93Code]];
    }
    
    // 5. 设置预览图层（用来让用户能够看到扫描情况）
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    // 5.1 设置preview图层的属性
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    // 5.2 设置preview图层的大小
    [preview setFrame:self.view.bounds];
    // 5.3 将图层添加到视图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    self.previewLayer = preview;
    self.session = session;
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    UCEScanView *rectView = [[UCEScanView alloc] initWithFrame:screenRect];
    CGFloat sidePadding = 10.0f;
    if (self.scanCodeType == ScanCodeTypeQRcode || self.scanCodeType == ScanCodeTypeAll) {
         rectView.transparentArea = CGSizeMake(kQRCodeScanSide, kQRCodeScanSide);
    }else {
         rectView.transparentArea = CGSizeMake(kBarCodeScanWidth, kBarCodeScanHeight);
    }
    rectView.backgroundColor = [UIColor clearColor];
    rectView.rectColor = self.rectColor ? :DefaultRectColor;
    self.scanView = rectView;
    [self.view addSubview:rectView];
    
    //修正扫描区域
    [output setRectOfInterest:CGRectMake(sidePadding / kScreenW,
                                         sidePadding / kScreenH,
                                         rectView.bounds.size.height / kScreenW,
                                         rectView.bounds.size.width / kScreenH)];
    
    [output setRectOfInterest:CGRectMake((self.scanView.frame.size.height - self.scanView.transparentArea.height)/2/self.scanView.height, 0, self.scanView.transparentArea.height/self.scanView.height, 1)];
    
    [output setRectOfInterest:CGRectMake(0, 0, 1, 1)];

    //画中间的基准线
    CGSize size = self.scanView.transparentArea;
    CGFloat startX = (self.scanView.bounds.size.width - size.width)/2;
    CGFloat startY = (self.scanView.bounds.size.height - size.height)/2;
    CGRect codeLineframe=CGRectMake(startX,startY,size.width,2);
    self.codeLine = [[UIImageView alloc] initWithFrame:codeLineframe];
    self.codeLine.image=[UIImage imageNamed:@"scan_wire"];
    
    [self.scanView addSubview:self.codeLine];
    
    
    //    CGFloat infoY = self.qrView.center.y + size.height/2;
    
    CGFloat infoHeight = 20.0f;
    
    UILabel *infoLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,self.scanView.height/2 + self.scanView.transparentArea.height/2 + 10, 0, infoHeight)];
    infoLabel.text = self.customInfo;
    infoLabel.font=[UIFont systemFontOfSize:15];
    [infoLabel sizeToFit];
    infoLabel.center = CGPointMake(self.scanView.center.x, infoLabel.center.y);
    infoLabel.backgroundColor=[UIColor clearColor];
    infoLabel.textColor=[UIColor whiteColor];
    [self.scanView addSubview:infoLabel];
    self.infoLabel = infoLabel;
    
    self.scanNumLabel.frame = CGRectMake(0, infoLabel.frame.origin.y + 40, SCREEN_WIDTH, infoHeight);
    [self.scanView addSubview:self.scanNumLabel];
}

#pragma mark - Actions

- (void)toolbarItemAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            [self flashOnOrOff];
            break;
        case 2:
            
            break;
        case 3:
            [self chooseImage];
            break;
        default:
            break;
    }
}

/**
 *进入相册界面
 */
-(void)chooseImage {
    // 从相册中选取
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.navigationBar.tintColor= [UIColor colorWithRed:0.255 green:0.412 blue:0.882 alpha:1.000];
        controller.allowsEditing=YES;
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                         }];
    }
}

- (void)back:(id)sender{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:true completion:nil];
    }else
        [self.navigationController popViewControllerAnimated:true];
}

- (void)setLightOnOffTitleWithState:(BOOL)state {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: (AVCaptureTorchMode)state];
        [device unlockForConfiguration];
    }
    [_lightOnOff setTitle:state ? @"关灯":@"开灯" forState:UIControlStateNormal];
}

- (void)flashOnOrOff {
    isLightOn = !isLightOn;
    [self setLightOnOffTitleWithState:isLightOn];
}

#pragma mark -
#pragma mark - Delegate
- (void) imagePickerController: (UIImagePickerController*)reader
 didFinishPickingMediaWithInfo: (NSDictionary*)info {
    
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    image = [self imageSizeWithScreenImage:image];
    
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    for (int index = 0; index < [features count]; index ++) {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        NSString *scannedResult = feature.messageString;
        
        if (self.complete) {
            [self showVoice:YES];
            self.complete([scannedResult copy]);
        }   
    }
}



#pragma mark - 
#pragma mark - complete
// 此方法是在识别到Code，并且完成转换
// 如果Code的内容越大，转换需要的时间就越长
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        // 提示：如果需要对url或者名片等信息进行扫描，可以在此进行扩展！
    
        if (self.autoGoBack) {
            NSString *str = obj.stringValue;
            NSLog(@"扫描结果:%@",str);
            [self.session stopRunning];
             NSArray  *array = [str componentsSeparatedByString:@"="];//--分隔符
            if (array.count == 2) {
                [self requestOtoCertificationCode:array[1]];
                
            } else {
                [CustomPasswordAlter showCustomPasswordAlterViewViewIn:self.view title:@"此二维码不符合核销规则,请检查" suret:@"确认" closet:@"" sureblock:^{
                     [self.session startRunning];
                } closeblock:^{
                    
                }];
            }
         
        }
    }
    
}
- (void)requestOtoCertificationCode:(NSString *)code{
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    
    NSDictionary *dic = @{
                          @"sid":sid,
                          @"code":code,
                          @"orderNo":self.orderNo ?: @""
                          };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/otoCertification"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",request.responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            [CustomPasswordAlter showCustomPasswordAlterViewViewIn:self.view title:@"核销成功!" suret:@"确认" closet:@"" sureblock:^{
                if (self.nvController) {
                     [self.nvController dismissViewControllerAnimated:YES completion:nil];
                } else {
                   [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
                
            } closeblock:^{
                
            }];
            
        } else {
            [self showSVProgressHUDErrorWithStatus:[dic objectForKey:@"msg"]];
            [self performSelector:@selector(prefromselect) withObject:nil afterDelay:1];

        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];

        [self performSelector:@selector(prefromselect) withObject:nil afterDelay:1];
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}
- (void)prefromselect{
    
    [self.session startRunning];

}
- (void)showSVProgressHUDSuccessWithStatus:(NSString *)str{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:str];
    [SVProgressHUD dismissWithDelay:1];
}
- (void)showSVProgressHUDErrorWithStatus:(NSString *)str{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:str];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD dismissWithDelay:1.0];
}
//  二维码的横线移动动画
- (void)createTimer {
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                            target:self
                                          selector:@selector(moveUpAndDownLine)
                                          userInfo:nil
                                           repeats:NO];
    
}

#pragma mark - animation

- (void)stopTimer {
    if ([_timer isValid] == YES) {
        [_timer invalidate];
        _timer =nil;
    }
}

- (void)moveUpAndDownLine {
    CGRect origin = self.codeLine.frame;
    CGRect animateFrame = origin;
    animateFrame.origin.y += self.scanView.transparentArea.height;
    
    [UIView animateWithDuration:kScanAnimationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut|
     UIViewAnimationOptionRepeat
                     animations:^{
                         self.codeLine.frame = animateFrame;
                     } completion:^(BOOL finished) {
                         self.codeLine.frame = origin;
                     }];
}


//- (void) readerControllerDidFailToRead: (ZBarReaderController*)reader
//                             withRetry: (BOOL) retry {
//}

- (BOOL) isPhotoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}


- (UIImage *)imageSizeWithScreenImage:(UIImage *)image {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat screenWidth = kScreenW;
    CGFloat screenHeight = kScreenH;
    
    // 如果读取的二维码照片宽和高小于屏幕尺寸，直接返回原图片
    if (imageWidth <= screenWidth && imageHeight <= screenHeight) {
        return image;
    }
    
    CGFloat max = MAX(imageWidth, imageHeight);
    CGFloat scale = max / (screenHeight * 2.0f);
    
    return [self imageWithImage:image scaledToSize:CGSizeMake(imageWidth / scale, imageHeight / scale)];
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - setters && getters



- (void)setTitleText:(NSString *)text {
    [self.titleLabel setText:text];
    [self.titleLabel sizeToFit];
}

//到下一个页
- (void)gotoNextPage:(UIViewController *)vc {
    [self.navigationController pushViewController:vc animated:YES];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 22, 200, 20)];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [_titleLabel setText:self.title];
        
    }
    return _titleLabel;
}

- (UILabel *)scanNumLabel {
    if (_scanNumLabel == nil) {
        _scanNumLabel = [[UILabel alloc] init];
        _scanNumLabel.font = [UIFont systemFontOfSize:15];
        _scanNumLabel.textAlignment = NSTextAlignmentCenter;
//        _scanNumLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _scanNumLabel;
}


#pragma mark - private

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
