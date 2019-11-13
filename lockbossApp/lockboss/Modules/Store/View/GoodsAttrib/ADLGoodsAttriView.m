//
//  ADLGoodsAttriView.m
//  lockboss
//
//  Created by adel on 2019/4/26.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsAttriView.h"
#import "ADLGlobalDefine.h"
#import "ADLApiDefine.h"
#import "ADLUserModel.h"
#import "ADLUtils.h"
#import "ADLToast.h"

#import "ORSKUDataFilter.h"
#import "ADLNetWorkManager.h"
#import "ADLLocalizedHelper.h"
#import "ADLKeyboardMonitor.h"

#import "ADLImagePreView.h"
#import "ADLTextHeaderView.h"
#import "ADLGoodsAttrFooter.h"
#import "ADLGoodsAttributeCell.h"
#import "ADLAttributeFlowLayout.h"

#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface ADLGoodsAttriView ()<UICollectionViewDataSource,UICollectionViewDelegate,ORSKUDataFilterDataSource,ADLGoodsAttrFooterDelegate>
@property (nonatomic, copy) void (^confirmAction) (NSMutableDictionary *selectDict);
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *selectDict;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, assign) BOOL confirm;

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *panelView;

//属性数据
@property (nonatomic, strong) NSArray *skuArr;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *serviceArr;
@property (nonatomic, strong) NSDictionary *serviceDict;

//头部信息
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *selectLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) NSString *imgUrl;

//sku选择
@property (nonatomic, assign) NSInteger inventoryCount;
@property (nonatomic, strong) ORSKUDataFilter *filter;
@property (nonatomic, assign) NSInteger limitCount;
@property (nonatomic, strong) NSString *orderId;//服务订单Id
@property (nonatomic, assign) NSInteger count;

@end

@implementation ADLGoodsAttriView
+ (instancetype)goodsAttributeViewWith:(NSDictionary *)dataDict confirmAction:(void (^)(NSMutableDictionary *))confirmAction {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds dataDict:dataDict confirmAction:confirmAction];
}

- (instancetype)initWithFrame:(CGRect)frame dataDict:(NSDictionary *)dataDict confirmAction:(void (^)(NSMutableDictionary *))confirmAction {
    if (self = [super initWithFrame:frame]) {
        self.confirm = [dataDict[@"confirm"] boolValue];
        self.imgUrl = [dataDict[@"imageUrl"] stringValue];
        self.count = [dataDict[@"count"] intValue];
        self.dataArr = dataDict[@"propertyVOList"];
        self.serviceArr = dataDict[@"serviceList"];
        self.serviceDict = dataDict[@"service"];
        self.skuArr = dataDict[@"skuList"];
        self.orderId = dataDict[@"orderId"];
        self.confirmAction = confirmAction;
        self.inventoryCount = NSIntegerMax;//不限制库存
        [self initializationViews:dataDict[@"select"]];
        [[ADLKeyboardMonitor monitor] setEnable:YES];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initializationViews:(NSString *)selectAttribute {
    //    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    //    for (NSDictionary *dict in self.skuArr) {
    //        if ([dict[@"inventory"] intValue] > 0) {
    //            [muArr addObject:dict];
    //        }
    //    }
    //    self.skuArr = muArr;
    
    UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0;
    [self addSubview:coverView];
    self.coverView = coverView;
    UITapGestureRecognizer *tapCover = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickClose)];
    [coverView addGestureRecognizer:tapCover];
    
    UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.75)];
    panelView.backgroundColor = [UIColor whiteColor];
    panelView.layer.cornerRadius = 5;
    [self addSubview:panelView];
    self.panelView = panelView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 70, 70)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    imageView.clipsToBounds = YES;
    [panelView addSubview:imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
    [imageView addGestureRecognizer:tap];
    self.imageView = imageView;
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-44, 0, 44, 44)];
    [closeBtn setImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    [panelView addSubview:closeBtn];
    
    UILabel *selectLab = [[UILabel alloc] init];
    selectLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    selectLab.textColor = COLOR_333333;
    selectLab.numberOfLines = 2;
    [panelView addSubview:selectLab];
    self.selectLab = selectLab;
    [selectLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(12);
        make.bottom.equalTo(imageView.mas_bottom);
        make.right.equalTo(panelView).offset(-12);
    }];
    
    UILabel *moneyLab = [[UILabel alloc] init];
    moneyLab.font = [UIFont systemFontOfSize:FONT_SIZE+2];
    moneyLab.textColor = APP_COLOR;
    [panelView addSubview:moneyLab];
    self.moneyLab = moneyLab;
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(12);
        make.bottom.equalTo(selectLab.mas_top).offset(-10);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 94, SCREEN_WIDTH-24, 0.5)];
    lineView.backgroundColor = SEPARATOR_COLOR;
    [panelView addSubview:lineView];
    
    ADLAttributeFlowLayout *layout = [[ADLAttributeFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 12;
    layout.minimumLineSpacing = 12;
    layout.sectionInset = UIEdgeInsetsMake(0, 12, 12, 12);
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 44);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 95, SCREEN_WIDTH, SCREEN_HEIGHT*0.75-95-VIEW_HEIGHT-BOTTOM_H) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [panelView addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView registerClass:[ADLGoodsAttributeCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionView registerClass:[ADLTextHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [collectionView registerClass:[ADLGoodsAttrFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.frame = CGRectMake(0, SCREEN_HEIGHT*0.75-VIEW_HEIGHT-BOTTOM_H, SCREEN_WIDTH, VIEW_HEIGHT);
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    NSString *btnTitle = self.confirm == YES ? @"确定":@"加入购物车";
    [confirmBtn setTitle:btnTitle forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.backgroundColor = APP_COLOR;
    [panelView addSubview:confirmBtn];
    self.confirmBtn = confirmBtn;
    
    _filter = [[ORSKUDataFilter alloc] initWithDataSource:self];
    if (selectAttribute) {
        NSArray *selArr = [selectAttribute componentsSeparatedByString:@", "];
        for (int i = 0; i < self.dataArr.count; i++) {
            NSArray *arr = self.dataArr[i][@"values"];
            for (int j = 0; j < arr.count; j++) {
                NSDictionary *dict = arr[j];
                if ([selArr containsObject:dict[@"propertyValue"]]) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                    [self.filter didSelectedPropertyWithIndexPath:indexPath];
                }
            }
        }
    } else {
        self.count = 1;
        _filter.needDefaultValue = YES;
    }
    
    [self updateSelectAttribute];
    [self.collectionView reloadData];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        coverView.alpha = 0.5;
        panelView.frame = CGRectMake(0, SCREEN_HEIGHT*0.25, SCREEN_WIDTH, SCREEN_HEIGHT*0.75);
    }];
}

#pragma mark ------ 更新选择 ------
- (void)updateSelectAttribute {
    self.selectDict = _filter.currentResult;
    if (self.selectDict == nil) {
        self.confirmBtn.enabled = NO;
        self.confirmBtn.backgroundColor = SEPARATOR_COLOR;
        [self.confirmBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:[UIImage imageNamed:@"img_square"]];
        
    } else {
        
        self.limitCount = [self.selectDict[@"activityInfo"][@"userBuyNum"] integerValue];
        //        self.inventoryCount = [self.selectDict[@"inventory"] integerValue];
        NSArray *selectArr = _filter.selectedIndexPaths;
        NSString *selectStr = @"已选：";
        selectArr = [selectArr sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *obj1, NSIndexPath *obj2) {
            if (obj1.section < obj2.section) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        }];
        for (NSIndexPath *indexPath in selectArr) {
            selectStr = [NSString stringWithFormat:@"%@%@, ",selectStr,self.dataArr[indexPath.section][@"values"][indexPath.row][@"propertyValue"]];
        }
        if (selectStr.length > 3) {
            self.selectLab.text = [selectStr substringToIndex:selectStr.length-2];
        } else {
            self.selectLab.text = selectStr;
        }
        
        if ([self.selectDict[@"activityInfo"][@"activityPrice"] doubleValue] > 0) {
            self.moneyLab.text = [NSString stringWithFormat:@"¥ %.2f",[self.selectDict[@"activityInfo"][@"activityPrice"] doubleValue]*self.count];
        } else {
            self.moneyLab.text = [NSString stringWithFormat:@"¥ %.2f",[self.selectDict[@"nowPrice"] doubleValue]*self.count];
        }
        
        if ([self.selectDict[@"skuImgUrl"] hasPrefix:@"http"]) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.selectDict[@"skuImgUrl"]] placeholderImage:[UIImage imageNamed:@"img_square"]];
        } else {
            if ([self.imgUrl hasPrefix:@"http"]) {
                [self.selectDict setValue:self.imgUrl forKey:@"skuImgUrl"];
            } else {
                [self.selectDict setValue:@"" forKey:@"skuImgUrl"];
            }
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.selectDict[@"skuImgUrl"]] placeholderImage:[UIImage imageNamed:@"img_square"]];
        }
    }
}

#pragma mark ------ ORSKUDataFilterDataSource ------
- (NSInteger)numberOfSectionsForPropertiesInFilter:(ORSKUDataFilter *)filter {
    return self.dataArr.count;
}

- (NSArray *)filter:(ORSKUDataFilter *)filter propertiesInSection:(NSInteger)section {
    if (self.dataArr.count > 0) {
        NSArray *arr = self.dataArr[section][@"values"];
        NSMutableArray *muArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in arr) {
            [muArr addObject:dict[@"propertyValue"]];
        }
        return muArr;
    } else {
        return nil;
    }
}

- (NSInteger)numberOfConditionsInFilter:(ORSKUDataFilter *)filter {
    return self.skuArr.count;
}

- (NSArray *)filter:(ORSKUDataFilter *)filter conditionForRow:(NSInteger)row {
    NSArray *arr = self.skuArr[row][@"propertyVOList"];
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [muArr addObject:dict[@"propertyValue"]];
    }
    return muArr;
}

- (id)filter:(ORSKUDataFilter *)filter resultOfConditionForRow:(NSInteger)row {
    return self.skuArr[row];
}

#pragma mark ------ 加入购物车,选择属性 ------
- (void)clickConfirmBtn {
    if (self.confirm) {
        if (self.confirmAction) {
            [self.selectDict setValue:[self.selectLab.text substringFromIndex:3] forKey:@"select"];
            [self.selectDict setValue:self.serviceDict forKey:@"service"];
            [self.selectDict setValue:@(self.count) forKey:@"count"];
            self.confirmAction(self.selectDict);
        }
        [self clickClose];
    } else {
        if ([ADLUserModel sharedModel].login) {
            [ADLToast showLoadingMessage:ADLString(@"loading")];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:@(self.count) forKey:@"num"];
            [params setValue:self.selectDict[@"id"] forKey:@"skuId"];
            if (self.serviceDict) {
                [params setValue:self.serviceDict[@"id"] forKey:@"services"];
            } else {
                [params setValue:@"" forKey:@"services"];
            }
            if (self.orderId) {
                [params setValue:self.orderId forKey:@"serviceOrderId"];
            }
            [ADLNetWorkManager postWithPath:k_add_car parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
                if ([responseDict[@"code"] integerValue] == 10000) {
                    [ADLToast showMessage:@"添加成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_SHOPPING_CAR object:@"refresh" userInfo:nil];
                    [self clickClose];
                }
            } failure:nil];
        } else {
            [self clickClose];
            if (self.confirmAction) {
                self.confirmAction(nil);
            }
        }
    }
}

#pragma mark ------ 点击商品图片 ------
- (void)clickImageView:(UITapGestureRecognizer *)tap {
    if (self.selectDict == nil) {
        [ADLImagePreView showWithImageViews:@[self.imageView] urlArray:@[self.imgUrl] currentIndex:0];
    } else {
        [ADLImagePreView showWithImageViews:@[self.imageView] urlArray:@[[self.selectDict[@"skuImgUrl"] stringValue]] currentIndex:0];
    }
}

#pragma mark ------ UICollectionView Delegate && DataSource ------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.serviceArr.count > 0) {
        return self.dataArr.count+1;
    } else {
        return self.dataArr.count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == self.dataArr.count) {
        return self.serviceArr.count;
    } else {
        NSArray *arr = self.dataArr[section][@"values"];
        return arr.count;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        ADLTextHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        if (indexPath.section == self.dataArr.count) {
            headerView.titLab.text = @"安装服务";
        } else {
            headerView.titLab.text = self.dataArr[indexPath.section][@"propertyName"];
            if (indexPath.section == 0) {
                headerView.topView.hidden = YES;
            } else {
                headerView.topView.hidden = NO;
            }
        }
        return headerView;
    } else {
        if (indexPath.section == self.dataArr.count-1) {
            ADLGoodsAttrFooter *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
            footerView.numTF.text = [NSString stringWithFormat:@"%ld",self.count];
            footerView.delegate = self;
            if (self.selectDict == nil) {
                footerView.numTF.enabled = NO;
                [footerView.addBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
                [footerView.reduceBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
            } else {
                NSInteger buyCount = self.inventoryCount;
                if (self.limitCount > 0) {
                    if (self.limitCount < self.inventoryCount) {
                        buyCount = self.limitCount;
                    }
                }
                if (buyCount == self.count) {
                    [footerView.addBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
                } else {
                    [footerView.addBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
                }
                if (self.count == 1) {
                    [footerView.reduceBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
                } else {
                    [footerView.reduceBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
                }
            }
            return footerView;
        } else {
            return [UICollectionReusableView new];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == self.dataArr.count-1) {
        return CGSizeMake(SCREEN_WIDTH, 54);
    } else {
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.dataArr.count) {
        NSDictionary *dict = self.serviceArr[indexPath.row];
        NSString *serStr = [NSString stringWithFormat:@"%@ %.2f",dict[@"name"], [dict[@"startingPrice"] doubleValue]];
        CGFloat wid = [serStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-24, 36) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width+20;
        return CGSizeMake(wid, 36);
    } else {
        NSArray *arr = self.dataArr[indexPath.section][@"values"];
        NSDictionary *dict = arr[indexPath.item];
        NSString *str = dict[@"propertyValue"];
        CGFloat wid = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-24, 36) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width+20;
        return CGSizeMake(wid, 36);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADLGoodsAttributeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == self.dataArr.count) {
        NSDictionary *dict = self.serviceArr[indexPath.row];
        cell.attrLab.backgroundColor = [UIColor whiteColor];
        cell.text = [NSString stringWithFormat:@"%@ %.2f",dict[@"name"],[dict[@"startingPrice"] doubleValue]];
        if ([dict[@"id"] isEqualToString:self.serviceDict[@"id"]]) {
            cell.attrLab.layer.borderColor = APP_COLOR.CGColor;
            cell.attrLab.textColor = APP_COLOR;
        } else {
            cell.attrLab.layer.borderColor = COLOR_D3D3D3.CGColor;
            cell.attrLab.textColor = COLOR_333333;
        }
        
    } else {
        NSArray *arr = self.dataArr[indexPath.section][@"values"];
        NSDictionary *dict = arr[indexPath.item];
        cell.text = dict[@"propertyValue"];
        
        if ([_filter.availableIndexPathsSet containsObject:indexPath]) {
            cell.attrLab.layer.borderColor = COLOR_D3D3D3.CGColor;
            cell.attrLab.textColor = COLOR_333333;
            cell.attrLab.backgroundColor = [UIColor whiteColor];
        } else {
            cell.attrLab.layer.borderColor = SEPARATOR_COLOR.CGColor;
            cell.attrLab.textColor = COLOR_999999;
            cell.attrLab.backgroundColor = SEPARATOR_COLOR;
        }
        
        if ([_filter.selectedIndexPaths containsObject:indexPath]) {
            cell.attrLab.backgroundColor = [UIColor whiteColor];
            cell.attrLab.layer.borderColor = APP_COLOR.CGColor;
            cell.attrLab.textColor = APP_COLOR;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.dataArr.count) {
        if ([self.serviceDict[@"id"] isEqualToString:self.serviceArr[indexPath.item][@"id"]]) {
            self.serviceDict = nil;
        } else {
            self.serviceDict = self.serviceArr[indexPath.item];
        }
        [collectionView reloadData];
    } else {
        if (![_filter.selectedIndexPaths containsObject:indexPath]) {
            [_filter didSelectedPropertyWithIndexPath:indexPath];
            [self updateSelectAttribute];
            [collectionView reloadData];
        }
    }
}

#pragma mark ------ 开始编辑 ------
- (void)didBeginEditing:(UITextField *)textField {
    CGFloat offsetY = self.collectionView.contentOffset.y;
    CGFloat bottomH = [ADLUtils convertRectWithView:textField];
    __weak typeof(self)weakSelf = self;
    [ADLKeyboardMonitor monitor].keyboardHeightChanged = ^(CGFloat keyboardH) {
        if (keyboardH == 0) {
            [weakSelf.collectionView setContentOffset:CGPointMake(0, offsetY) animated:YES];
        } else {
            if (bottomH < keyboardH) {
                [weakSelf.collectionView setContentOffset:CGPointMake(0, offsetY+keyboardH-bottomH) animated:YES];
            }
        }
    };
}

#pragma mark ------ 数量改变 ------
- (void)didChangedCount:(NSInteger)count footerView:(ADLGoodsAttrFooter *)footerView {
    if (self.selectDict) {
        NSInteger buyCount = self.inventoryCount;
        if (self.limitCount > 0) {
            if (self.limitCount < self.inventoryCount) {
                buyCount = self.limitCount;
            }
        }
        if (count > buyCount) {
            count = buyCount;
        }
        if (count == 0) {
            count = 1;
        }
        self.count = count;
        
        if (count == buyCount) {
            [footerView.addBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        } else {
            [footerView.addBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        }
        if (count == 1) {
            [footerView.reduceBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        } else {
            [footerView.reduceBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        }
        
        footerView.numTF.text = [NSString stringWithFormat:@"%ld",count];
        if ([self.selectDict[@"activityInfo"][@"activityPrice"] doubleValue] > 0) {
            self.moneyLab.text = [NSString stringWithFormat:@"¥ %.2f",[self.selectDict[@"activityInfo"][@"activityPrice"] doubleValue]*count];
        } else {
            self.moneyLab.text = [NSString stringWithFormat:@"¥ %.2f",[self.selectDict[@"nowPrice"] doubleValue]*count];
        }
    }
}

#pragma mark ------ 点击CoverView/关闭按钮 ------
- (void)clickClose {
    if (self.confirm == NO && self.confirmAction) {
        if (self.selectDict) {
            [self.selectDict setValue:[self.selectLab.text substringFromIndex:3] forKey:@"select"];
            [self.selectDict setValue:self.serviceDict forKey:@"service"];
            [self.selectDict setValue:@(self.count) forKey:@"count"];
        }
        self.confirmAction(self.selectDict);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 0;
        self.panelView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.75);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dealloc {
    [[ADLKeyboardMonitor monitor] setEnable:NO];
}

@end
