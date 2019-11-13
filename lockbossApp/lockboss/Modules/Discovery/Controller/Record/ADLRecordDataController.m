//
//  ADLRecordDataController.m
//  lockboss
//
//  Created by Han on 2019/6/9.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLRecordDataController.h"
#import "ADLKeyboardMonitor.h"
#import "ADLSettleDataView.h"
#import "ADLRecordDataView.h"
#import "ADLSheetView.h"

@interface ADLRecordDataController ()<ADLRecordDataViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ADLRecordDataView *recordView;
@property (nonatomic, assign) NSInteger imageIndex;
@end

@implementation ADLRecordDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(0, 2399);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    ADLRecordDataView *recordView = [[NSBundle mainBundle] loadNibNamed:@"ADLRecordDataView" owner:nil options:nil].lastObject;
    recordView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 2399);
    recordView.delegate = self;
    [scrollView addSubview:recordView];
    self.recordView = recordView;
    
    if (self.type == ADLRecordTypeLook) {
        [self addNavigationView:@"备案详情"];
        [self getProjectRecordData];
    } else if (self.type == ADLRecordTypeModify) {
        [self addNavigationView:@"修改项目备案"];
        [self getProjectRecordData];
    } else if (self.type == ADLRecordTypeReview) {
        [self addNavigationView:@"备案详情"];
        [recordView.submitBtn setTitle:@"修改" forState:UIControlStateNormal];
        [self getProjectRecordData];
    } else {
        [self addNavigationView:@"备案"];
    }
    
    [[ADLKeyboardMonitor monitor] setEnable:YES];
}

#pragma mark ------ 开始编辑 ------
- (void)inputViewDidBeginEditing:(UIView *)inputView {
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat bottomH = [ADLUtils convertRectWithView:inputView];
    __weak typeof(self)weakSelf = self;
    [ADLKeyboardMonitor monitor].keyboardHeightChanged = ^(CGFloat keyboardH) {
        if (keyboardH == 0) {
            if (weakSelf.recordView.updateOffset) {
                CGFloat maxOffset = weakSelf.scrollView.contentSize.height-weakSelf.scrollView.frame.size.height;
                if (offsetY > maxOffset && maxOffset > 0) {
                    [weakSelf.scrollView setContentOffset:CGPointMake(0, maxOffset) animated:YES];
                } else {
                    [weakSelf.scrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
                }
            }
        } else {
            if (bottomH < keyboardH) {
                [UIView animateWithDuration:0.5 animations:^{
                    weakSelf.scrollView.contentOffset = CGPointMake(0, offsetY+keyboardH-bottomH);
                }];
            }
        }
    };
}

#pragma mark ------ 点击图片 ------
- (void)didClikImageViewWithIndex:(NSInteger)index {
    self.imageIndex = index;
    ADLSheetView *sheetView = [ADLSheetView sheetViewWithTitle:nil];
    [sheetView addActionWithTitle:ADLString(@"take_photo") handler:^{
        ADLCameraStatus status = [ADLUtils getCameraStatus];
        if (status == ADLCameraStatusDenied) {
            [ADLAlertView showWithTitle:ADLString(@"cannot_photo") message:ADLString(@"camera_permission") confirmTitle:nil confirmAction:^{
                [[UIApplication sharedApplication] openURL:APP_SETTING_URL];
            } cancleTitle:nil cancleAction:nil showCancle:YES];
        } else if (status == ADLCameraStatusAllow) {
            UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
            pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerVC.delegate = self;
            [self presentViewController:pickerVC animated:YES completion:nil];
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
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    switch (self.imageIndex) {
        case 0:
            self.recordView.licenseImageUrl = nil;
            self.recordView.licenseImage = image;
            self.recordView.licenseImgView.image = image;
            self.recordView.licenseImgBtn.hidden = NO;
            break;
        case 1:
            self.recordView.idImage1Url = nil;
            self.recordView.idImage1 = image;
            self.recordView.idImgView1.image = image;
            self.recordView.idImgBtn1.hidden = NO;
            self.recordView.idImgView2.hidden = NO;
            break;
        case 2:
            self.recordView.idImage2Url = nil;
            self.recordView.idImage2 = image;
            self.recordView.idImgView2.image = image;
            self.recordView.idImgBtn2.hidden = NO;
            break;
        case 3:
            self.recordView.bankImageUrl = nil;
            self.recordView.bankImage = image;
            self.recordView.bankImgView.image = image;
            self.recordView.bankImgBtn.hidden = NO;
            break;
    }
}

#pragma mark ------ 提交 ------
- (void)didClickSubmitBtn:(NSMutableDictionary *)params {
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    if (self.projectId != nil) {
        [params setValue:self.projectId forKey:@"id"];
    }
    
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    if (self.recordView.licenseImage != nil) {
        NSDictionary *dict1 = @{@"type":@"licenseImgUrl",@"image":self.recordView.licenseImage};
        [imageArr addObject:dict1];
    }
    if (self.recordView.idImage1 != nil) {
        NSDictionary *dict2 = @{@"type":@"documentBefore",@"image":self.recordView.idImage1};
        [imageArr addObject:dict2];
    }
    if (self.recordView.idImage2 != nil) {
        NSDictionary *dict3 = @{@"type":@"documentBack",@"image":self.recordView.idImage2};
        [imageArr addObject:dict3];
    }
    if (self.recordView.bankImage != nil) {
        NSDictionary *dict4 = @{@"type":@"bankLicence",@"image":self.recordView.bankImage};
        [imageArr addObject:dict4];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        for (int i = 0; i < imageArr.count; i++) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ADLToast showLoadingMessage:[NSString stringWithFormat:@"图片上传中(%d/%lu)",i+1,imageArr.count]];
            });
            NSDictionary *dict = imageArr[i];
            NSData *data = [ADLUtils compressImageQuality:dict[@"image"] maxLength:IMAGE_MAX_LENGTH];
            [ADLNetWorkManager postImagePath:k_upload_image parameters:nil imageDataArr:@[data] imageName:@"img" autoToast:YES progress:nil success:^(NSDictionary *responseDict) {
                if ([responseDict[@"code"] integerValue] == 10000) {
                    dispatch_semaphore_signal(sema);
                    NSArray *imgArr = responseDict[@"data"];
                    [params setValue:imgArr.firstObject[@"imgUrl"] forKey:dict[@"type"]];
                } else {
                    return;
                }
                
            } failure:^(NSError *error) {
                return;
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        [self addProjectRecordWithDcit:params];
    });
}

#pragma mark ------ 添加/修改项目备案 ------
- (void)addProjectRecordWithDcit:(NSDictionary *)params {
    NSString *path = k_record_project;
    NSString *toast = @"添加成功";
    if (self.type == ADLRecordTypeModify) {
        path = k_submit_project_record;
        toast = @"修改成功";
    }
    if (self.type == ADLRecordTypeReview) {
        path = k_modify_project_record;
        toast = @"修改成功";
    }
    
    [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ADLToast showMessage:toast];
                if (self.modifySuccess) {
                    self.modifySuccess();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            });
        }
    } failure:nil];
}

#pragma mark ------ 获取项目备案信息 ------
- (void)getProjectRecordData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.projectId forKey:@"id"];
    [ADLNetWorkManager postWithPath:k_query_project_record parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.recordView updateInputWithDictionary:responseDict[@"data"]];
            if (self.type == ADLRecordTypeLook) {
                [self.recordView setInputViewUneditable];
            }
        }
    } failure:nil];
}

#pragma mark ------ 移除键盘监听 ------
- (void)dealloc {
    [[ADLKeyboardMonitor monitor] setEnable:NO];
}

@end
