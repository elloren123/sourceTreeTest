//
//  ADLGoodsHeaderView.m
//  lockboss
//
//  Created by Han on 2019/7/21.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLGoodsHeaderView.h"
#import "ADLGoodsActivityView.h"
#import "ADLGoodsNameView.h"
#import "ADLGlobalDefine.h"
#import "ADLImagePreView.h"
#import "ADLGoodsEvaluateCell.h"
#import "ADLUtils.h"

#import <UIImageView+WebCache.h>

@interface ADLGoodsHeaderView ()<UIScrollViewDelegate,ADLGoodsEvaluateCellDelegate>
@property (nonatomic, strong) ADLGoodsActivityView *activityView;
@property (nonatomic, strong) ADLGoodsNameView *nameView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *indexLab;
@property (nonatomic, strong) NSArray *urlArr;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL activity;
///商品图片加标题高度
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UILabel *attributeLab;
@property (nonatomic, strong) UILabel *addressLab;
@property (nonatomic, strong) UILabel *evaluateLab;
@property (nonatomic, strong) UILabel *evaRateLab;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) CGFloat originalH;
@property (nonatomic, strong) UIView *evaluateView;
@property (nonatomic, strong) UIView *relevantView;
@property (nonatomic, strong) NSMutableArray *evaluateArr;
@property (nonatomic, strong) NSArray *relevantArr;
@property (nonatomic, strong) ADLGoodsEvaluateCell *firstCell;
@property (nonatomic, strong) ADLGoodsEvaluateCell *secondCell;
@end

@implementation ADLGoodsHeaderView

+ (instancetype)headerViewWithHeight:(CGFloat)height imgUrls:(NSArray *)imgUrls activity:(BOOL)activity {
    return [[self alloc] initWithHeight:height imgUrls:imgUrls activity:activity];
}

- (instancetype)initWithHeight:(CGFloat)height imgUrls:(NSArray *)imgUrls activity:(BOOL)activity {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height+ROW_HEIGHT*2+VIEW_HEIGHT+24)]) {
        self.originalH = height+ROW_HEIGHT*2+VIEW_HEIGHT+24;
        self.height = height;
        self.urlArr = imgUrls;
        self.activity = activity;
        [self initializationView];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initializationView {
    if (self.urlArr.count == 0) {
        self.urlArr = @[@""];
    }
    NSInteger count = self.urlArr.count;
    if (count == 1) {
        [self creatImageimgWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) urlStr:self.urlArr.firstObject tag:0];
    } else {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        [self creatImageimgWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) urlStr:self.urlArr.lastObject tag:count-1];
        for (int i = 0; i < count; i++) {
            [self creatImageimgWithFrame:CGRectMake((i+1)*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_WIDTH) urlStr:self.urlArr[i] tag:i];
        }
        [self creatImageimgWithFrame:CGRectMake((self.urlArr.count+1)*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_WIDTH) urlStr:self.urlArr.firstObject tag:0];
        
        scrollView.contentSize = CGSizeMake((count+2)*SCREEN_WIDTH, 0);
        scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        UILabel *indexLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, SCREEN_WIDTH-32, 40, 20)];
        indexLab.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        indexLab.text = [NSString stringWithFormat:@"1/%lu",self.urlArr.count];
        indexLab.textAlignment = NSTextAlignmentCenter;
        indexLab.font = [UIFont systemFontOfSize:12];
        indexLab.textColor = [UIColor whiteColor];
        indexLab.layer.cornerRadius = 10;
        indexLab.clipsToBounds = YES;
        [self addSubview:indexLab];
        self.indexLab = indexLab;
    }
    
    if (self.activity) {
        ADLGoodsActivityView *activityView = [[NSBundle mainBundle] loadNibNamed:@"ADLGoodsActivityView" owner:nil options:nil].lastObject;
        activityView.frame = CGRectMake(0, SCREEN_WIDTH, SCREEN_WIDTH, self.height-SCREEN_WIDTH);
        [self addSubview:activityView];
        self.activityView = activityView;
        
    } else {
        ADLGoodsNameView *nameView = [[NSBundle mainBundle] loadNibNamed:@"ADLGoodsNameView" owner:nil options:nil].lastObject;
        nameView.frame = CGRectMake(0, SCREEN_WIDTH, SCREEN_WIDTH, self.height-SCREEN_WIDTH);
        [self addSubview:nameView];
        self.nameView = nameView;
    }
    
    UIView *spView1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, SCREEN_WIDTH, 8)];
    spView1.backgroundColor = COLOR_F2F2F2;
    [self addSubview:spView1];
    
    UILabel *attrLab = [[UILabel alloc] initWithFrame:CGRectMake(12, self.height+8, 50, ROW_HEIGHT)];
    attrLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    attrLab.textColor = COLOR_666666;
    attrLab.text = @"已选";
    [self addSubview:attrLab];
    
    UILabel *attributeLab = [[UILabel alloc] initWithFrame:CGRectMake(60, self.height+8, SCREEN_WIDTH-90, ROW_HEIGHT)];
    attributeLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    attributeLab.textColor = COLOR_333333;
    [self addSubview:attributeLab];
    self.attributeLab = attributeLab;
    
    UIImageView *attrImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20, self.height+8, 8, ROW_HEIGHT)];
    attrImgView.image = [UIImage imageNamed:@"tableView_indicator"];
    attrImgView.contentMode = UIViewContentModeCenter;
    [self addSubview:attrImgView];
    
    UIButton *attributeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height+8, SCREEN_WIDTH, ROW_HEIGHT)];
    [attributeBtn addTarget:self action:@selector(clickAttributeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:attributeBtn];
    
    UILabel *addLab = [[UILabel alloc] initWithFrame:CGRectMake(12, self.height+ROW_HEIGHT+8, 50, ROW_HEIGHT)];
    addLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    addLab.textColor = COLOR_666666;
    addLab.text = @"送至";
    [self addSubview:addLab];
    
    UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(60, self.height+ROW_HEIGHT+8, SCREEN_WIDTH-90, ROW_HEIGHT)];
    addressLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    addressLab.textColor = COLOR_333333;
    [self addSubview:addressLab];
    self.addressLab = addressLab;
    
    UIImageView *addImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20, self.height+ROW_HEIGHT+8, 8, ROW_HEIGHT)];
    addImgView.image = [UIImage imageNamed:@"tableView_indicator"];
    addImgView.contentMode = UIViewContentModeCenter;
    [self addSubview:addImgView];
    
    UIButton *addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height+ROW_HEIGHT+8, SCREEN_WIDTH, ROW_HEIGHT)];
    [addressBtn addTarget:self action:@selector(clickAddressBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addressBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height+ROW_HEIGHT+8, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = SEPARATOR_COLOR;
    [self addSubview:lineView];
    
    UIView *spView2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.height+ROW_HEIGHT*2+8, SCREEN_WIDTH, 8)];
    spView2.backgroundColor = COLOR_F2F2F2;
    [self addSubview:spView2];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(12, self.height+ROW_HEIGHT*2+VIEW_HEIGHT/2+8, 3, 16)];
    redView.backgroundColor = APP_COLOR;
    [self addSubview:redView];
    
    UILabel *evaluateLab = [[UILabel alloc] initWithFrame:CGRectMake(23, self.height+ROW_HEIGHT*2+16, SCREEN_WIDTH-150, VIEW_HEIGHT)];
    evaluateLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    evaluateLab.textColor = COLOR_333333;
    evaluateLab.text = @"暂无评价(0)";
    [self addSubview:evaluateLab];
    self.evaluateLab = evaluateLab;
    
    UILabel *evaRateLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-115, self.height+ROW_HEIGHT*2+16, 90, VIEW_HEIGHT)];
    evaRateLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    evaRateLab.textAlignment = NSTextAlignmentRight;
    evaRateLab.textColor = COLOR_333333;
    evaRateLab.hidden = YES;
    [self addSubview:evaRateLab];
    self.evaRateLab = evaRateLab;
    
    UIImageView *evaImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20, self.height+ROW_HEIGHT*2+16, 8, VIEW_HEIGHT)];
    evaImgView.image = [UIImage imageNamed:@"tableView_indicator"];
    evaImgView.contentMode = UIViewContentModeCenter;
    [self addSubview:evaImgView];
    
    UIButton *evaCountBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height+ROW_HEIGHT*2+16, SCREEN_WIDTH, ROW_HEIGHT)];
    [evaCountBtn addTarget:self action:@selector(clickLookAllEvaluateBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:evaCountBtn];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height+ROW_HEIGHT*2+VIEW_HEIGHT+16, SCREEN_WIDTH, 8)];
    bottomView.backgroundColor = COLOR_F2F2F2;
    [self addSubview:bottomView];
    self.bottomView = bottomView;
}

#pragma mark ------ 创建UIImageView ------
- (void)creatImageimgWithFrame:(CGRect)frame urlStr:(NSString *)urlStr tag:(NSInteger)tag {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.userInteractionEnabled = YES;
    imgView.clipsToBounds = YES;
    imgView.tag = tag;
    [imgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"img_rectangle"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
    [imgView addGestureRecognizer:tap];
    if (self.scrollView) {
        [self.scrollView addSubview:imgView];
    } else {
        [self addSubview:imgView];
    }
}

#pragma mark ------ 更新商品名称 ------
- (void)updateGoodsName:(NSString *)goodsName goodsTitle:(NSString *)goodsTitle {
    if (self.activity) {
        self.activityView.nameLab.text = goodsName;
        self.activityView.descLab.text = goodsTitle;
    } else {
        self.nameView.nameLab.text = goodsName;
        self.nameView.descLab.text = goodsTitle;
    }
}

#pragma mark ------ 更新价格、库存 ------
- (void)updatePrice:(double)price money:(double)money inventory:(NSString *)inventory {
    NSString *priceStr = [NSString stringWithFormat:@"¥ %.2f",price];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, 1)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(priceStr.length-3, 3)];
    if (self.activity) {
        self.activityView.priceLab.attributedText = attributeStr;
        self.activityView.moneyLab.text = [NSString stringWithFormat:@"¥ %.2f",money];
//        self.activityView.inventoryLab.text = inventory;
    } else {
        self.nameView.priceLab.attributedText = attributeStr;
//        self.nameView.inventoryLab.text = inventory;
    }
}

#pragma mark ------ 活动商品是否开始更新时间 ------
- (void)updateActivityGoodsTime:(BOOL)update {
    if (self.activity) {
        if (update) {
            if ([self.timer isValid]) {
                [self.timer invalidate];
            }
            [self updateTime];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        } else {
            [self.timer invalidate];
        }
    }
}

#pragma mark ------ 更新时间 ------
- (void)updateTime {
    [ADLUtils calculateDateInterval:self.timestamp includeDay:NO finish:^(NSString *day, NSString *hour, NSString *minute, NSString *second) {
        self.activityView.hourLab.text = hour;
        self.activityView.minuteLab.text = minute;
        self.activityView.secondLab.text = second;
    }];
}

#pragma mark ------ 更新属性视图 ------
- (void)updateSelectAttribute:(NSString *)attribute {
    self.attributeLab.text = attribute;
}

#pragma mark ------ 更新收货地址 ------
- (void)updateShipAddress:(NSString *)address {
    self.addressLab.text = address;
}

#pragma mark ------ 更新评价数量 ------
- (void)updateEvaluateCount:(NSDictionary *)dict {
    if ([dict[@"allNum"] integerValue] > 0) {
        self.evaluateLab.text = [NSString stringWithFormat:@"商品评价(%@)",dict[@"allNum"]];
        NSString *rateStr = [NSString stringWithFormat:@"好评度 %d%%",(int)(([dict[@"goodsNum"] doubleValue]/[dict[@"allNum"] doubleValue])*100)];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:rateStr];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:NSMakeRange(4, rateStr.length-4)];
        self.evaRateLab.attributedText = attributeStr;
        self.evaluateLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
        self.evaRateLab.hidden = NO;
    }
}

#pragma mark ------ 更新评价内容 ------
- (void)updateEvaluateInfWithEvaluateArr:(NSMutableArray *)evaArr heiArr:(NSArray *)heiArr {
    if (evaArr.count > 0) {
        if (self.evaluateView) {
            if (evaArr.count == 1) {
                [self updateEvaluateData:evaArr.firstObject];
            } else {
                [self updateEvaluateData:evaArr.firstObject];
                [self updateEvaluateData:evaArr.lastObject];
            }
        } else {
            UIView *evaluateView = [[UIView alloc] init];
            self.evaluateView = evaluateView;
            self.evaluateArr = evaArr;
            [self addSubview:evaluateView];
            
            CGFloat originalY = 0;
            for (int i = 0; i < evaArr.count; i++) {
                ADLGoodsEvaluateCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ADLGoodsEvaluateCell" owner:nil options:nil].lastObject;
                cell.frame = CGRectMake(0, originalY, SCREEN_WIDTH, [heiArr[i] floatValue]);
                NSDictionary *dict = evaArr[i];
                [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[dict[@"headShot"] stringValue]] placeholderImage:[UIImage imageNamed:@"user_head"]];
                cell.nickLab.text = dict[@"addUser"];
                cell.dateLab.text = dict[@"addDatetime"];
                cell.starView.image = [ADLUtils getStarImageWithCount:[dict[@"description"] integerValue]];
                cell.descLab.text = dict[@"evaluateInfo"];
                [cell updateImageViewImage:dict[@"imgArr"] width:SCREEN_WIDTH-24];
                [cell.evaluateBtn setTitle:[NSString stringWithFormat:@"  %@",dict[@"replyNum"]] forState:UIControlStateNormal];
                [cell.likeBtn setTitle:[NSString stringWithFormat:@"  %@",dict[@"praiseNum"]] forState:UIControlStateNormal];
                if ([dict[@"isPraise"] boolValue]) {
                    cell.likeBtn.selected = YES;
                } else {
                    cell.likeBtn.selected = NO;
                }
                cell.modelLab.text = dict[@"skuName"];
                cell.delegate = self;
                if (i == evaArr.count-1) {
                    cell.spView.hidden = YES;
                }
                [evaluateView addSubview:cell];
                originalY = originalY+[heiArr[i] floatValue];
                
                if (i == 0) {
                    self.firstCell = cell;
                    UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFirstEvaluateCell)];
                    [cell addGestureRecognizer:firstTap];
                } else {
                    self.secondCell = cell;
                    UITapGestureRecognizer *secondTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSecondEvaluateCell)];
                    [cell addGestureRecognizer:secondTap];
                }
            }
            
            UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            spView.backgroundColor = SEPARATOR_COLOR;
            [evaluateView addSubview:spView];
            
            UIButton *lookAllBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            lookAllBtn.frame = CGRectMake(SCREEN_WIDTH/2-60, originalY+3, 120, 38);
            [lookAllBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
            lookAllBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [lookAllBtn setTitle:@"查看全部评价" forState:UIControlStateNormal];
            lookAllBtn.layer.cornerRadius = 19;
            lookAllBtn.layer.borderWidth = 0.5;
            lookAllBtn.layer.borderColor = COLOR_D3D3D3.CGColor;
            [lookAllBtn addTarget:self action:@selector(clickLookAllEvaluateBtn) forControlEvents:UIControlEventTouchUpInside];
            [evaluateView addSubview:lookAllBtn];
            
            evaluateView.frame = CGRectMake(0, self.originalH-8, SCREEN_WIDTH, originalY+53);
            self.bottomView.frame = CGRectMake(0, self.originalH+originalY+45+self.relevantView.frame.size.height, SCREEN_WIDTH, 8);
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.originalH+originalY+53+self.relevantView.frame.size.height);
            CGRect frame = self.relevantView.frame;
            frame.origin.y = self.originalH+originalY+45;
            self.relevantView.frame = frame;
        }
    }
}

#pragma mark ------ 更新评价数据 ------
- (void)updateEvaluateData:(NSMutableDictionary *)dict {
    if (self.evaluateArr.count == 1) {
        NSDictionary *evaDict = self.evaluateArr.firstObject;
        if ([evaDict[@"id"] isEqualToString:dict[@"id"]]) {
            [self updateEvaluateStatus:dict index:0];
        }
    }
    if (self.evaluateArr.count == 2) {
        NSDictionary *firstDict = self.evaluateArr.firstObject;
        if ([firstDict[@"id"] isEqualToString:dict[@"id"]]) {
            [self updateEvaluateStatus:dict index:0];
        } else {
            NSDictionary *lastDict = self.evaluateArr.lastObject;
            if ([lastDict[@"id"] isEqualToString:dict[@"id"]]) {
                [self updateEvaluateStatus:dict index:1];
            }
        }
    }
}

#pragma mark ------ 更新评论点赞回复状态 ------
- (void)updateEvaluateStatus:(NSMutableDictionary *)dict index:(NSInteger)index {
    if (index == 0) {
        [self.evaluateArr replaceObjectAtIndex:0 withObject:dict];
        [self.firstCell.evaluateBtn setTitle:[NSString stringWithFormat:@"  %@",dict[@"replyNum"]] forState:UIControlStateNormal];
        [self.firstCell.likeBtn setTitle:[NSString stringWithFormat:@"  %@",dict[@"praiseNum"]] forState:UIControlStateNormal];
        if ([dict[@"isPraise"] boolValue]) {
            self.firstCell.likeBtn.selected = YES;
        } else {
            self.firstCell.likeBtn.selected = NO;
        }
    } else {
        [self.evaluateArr replaceObjectAtIndex:1 withObject:dict];
        [self.secondCell.evaluateBtn setTitle:[NSString stringWithFormat:@"  %@",dict[@"replyNum"]] forState:UIControlStateNormal];
        [self.secondCell.likeBtn setTitle:[NSString stringWithFormat:@"  %@",dict[@"praiseNum"]] forState:UIControlStateNormal];
        if ([dict[@"isPraise"] boolValue]) {
            self.secondCell.likeBtn.selected = YES;
        } else {
            self.secondCell.likeBtn.selected = NO;
        }
    }
}

#pragma mark ------ 更新推荐商品 ------
- (void)updateRelevantGoods:(NSArray *)goodsArr {
    if (self.relevantArr.count == 0) {
        if (goodsArr.count > 0) {
            CGFloat releW = SCREEN_WIDTH/3-10;
            CGFloat releH = releW+64;
            NSInteger count = goodsArr.count;
            CGFloat relevantH = VIEW_HEIGHT+8;
            
            UIView *relevantView = [[UIView alloc] init];
            self.relevantView = relevantView;
            self.relevantArr = goodsArr;
            [self addSubview:relevantView];
            
            UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
            spView.backgroundColor = COLOR_F2F2F2;
            [relevantView addSubview:spView];
            
            UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(12, VIEW_HEIGHT/2, 3, 16)];
            redView.backgroundColor = APP_COLOR;
            [relevantView addSubview:redView];
            
            UILabel *releLab = [[UILabel alloc] initWithFrame:CGRectMake(23, 8, 290, VIEW_HEIGHT)];
            releLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
            releLab.textColor = COLOR_333333;
            releLab.text = @"为你推荐";
            [relevantView addSubview:releLab];
            
            UIScrollView *scrollView;
            if (count > 6) {
                relevantH = relevantH+releH*2+50;
                scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(9, VIEW_HEIGHT+8, SCREEN_WIDTH-21, releH*2+12)];
                scrollView.contentSize = CGSizeMake((count%6 == 0 ? count/6 : count/6+1)*(SCREEN_WIDTH-21), 0);
                scrollView.showsHorizontalScrollIndicator = NO;
                scrollView.showsVerticalScrollIndicator = NO;
                scrollView.pagingEnabled = YES;
                scrollView.tag = 23;
                scrollView.delegate = self;
                [relevantView addSubview:scrollView];
                
                UIPageControl *pageControl = [[UIPageControl alloc] init];
                pageControl.center = CGPointMake(relevantView.center.x, releH*2+27+VIEW_HEIGHT+8);
                pageControl.pageIndicatorTintColor = SEPARATOR_COLOR;
                pageControl.currentPageIndicatorTintColor = APP_COLOR;
                pageControl.transform = CGAffineTransformMakeScale(1.3, 1.3);
                pageControl.numberOfPages = (count%6 == 0 ? count/6 : count/6+1);
                pageControl.currentPage = 0;
                [relevantView addSubview:pageControl];
                self.pageControl = pageControl;
            } else {
                if (count < 4) {
                    relevantH = relevantH+releH+10;
                } else {
                    relevantH = relevantH+releH*2+22;
                }
            }
            
            for (int i = 0; i < count; i++) {
                CGFloat originalX = 3+(releW+3)*(i%3)+(SCREEN_WIDTH-21)*(i/6);
                CGFloat originalY = (releH+10)*(i/3)-(releH*2+20)*(i/6);
                if (count < 7) {
                    originalY = originalY+VIEW_HEIGHT+8;
                    originalX = originalX+9;
                }
                UIView *releView = [self relevantViewWithFrame:CGRectMake(originalX, originalY, releW, releH) goodsDict:goodsArr[i] tag:i];
                if (count > 6) {
                    [scrollView addSubview:releView];
                } else {
                    [relevantView addSubview:releView];
                }
            }
            
            relevantView.frame = CGRectMake(0, self.originalH+self.evaluateView.frame.size.height-8, SCREEN_WIDTH, relevantH);
            self.bottomView.frame = CGRectMake(0, self.originalH+self.evaluateView.frame.size.height+relevantH-8, SCREEN_WIDTH, 8);
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.originalH+self.evaluateView.frame.size.height+relevantH);
        }
    }
}

#pragma mark ------ 初始化商品视图 ------
- (UIView *)relevantViewWithFrame:(CGRect)frame goodsDict:(NSDictionary *)dict tag:(NSInteger)tag {
    UIView *releView = [[UIView alloc] initWithFrame:frame];
    releView.tag = tag;
    CGFloat wid = frame.size.width;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wid, wid)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.layer.borderColor = COLOR_D3D3D3.CGColor;
    imgView.layer.borderWidth = 0.5;
    imgView.clipsToBounds = YES;
    [imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"goodsImg"]] placeholderImage:[UIImage imageNamed:@"img_square"]];
    [releView addSubview:imgView];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(4, wid+6, wid-8, 32)];
    nameLab.font = [UIFont systemFontOfSize:13];
    nameLab.textColor = COLOR_666666;
    nameLab.text = dict[@"goodsName"];
    nameLab.numberOfLines = 2;
    [releView addSubview:nameLab];
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(4, wid+44, wid-8, 20)];
    priceLab.text = [NSString stringWithFormat:@"¥ %.2f",[dict[@"advicePrice"] doubleValue]];
    priceLab.font = [UIFont boldSystemFontOfSize:13];
    priceLab.textColor = COLOR_333333;
    [releView addSubview:priceLab];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRelevantView:)];
    [releView addGestureRecognizer:tap];
    return releView;
}

#pragma mark ------ ScrollView代理 ------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    NSInteger index = (scrollView.contentOffset.x+0.5*width)/width;
    if (scrollView.tag == 23) {
        self.pageControl.currentPage = index;
    } else {
        if (index == 0) {
            index = self.urlArr.count;
        } else if (index == self.urlArr.count+1) {
            index = 1;
        }
        self.indexLab.text = [NSString stringWithFormat:@"%ld/%ld",index,self.urlArr.count];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView.tag != 23) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag != 23) {
        CGFloat width = scrollView.frame.size.width;
        int index = (scrollView.contentOffset.x+0.5*width)/width;
        if (index == self.urlArr.count+1) {
            [scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
        } else if (index == 0) {
            [scrollView setContentOffset:CGPointMake(self.urlArr.count*width, 0) animated:NO];
        }
    }
}

#pragma mark ------ 点击商品图片 ------
- (void)clickImageView:(UITapGestureRecognizer *)tap {
    [ADLImagePreView showWithImageViews:nil urlArray:self.urlArr currentIndex:tap.view.tag];
}

#pragma mark ------ 点击属性 ------
- (void)clickAttributeBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAttributeBtn)]) {
        [self.delegate didClickAttributeBtn];
    }
}

#pragma mark ------ 点击地址 ------
- (void)clickAddressBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAddressBtn:)]) {
        if ([self.addressLab.text containsString:@"请"]) {
            [self.delegate didClickAddressBtn:YES];
        } else {
            [self.delegate didClickAddressBtn:NO];
        }
    }
}

#pragma mark ------ 查看全部评价 ------
- (void)clickLookAllEvaluateBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLookEvaluateBtn)]) {
        [self.delegate didClickLookEvaluateBtn];
    }
}

#pragma mark ------ 评价点赞 ------
- (void)didClickLikeBtn:(UIButton *)sender {
    ADLGoodsEvaluateCell *cell = (ADLGoodsEvaluateCell *)sender.superview.superview;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickEvaluateLikeBtn:index:)]) {
        if (cell == self.firstCell) {
            [self.delegate didClickEvaluateLikeBtn:self.evaluateArr.firstObject index:0];
        } else {
            [self.delegate didClickEvaluateLikeBtn:self.evaluateArr.lastObject index:1];
        }
    }
}

#pragma mark ------ 点击评价用户头像 ------
- (void)didClickUserIcon:(UIImageView *)imageView {
    ADLGoodsEvaluateCell *cell = (ADLGoodsEvaluateCell *)imageView.superview.superview;
    NSString *imgUrl = @"";
    if (cell == self.firstCell) {
        imgUrl = [self.evaluateArr.firstObject[@"headShot"] stringValue];
    } else {
        imgUrl = [self.evaluateArr.lastObject[@"headShot"] stringValue];
    }
    if (imgUrl) {
        [ADLImagePreView showWithImageViews:@[imageView] urlArray:@[imgUrl] currentIndex:0];
    }
}

#pragma mark ------ 评价图片 ------
- (void)didClickImageView:(UIImageView *)imageView {
    ADLGoodsEvaluateCell *cell = (ADLGoodsEvaluateCell *)imageView.superview.superview.superview;
    NSArray *urlArr;
    if (cell == self.firstCell) {
        urlArr = self.evaluateArr.firstObject[@"imgArr"];
    } else {
        urlArr = self.evaluateArr.lastObject[@"imgArr"];
    }
    [ADLImagePreView showWithImageViews:cell.imageViewArr urlArray:urlArr currentIndex:imageView.tag];
}

#pragma mark ------ 点击评价Cell ------
- (void)clickFirstEvaluateCell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickEvaluateCell:index:)]) {
        [self.delegate didClickEvaluateCell:self.evaluateArr.firstObject index:0];
    }
}

- (void)clickSecondEvaluateCell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickEvaluateCell:index:)]) {
        [self.delegate didClickEvaluateCell:self.evaluateArr.lastObject index:1];
    }
}

#pragma mark ------ 点击推荐商品 ------
- (void)clickRelevantView:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickRelevantGoods:)]) {
        [self.delegate didClickRelevantGoods:self.relevantArr[tap.view.tag][@"goodsId"]];
    }
}

#pragma mark ------ 销毁Timer ------
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview && self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
