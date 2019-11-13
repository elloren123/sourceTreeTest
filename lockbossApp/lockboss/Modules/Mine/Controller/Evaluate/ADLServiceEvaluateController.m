//
//  ADLServiceEvaluateController.m
//  lockboss
//
//  Created by adel on 2019/6/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLServiceEvaluateController.h"
#import "ADLAlbumListController.h"

#import "ADLEvaluateStarView.h"
#import "ADLLocalImgPreView.h"
#import "ADLDeleteImageCell.h"
#import "ADLSheetView.h"
#import "ADLTextView.h"

#import <Photos/Photos.h>

@interface ADLServiceEvaluateController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ADLDeleteImageCellDelegate,ADLTextViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ADLEvaluateStarView *starView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) CGFloat cellW;
@end

@implementation ADLServiceEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"服务评价"];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    scrollView.backgroundColor = COLOR_F2F2F2;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 162)];
    topView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:topView];
    
    UILabel *otherLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 300, 45)];
    otherLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    otherLab.textColor = COLOR_333333;
    otherLab.text = @"服务评价";
    [topView addSubview:otherLab];
    
    UILabel *promptLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-112, 0, 100, 45)];
    promptLab.font = [UIFont systemFontOfSize:13];
    promptLab.textAlignment = NSTextAlignmentRight;
    promptLab.textColor = COLOR_999999;
    promptLab.text = @"满意请给5星哦";
    [topView addSubview:promptLab];
    
    UIView *spLine = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 0.5)];
    spLine.backgroundColor = SEPARATOR_COLOR;
    [topView addSubview:spLine];
    
    ADLEvaluateStarView *starView = [[NSBundle mainBundle] loadNibNamed:@"ADLEvaluateStarView" owner:nil options:nil].lastObject;
    starView.frame = CGRectMake(0, 56, SCREEN_WIDTH, 106);
    starView.firstLab.text = @"服务效率";
    starView.secondLab.text = @"服务态度";
    starView.thirdLab.text = @"服务专业度";
    [topView addSubview:starView];
    self.starView = starView;
    
    CGFloat gap = 3;
    CGFloat cellW = (SCREEN_WIDTH-24-gap*3)/4;
    if (SCREEN_WIDTH > 500) {
        gap = 15;
        cellW = (SCREEN_WIDTH-24-gap*5)/6;
    }
    self.cellW = cellW;
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 170, SCREEN_WIDTH, 169+cellW)];
    centerView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:centerView];
    self.centerView = centerView;
    
    ADLTextView *textView = [ADLTextView textViewWithFrame:CGRectMake(12, 12, SCREEN_WIDTH-24, 136) limitLength:200];
    textView.placeholder = @"说说您对师傅的服务是否满意吧~";
    textView.bgColor = COLOR_F2F2F2;
    textView.delegate = self;
    [centerView addSubview:textView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(cellW, cellW);
    layout.minimumInteritemSpacing = gap-1;
    layout.minimumLineSpacing = gap+1;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(12, 155, SCREEN_WIDTH-24, cellW) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    [centerView addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView registerClass:[ADLDeleteImageCell class] forCellWithReuseIdentifier:@"ADLDeleteImageCell"];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.frame = CGRectMake(12, 389+cellW, SCREEN_WIDTH-24, VIEW_HEIGHT);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [submitBtn setTitle:@"发表评价" forState:UIControlStateNormal];
    submitBtn.backgroundColor = APP_COLOR;
    submitBtn.layer.cornerRadius = CORNER_RADIUS;
    [submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:submitBtn];
    self.submitBtn = submitBtn;
    scrollView.contentSize = CGSizeMake(0, 489+cellW);
}

#pragma mark ------ 输入内容改变 ------
- (void)textViewDidChangeText:(NSString *)text {
    self.content = text;
}

#pragma mark ------ UICollectionView Delegate && DataSuorce ------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataArr.count < 9) {
        return self.dataArr.count+1;
    } else {
        return 9;
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
                        albumVC.maxCount = 9;
                        albumVC.currentCount = self.dataArr.count;
                        albumVC.finish = ^(NSArray *imageArr) {
                            if (imageArr.count > 0) {
                                [self.dataArr addObjectsFromArray:imageArr];
                                [self reloadCollectionView];
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
    [self reloadCollectionView];
}

#pragma mark ------ 删除图片 ------
- (void)didClickDeleteBtn:(UIButton *)sender {
    ADLDeleteImageCell *cell = (ADLDeleteImageCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.dataArr removeObjectAtIndex:indexPath.item];
    [self reloadCollectionView];
}

#pragma mark ------ 刷新图片 ------
- (void)reloadCollectionView {
    CGRect centerViewFrame = self.centerView.frame;
    CGRect collectionFrame = self.collectionView.frame;
    CGRect submitBtnFrame = self.submitBtn.frame;
    if (SCREEN_WIDTH < 500) {
        if (self.dataArr.count < 4) {
            centerViewFrame.size.height = self.cellW+169;
            collectionFrame.size.height = self.cellW;
            submitBtnFrame.origin.y = self.cellW+389;
            self.scrollView.contentSize = CGSizeMake(0, self.cellW+489);
        } else if (self.dataArr.count < 8) {
            centerViewFrame.size.height = self.cellW*2+173;
            collectionFrame.size.height = self.cellW*2+4;
            submitBtnFrame.origin.y = self.cellW*2+393;
            self.scrollView.contentSize = CGSizeMake(0, self.cellW*2+493);
        } else {
            centerViewFrame.size.height = self.cellW*3+177;
            collectionFrame.size.height = self.cellW*3+8;
            submitBtnFrame.origin.y = self.cellW*3+397;
            self.scrollView.contentSize = CGSizeMake(0, self.cellW*3+497);
        }
    } else {
        if (self.dataArr.count < 6) {
            centerViewFrame.size.height = self.cellW+169;
            collectionFrame.size.height = self.cellW;
            submitBtnFrame.origin.y = self.cellW+389;
            self.scrollView.contentSize = CGSizeMake(0, self.cellW+489);
        } else {
            centerViewFrame.size.height = self.cellW*2+185;
            collectionFrame.size.height = self.cellW*2+16;
            submitBtnFrame.origin.y = self.cellW*2+405;
            self.scrollView.contentSize = CGSizeMake(0, self.cellW*2+505);
        }
    }
    self.collectionView.frame = collectionFrame;
    self.centerView.frame = centerViewFrame;
    self.submitBtn.frame = submitBtnFrame;
    [self.collectionView reloadData];
}

#pragma mark ------ 提交 ------
- (void)clickSubmitBtn {
    if (self.starView.firstStar == 0) {
        [ADLToast showMessage:@"请选择对服务效率的星评"];
        return;
    }
    if (self.starView.secondStar == 0) {
        [ADLToast showMessage:@"请选择对服务态度的星评"];
        return;
    }
    if (self.starView.thirdStar == 0) {
        [ADLToast showMessage:@"请选择对服务专业度的星评"];
        return;
    }
    if (self.content.length == 0) {
        [ADLToast showMessage:@"请输入评价内容"];
        return;
    }
    if ([ADLUtils hasEmoji:self.content]) {
        [ADLToast showMessage:@"请不要输入表情和特殊符号"];
        return;
    }
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.orderId forKey:@"serviceOrderId"];
    [params setValue:self.content forKey:@"desc"];
    [params setValue:self.personId forKey:@"serviceUserId"];
    [params setValue:@(self.starView.firstStar) forKey:@"serviceEfficiency"];
    [params setValue:@(self.starView.secondStar) forKey:@"serviceAttitude"];
    [params setValue:@(self.starView.thirdStar) forKey:@"serviceMajor"];
    
    NSInteger imgCount = self.dataArr.count;
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
                        [ADLToast showLoadingMessage:[NSString stringWithFormat:@"图片上传中(%.0f/%ld)",totalProgress,imgCount]];
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
                    [ADLToast showMessage:@"图片上传失败！"];
                } else {
                    [params setValue:[imgStrArr componentsJoinedByString:@","] forKey:@"imgUrl"];
                    [self submitServiceEvaluateWithDictionary:params];
                }
            });
        });
    } else {
        [self submitServiceEvaluateWithDictionary:params];
    }
}

#pragma mark ------ 提交请求 ------
- (void)submitServiceEvaluateWithDictionary:(NSDictionary *)params {
    [ADLNetWorkManager postWithPath:k_service_add_evaluate parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"评价成功"];
            if (self.evaluateFinish) {
                self.evaluateFinish();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:nil];
}

@end
