//
//  ADLServiceView.m
//  lockboss
//
//  Created by adel on 2019/5/21.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLServiceView.h"
#import "ADLGlobalDefine.h"
#import "ADLAttributeFlowLayout.h"
#import "ADLGoodsAttributeCell.h"
#import "ADLTextHeaderView.h"

@interface ADLServiceView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, copy) void (^confirmAction) (NSMutableDictionary *selectDict);
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *selectDict;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) NSArray *serviceArr;

@end

@implementation ADLServiceView

+ (instancetype)serviceViewWithServiceArr:(NSArray *)serviceArr selectStr:(NSString *)selectStr confirmAction:(void (^)(NSMutableDictionary *))confirmAction {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds serviceArr:serviceArr selectStr:selectStr confirmAction:confirmAction];
}

- (instancetype)initWithFrame:(CGRect)frame serviceArr:(NSArray *)serviceArr selectStr:(NSString *)selectStr confirmAction:(void (^)(NSMutableDictionary *))confirmAction {
    if (self = [super initWithFrame:frame]) {
        self.confirmAction = confirmAction;
        self.serviceArr = serviceArr;
        [self initializationViews:selectStr];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initializationViews:(NSString *)selectService {
    for (NSMutableDictionary *dict in self.serviceArr) {
        if ([dict[@"name"] isEqualToString:selectService]) {
            [dict setValue:@(1) forKey:@"select"];
            self.selectDict = dict;
        } else {
            [dict setValue:@(0) forKey:@"select"];
        }
    }
    
    UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0;
    [self addSubview:coverView];
    self.coverView = coverView;
    UITapGestureRecognizer *tapCover = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickClose)];
    [coverView addGestureRecognizer:tapCover];
    
    CGFloat wid = self.frame.size.width;
    CGFloat hei = self.frame.size.height;
    UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(0, hei, wid, hei*0.6)];
    panelView.backgroundColor = [UIColor whiteColor];
    panelView.layer.cornerRadius = 5;
    [self addSubview:panelView];
    self.panelView = panelView;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, wid-100, 44)];
    titleLab.text = @"选择服务";
    titleLab.textColor = COLOR_333333;
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [panelView addSubview:titleLab];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(wid-44, 0, 44, 44)];
    [closeBtn setImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    [panelView addSubview:closeBtn];
    
    ADLAttributeFlowLayout *layout = [[ADLAttributeFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 12;
    layout.minimumLineSpacing = 12;
    layout.sectionInset = UIEdgeInsetsMake(0, 12, 12, 12);
    layout.headerReferenceSize = CGSizeMake(wid, 44);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, wid, hei*0.6-50-VIEW_HEIGHT-BOTTOM_H) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [panelView addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView registerClass:[ADLGoodsAttributeCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionView registerClass:[ADLTextHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.frame = CGRectMake(0, hei*0.6-VIEW_HEIGHT-BOTTOM_H, wid, VIEW_HEIGHT+BOTTOM_H);
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.backgroundColor = APP_COLOR;
    [panelView addSubview:confirmBtn];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        coverView.alpha = 0.5;
        panelView.frame = CGRectMake(0, hei*0.4, wid, hei*0.6);
    }];
}

#pragma mark ------ UICollectionView Delegate && DataSource ------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.serviceArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADLGoodsAttributeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dict = self.serviceArr[indexPath.item];
    cell.text = [NSString stringWithFormat:@"%@ %.2f",dict[@"name"],[dict[@"startingPrice"] doubleValue]];
    if ([dict[@"select"] boolValue]) {
        cell.attrLab.layer.borderColor = APP_COLOR.CGColor;
        cell.attrLab.textColor = APP_COLOR;
    } else {
        cell.attrLab.layer.borderColor = COLOR_D3D3D3.CGColor;
        cell.attrLab.textColor = COLOR_333333;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ADLTextHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    headerView.titLab.text = @"安装服务";
    headerView.topView.hidden = YES;
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.serviceArr[indexPath.row];
    NSString *serStr = [NSString stringWithFormat:@"%@ %.2f",dict[@"name"], [dict[@"startingPrice"] doubleValue]];
    CGFloat wid = [serStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-24, 36) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width+20;
    return CGSizeMake(wid, 36);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *muDict = self.serviceArr[indexPath.row];
    if ([muDict[@"select"] integerValue] == 1) {
        [muDict setValue:@(0) forKey:@"select"];
        self.selectDict = nil;
    } else {
        for (int i = 0; i < self.serviceArr.count; i++) {
            NSMutableDictionary *dict = self.serviceArr[i];
            if (indexPath.item == i) {
                [dict setValue:@(1) forKey:@"select"];
                self.selectDict = dict;
            } else {
                [dict setValue:@(0) forKey:@"select"];
            }
        }
    }
    [collectionView reloadData];
}

#pragma mark ------ 确定 ------
- (void)clickConfirmBtn {
    [self clickClose];
    if (self.confirmAction) {
        self.confirmAction(self.selectDict);
    }
}

#pragma mark ------ 关闭 ------
- (void)clickClose {
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 0;
        self.panelView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.6);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
