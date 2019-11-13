//
//  ADLOrderDinnerCell.m
//  lockboss
//
//  Created by bailun91 on 2019/9/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLOrderDinnerCell.h"
#import "ADLGlobalDefine.h"

@implementation ADLOrderDinnerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(13, 10, 80, 80)];
        [self.contentView addSubview:iconImg];
        self.iconImg = iconImg;
        
        
        UILabel *shop = [[UILabel alloc] initWithFrame:CGRectMake(105, 10, SCREEN_WIDTH/2, 20)];
        shop.font = [UIFont systemFontOfSize:FONT_SIZE];
        shop.textAlignment = NSTextAlignmentLeft;
        shop.textColor = [UIColor blackColor];
        [self.contentView addSubview:shop];
        self.shopName = shop;

        for (int i = 0 ; i < 5; i++) {
            UIImageView *starImg = [[UIImageView alloc] initWithFrame:CGRectMake(105+15*i, 36, 13, 12)];
            [self.contentView addSubview:starImg];
            if (i == 0) {
                self.starImg1 = starImg;
                
            } else if (i == 1) {
                self.starImg2 = starImg;
                
            } else if (i == 2) {
                self.starImg3 = starImg;
                
            } else if (i == 3) {
                self.starImg4 = starImg;
                
            } else if (i == 4) {
                self.starImg5 = starImg;
            }
        }
        
        
        UILabel *renqiLbl = [[UILabel alloc] initWithFrame:CGRectMake(105, 54, SCREEN_WIDTH/2, 15)];
        renqiLbl.font = [UIFont systemFontOfSize:12];
        renqiLbl.textAlignment = NSTextAlignmentLeft;
        renqiLbl.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:renqiLbl];
        self.renQiLbl = renqiLbl;
        
        
        UILabel *juliLbl = [[UILabel alloc] initWithFrame:CGRectMake(105, 74, SCREEN_WIDTH/2, 15)];
        juliLbl.font = [UIFont systemFontOfSize:12];
        juliLbl.textAlignment = NSTextAlignmentLeft;
        juliLbl.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:juliLbl];
        self.juLiLbl = juliLbl;
        
        
        UILabel *workLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-135, 10, 130, 50)];
        workLbl.font = [UIFont systemFontOfSize:12.5];
        workLbl.textAlignment = NSTextAlignmentCenter;
        workLbl.numberOfLines = 0;
        workLbl.textColor = [UIColor grayColor];
        [self.contentView addSubview:workLbl];
        self.workLbl = workLbl;
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 99, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:lineView];
    }
    
    return self;
}

//- (void)layoutSubviews {
//    NSLog(@"layoutSubviews !!!");
//
//    CGFloat hei = self.frame.size.height;
//    self.titLab.frame = CGRectMake(12, 0, SCREEN_WIDTH*0.3, hei);
//    self.lineView.frame = CGRectMake(SCREEN_WIDTH*0.3+24, 0, 0.5, hei);
//    self.descLab.frame = CGRectMake(SCREEN_WIDTH*0.3+36, 0, SCREEN_WIDTH*0.7-48, hei);
//    self.spView.frame = CGRectMake(12, hei-0.5, SCREEN_WIDTH-12, 0.5);
//}

@end
