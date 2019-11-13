//
//  ADLSelectImageController.m
//  lockboss
//
//  Created by adel on 2019/6/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSelectImageController.h"
#import "ADLSelectImageCell.h"

@interface ADLSelectImageController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *indexPathArr;
@end

@implementation ADLSelectImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:self.albumName];
    [self addRightButtonWithTitle:ADLString(@"done") action:@selector(clickDoneBtn)];
    
    CGFloat gap = 4;
    CGFloat cellW = (SCREEN_WIDTH-20)/4;
    if (SCREEN_WIDTH > 500) {
        gap = 12;
        cellW = (SCREEN_WIDTH-108)/8;
    }
    
    for (int i = 0; i < self.assets.count; i++) {
        ADLImageModel *model = [[ADLImageModel alloc] init];
        [self.dataArr addObject:model];
    }
    
    self.indexPathArr = [[NSMutableArray alloc] init];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(cellW, cellW);
    layout.minimumInteritemSpacing = gap-1;
    layout.minimumLineSpacing = gap;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(gap, NAVIGATION_H, SCREEN_WIDTH-gap*2, SCREEN_HEIGHT-NAVIGATION_H) collectionViewLayout:layout];
    collectionView.backgroundColor = COLOR_F2F2F2;
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView registerClass:[ADLSelectImageCell class] forCellWithReuseIdentifier:@"ADLSelectImageCell"];
}

#pragma mark ------ UICollectionView ------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADLSelectImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ADLSelectImageCell" forIndexPath:indexPath];
    ADLImageModel *model = self.dataArr[indexPath.item];
    if (model.image == nil) {
        model.asset = [self.assets objectAtIndex:indexPath.item];
    }
    cell.imgView.image = model.image;
    cell.checkBtn.selected = model.select;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ADLSelectImageCell *cell = (ADLSelectImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (!cell.checkBtn.selected && self.currentCount+self.indexPathArr.count > self.maxCount-1) {
        [ADLToast showMessage:ADLString(@"photo_max")];
    } else {
        ADLImageModel *model = self.dataArr[indexPath.item];
        cell.checkBtn.selected = !cell.checkBtn.selected;
        model.select = cell.checkBtn.selected;
        if (model.select) {
            [self.indexPathArr addObject:indexPath];
        } else {
            [self.indexPathArr removeObject:indexPath];
        }
    }
}

#pragma mark ------ 完成 ------
- (void)clickDoneBtn {
    if (self.finish) {
        NSMutableArray *imageArr = [[NSMutableArray alloc] init];
        if (self.indexPathArr.count > 0) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.synchronous = YES;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            
            for (NSIndexPath *indexPath in self.indexPathArr) {
                PHAsset *asset = [self.assets objectAtIndex:indexPath.item];
                [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    [imageArr addObject:result];
                }];
            }
        }
        self.assets = nil;
        self.finish(imageArr);
    } else {
        [self customPopViewController];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

@end
