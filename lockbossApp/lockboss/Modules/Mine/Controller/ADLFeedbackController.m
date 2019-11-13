//
//  ADLFeedbackController.m
//  lockboss
//
//  Created by adel on 2019/7/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLFeedbackController.h"
#import "ADLAlbumListController.h"
#import "ADLLocalImgPreView.h"
#import "ADLDeleteImageCell.h"
#import "ADLSheetView.h"
#import "ADLTextView.h"

#import <Photos/Photos.h>

@interface ADLFeedbackController ()<ADLTextViewDelegate,ADLDeleteImageCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) NSString *content;
@end

@implementation ADLFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.hotelId) {
        [self addNavigationView:ADLString(@"feedback_hotel")];
    } else {
        [self addNavigationView:ADLString(@"feedback")];
    }
    
    CGFloat gap = 3;
    CGFloat cellW = (SCREEN_WIDTH-24-gap*3)/4;
    if (SCREEN_WIDTH > 500) {
        gap = 15;
        cellW = (SCREEN_WIDTH-24-gap*5)/6;
    }
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, cellW+266)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    UILabel *suggLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 16, SCREEN_WIDTH-24, 20)];
    suggLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    suggLab.textColor = COLOR_333333;
    suggLab.text = ADLString(@"feedback_problems");
    [whiteView addSubview:suggLab];
    
    ADLTextView *textView = [ADLTextView textViewWithFrame:CGRectMake(12, 50, SCREEN_WIDTH-24, 160) limitLength:200];
    textView.bgColor = COLOR_F2F2F2;
    textView.placeholder = ADLString(@"feedback_placeholder");
    textView.delegate = self;
    [whiteView addSubview:textView];
    
    UILabel *picLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 224, SCREEN_WIDTH-24, 20)];
    picLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    picLab.textColor = COLOR_333333;
    picLab.text = ADLString(@"feedback_image");
    [whiteView addSubview:picLab];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(cellW, cellW);
    layout.minimumInteritemSpacing = gap-1;
    layout.minimumLineSpacing = gap+1;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(12, 254, SCREEN_WIDTH-24, cellW) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    [whiteView addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView registerClass:[ADLDeleteImageCell class] forCellWithReuseIdentifier:@"ADLDeleteImageCell"];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.frame = CGRectMake(12, cellW+NAVIGATION_H+310, SCREEN_WIDTH-24, VIEW_HEIGHT);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [submitBtn setTitle:ADLString(@"submit") forState:UIControlStateNormal];
    submitBtn.backgroundColor = APP_COLOR;
    submitBtn.layer.cornerRadius = CORNER_RADIUS;
    [submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    self.submitBtn = submitBtn;
}

#pragma mark ------ UICollectionView ------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataArr.count < 4) {
        return self.dataArr.count+1;
    } else {
        return 4;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADLDeleteImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ADLDeleteImageCell" forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.item < self.dataArr.count) {
        cell.deleteBtn.hidden = NO;
        cell.imgView.image = self.dataArr[indexPath.item];
    } else {
        cell.deleteBtn.hidden = YES;
        cell.imgView.image = [UIImage imageNamed:@"img_add"];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.item == self.dataArr.count) {
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
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusAuthorized) {
                        ADLAlbumListController *albumVC = [[ADLAlbumListController alloc] init];
                        albumVC.maxCount = 4;
                        albumVC.currentCount = self.dataArr.count;
                        albumVC.finish = ^(NSArray *imageArr) {
                            if (imageArr.count > 0) {
                                [self.dataArr addObjectsFromArray:imageArr];
                                [self.collectionView reloadData];
                            }
                        };
                        [self customPushViewController:albumVC];
                    } else {
                        [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:ADLString(@"photo_permission") confirmTitle:nil confirmAction:^{
                            [[UIApplication sharedApplication] openURL:APP_SETTING_URL];
                        } cancleTitle:nil cancleAction:nil showCancle:YES];
                    }
                });
            }];
        }];
        [sheetView show];
    } else {
        NSMutableArray *imgViewArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.dataArr.count; i++) {
            ADLDeleteImageCell *cell = (ADLDeleteImageCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            [imgViewArr addObject:cell.imgView];
        }
        [ADLLocalImgPreView showWithImageViews:imgViewArr currentIndex:indexPath.item];
    }
}

#pragma mark ------ UIImagePickerControllerDelegate ------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.dataArr addObject:image];
    [self.collectionView reloadData];
}

#pragma mark ------ 删除图片 ------
- (void)didClickDeleteBtn:(UIButton *)sender {
    ADLDeleteImageCell *cell = (ADLDeleteImageCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.dataArr removeObjectAtIndex:indexPath.item];
    [self.collectionView reloadData];
}

#pragma mark ------ 输入改变 ------
- (void)textViewDidChangeText:(NSString *)text {
    self.content = text;
}

#pragma mark ------ 提交 ------
- (void)clickSubmitBtn {
    if (self.content.length == 0) {
        [ADLToast showMessage:ADLString(@"feedback_placeholder")];
        return;
    }
    if ([ADLUtils hasEmoji:self.content]) {
        [ADLToast showMessage:ADLString(@"emoji_input")];
        return;
    }
    
    NSInteger imgCount = self.dataArr.count;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    if (self.hotelId) {
        [params setValue:self.hotelId forKey:@"checkingInId"];
        [params setValue:self.content forKey:@"content"];
        
        if (imgCount > 0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *imgDataArr = [[NSMutableArray alloc] init];
                for (int i = 0; i < imgCount; i++) {
                    NSData *data = [ADLUtils compressImageQuality:self.dataArr[i] maxLength:IMAGE_MAX_LENGTH];
                    [imgDataArr addObject:data];
                }
                
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [param setValue:[ADLUserModel sharedModel].token forKey:@"token"];
                [param setValue:[ADLUtils handleParamsSign:param] forKey:@"sign"];
                
                [ADLNetWorkManager postImagePath:ADEL_batchUploadImage parameters:param imageDataArr:imgDataArr imageName:@"files" autoToast:YES progress:^(NSProgress *progress) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        int pro = (int)(progress.fractionCompleted*100);
                        if (pro == 100) pro = 99;
                        [ADLToast showLoadingMessage:[NSString stringWithFormat:@"%@(%d%%)",ADLString(@"image_upload"),pro]];
                    });
                } success:^(NSDictionary *responseDict) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [params setValue:responseDict[@"data"][@"url"] forKey:@"imageUrls"];
                        [self hotelFeedbackWithDict:params];
                    });
                } failure:nil];
            });
        } else {
            [self hotelFeedbackWithDict:params];
        }
    } else {
        [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
        [params setValue:self.content forKey:@"feedbackContent"];
        
        if (imgCount > 0) {
            NSMutableArray *imgStrArr = [[NSMutableArray alloc] init];
            NSMutableArray *proArr = [[NSMutableArray alloc] init];
            for (int i = 0; i < imgCount; i++) {
                [imgStrArr addObject:@"picture"];
                [proArr addObject:@(0.0)];
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_group_t group = dispatch_group_create();
                for (int i = 0; i < imgCount; i++) {
                    dispatch_group_enter(group);
                    NSData *data = [ADLUtils compressImageQuality:self.dataArr[i] maxLength:IMAGE_MAX_LENGTH];
                    [ADLNetWorkManager postImagePath:k_upload_image parameters:nil imageDataArr:@[data] imageName:@"img" autoToast:NO progress:^(NSProgress *progress) {
                        [proArr replaceObjectAtIndex:i withObject:@(progress.fractionCompleted)];
                        double totalProgress = 0;
                        for (NSNumber *number in proArr) {
                            totalProgress = totalProgress+[number doubleValue];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [ADLToast showLoadingMessage:[NSString stringWithFormat:@"%@(%.0f/%ld)",ADLString(@"image_upload"),totalProgress,imgCount]];
                        });
                    } success:^(NSDictionary *responseDict) {
                        if ([responseDict[@"code"] integerValue] == 10000) {
                            [imgStrArr replaceObjectAtIndex:i withObject:[[responseDict[@"data"] firstObject][@"imgUrl"] stringValue]];
                        }
                        dispatch_group_leave(group);
                    } failure:^(NSError *error) {
                        dispatch_group_leave(group);
                    }];
                }
                dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                    if ([imgStrArr containsObject:@"picture"]) {
                        [ADLToast showMessage:ADLString(@"image_failed")];
                    } else {
                        [params setValue:[imgStrArr componentsJoinedByString:@","] forKey:@"img"];
                        [self submitFeedbackWithDict:params];
                    }
                });
            });
        } else {
            [self submitFeedbackWithDict:params];
        }
    }
}

#pragma mark ------ 提交反馈 ------
- (void)submitFeedbackWithDict:(NSDictionary *)params {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_user_feedback parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:ADLString(@"submit_success")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:nil];
}

#pragma mark ------ 酒店反馈 ------
- (void)hotelFeedbackWithDict:(NSMutableDictionary *)params {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_feedbackMessage parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:ADLString(@"submit_success")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:nil];
}

@end
