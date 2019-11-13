//
//  ADLServiceNoteController.m
//  lockboss
//
//  Created by adel on 2019/6/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLServiceNoteController.h"
#import "ADLAlbumListController.h"

#import "ADLDeleteImageCell.h"
#import "ADLLocalImgPreView.h"
#import "ADLServiceModel.h"
#import "ADLSheetView.h"
#import "ADLTextView.h"

#import <Photos/Photos.h>

@interface ADLServiceNoteController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ADLDeleteImageCellDelegate,ADLTextViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) NSString *noteStr;
@property (nonatomic, assign) CGFloat cellW;

@end

@implementation ADLServiceNoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"服务备注"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-12, 44)];
    titLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    titLab.textColor = COLOR_333333;
    titLab.text = @"描述您的需求和问题：";
    [scrollView addSubview:titLab];
    
    ADLTextView *textView = [ADLTextView textViewWithFrame:CGRectMake(12, 44, SCREEN_WIDTH-24, 130) limitLength:200];
    textView.bgColor = SEPARATOR_COLOR;
    textView.placeholder = @"请输入备注";
    textView.text = self.model.serviceNote;
    textView.delegate = self;
    [scrollView addSubview:textView];
    
    if (self.model.noteImageArr.count > 0) {
        [self.dataArr addObjectsFromArray:self.model.noteImageArr];
    }
    
    CGFloat gap = 3;
    CGFloat cellW = (SCREEN_WIDTH-24-gap*3)/4;
    if (SCREEN_WIDTH > 500) {
        gap = 15;
        cellW = (SCREEN_WIDTH-24-gap*5)/6;
    }
    self.cellW = cellW;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(cellW, cellW);
    layout.minimumInteritemSpacing = gap-1;
    layout.minimumLineSpacing = gap+1;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(12, 184, SCREEN_WIDTH-24, cellW) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    [scrollView addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView registerClass:[ADLDeleteImageCell class] forCellWithReuseIdentifier:@"ADLDeleteImageCell"];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    if (SCREEN_WIDTH > 500) {
        submitBtn.frame = CGRectMake(12, 334+cellW, SCREEN_WIDTH-24, VIEW_HEIGHT);
    } else {
        submitBtn.frame = CGRectMake(12, 234+cellW, SCREEN_WIDTH-24, VIEW_HEIGHT);
    }
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    submitBtn.backgroundColor = APP_COLOR;
    submitBtn.layer.cornerRadius = CORNER_RADIUS;
    [submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:submitBtn];
    self.submitBtn = submitBtn;
    
    [self reloadCollectionView];
}

#pragma mark ------ 输入内容改变 ------
- (void)textViewDidChangeText:(NSString *)text {
    self.noteStr = text;
}

#pragma mark ------ UICollectionView ------
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
    CGRect collectionFrame = self.collectionView.frame;
    CGRect submitBtnFrame = self.submitBtn.frame;
    if (SCREEN_WIDTH < 500) {
        if (self.dataArr.count < 4) {
            collectionFrame.size.height = self.cellW;
            submitBtnFrame.origin.y = self.cellW+234;
            self.scrollView.contentSize = CGSizeMake(0, self.cellW+334);
        } else if (self.dataArr.count < 8) {
            collectionFrame.size.height = self.cellW*2+4;
            submitBtnFrame.origin.y = self.cellW*2+238;
            self.scrollView.contentSize = CGSizeMake(0, self.cellW*2+344);
        } else {
            collectionFrame.size.height = self.cellW*3+8;
            submitBtnFrame.origin.y = self.cellW*3+242;
            self.scrollView.contentSize = CGSizeMake(0, self.cellW*3+364);
        }
    } else {
        if (self.dataArr.count < 6) {
            collectionFrame.size.height = self.cellW;
            submitBtnFrame.origin.y = self.cellW+334;
            self.scrollView.contentSize = CGSizeMake(0, self.cellW+434);
        } else {
            collectionFrame.size.height = self.cellW*2+11;
            submitBtnFrame.origin.y = self.cellW*2+344;
            self.scrollView.contentSize = CGSizeMake(0, self.cellW*2+444);
        }
    }
    self.collectionView.frame = collectionFrame;
    self.submitBtn.frame = submitBtnFrame;
    [self.collectionView reloadData];
}

#pragma mark ------ 提交 ------
- (void)clickSubmitBtn {
    if ([ADLUtils hasEmoji:self.noteStr]) {
        [ADLToast showMessage:@"请不要输入表情和特殊符号"];
    } else {
        [self.view endEditing:YES];
        if (self.clickConfirm) {
            self.model.serviceNote = self.noteStr;
            [self.model.noteImageArr removeAllObjects];
            [self.model.noteImageArr addObjectsFromArray:self.dataArr];
            self.clickConfirm(self.model);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
