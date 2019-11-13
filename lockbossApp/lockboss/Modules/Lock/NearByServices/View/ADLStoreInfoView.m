//
//  ADLStoreInfoView.m
//  lockboss
//
//  Created by bailun91 on 2019/10/15.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLStoreInfoView.h"

@implementation ADLStoreInfoView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews {
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    bgImg.image = [UIImage imageNamed:@"icon_beijing"];
    [self addSubview:bgImg];
    
    
    UIImageView *storeImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-32.5, 13, 65, 65)];
    storeImage.image = [UIImage imageNamed:@"icon_chanpjiemian"];
    [self addSubview:storeImage];
    self.storeImg = storeImage;
    
    
    //商家名称
    UILabel *stoName = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 30)];
    stoName.textAlignment = NSTextAlignmentCenter;
    stoName.font = [UIFont systemFontOfSize:19];
    stoName.textColor = [UIColor blackColor];
//    stoName.text = @"商家名称";
    [self addSubview:stoName];
    self.storeName = stoName;
    
    
    //
    UILabel *weiSheng = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH/3-5, 25)];
    weiSheng.textAlignment = NSTextAlignmentRight;
    weiSheng.font = [UIFont systemFontOfSize:15];
    weiSheng.textColor = [UIColor darkGrayColor];
    weiSheng.text = @"卫生";
    [self addSubview:weiSheng];
    self.wsLabel = weiSheng;
    
    
    //'星星'
    for (int i = 0 ; i < 5; i++) {
        UIImageView *starImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3+18*i, 115, 16, 15)];
        starImg.image = [UIImage imageNamed:@"icon_xing1"];
        [self addSubview:starImg];
        
        if (0 == i) {
            self.star1 = starImg;
        } else if (1 == i) {
            self.star2 = starImg;
        } else if (2 == i) {
            self.star3 = starImg;
        } else if (3 == i) {
            self.star4 = starImg;
        } else if (4 == i) {
            self.star5 = starImg;
        }
    }
    
    
    //商家得分label
    UILabel *scoreLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3+94, 110, SCREEN_WIDTH/2, 25)];
    scoreLab.textAlignment = NSTextAlignmentLeft;
    scoreLab.font = [UIFont systemFontOfSize:15];
    scoreLab.textColor = [UIColor darkGrayColor];
    scoreLab.text = @"暂无评分";
    [self addSubview:scoreLab];
    self.stoScore = scoreLab;
    
    
    //商家地址
    UILabel *stoAddress = [[UILabel alloc] initWithFrame:CGRectMake(0, 135, SCREEN_WIDTH, 25)];
    stoAddress.textAlignment = NSTextAlignmentCenter;
    stoAddress.font = [UIFont systemFontOfSize:15];
    stoAddress.textColor = [UIColor darkGrayColor];
//    stoAddress.text = @"----";
    [self addSubview:stoAddress];
    self.stoAddress = stoAddress;
}

#pragma mark ------  刷新view ------
- (void)updateStoreInfoView:(NSMutableDictionary *)dict {
//    self.storeName.text = dict[@"shopName"];
    [self updateStarImgsAndLabel:dict[@"hygiene"]];
    self.stoScore.text = [NSString stringWithFormat:@"%.1f (%zd人评论)", [dict[@"hygiene"] floatValue], [dict[@"praiseNum"] integerValue]+[dict[@"badNum"] integerValue]];
//    self.stoAddress.text = dict[@"areaDetailed"];
}
- (void)updateStarImgsAndLabel:(NSString *)score {
    if (score.floatValue > 4) {
        self.star1.image = [UIImage imageNamed:@"icon_xing"];
        self.star2.image = [UIImage imageNamed:@"icon_xing"];
        self.star3.image = [UIImage imageNamed:@"icon_xing"];
        self.star4.image = [UIImage imageNamed:@"icon_xing"];
        self.star5.image = [UIImage imageNamed:@"icon_xing"];
   
    } else if (score.floatValue > 3) {
        self.star1.image = [UIImage imageNamed:@"icon_xing"];
        self.star2.image = [UIImage imageNamed:@"icon_xing"];
        self.star3.image = [UIImage imageNamed:@"icon_xing"];
        self.star4.image = [UIImage imageNamed:@"icon_xing"];
    
    } else if (score.floatValue > 2) {
        self.star1.image = [UIImage imageNamed:@"icon_xing"];
        self.star2.image = [UIImage imageNamed:@"icon_xing"];
        self.star3.image = [UIImage imageNamed:@"icon_xing"];
   
    } else if (score.floatValue > 1) {
        self.star1.image = [UIImage imageNamed:@"icon_xing"];
        self.star2.image = [UIImage imageNamed:@"icon_xing"];
    
    } else {
        self.star1.image = [UIImage imageNamed:@"icon_xing"];
    }
}

@end
