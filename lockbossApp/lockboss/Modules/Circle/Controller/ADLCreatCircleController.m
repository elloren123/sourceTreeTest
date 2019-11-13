//
//  ADLCreatCircleController.m
//  lockboss
//
//  Created by Han on 2019/6/2.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLCreatCircleController.h"
#import "ADLEditImageController.h"

#import "ADLLocalImgPreView.h"
#import "ADLSheetView.h"

@interface ADLCreatCircleController ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *updateLab;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic, strong) UIImage *image;
@end

@implementation ADLCreatCircleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"创建群组"];
    self.top.constant = NAVIGATION_H+16;
    self.view.backgroundColor = [UIColor whiteColor];
    self.submitBtn.layer.cornerRadius = CORNER_RADIUS;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImgView)];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressImgView:)];
    [self.imgView addGestureRecognizer:tap];
    [self.imgView addGestureRecognizer:longPress];
}

#pragma mark ------ 点击图片 ------
- (void)clickImgView {
    if ([self.nameTF isFirstResponder]) {
        [self.nameTF resignFirstResponder];
    }
    
    ADLSheetView *sheetView = [ADLSheetView sheetViewWithTitle:nil];
    [sheetView addActionWithTitle:ADLString(@"take_photo") handler:^{
        ADLCameraStatus status = [ADLUtils getCameraStatus];
        if (status == ADLCameraStatusDenied) {
            [ADLAlertView showWithTitle:ADLString(@"cannot_photo") message:ADLString(@"camera_permission") confirmTitle:nil confirmAction:^{
                [[UIApplication sharedApplication] openURL:APP_SETTING_URL];
            } cancleTitle:nil cancleAction:nil showCancle:YES];
        } else if (status == ADLCameraStatusAllow) {
            UIImagePickerController *pickerVc = [[UIImagePickerController alloc] init];
            pickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerVc.delegate = self;
            [self presentViewController:pickerVc animated:YES completion:nil];
        } else {
            [ADLAlertView showWithTitle:ADLString(@"cannot_photo") message:ADLString(@"photo_camera") confirmTitle:nil confirmAction:nil cancleTitle:nil cancleAction:nil showCancle:NO];
        }
    }];
    [sheetView addActionWithTitle:ADLString(@"select_photo") handler:^{
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerVC.navigationBar.tintColor = [UIColor blackColor];
        pickerVC.delegate = self;
        [self presentViewController:pickerVC animated:YES completion:nil];
    }];
    [sheetView show];
}

#pragma mark ------ UIImagePickerControllerDelegate ------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    ADLEditImageController *editVC = [[ADLEditImageController alloc] init];
    editVC.image = image;
    editVC.finishBlock = ^(UIImage *image) {
        self.image = image;
        self.imgView.image = image;
        self.updateLab.hidden = YES;
    };
    [picker pushViewController:editVC animated:NO];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIView *view = viewController.view;
    for (int i = 0; i < view.subviews.count; i++) {
        if ([[view.subviews[i] description] containsString:@"PLCropOverlay"]) {
            UIView *plView = view.subviews[i];
            [plView setValue:@"编辑"forKey:@"_defaultOKButtonTitle"];
        }
    }
}

#pragma mark ------ 长按图片 ------
- (void)longPressImgView:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([self.nameTF isFirstResponder]) {
            [self.nameTF resignFirstResponder];
        }
        if (self.updateLab.hidden) {
            [ADLLocalImgPreView showWithImageViews:@[self.imgView] currentIndex:0];
        }
    }
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ------ 提交 ------
- (IBAction)clickSubmitBtn:(UIButton *)sender {
    if ([self.nameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        [ADLToast showMessage:@"请填写群组名称"];
        return;
    }
    
    if ([ADLUtils hasEmoji:self.nameTF.text]) {
        [ADLToast showMessage:@"请不要输入表情和特殊符号"];
        return;
    }
    
    if (self.image == nil) {
        [ADLToast showMessage:@"请选择群组头像"];
        return;
    }
    
    if ([self.nameTF isFirstResponder]) {
        [self.nameTF resignFirstResponder];
    }
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.nameTF.text forKey:@"name"];
    NSData *data = [ADLUtils compressImageQuality:self.image maxLength:IMAGE_MAX_LENGTH];
    
    [ADLNetWorkManager postImagePath:k_circle_create parameters:params imageDataArr:@[data] imageName:@"icon" autoToast:YES progress:^(NSProgress *progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            double pro = progress.fractionCompleted*100;
            if (pro == 100) {
                pro = 99;
            }
            [ADLToast showLoadingMessage:[NSString stringWithFormat:@"图片上传中(%d%%)",(int)pro]];
        });
    } success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"创建成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_CIRCLE_DATA object:nil userInfo:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:nil];
}

@end
