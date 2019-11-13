//
//  ADLHotelListHeadView.m
//  lockboss
//
//  Created by adel on 2019/9/20.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelListHeadView.h"

@interface ADLHotelListHeadView ()
@property (nonatomic ,strong)UIView *lien;
@end

@implementation ADLHotelListHeadView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addsubView];
        self.backgroundColor = [UIColor whiteColor];
        UIView *lien = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 0.5, self.width, 0.5)];
        lien.backgroundColor = [UIColor grayColor];
        [self addSubview:lien];
    }
    return self;
}
-(void)addsubView
{
    int margin = 10;//间隙
    
    int width = SCREEN_WIDTH/4;//格子的宽
    
    int height = 30;//格子的高
    
    for (int i = 0; i < self.array.count; i++) {
        //int row = i/1;
        int col = i%self.array.count;
        UIButton * btn = [self createButtonFrame:CGRectMake(40+col*(width+margin),5, width,  height) imageName:@"icon_jiantou" title:self.array[i] titleColor:COLOR_333333 font:12 target:self action:@selector(Clicktagbtn:)];
        [btn setImage:[UIImage imageNamed:@"icon_biankuang"] forState:UIControlStateSelected];
        [btn setTitleColor:COLOR_E0212A forState:UIControlStateSelected];
        
        [self addSubview:btn];
        if (i == 0) {
          btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        }
        if (i == 2) {
               btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        }
       
        [self layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight createButton:btn imageTitleSpace:5];
     
        btn.tag = i;
    }
}
-(void)Clicktagbtn:(UIButton *)btn {
    if (self.blockBtn) {
        self.blockBtn(btn);
    }
}
-(NSArray *)array {
    if (!_array) {
        _array = @[ADLString(@"只能排序"),ADLString(@"价格排序"),ADLString(@"筛选")];
    }
    return _array;
}

@end
