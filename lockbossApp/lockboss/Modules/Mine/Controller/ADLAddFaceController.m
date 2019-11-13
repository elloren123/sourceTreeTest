//
//  ADLAddFaceController.m
//  lockboss
//
//  Created by Adel on 2019/9/23.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLAddFaceController.h"
#import <AVFoundation/AVFoundation.h>
#import "ADLKeyboardMonitor.h"

@interface ADLAddFaceController ()<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,UITextFieldDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *faceView;
@property (nonatomic, strong) UITextField *remarkTF;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *anewBtn;
@property (nonatomic, assign) NSInteger times;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL face;
@end

@implementation ADLAddFaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.face = NO;
    [self addNavigationView:@"添加人脸"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.hidden = YES;
    
    AVCaptureDevice *frontDevice;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionFront) {
            frontDevice = device;
            break;
        }
    }
    
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:frontDevice error:nil];
    
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    AVCaptureMetadataOutput *metaOutput = [[AVCaptureMetadataOutput alloc] init];
    [metaOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.session = [[AVCaptureSession alloc] init];
    
    [self.session beginConfiguration];
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    if ([self.session canAddOutput:metaOutput]) {
        [self.session addOutput:metaOutput];
    }
    [self.session commitConfiguration];
    
    [metaOutput setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
    metaOutput.rectOfInterest = CGRectMake((NAVIGATION_H+70)/SCREEN_HEIGHT, 50/SCREEN_WIDTH, (SCREEN_WIDTH-100)/SCREEN_HEIGHT, (SCREEN_WIDTH-100)/SCREEN_WIDTH);
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.frame = CGRectMake(20, NAVIGATION_H+40, SCREEN_WIDTH-40, SCREEN_WIDTH-40);
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.cornerRadius = (SCREEN_WIDTH-40)/2;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //前置摄像头要设置一下 要不然画面是镜像
    for (AVCaptureVideoDataOutput *doutput in self.session.outputs) {
        for (AVCaptureConnection *connection in doutput.connections) {
            if (connection.supportsVideoMirroring) {
                connection.videoOrientation = AVCaptureVideoOrientationPortrait;
                connection.videoMirrored = YES;
            }
        }
    }
    [self.session startRunning];
    
    UIImageView *faceView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, SCREEN_WIDTH-40, SCREEN_WIDTH-40)];
    faceView.layer.cornerRadius = (SCREEN_WIDTH-40)/2;
    faceView.clipsToBounds = YES;
    [scrollView addSubview:faceView];
    self.faceView = faceView;
    
    UIButton *anewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    anewBtn.frame = CGRectMake(30, SCREEN_WIDTH+50, SCREEN_WIDTH-60, 44);
    [anewBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    anewBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [anewBtn setTitle:@"重新识别" forState:UIControlStateNormal];
    anewBtn.backgroundColor = COLOR_F2F2F2;
    anewBtn.layer.cornerRadius = CORNER_RADIUS;
    [anewBtn addTarget:self action:@selector(clickAnewBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:anewBtn];
    self.anewBtn = anewBtn;
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.frame = CGRectMake(30, SCREEN_WIDTH+110, SCREEN_WIDTH-60, 44);
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [confirmBtn setTitle:ADLString(@"confirm") forState:UIControlStateNormal];
    confirmBtn.backgroundColor = APP_COLOR;
    confirmBtn.layer.cornerRadius = CORNER_RADIUS;
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:confirmBtn];
    self.confirmBtn = confirmBtn;
    
    UITextField *remarkTF = [[UITextField alloc] initWithFrame:CGRectMake(30, SCREEN_HEIGHT-BOTTOM_H-NAVIGATION_H-162, SCREEN_WIDTH-60, 44)];
    remarkTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    remarkTF.borderStyle = UITextBorderStyleRoundedRect;
    remarkTF.font = [UIFont systemFontOfSize:FONT_SIZE];
    remarkTF.returnKeyType = UIReturnKeyDone;
    remarkTF.textColor = COLOR_333333;
    remarkTF.placeholder = @"设置备注名";
    remarkTF.delegate = self;
    [scrollView addSubview:remarkTF];
    self.remarkTF = remarkTF;
    remarkTF.hidden = YES;
    
    __weak typeof(self)weakSelf = self;
    [[ADLKeyboardMonitor monitor] setEnable:YES];
    CGFloat bottomH = [ADLUtils convertRectWithView:remarkTF];
    [ADLKeyboardMonitor monitor].keyboardHeightChanged = ^(CGFloat keyboardH) {
        if (keyboardH == 0) {
            [weakSelf.scrollView setContentOffset:CGPointZero animated:YES];
        } else {
            if (bottomH < keyboardH) {
                [weakSelf.scrollView setContentOffset:CGPointMake(0, keyboardH-bottomH) animated:YES];
            }
        }
    };
}

#pragma mark ------ 取消键盘监听 ------
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[ADLKeyboardMonitor monitor] setEnable:NO];
    [self.timer invalidate];
}

#pragma mark ------ AVCaptureVideoDataOutputSampleBufferDelegate ------
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (self.face == YES) {
        self.face = NO;
        UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
        if ([self hasFace:image]) {
            [self.session stopRunning];
            self.scrollView.hidden = NO;
            self.faceView.image = image;
        }
    }
}

#pragma mark ------ AVCaptureMetadataOutputObjectsDelegate ------
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (![self.timer isValid]) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(detectorFaceCount) userInfo:nil repeats:NO];
    }
    self.times++;
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [ADLUtils limitedTextField:textField replacementString:string maxLength:18];
}

#pragma mark ------ 延时获取检测到人脸次数 ------
- (void)detectorFaceCount {
    [self.timer invalidate];
    if (self.times > 10) {
        self.face = YES;
    }
    self.times = 0;
}

#pragma mark ------ 获取图片 ------
- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGFloat imgpW = CVPixelBufferGetWidth(imageBuffer);
    CGFloat imgpH = CVPixelBufferGetHeight(imageBuffer);
    CGImageRef sessionImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, (imgpH-imgpW)/2, imgpW, imgpW)];
    UIImage *image = [[UIImage alloc] initWithCGImage:sessionImage];
    CGImageRelease(sessionImage);
    return image;
}

#pragma mark ------ 检测是否有人脸 ------
- (BOOL)hasFace:(UIImage *)faceImg {
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    CIImage *ciImage = [CIImage imageWithCGImage:faceImg.CGImage];
    NSArray *features = [faceDetector featuresInImage:ciImage];
    CIFaceFeature *faceFeature = [features firstObject];
    if (faceFeature) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark ------ 重新识别 ------
- (void)clickAnewBtn {
    [self.session startRunning];
    self.scrollView.hidden = YES;
}

#pragma mark ------ 确定 ------
- (void)clickConfirmBtn {
    if ([self.confirmBtn.titleLabel.text isEqualToString:ADLString(@"confirm")]) {
        self.anewBtn.hidden = YES;
        self.remarkTF.hidden = NO;
        self.confirmBtn.frame = CGRectMake(30, SCREEN_HEIGHT-BOTTOM_H-NAVIGATION_H-68, SCREEN_WIDTH-60, 44);
        [self.confirmBtn setTitle:ADLString(@"submit") forState:UIControlStateNormal];
    } else {
        if (self.remarkTF.text.length == 0) {
            [ADLToast showMessage:@"请输入备注名"];
            return;
        }
        
        if ([ADLUtils hasEmoji:self.remarkTF.text]) {
            [ADLToast showMessage:@"暂时不支持输入表情和特殊符号"];
            return;
        }
        
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[ADLUserModel sharedModel].token forKey:@"token"];
        [params setValue:self.remarkTF.text forKey:@"name"];
        [params setValue:@(-1) forKey:@"endDatetime"];
        [params setValue:@(1) forKey:@"dataType"];
        [params setValue:@(2) forKey:@"type"];
        [params setValue:[ADLUtils timestampWithDate:nil format:nil] forKey:@"startDatetime"];
        [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
        NSData *imageData = [ADLUtils compressImageQuality:self.faceView.image maxLength:IMAGE_MAX_LENGTH];
        [ADLNetWorkManager postImagePath:ADEL_L3_face_add parameters:params imageDataArr:@[imageData] imageName:@"faceFile" autoToast:YES progress:nil success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:@"人脸添加成功"];
                if (self.success) {
                    self.success();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:nil];
    }
}

@end
