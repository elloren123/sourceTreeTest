//
//  ADLGoodsDetailView.m
//  lockboss
//
//  Created by adel on 2019/7/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsDetailView.h"
#import "ADLGlobalDefine.h"
#import "ADLUtils.h"

#import "ADLImagePreView.h"
#import "ADLImageListView.h"
#import "ADLGoodsSpecCell.h"
#import "ADLSingleImageCell.h"
#import "ADLVideoPreviewCell.h"
#import "ADLGoodsLSReportCell.h"

#import <UIImageView+WebCache.h>

@interface ADLGoodsDetailView ()<UITableViewDelegate,UITableViewDataSource,ADLVideoPreviewCellDelegate>
@property (nonatomic, strong) ADLImageListView *listView;
@end

@implementation ADLGoodsDetailView

+ (instancetype)detailViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.estimatedRowHeight = 0;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        self.tableView = tableView;
        
        __weak typeof(self)weakSelf = self;
        ADLImageListView *listView = [ADLImageListView listViewWithContentInserts:UIEdgeInsetsMake(15, 12, 0, 12)];
        listView.imageViewHeightChanged = ^(CGFloat totalHeight) {
            weakSelf.tableView.tableFooterView = weakSelf.listView;
        };
        self.listView = listView;
    }
    return self;
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.specArr.count;
    } else if (section == 1) {
        return self.cerUrl ? 1 : 0;
    } else if (section == 2) {
        return self.videoDuration ? 1 : 0;
    } else {
        return self.reportArr.count == 0 ? 0 : 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.specArr.count == 0 ? 0 : VIEW_HEIGHT;
    } else if (section == 1) {
        if (self.cerUrl) {
            if (self.specArr.count > 0) {
                return VIEW_HEIGHT+8;
            } else {
                return VIEW_HEIGHT;
            }
        } else {
            return 0;
        }
    } else if (section == 2) {
        return self.videoDuration ? VIEW_HEIGHT : 0;
    } else {
        return self.reportArr.count == 0 ? 0 : VIEW_HEIGHT;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    if (section == 0) {
        if (self.specArr.count > 0) {
            headerView.backgroundColor = [UIColor whiteColor];
            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT);
            UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(12, VIEW_HEIGHT/2-8, 3, 16)];
            redView.backgroundColor = APP_COLOR;
            [headerView addSubview:redView];
            UILabel *specLab = [[UILabel alloc] initWithFrame:CGRectMake(23, 0, 100, VIEW_HEIGHT)];
            specLab.font = [UIFont systemFontOfSize:FONT_SIZE];
            specLab.textColor = COLOR_333333;
            specLab.text = @"商品详情";
            [headerView addSubview:specLab];
            UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT-0.5, SCREEN_WIDTH, 0.5)];
            spView.backgroundColor = SEPARATOR_COLOR;
            [headerView addSubview:spView];
        }
    } else if (section == 1) {
        if (self.cerUrl) {
            UILabel *cerLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 160, VIEW_HEIGHT)];
            cerLab.font = [UIFont systemFontOfSize:FONT_SIZE];
            cerLab.textColor = COLOR_333333;
            cerLab.text = @"LS-10认证证书";
            if (self.specArr.count > 0) {
                headerView.backgroundColor = COLOR_F2F2F2;
                headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT+8);
                UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, VIEW_HEIGHT)];
                whiteView.backgroundColor = [UIColor whiteColor];
                [headerView addSubview:whiteView];
                [whiteView addSubview:cerLab];
            } else {
                headerView.backgroundColor = [UIColor whiteColor];
                headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT);
                [headerView addSubview:cerLab];
            }
        }
    } else if (section == 2) {
        headerView.backgroundColor = [UIColor whiteColor];
        if (self.videoDuration) {
            UILabel *videoLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 160, VIEW_HEIGHT)];
            videoLab.font = [UIFont systemFontOfSize:FONT_SIZE];
            videoLab.textColor = COLOR_333333;
            videoLab.text = @"LS-10认证视频";
            [headerView addSubview:videoLab];
        }
    } else {
        headerView.backgroundColor = [UIColor whiteColor];
        if (self.reportArr.count > 0) {
            UILabel *reportLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 160, VIEW_HEIGHT)];
            reportLab.font = [UIFont systemFontOfSize:FONT_SIZE];
            reportLab.textColor = COLOR_333333;
            reportLab.text = @"LS-10认证报告";
            [headerView addSubview:reportLab];
        }
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self.specHArr[indexPath.row] floatValue];
    } else if (indexPath.section == 1) {
        return 210;
    } else if (indexPath.section == 2) {
        return (SCREEN_WIDTH-24)*0.56;
    } else {
        if (self.reportArr.count < 2) {
            return (SCREEN_WIDTH-24)*0.7;
        } else {
            return (SCREEN_WIDTH-24)*0.7+30;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ADLGoodsSpecCell *specCell = [tableView dequeueReusableCellWithIdentifier:@"spec"];
        if (specCell == nil) {
            specCell = [[ADLGoodsSpecCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"spec"];
            specCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dict = self.specArr[indexPath.row];
        specCell.titLab.text = dict[@"propertyName"];
        specCell.descLab.text = dict[@"propertyValue"];
        return specCell;
    } else if (indexPath.section == 1) {
        ADLSingleImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"image"];
        if (imageCell == nil) {
            imageCell = [[ADLSingleImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"image" imgSize:CGSizeMake(150, 210)];
            imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [imageCell.imgView sd_setImageWithURL:[NSURL URLWithString:self.cerUrl] placeholderImage:[UIImage imageNamed:@"img_square"]];
        imageCell.imgUrl = self.cerUrl;
        return imageCell;
    } else if (indexPath.section == 2) {
        ADLVideoPreviewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:@"video"];
        if (videoCell == nil) {
            videoCell = [[ADLVideoPreviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"video"];
            videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            videoCell.delegate = self;
        }
        videoCell.imgSize = CGSizeMake(self.previewImage.size.width, self.previewImage.size.height);
        videoCell.imgView.image = self.previewImage;
        videoCell.durationLab.text = self.videoDuration;
        return videoCell;
    } else {
        if (self.reportArr.count == 1) {
            ADLSingleImageCell *singleReportCell = [tableView dequeueReusableCellWithIdentifier:@"singleReport"];
            if (singleReportCell == nil) {
                singleReportCell = [[ADLSingleImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"singleReport" imgSize:CGSizeMake(SCREEN_WIDTH-24, (SCREEN_WIDTH-24)*0.7)];
                singleReportCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [singleReportCell.imgView sd_setImageWithURL:[NSURL URLWithString:self.reportArr.firstObject]];
            singleReportCell.imgUrl = self.reportArr.firstObject;
            return singleReportCell;
            
        } else {
            ADLGoodsLSReportCell *reportCell = [tableView dequeueReusableCellWithIdentifier:@"report"];
            if (reportCell == nil) {
                reportCell = [[ADLGoodsLSReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"report" imgSize:CGSizeMake(SCREEN_WIDTH-24, (SCREEN_WIDTH-24)*0.7)];
            }
            reportCell.urlArr = self.reportArr;
            return reportCell;
        }
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.contentOffsetChanged) {
        self.contentOffsetChanged(scrollView.contentOffset.y);
    }
}

#pragma mark ------ 详情图片 ------
- (void)setDetailArr:(NSArray *)detailArr {
    if (detailArr.count == 0) return;
    if (_detailArr.count == 0) {
        _detailArr = detailArr;
        self.listView.urlArr = detailArr;
    }
}

#pragma mark ------ 点击视频 ------
- (void)didClickVideoPreView {
    if (self.clickVideo) {
        self.clickVideo(self.videoUrl);
    }
}

@end
