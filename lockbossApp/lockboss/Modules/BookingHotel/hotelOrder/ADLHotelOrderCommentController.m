//
//  ADLHotelOrderCommentController.m
//  lockboss
//
//  Created by adel on 2019/10/10.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelOrderCommentController.h"
#import "ADLHotelOrderListCell.h"
#import "ADLBookingHotelModel.h"
#import "ADLTextView.h"
#import "ADLDeleteImageCell.h"
#import "ADLSheetView.h"
#import "ADLLocalImgPreView.h"
#import <Photos/Photos.h>
#import "ADLAlbumListController.h"
#import "ADLHotelOrderModel.h"
#import "ADLCommentStarView.h"

@interface ADLHotelOrderCommentController ()<UITableViewDataSource,UITableViewDelegate,ADLTextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ADLDeleteImageCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *array;
@property (nonatomic ,strong)UIView *footerView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic ,copy)NSString *strUrl;
@property (nonatomic ,weak) ADLTextView *textView;
@property (nonatomic ,strong)UIButton *submitBtn;
@property (nonatomic ,assign)int maxImage;//图片数量
@property (nonatomic ,weak)UILabel *number;//星数
@end

@implementation ADLHotelOrderCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];
    //1评论  2,用户退款请求
    if (self.afterType == 1) {
        [self addNavigationView:ADLString(@"评论")];
        self.maxImage = 9;
    }else   if (self.afterType == 2) {
       [self addNavigationView:ADLString(@"退款")];
           self.maxImage = 3;
    }else   if (self.afterType == 3) {
       [self addNavigationView:ADLString(@"退款")];
    }else   if (self.afterType == 4) {
        
    }

    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = self.footerView;
    // [self HotenRoomData];
}
-(void)uploadPictures{
    
  
       [ADLToast showLoadingMessage:ADLString(@"loading")];
    WS(ws);
    if (self.dataArr.count > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *imgDataArr = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.dataArr.count; i++) {
                NSData *data = [ADLUtils compressImageQuality:self.dataArr[i] maxLength:IMAGE_MAX_LENGTH];
                [imgDataArr addObject:data];
            }
            
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            param[@"token"] =[ADLUserModel sharedModel].token;
            param[@"sign"] = [ADLUtils handleParamsSign:param];
         
            
            [ADLNetWorkManager postImagePath:ADEL_batchUploadImage parameters:param imageDataArr:imgDataArr imageName:@"files" autoToast:YES progress:^(NSProgress *progress) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    int pro = (int)(progress.fractionCompleted*100);
                    if (pro == 100) pro = 99;
                    [ADLToast showLoadingMessage:[NSString stringWithFormat:@"%@(%d%%)",ADLString(@"image_upload"),pro]];
                });
                
                
            } success:^(NSDictionary *responseDict) {
                
                
                dispatch_async(dispatch_get_main_queue(), ^{

                    [ws HotenPresentAfter:responseDict];
                });
                
                
            } failure:^(NSError *error) {
                [ADLToast showMessage:ADLString(@"submit_success")];
            }];
        });
    }else {
        
        [self HotenPresentAfter:nil];
    }
    
}
#pragma mark ------ 1酒店评论 2退款 提交酒店反馈-----
- (void)HotenPresentAfter:(NSDictionary *)dict {
    //[ADLToast showLoadingMessage:ADLString(@"loading")];
   NSMutableDictionary  *params = [NSMutableDictionary dictionary];
    //1评论
    if (self.afterType == 1) {
        self.strUrl =ADEL_hotel_roomSellOrder_comment;
        params[@"roomSellOrderId"] = self.model.roomSellOrderId;
        params[@"gradeMessages"] = self.textView.text;
        params[@"grade"] = self.number.text;
        
        NSString *str = dict[@"data"][@"url"];
        if (str.length > 0) {
            NSArray *arr = [str componentsSeparatedByString:@","];
            NSString* pics = [self dictionaryToJsonString:arr];
            [params setValue:pics forKey:@"pics"];
        }
   
    }
    //2,用户退款请求
    if (self.afterType == 2) {
        self.strUrl = ADEL_hotel_roomSellOrder_refund;
        params[@"roomSellOrderId"] = self.model.roomSellOrderId;
        params[@"des"] = self.textView.text;
        
        NSString *str = dict[@"data"][@"url"];
        if (str.length > 0) {
            NSArray *arr = [str componentsSeparatedByString:@","];
            NSString* pics = [self dictionaryToJsonString:arr];
            
            [params setValue:pics forKey:@"url"];
        }

       
    }
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    WS(ws);
    [ADLNetWorkManager postWithPath:self.strUrl parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:ADLString(@"提交成功")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ws.navigationController popViewControllerAnimated:YES];
            });
        }
      
    }  failure:nil];
}
- (NSString *)dictionaryToJsonString:(NSArray *)arr{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
#pragma mark ------ UITableView ------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ADLHotelOrderListCell *cell = [ADLHotelOrderListCell cellWithTableView:tableView hotelOrderCell:ADLHotelOrderDetailsCell];
    cell.model = self.model;
    //cell.userInteractionEnabled = NO;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  180;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
                        albumVC.maxCount = self.maxImage;
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


-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,NAVIGATION_H,SCREEN_WIDTH,SCREEN_HEIGHT - NAVIGATION_H) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // _tableView.bounces = NO;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor =COLOR_F7F7F7;
        // _tableView.alpha = 0.7;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}
-(UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 600)];
        _footerView.backgroundColor =  [UIColor whiteColor];
        ADLTextView *textView;
        if (self.afterType == 1) {
            UILabel *title = [self.view createLabelFrame:CGRectMake(20, 5,90, 20) font:12 text:ADLString(@"客户满意度评价") texeColor:COLOR_666666];
         
            WS(ws);
            ADLCommentStarView *CommentStarView = [[ADLCommentStarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title.frame)+10,5, 130, 20) numberOfStars:5 rateStyle:WholeStar isAnination:YES finish:^(CGFloat currentScore) {
                NSLog(@"%.1f",currentScore);
                ws.number.text =[NSString stringWithFormat:@"%.1f",currentScore];
            }];
            UILabel *number = [self.view createLabelFrame:CGRectMake(CGRectGetMaxX(CommentStarView.frame)+5, 5,50, 20) font:12 text:@"5.0" texeColor:COLOR_E0212A];
            self.number = number;
            //  CommentStarView.backgroundColor = [UIColor yellowColor];
            [_footerView addSubview:number];
            [_footerView addSubview:title];
            [_footerView addSubview:CommentStarView];
              textView = [ADLTextView textViewWithFrame:CGRectMake(12, CGRectGetMaxY(CommentStarView.frame)+10, SCREEN_WIDTH-24, 160) limitLength:200];
        }else {
          textView = [ADLTextView textViewWithFrame:CGRectMake(12, 10, SCREEN_WIDTH-24, 160) limitLength:200];
        }
        textView.bgColor = COLOR_F2F2F2;
        textView.placeholder = ADLString(@"feedback_placeholder");
        textView.delegate = self;
        [_footerView addSubview:textView];
        self.textView = textView;
        CGFloat gap = 3;
        CGFloat cellW = (SCREEN_WIDTH-24-gap*3)/4;
        if (SCREEN_WIDTH > 500) {
            gap = 15;
            cellW = (SCREEN_WIDTH-24-gap*5)/6;
        }
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(cellW, cellW);
        layout.minimumInteritemSpacing = gap-1;
        layout.minimumLineSpacing = gap+1;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(textView.frame)+20, SCREEN_WIDTH-24, cellW) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.scrollEnabled = NO;
        [_footerView addSubview:collectionView];
        self.collectionView = collectionView;
        [collectionView registerClass:[ADLDeleteImageCell class] forCellWithReuseIdentifier:@"ADLDeleteImageCell"];
        [_footerView addSubview:self.submitBtn];
    }
    return _footerView;
}
-(UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [self.view createButtonFrame:CGRectMake(20,self.footerView.height - 50, SCREEN_WIDTH - 40, 50) imageName:nil title:ADLString(@"提交") titleColor:[UIColor whiteColor] font:10 target:self action:@selector(uploadPictures)];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _submitBtn.backgroundColor = COLOR_E0212A;
    }
    return _submitBtn;
}
-(NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

@end
