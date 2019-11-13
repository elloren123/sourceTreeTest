//
//  ADLClassifyPullView.m
//  lockboss
//
//  Created by adel on 2019/5/27.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLClassifyPullView.h"
#import "ADLClassifyItemView.h"
#import "ADLClassifySelCell.h"
#import "ADLGlobalDefine.h"

@interface ADLClassifyPullView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, copy) void (^confirmAction) (NSString *brandId, NSString *classifyId, NSString *proValueId);
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *itemViewArr;
@property (nonatomic, strong) NSMutableArray *itemArr;
@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UIView *linkView;
@property (nonatomic, assign) NSInteger index;

@end

@implementation ADLClassifyPullView

+ (instancetype)pullViewWithFrameY:(CGFloat)frameY dataArr:(NSArray *)dataArr confirmAction:(void (^)(NSString *, NSString *, NSString *))confirmAction {
    return [[self alloc] initWithFrame:CGRectMake(0, frameY, SCREEN_WIDTH, 50.5) dataArr:dataArr confirmAction:confirmAction];
}

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr confirmAction:(void (^)(NSString *, NSString *, NSString *))confirmAction {
    if (self = [super initWithFrame:frame]) {
        self.confirmAction = confirmAction;
        self.dataArr = dataArr;
        [self setupView];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)setupView {
    CGFloat wid = self.frame.size.width;
    NSInteger count = self.dataArr.count;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, wid, 50)];
    scrollView.contentSize = CGSizeMake(count*112+12, 50);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    
    UIView *linkView = [[UIView alloc] init];
    linkView.backgroundColor = COLOR_F7F7F7;
    [scrollView addSubview:linkView];
    self.linkView = linkView;
    
    self.itemArr = [[NSMutableArray alloc] init];
    self.itemViewArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        ADLClassifyItemView *itemView = [[NSBundle mainBundle] loadNibNamed:@"ADLClassifyItemView" owner:nil options:nil].lastObject;
        itemView.frame = CGRectMake(12+(i%count)*112, 8, 100, 34);
        itemView.titLab.text = self.dataArr[i][@"name"];
        itemView.layer.cornerRadius = 17;
        itemView.tag = i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItemView:)];
        [itemView addGestureRecognizer:tap];
        [scrollView addSubview:itemView];
        [self.itemViewArr addObject:itemView];
    }
    
    UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, wid, 0.5)];
    spView.backgroundColor = SEPARATOR_COLOR;
    [self addSubview:spView];
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, wid, SCREEN_HEIGHT)];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0;
    [self addSubview:coverView];
    self.coverView = coverView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCoverView)];
    [coverView addGestureRecognizer:tap];
    
    UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, wid, 0)];
    panelView.backgroundColor = COLOR_F7F7F7;
    panelView.clipsToBounds = YES;
    [self addSubview:panelView];
    self.panelView = panelView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    layout.itemSize = CGSizeMake(wid/2-1, 38);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, wid, SCREEN_HEIGHT*0.4-ROW_HEIGHT) collectionViewLayout:layout];
    collectionView.backgroundColor = COLOR_F7F7F7;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [panelView addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView registerNib:[UINib nibWithNibName:@"ADLClassifySelCell" bundle:nil] forCellWithReuseIdentifier:@"PullCell"];
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    resetBtn.frame = CGRectMake(0, SCREEN_HEIGHT*0.4-ROW_HEIGHT, wid/2, ROW_HEIGHT);
    [resetBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(clickResetButton) forControlEvents:UIControlEventTouchUpInside];
    resetBtn.backgroundColor = [UIColor whiteColor];
    [panelView addSubview:resetBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.frame = CGRectMake(wid/2, SCREEN_HEIGHT*0.4-ROW_HEIGHT, wid/2, ROW_HEIGHT);
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.backgroundColor = APP_COLOR;
    [panelView addSubview:confirmBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.4-ROW_HEIGHT, wid, 0.5)];
    lineView.backgroundColor = SEPARATOR_COLOR;
    [panelView addSubview:lineView];
}

#pragma mark ------ UICollectionDelegate && DataSource ------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADLClassifySelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PullCell" forIndexPath:indexPath];
    NSDictionary *dict = self.itemArr[indexPath.row];
    cell.titLab.text = dict[self.dataArr[self.index][@"key"]];
    if ([dict[@"select"] boolValue]) {
        cell.imgView.hidden = NO;
        cell.titLab.textColor = APP_COLOR;
    } else {
        cell.imgView.hidden = YES;
        cell.titLab.textColor = COLOR_333333;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *muDict = self.itemArr[indexPath.row];
    if ([muDict[@"select"] boolValue]) {
        [muDict setValue:@(NO) forKey:@"select"];
    } else {
        [muDict setValue:@(YES) forKey:@"select"];
    }
    [collectionView reloadData];
}

#pragma mark ------ 点击Item ------
- (void)clickItemView:(UITapGestureRecognizer *)tap {
    NSInteger tag = tap.view.tag;
    ADLClassifyItemView *itemView = self.itemViewArr[tag];
    self.linkView.frame = CGRectMake(itemView.frame.origin.x, 25, 100, 25);
    
    if (itemView.select) {
        itemView.layer.borderWidth = 0;
        itemView.backgroundColor = COLOR_F7F7F7;
    }
    
    if (self.frame.size.height > 51) {
        ADLClassifyItemView *oldItemView = self.itemViewArr[self.index];
        if (oldItemView.select) {
            oldItemView.layer.borderWidth = 0.5;
            oldItemView.backgroundColor = COLOR_F7E4E4;
        }
        if (tag != self.index) {
            [UIView animateWithDuration:0.3 animations:^{
                oldItemView.imgView.transform = CGAffineTransformIdentity;
            }];
        }
        if (itemView.check) {
            [self clickCoverView];
        } else {
            [self.itemArr removeAllObjects];
            NSArray *arr = self.dataArr[tag][@"data"];
            for (NSMutableDictionary *dict in arr) {
                [self.itemArr addObject:[dict mutableCopy]];
            }
            [self.collectionView reloadData];
            
            [UIView animateWithDuration:0.3 animations:^{
                itemView.imgView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        }
        oldItemView.check = NO;
        itemView.check = YES;
        self.index = tag;
    } else {
        [self.itemArr removeAllObjects];
        NSArray *arr = self.dataArr[tag][@"data"];
        for (NSMutableDictionary *dict in arr) {
            [self.itemArr addObject:[dict mutableCopy]];
        }
        [self.collectionView reloadData];
        
        CGRect frame = self.frame;
        frame.size.height = SCREEN_HEIGHT;
        self.frame = frame;
        itemView.check = YES;
        self.index = tag;
        [UIView animateWithDuration:0.3 animations:^{
            self.coverView.alpha = 0.3;
            itemView.imgView.transform = CGAffineTransformMakeRotation(M_PI);
            self.panelView.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT*0.4);
        }];
    }
}

#pragma mark ------ 点击遮罩 ------
- (void)clickCoverView {
    ADLClassifyItemView *itemView = self.itemViewArr[self.index];
    self.linkView.frame = CGRectMake(itemView.frame.origin.x, 25, 100, 0);
    itemView.check = NO;
    
    if (itemView.select) {
        itemView.layer.borderWidth = 0.5;
        itemView.backgroundColor = COLOR_F7E4E4;
    }
    
    CGRect frame = self.panelView.frame;
    frame.size.height = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 0;
        self.panelView.frame = frame;
        itemView.imgView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        CGRect fra = self.frame;
        fra.size.height = 50;
        self.frame = fra;
    }];
}

#pragma mark ------ 重置 ------
- (void)clickResetButton {
    for (NSMutableDictionary *dict in self.itemArr) {
        [dict setValue:@(NO) forKey:@"select"];
    }
    [self.collectionView reloadData];
}

#pragma mark ------ 确定 ------
- (void)clickConfirmButton {
    [self clickCoverView];
    NSMutableString *selectStr = [[NSMutableString alloc] init];
    NSString *key = self.dataArr[self.index][@"key"];
    for (NSMutableDictionary *dict in self.itemArr) {
        if ([dict[@"select"] boolValue]) {
            [selectStr appendString:dict[key]];
            [selectStr appendString:@","];
        }
    }
    
    NSMutableDictionary *dataDict = self.dataArr[self.index];
    [dataDict setValue:[self.itemArr mutableCopy] forKey:@"data"];
    
    ADLClassifyItemView *itemView = self.itemViewArr[self.index];
    self.linkView.frame = CGRectMake(itemView.frame.origin.x, 25, 100, 0);
    if (selectStr.length > 0) {
        itemView.titLab.text = [selectStr substringToIndex:selectStr.length-1];
        itemView.imgView.image = [UIImage imageNamed:@"classify_down_sel"];
        itemView.backgroundColor = COLOR_F7E4E4;
        itemView.titLab.textColor = APP_COLOR;
        itemView.layer.borderWidth = 0.5;
        itemView.select = YES;
    } else {
        itemView.titLab.text = self.dataArr[self.index][@"name"];
        itemView.imgView.image = [UIImage imageNamed:@"classify_down_nor"];
        itemView.titLab.textColor = COLOR_333333;
        itemView.backgroundColor = COLOR_F7F7F7;
        itemView.layer.borderWidth = 0;
        itemView.select = NO;
    }
    
    NSMutableArray *brandArr = [[NSMutableArray alloc] init];
    NSMutableArray *classifyArr = [[NSMutableArray alloc] init];
    NSMutableArray *proValueArr = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in self.dataArr) {
        NSArray *itemArr = dict[@"data"];
        if ([dict[@"key"] isEqualToString:@"name"]) {
            for (NSDictionary *branDict in itemArr) {
                if ([branDict[@"select"] boolValue]) {
                    [brandArr addObject:branDict[@"id"]];
                }
            }
        } else if ([dict[@"key"] isEqualToString:@"className"]) {
            for (NSDictionary *clasDict in itemArr) {
                if ([clasDict[@"select"] boolValue]) {
                    [classifyArr addObject:clasDict[@"id"]];
                }
            }
        } else {
            NSMutableDictionary *proDict = [[NSMutableDictionary alloc] init];
            NSMutableArray *proArr = [[NSMutableArray alloc] init];
            for (NSDictionary *itemDict in itemArr) {
                if ([itemDict[@"select"] boolValue]) {
                    [proArr addObject:itemDict[@"id"]];
                }
            }
            if (proArr.count > 0) {
                [proDict setValue:proArr forKey:@"vids"];
                [proValueArr addObject:proDict];
            }
        }
    }
    NSString *brandId = nil;
    NSString *classifyId = nil;
    NSString *proValueId = nil;
    
    if (brandArr.count > 0) {
        NSData *branData = [NSJSONSerialization dataWithJSONObject:brandArr options:kNilOptions error:nil];
        brandId = [[NSString alloc] initWithData:branData encoding:NSUTF8StringEncoding];
    }
    if (classifyArr.count > 0) {
        NSData *clasData = [NSJSONSerialization dataWithJSONObject:classifyArr options:kNilOptions error:nil];
        classifyId = [[NSString alloc] initWithData:clasData encoding:NSUTF8StringEncoding];
    }
    if (proValueArr.count > 0) {
        NSData *provData = [NSJSONSerialization dataWithJSONObject:proValueArr options:kNilOptions error:nil];
        proValueId = [[NSString alloc] initWithData:provData encoding:NSUTF8StringEncoding];
    }
    
    if (self.confirmAction) {
        self.confirmAction(brandId, classifyId, proValueId);
    }
}

@end
