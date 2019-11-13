//
//  ADLAlbumListController.m
//  lockboss
//
//  Created by Han on 2019/6/3.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLAlbumListController.h"
#import "ADLSelectImageController.h"
#import "ADLAlbumListCell.h"
#import "ADLAlbumModel.h"
#import "ADLBlankView.h"

@interface ADLAlbumListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLBlankView *blankView;
@end

@implementation ADLAlbumListController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:ADLString(@"photo")];
    [self addRightButtonWithTitle:ADLString(@"cancle") action:@selector(clickCancleBtn)];
    self.backBtn.hidden = YES;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 70;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self getAlbumList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumList"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLAlbumListCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ADLAlbumModel *model = self.dataArr[indexPath.row];
    cell.nameLab.text = model.albumTitle;
    cell.countLab.text = [NSString stringWithFormat:@"（%ld）",model.imageNumber];
    cell.imgView.image = model.image;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLAlbumModel *model = self.dataArr[indexPath.row];
    ADLSelectImageController *selectVC = [[ADLSelectImageController alloc] init];
    selectVC.currentCount = self.currentCount;
    selectVC.maxCount = self.maxCount;
    selectVC.albumName = model.albumTitle;
    selectVC.assets = model.assets;
    selectVC.finish = ^(NSArray *images) {
        if (self.finish) {
            self.finish(images);
        }
        [self customPopViewController];
        [self.navigationController popViewControllerAnimated:NO];
    };
    [self.navigationController pushViewController:selectVC animated:YES];
}

#pragma mark ------ 取消 ------
- (void)clickCancleBtn {
    [self customPopViewController];
}

#pragma mark ------ 获取相册列表 ------
- (void)getAlbumList {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //相机胶卷
        PHFetchResult *cameraCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        //个人收藏
        PHFetchResult *favoritesCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumFavorites options:nil];
        //其它相册
        PHFetchResult *albumCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        
        for (PHAssetCollection *collection in cameraCollection) {
            ADLAlbumModel *model = [[ADLAlbumModel alloc] init];
            model.collection = collection;
            if (model.imageNumber > 0) {
                [self.dataArr addObject:model];
            }
        }
        
        for (PHAssetCollection *collection in favoritesCollection) {
            ADLAlbumModel *model = [[ADLAlbumModel alloc] init];
            model.collection = collection;
            if (model.imageNumber > 0) {
                [self.dataArr addObject:model];
            }
        }
        
        for (PHAssetCollection *collection in albumCollections) {
            ADLAlbumModel *model = [[ADLAlbumModel alloc] init];
            model.collection = collection;
            if (model.imageNumber > 0) {
                [self.dataArr addObject:model];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.dataArr.count == 0) {
                self.tableView.tableFooterView = self.blankView;
            }
            [self.tableView reloadData];
        });
    });
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H) imageName:nil prompt:ADLString(@"photo_null") backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

@end
