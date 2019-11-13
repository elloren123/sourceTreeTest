//
//  ADLGoodsDetailView.h
//  lockboss
//
//  Created by adel on 2019/7/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLGoodsDetailView : UIView

///初始化
+ (instancetype)detailViewWithFrame:(CGRect)frame;

///TableView
@property (nonatomic, strong) UITableView *tableView;

///商品规格数组
@property (nonatomic, strong) NSArray *specArr;

///商品规格高度数组
@property (nonatomic, strong) NSArray *specHArr;

///认证证书图片地址
@property (nonatomic, strong) NSString *cerUrl;

///视频地址
@property (nonatomic, strong) NSString *videoUrl;

///视频预览图
@property (nonatomic, strong) UIImage *previewImage;

///视频时长
@property (nonatomic, strong) NSString *videoDuration;

///认证报告图片地址数组
@property (nonatomic, strong) NSArray *reportArr;

///商品详情图片
@property (nonatomic, strong) NSArray *detailArr;

///点击视频
@property (nonatomic, copy) void (^clickVideo) (NSString *videoUrl);

///TableView偏移
@property (nonatomic, copy) void (^contentOffsetChanged) (CGFloat offsetY);

@end
