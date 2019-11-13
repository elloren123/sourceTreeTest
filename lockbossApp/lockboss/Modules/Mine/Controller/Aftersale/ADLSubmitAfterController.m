//
//  ADLSubmitAfterController.m
//  lockboss
//
//  Created by adel on 2019/7/1.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSubmitAfterController.h"
#import "ADLAlbumListController.h"
#import "ADLAftersaleController.h"
#import "ADLStoreOrderController.h"

#import "ADLAttributeFlowLayout.h"
#import "ADLGoodsAttributeCell.h"
#import "ADLDeleteImageCell.h"
#import "ADLLocalImgPreView.h"
#import "ADLKeyboardMonitor.h"
#import "ADLSheetView.h"
#import "ADLTextView.h"

#import <Photos/Photos.h>

@interface ADLSubmitAfterController ()<ADLTextViewDelegate,ADLDeleteImageCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UICollectionView *imgCollectionView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reasonH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descH;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *needLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UIView *reasonView;
@property (weak, nonatomic) IBOutlet UIView *descView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, assign) CGFloat cellW;
@end

@implementation ADLSubmitAfterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.top.constant = NAVIGATION_H;
    self.imgArr = [[NSMutableArray alloc] init];
    self.submitBtn.layer.cornerRadius = CORNER_RADIUS;
    int type = [self.dataDict[@"aftersaleType"] intValue];
    if (type == 0) {
        [self addNavigationView:@"退货"];
        self.needLab.text = @"申请退货的商品";
    } else if (type == 1) {
        [self addNavigationView:@"换货"];
        self.needLab.text = @"申请换货的商品";
    } else {
        [self addNavigationView:@"维修"];
        self.needLab.text = @"申请维修的商品";
    }
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.dataDict[@"goodsImg"]] placeholderImage:[UIImage imageNamed:@"img_square"]];
    self.nameLab.text = self.dataDict[@"goodsName"];
    NSString *descStr = [NSString stringWithFormat:@"单价: ¥%.2f   购买数量: %@   申请数量: %@",[self.dataDict[@"price"] doubleValue],self.dataDict[@"goodsNum"],self.dataDict[@"aftersaleCount"]];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:descStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_999999 range:NSMakeRange(0, 3)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_999999 range:[descStr rangeOfString:@"购买数量:"]];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_999999 range:[descStr rangeOfString:@"申请数量:"]];
    self.descLab.attributedText = attributeStr;
    
    ADLAttributeFlowLayout *tagLayout = [[ADLAttributeFlowLayout alloc] init];
    tagLayout.minimumInteritemSpacing = 10;
    tagLayout.minimumLineSpacing = 10;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(12, 59, SCREEN_WIDTH-24, 128) collectionViewLayout:tagLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    [self.reasonView addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView registerClass:[ADLGoodsAttributeCell class] forCellWithReuseIdentifier:@"cell"];
    
    ADLTextView *textView = [ADLTextView textViewWithFrame:CGRectMake(12, 49, SCREEN_WIDTH-24, 135) limitLength:200];
    textView.placeholder = @"请描述具体售后原因...";
    textView.bgColor = COLOR_F2F2F2;
    textView.delegate = self;
    [self.descView addSubview:textView];
    [self initializationTagDataWithType:type];
    
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
    
    if (type != 3) {
        UICollectionView *imgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(12, 194, SCREEN_WIDTH-24, cellW) collectionViewLayout:layout];
        imgCollectionView.backgroundColor = [UIColor whiteColor];
        imgCollectionView.delegate = self;
        imgCollectionView.dataSource = self;
        imgCollectionView.scrollEnabled = NO;
        [self.descView addSubview:imgCollectionView];
        self.imgCollectionView = imgCollectionView;
        [imgCollectionView registerClass:[ADLDeleteImageCell class] forCellWithReuseIdentifier:@"ADLDeleteImageCell"];
        self.descH.constant = cellW+206;
        self.contentH.constant = self.reasonH.constant+self.descH.constant+302;
    } else {
        self.descH.constant = 196;
        self.contentH.constant = self.reasonH.constant+498;
    }
    
    [[ADLKeyboardMonitor monitor] setEnable:YES];
}

#pragma mark ------ UICollectionView Delegate && dataSource ------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.collectionView) {
        return self.dataArr.count;
    } else {
        if (self.imgArr.count < 9) {
            return self.imgArr.count+1;
        } else {
            return 9;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.collectionView) {
        ADLGoodsAttributeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        NSDictionary *dict = self.dataArr[indexPath.item];
        cell.text = dict[@"tagName"];
        if ([dict[@"selected"] boolValue]) {
            cell.attrLab.layer.borderColor = APP_COLOR.CGColor;
            cell.attrLab.textColor = APP_COLOR;
        } else {
            cell.attrLab.layer.borderColor = COLOR_D3D3D3.CGColor;
            cell.attrLab.textColor = COLOR_333333;
        }
        return cell;
    } else {
        ADLDeleteImageCell *imgCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ADLDeleteImageCell" forIndexPath:indexPath];
        imgCell.delegate = self;
        if (indexPath.item < self.imgArr.count) {
            imgCell.deleteBtn.hidden = NO;
            imgCell.imgView.image = self.imgArr[indexPath.item];
        } else {
            imgCell.deleteBtn.hidden = YES;
            imgCell.imgView.image = [UIImage imageNamed:@"img_add"];
        }
        return imgCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (collectionView == self.collectionView) {
        NSMutableDictionary *muDict = self.dataArr[indexPath.item];
        if ([muDict[@"selected"] boolValue] == NO) {
            for (NSMutableDictionary *dict in self.dataArr) {
                [dict setValue:@(0) forKey:@"selected"];
            }
            [muDict setValue:@(1) forKey:@"selected"];
        }
        [self.collectionView reloadData];
    } else {
        if (indexPath.item == self.imgArr.count) {
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
                            albumVC.currentCount = self.imgArr.count;
                            albumVC.finish = ^(NSArray *imageArr) {
                                if (imageArr.count > 0) {
                                    [self.imgArr addObjectsFromArray:imageArr];
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
            for (int i = 0; i < self.imgArr.count; i++) {
                ADLDeleteImageCell *cell = (ADLDeleteImageCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                [imgViewArr addObject:cell.imgView];
            }
            [ADLLocalImgPreView showWithImageViews:imgViewArr currentIndex:indexPath.item];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.collectionView) {
        NSDictionary *dict = self.dataArr[indexPath.item];
        CGFloat tagW = [ADLUtils calculateString:dict[@"tagName"] rectSize:CGSizeMake(SCREEN_WIDTH-24, 36) fontSize:13].width+20;
        return CGSizeMake(tagW, 36);
    } else {
        return CGSizeMake(self.cellW, self.cellW);
    }
}

#pragma mark ------ UIImagePickerControllerDelegate ------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.imgArr addObject:image];
    [self reloadCollectionView];
}

#pragma mark ------ 删除图片 ------
- (void)didClickDeleteBtn:(UIButton *)sender {
    ADLDeleteImageCell *cell = (ADLDeleteImageCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.imgCollectionView indexPathForCell:cell];
    [self.imgArr removeObjectAtIndex:indexPath.item];
    [self reloadCollectionView];
}

#pragma mark ------ 刷新图片 ------
- (void)reloadCollectionView {
    CGRect collectionFrame = self.imgCollectionView.frame;
    if (SCREEN_WIDTH < 500) {
        if (self.imgArr.count < 4) {
            collectionFrame.size.height = self.cellW;
            self.descH.constant = self.cellW+206;
        } else if (self.imgArr.count < 8) {
            collectionFrame.size.height = self.cellW*2+4;
            self.descH.constant = self.cellW*2+210;
        } else {
            collectionFrame.size.height = self.cellW*3+8;
            self.descH.constant = self.cellW*3+214;
        }
    } else {
        if (self.imgArr.count < 6) {
            collectionFrame.size.height = self.cellW;
            self.descH.constant = self.cellW+206;
        } else {
            collectionFrame.size.height = self.cellW*2+11;
            self.descH.constant = self.cellW*2+217;
        }
    }
    self.imgCollectionView.frame = collectionFrame;
    self.contentH.constant = self.reasonH.constant+self.descH.constant+302;
    [self.imgCollectionView reloadData];
}

#pragma mark ------ 开始输入 ------
- (void)textViewDidBeginEdit:(UIView *)textView {
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat bottomH = [ADLUtils convertRectWithView:textView];
    __weak typeof(self)weakSelf = self;
    [ADLKeyboardMonitor monitor].keyboardHeightChanged = ^(CGFloat keyboardH) {
        if (keyboardH == 0) {
            [weakSelf.scrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
        } else {
            if (bottomH < keyboardH) {
                [weakSelf.scrollView setContentOffset:CGPointMake(0, offsetY+keyboardH-bottomH) animated:YES];
            }
        }
    };
}

#pragma mark ------ 输入改变 ------
- (void)textViewDidChangeText:(NSString *)text {
    self.reason = text;
}

#pragma mark ------ 提交申请 ------
- (IBAction)clickSubmitApplyBtn:(UIButton *)sender {
    if (self.reason.length == 0) {
        [ADLToast showMessage:@"请输入申请原因"];
        return;
    }
    if ([ADLUtils hasEmoji:self.reason]) {
        [ADLToast showMessage:@"请不要输入表情和特殊符号"];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.dataDict[@"suborderId"] forKey:@"suborderId"];
    [params setValue:self.dataDict[@"skuId"] forKey:@"skuId"];
    [params setValue:self.dataDict[@"aftersaleType"] forKey:@"type"];
    [params setValue:self.dataDict[@"aftersaleCount"] forKey:@"num"];
    for (NSDictionary *dict in self.dataArr) {
        if ([dict[@"selected"] boolValue]) {
            [params setValue:dict[@"tagId"] forKey:@"tag"];
            break;
        }
    }
    [params setValue:self.reason forKey:@"reason"];
    NSInteger imgCount = self.imgArr.count;
    [ADLToast showLoadingMessage:ADLString(@"loading")];
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
                NSData *data = [ADLUtils compressImageQuality:self.imgArr[i] maxLength:IMAGE_MAX_LENGTH];
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
                    [params setValue:[imgStrArr componentsJoinedByString:@","] forKey:@"imgsUrl"];
                    [self addAftersaleWithDict:params];
                }
            });
        });
    } else {
        [self addAftersaleWithDict:params];
    }
}

#pragma mark ------ 添加售后订单 ------
- (void)addAftersaleWithDict:(NSDictionary *)params {
    [ADLNetWorkManager postWithPath:k_add_after_sale parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"售后申请添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self popViewController];
            });
        }
    } failure:nil];
}

#pragma mark ------ 跳转控制器 ------
- (void)popViewController {
    if (self.orderVC) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ADLStoreOrderController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    } else {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ADLAftersaleController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}

#pragma mark ------ 初始化售后原因标签 ------
- (void)initializationTagDataWithType:(int)type {
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setValue:@"外观损坏" forKey:@"tagName"];
    [dict1 setValue:@(0) forKey:@"selected"];
    [dict1 setValue:@(0) forKey:@"tagId"];
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
    [dict2 setValue:@"质量问题" forKey:@"tagName"];
    [dict2 setValue:@(0) forKey:@"selected"];
    [dict2 setValue:@(1) forKey:@"tagId"];
    
    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
    [dict3 setValue:@"卖家发错货" forKey:@"tagName"];
    [dict3 setValue:@(0) forKey:@"selected"];
    [dict3 setValue:@(2) forKey:@"tagId"];
    
    NSMutableDictionary *dict4 = [[NSMutableDictionary alloc] init];
    [dict4 setValue:@"七天无理由" forKey:@"tagName"];
    [dict4 setValue:@(0) forKey:@"selected"];
    [dict4 setValue:@(3) forKey:@"tagId"];
    
    NSMutableDictionary *dict5 = [[NSMutableDictionary alloc] init];
    [dict5 setValue:@"商品与描述不符" forKey:@"tagName"];
    [dict5 setValue:@(0) forKey:@"selected"];
    [dict5 setValue:@(4) forKey:@"tagId"];
    
    NSMutableDictionary *dict6 = [[NSMutableDictionary alloc] init];
    [dict6 setValue:@"其他" forKey:@"tagName"];
    [dict6 setValue:@(0) forKey:@"selected"];
    [dict6 setValue:@(5) forKey:@"tagId"];
    
    NSMutableDictionary *dict7 = [[NSMutableDictionary alloc] init];
    [dict7 setValue:@"商品故障" forKey:@"tagName"];
    [dict7 setValue:@(0) forKey:@"selected"];
    [dict7 setValue:@(6) forKey:@"tagId"];
    
    NSMutableDictionary *dict8 = [[NSMutableDictionary alloc] init];
    [dict8 setValue:@"不想要了" forKey:@"tagName"];
    [dict8 setValue:@(0) forKey:@"selected"];
    [dict8 setValue:@(7) forKey:@"tagId"];
    
    NSMutableDictionary *dict9 = [[NSMutableDictionary alloc] init];
    [dict9 setValue:@"买多了" forKey:@"tagName"];
    [dict9 setValue:@(0) forKey:@"selected"];
    [dict9 setValue:@(8) forKey:@"tagId"];
    
    NSMutableDictionary *dict10 = [[NSMutableDictionary alloc] init];
    [dict10 setValue:@"未收到货" forKey:@"tagName"];
    [dict10 setValue:@(0) forKey:@"selected"];
    [dict10 setValue:@(9) forKey:@"tagId"];
    
    NSMutableDictionary *dict11 = [[NSMutableDictionary alloc] init];
    [dict11 setValue:@"未按约定时间发货" forKey:@"tagName"];
    [dict11 setValue:@(0) forKey:@"selected"];
    [dict11 setValue:@(10) forKey:@"tagId"];
    
    if (type == 0) {
        [dict1 setValue:@(1) forKey:@"selected"];
        [self.dataArr addObject:dict1];
        [self.dataArr addObject:dict2];
        [self.dataArr addObject:dict3];
        [self.dataArr addObject:dict4];
        [self.dataArr addObject:dict5];
        [self.dataArr addObject:dict7];
        [self.dataArr addObject:dict8];
        [self.dataArr addObject:dict9];
        [self.dataArr addObject:dict6];
    } else if (type == 1) {
        [dict1 setValue:@(1) forKey:@"selected"];
        [self.dataArr addObject:dict1];
        [self.dataArr addObject:dict2];
        [self.dataArr addObject:dict3];
        [self.dataArr addObject:dict5];
        [self.dataArr addObject:dict7];
        [self.dataArr addObject:dict6];
    } else {
        [dict7 setValue:@(1) forKey:@"selected"];
        [self.dataArr addObject:dict7];
        [self.dataArr addObject:dict6];
    }
    [self.collectionView reloadData];
    CGFloat collectH = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    self.collectionView.frame = CGRectMake(12, 59, SCREEN_WIDTH-24, collectH);
    self.reasonH.constant = collectH+70;
}

#pragma mark ------ 移除键盘监听 ------
- (void)dealloc {
    [[ADLKeyboardMonitor monitor] setEnable:NO];
}

@end
