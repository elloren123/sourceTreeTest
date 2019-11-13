//
//  ADLMineController.m
//  lockboss
//
//  Created by adel on 2019/3/29.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLMineController.h"

#import "ADLPersonalInfoController.h"
#import "ADLSettingController.h"
#import "ADLFAQController.h"

#import "ADLOrderTypeController.h"
#import "ADLAftersaleController.h"
#import "ADLEvaluateCenterController.h"
#import "ADLFavoriteGoodsController.h"
#import "ADLCouponController.h"

#import "ADLFeedbackController.h"
#import "ADLCheckInRecordController.h"
#import "ADLFingerManageController.h"
#import "ADLFaceManagerController.h"

#import "ADLMineViewCell.h"
#import "ADLImagePreView.h"

#import <Masonry.h>

#import "ADLBlockchainOpenLockController.h"
@interface ADLMineController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nickLab;
@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) UILabel *accLab;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UILabel *mineLab;
@property (nonatomic, strong) UIButton *editBtn;
@end

@implementation ADLMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat imgW = 70;
    if (SCREEN_WIDTH > 500) imgW = 100;
    CGFloat headH = imgW+FONT_SIZE*2+57;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UIView *navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H)];
    navBgView.backgroundColor = [UIColor colorWithRed:237/255.0 green:61/255.0 blue:60/255.0 alpha:1];
    [self.view addSubview:navBgView];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    self.navView = navView;
    
    UILabel *mineLab = [[UILabel alloc] initWithFrame:CGRectMake(50, STATUS_HEIGHT, SCREEN_WIDTH-100, NAV_H)];
    mineLab.font = [UIFont boldSystemFontOfSize:17];
    mineLab.textAlignment = NSTextAlignmentCenter;
    mineLab.textColor = COLOR_333333;
    mineLab.text = @"我的";
    [navView addSubview:mineLab];
    self.mineLab = mineLab;
    
    UIButton *editBtnB = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-NAV_H, STATUS_HEIGHT, NAV_H, NAV_H)];
    [editBtnB setImage:[UIImage imageNamed:@"mine_edit_b"] forState:UIControlStateNormal];
    [editBtnB addTarget:self action:@selector(clickEditInfo) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:editBtnB];
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-NAV_H, STATUS_HEIGHT, NAV_H, NAV_H)];
    [editBtn setImage:[UIImage imageNamed:@"mine_edit_w"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(clickEditInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
    self.editBtn = editBtn;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H-0.3, SCREEN_WIDTH, 0.3)];
    lineView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [navView addSubview:lineView];
    navView.alpha = 0;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headH)];
    headerView.backgroundColor = [UIColor colorWithRed:237/255.0 green:61/255.0 blue:60/255.0 alpha:1];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headH)];
    bgImgView.image = [UIImage imageNamed:@"mine_head_bg"];
    [headerView addSubview:bgImgView];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-imgW-6)/2, 12, imgW+6, imgW+6)];
    whiteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    whiteView.layer.cornerRadius = imgW/2+3;
    [headerView addSubview:whiteView];
    
    UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-imgW)/2, 15, imgW, imgW)];
    headImgView.contentMode = UIViewContentModeScaleAspectFill;
    headImgView.userInteractionEnabled = YES;
    headImgView.layer.cornerRadius = imgW/2;
    [headerView addSubview:headImgView];
    headImgView.clipsToBounds = YES;
    self.headImgView = headImgView;
    
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEditInfo)];
    [headImgView addGestureRecognizer:headTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAvaterImageView:)];
    [headImgView addGestureRecognizer:longPress];
    
    UILabel *nickLab = [[UILabel alloc] initWithFrame:CGRectMake(30, imgW+28, SCREEN_WIDTH-60, FONT_SIZE+6)];
    nickLab.textAlignment = NSTextAlignmentCenter;
    nickLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    nickLab.textColor = [UIColor whiteColor];
    nickLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *nickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEditInfo)];
    [nickLab addGestureRecognizer:nickTap];
    [headerView addSubview:nickLab];
    self.nickLab = nickLab;
    
    UILabel *accLab = [[UILabel alloc] initWithFrame:CGRectMake(30, imgW+FONT_SIZE+40, SCREEN_WIDTH-60, FONT_SIZE+2)];
    accLab.textAlignment = NSTextAlignmentCenter;
    accLab.font = [UIFont systemFontOfSize:FONT_SIZE-2];
    accLab.textColor = [UIColor whiteColor];
    [headerView addSubview:accLab];
    self.accLab = accLab;
    
    [self.dataArr addObjectsFromArray:@[@"我的订单",@"我的售后服务",@"评价中心",@"喜欢的商品",@"优惠券",@"区块链开锁记录查询",ADLString(@"feedback"),ADLString(@"check_record"),ADLString(@"finger_setting"),@"人脸管理",ADLString(@"setting"),@"常见问题"]];
    self.imgArr = [NSArray arrayWithObjects:@"mine_order",@"mine_service",@"mine_evaluate",@"mine_like",@"mine_coupons",@"mine_block",@"mine_feedback",@"mine_record",@"mine_fingerprint",@"mine_face",@"mine_setting",@"mine_problem", nil];
    
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    UIView *overView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1200)];
    overView.backgroundColor = COLOR_F2F2F2;
    [footerview addSubview:overView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor colorWithRed:237/255.0 green:61/255.0 blue:60/255.0 alpha:1];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = ROW_HEIGHT;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = footerview;
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAVIGATION_H);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark ------ 更新数据 ------
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([ADLUserModel sharedModel].login) {
        self.nickLab.text = [ADLUserModel sharedModel].nickName;
        self.accLab.text = [ADLUserModel sharedModel].phone;
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[ADLUserModel sharedModel].headShot] placeholderImage:[UIImage imageNamed:@"user_head"]];
    } else {
        self.nickLab.text = @"登录";
        self.accLab.text = @"";
        self.headImgView.image = [UIImage imageNamed:@"user_head"];
    }
}

#pragma mark ------ 编辑 ------
- (void)clickEditInfo {
    if ([ADLUserModel sharedModel].login) {
        ADLPersonalInfoController *infoVC = [[ADLPersonalInfoController alloc] init];
        infoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:infoVC animated:YES];
    } else {
        [self pushLoginViewControllerHideTabbar:YES success:nil];
    }
}

#pragma mark ------ UItableView Delegate && DataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    headerView.backgroundColor = COLOR_F2F2F2;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLMineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mine"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLMineViewCell" owner:nil options:nil].lastObject;
    }
    if (indexPath.section == 0) {
        cell.label.text = self.dataArr[indexPath.row];
        cell.imgView.image = [UIImage imageNamed:self.imgArr[indexPath.row]];
    } else {
        cell.label.text = self.dataArr[indexPath.row+10];
        cell.imgView.image = [UIImage imageNamed:self.imgArr[indexPath.row+10]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([ADLUserModel sharedModel].login) {
            [self pushViewControllerWithIndex:indexPath.row];
        } else {
            [self pushLoginViewControllerHideTabbar:YES success:nil];
        }
        
    } else {
        if (indexPath.row == 0) {
            if ([ADLUserModel sharedModel].login) {
                ADLSettingController *settingVC = [[ADLSettingController alloc] init];
                settingVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:settingVC animated:YES];
            } else {
                [self pushLoginViewControllerHideTabbar:YES success:nil];
            }
        } else {
            ADLFAQController *faqVC = [[ADLFAQController alloc] init];
            faqVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:faqVC animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat alpha = scrollView.contentOffset.y/NAVIGATION_H;
    if (alpha > 1) {
        alpha = 1;
    }
    if (alpha < 0) {
        alpha = 0;
    }
    self.navView.alpha = alpha;
    self.editBtn.alpha = 1-alpha;
}

#pragma mark ------ 跳转控制器 ------
- (void)pushViewControllerWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            ADLOrderTypeController *typeVC = [[ADLOrderTypeController alloc] init];
            typeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:typeVC animated:YES];
        }
            break;
        case 1: {
            ADLAftersaleController *aftersaleVC = [[ADLAftersaleController alloc] init];
            aftersaleVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aftersaleVC animated:YES];
        }
            break;
        case 2: {
            ADLEvaluateCenterController *centerVC = [[ADLEvaluateCenterController alloc] init];
            centerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:centerVC animated:YES];
        }
            break;
        case 3: {
            ADLFavoriteGoodsController *favoriteVC = [[ADLFavoriteGoodsController alloc] init];
            favoriteVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:favoriteVC animated:YES];
        }
            break;
        case 4: {
            ADLCouponController *couponVC = [[ADLCouponController alloc] init];
            couponVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:couponVC animated:YES];
        }
            break;
        case 5: {//区块链
            ADLBlockchainOpenLockController *vc = [[ADLBlockchainOpenLockController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6: {
            ADLFeedbackController *feedbackVC = [[ADLFeedbackController alloc] init];
            feedbackVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
        case 7: {
            ADLCheckInRecordController *recordVC = [[ADLCheckInRecordController alloc] init];
            recordVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:recordVC animated:YES];
        }
            break;
        case 8: {
            ADLFingerManageController *fingerVC = [[ADLFingerManageController alloc] init];
            fingerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fingerVC animated:YES];
        }
            break;
        case 9: {//人脸管理
            ADLFaceManagerController *faceVC = [[ADLFaceManagerController alloc] init];
            faceVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:faceVC animated:YES];
        }
            break;
    }
}

#pragma mark ------ 长按头像 ------
- (void)longPressAvaterImageView:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan && [ADLUserModel sharedModel].headShot.length > 0) {
        [ADLImagePreView showWithImageViews:@[longPress.view]
                                   urlArray:@[[ADLUserModel sharedModel].headShot]
                               currentIndex:0];
    }
}

@end
