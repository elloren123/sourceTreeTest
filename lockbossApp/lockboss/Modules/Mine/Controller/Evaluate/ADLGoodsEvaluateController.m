//
//  ADLGoodsEvaluateController.m
//  lockboss
//
//  Created by adel on 2019/6/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsEvaluateController.h"
#import "ADLAlbumListController.h"

#import "ADLEvaluateStarView.h"
#import "ADLLocalImgPreView.h"
#import "ADLDeleteImageCell.h"
#import "ADLSheetView.h"
#import "ADLTextView.h"

#import <Photos/Photos.h>

@interface ADLGoodsEvaluateController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ADLDeleteImageCellDelegate,ADLTextViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ADLEvaluateStarView *starView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *scoreArr;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) CGFloat cellW;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *submitBtn;
@end

@implementation ADLGoodsEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"评价晒单"];
    self.scoreArr = [[NSMutableArray alloc] init];
    self.score = 5;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    scrollView.backgroundColor = COLOR_F2F2F2;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:topView];
    self.topView = topView;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 13, 60, 60)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:[UIImage imageNamed:@"img_square"]];
    [topView addSubview:imgView];
    
    UILabel *scoreLab = [[UILabel alloc] initWithFrame:CGRectMake(82, 20, 100, 20)];
    scoreLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    scoreLab.textColor = COLOR_333333;
    scoreLab.text = @"商品评分";
    [topView addSubview:scoreLab];
    
    for (int i = 0; i < 5; i++) {
        UIButton *scoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(77+26*i, 47, 26, 26)];
        [scoreBtn setImage:[UIImage imageNamed:@"star_normal"] forState:UIControlStateNormal];
        [scoreBtn setImage:[UIImage imageNamed:@"star_select"] forState:UIControlStateSelected];
        [scoreBtn addTarget:self action:@selector(clickScoreBtn:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:scoreBtn];
        scoreBtn.selected = YES;
        scoreBtn.tag = i+1;
        [self.scoreArr addObject:scoreBtn];
    }
    
    ADLTextView *textView = [ADLTextView textViewWithFrame:CGRectMake(12, 87, SCREEN_WIDTH-24, 136) limitLength:200];
    textView.placeholder = @"说说产品的优点和美中不足的地方吧~";
    textView.bgColor = COLOR_F2F2F2;
    textView.delegate = self;
    [topView addSubview:textView];
    
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
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(12, 230, SCREEN_WIDTH-24, cellW) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    [topView addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView registerClass:[ADLDeleteImageCell class] forCellWithReuseIdentifier:@"ADLDeleteImageCell"];
    topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 242+cellW);
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 242+cellW, SCREEN_WIDTH, 169)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    spView.backgroundColor = COLOR_F2F2F2;
    [bottomView addSubview:spView];
    
    UILabel *otherLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, 200, 45)];
    otherLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    otherLab.textColor = COLOR_333333;
    otherLab.text = @"物流服务评价";
    [bottomView addSubview:otherLab];
    
    UILabel *promptLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-112, 8, 100, 45)];
    promptLab.font = [UIFont systemFontOfSize:13];
    promptLab.textAlignment = NSTextAlignmentRight;
    promptLab.textColor = COLOR_999999;
    promptLab.text = @"满意请给5星哦";
    [bottomView addSubview:promptLab];
    
    UIView *spLine = [[UIView alloc] initWithFrame:CGRectMake(0, 53, SCREEN_WIDTH, 0.5)];
    spLine.backgroundColor = SEPARATOR_COLOR;
    [bottomView addSubview:spLine];
    
    ADLEvaluateStarView *starView = [[NSBundle mainBundle] loadNibNamed:@"ADLEvaluateStarView" owner:nil options:nil].lastObject;
    starView.frame = CGRectMake(0, 63, SCREEN_WIDTH, 106);
    [bottomView addSubview:starView];
    self.starView = starView;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.frame = CGRectMake(12, 471+cellW, SCREEN_WIDTH-24, VIEW_HEIGHT);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [submitBtn setTitle:@"发表评价" forState:UIControlStateNormal];
    submitBtn.backgroundColor = APP_COLOR;
    submitBtn.layer.cornerRadius = CORNER_RADIUS;
    [submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:submitBtn];
    self.submitBtn = submitBtn;
    scrollView.contentSize = CGSizeMake(0, 566+cellW);
}

#pragma mark ------ 商品评分 ------
- (void)clickScoreBtn:(UIButton *)sender {
    self.score = sender.tag;
    [self.scoreArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < sender.tag) {
            obj.selected = YES;
        } else {
            obj.selected = NO;
        }
    }];
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
    CGRect topViewFrame = self.topView.frame;
    CGRect collectionFrame = self.collectionView.frame;
    CGRect bottomViewFrame = self.bottomView.frame;
    CGRect submitBtnFrame = self.submitBtn.frame;
    if (SCREEN_WIDTH < 500) {
        if (self.dataArr.count < 4) {
            topViewFrame.size.height = self.cellW+242;
            collectionFrame.size.height = self.cellW;
            bottomViewFrame.origin.y = self.cellW+242;
            submitBtnFrame.origin.y = self.cellW+471;
            self.scrollView.contentSize = CGSizeMake(0, self.cellW+566);
        } else if (self.dataArr.count < 8) {
            topViewFrame.size.height = self.cellW*2+246;
            collectionFrame.size.height = self.cellW*2+4;
            bottomViewFrame.origin.y = self.cellW*2+246;
            submitBtnFrame.origin.y = self.cellW*2+475;
            self.scrollView.contentSize = CGSizeMake(0, self.cellW*2+570);
        } else {
            topViewFrame.size.height = self.cellW*3+250;
            collectionFrame.size.height = self.cellW*3+8;
            bottomViewFrame.origin.y = self.cellW*3+250;
            submitBtnFrame.origin.y = self.cellW*3+479;
            self.scrollView.contentSize = CGSizeMake(0, self.cellW*3+574);
        }
    } else {
        if (self.dataArr.count < 6) {
            topViewFrame.size.height = self.cellW+242;
            collectionFrame.size.height = self.cellW;
            bottomViewFrame.origin.y = self.cellW+242;
            submitBtnFrame.origin.y = self.cellW+571;
            self.scrollView.contentSize = CGSizeMake(0, self.cellW+666);
        } else {
            topViewFrame.size.height = self.cellW*2+258;
            collectionFrame.size.height = self.cellW*2+16;
            bottomViewFrame.origin.y = self.cellW*2+258;
            submitBtnFrame.origin.y = self.cellW*2+587;
            self.scrollView.contentSize = CGSizeMake(0, self.cellW*2+682);
        }
    }
    self.collectionView.frame = collectionFrame;
    self.topView.frame = topViewFrame;
    self.bottomView.frame = bottomViewFrame;
    self.submitBtn.frame = submitBtnFrame;
    [self.collectionView reloadData];
}

#pragma mark ------ 提交 ------
- (void)clickSubmitBtn {
    if (self.content.length == 0) {
        [ADLToast showMessage:@"请输入评价内容"];
        return;
    }
    if ([ADLUtils hasEmoji:self.content]) {
        [ADLToast showMessage:@"请不要输入表情和特殊符号"];
        return;
    }
    if (self.starView.firstStar == 0) {
        [ADLToast showMessage:@"请选择对快递包装的星评"];
        return;
    }
    if (self.starView.secondStar == 0) {
        [ADLToast showMessage:@"请选择对送货态度的星评"];
        return;
    }
    if (self.starView.thirdStar == 0) {
        [ADLToast showMessage:@"请选择对服务态度的星评"];
        return;
    }
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"buyerUserid"];
    [params setValue:self.orderId forKey:@"ofId"];
    [params setValue:self.skuId forKey:@"skuId"];
    [params setValue:self.goodsId forKey:@"goodsId"];
    [params setValue:self.goodsName forKey:@"skuName"];
    [params setValue:self.content forKey:@"evaluateInfo"];
    [params setValue:@(self.score) forKey:@"description"];
    [params setValue:@(self.starView.firstStar) forKey:@"pack"];
    [params setValue:@(self.starView.secondStar) forKey:@"ship"];
    [params setValue:@(self.starView.thirdStar) forKey:@"service"];
    
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
                    [self submitEvaluateWithDictionary:params];
                }
            });
        });
    } else {
        [self submitEvaluateWithDictionary:params];
    }
}

#pragma mark ------ 提交请求 ------
- (void)submitEvaluateWithDictionary:(NSDictionary *)params {
    [ADLNetWorkManager postWithPath:k_goods_add_evaluate parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
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
