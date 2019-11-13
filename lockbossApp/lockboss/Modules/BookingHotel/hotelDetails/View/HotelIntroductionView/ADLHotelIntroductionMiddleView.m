//
//  ADLHotelIntroductionMiddleView.m
//  lockboss
//
//  Created by adel on 2019/9/25.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelIntroductionMiddleView.h"
#import "ADLBookingHotelModel.h"
@interface ADLHotelIntroductionMiddleView ()
@property (nonatomic ,strong)UIView *lien;
@end

@implementation ADLHotelIntroductionMiddleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // [self addsubView];
        self.backgroundColor = [UIColor whiteColor];
        UILabel *title = [self createLabelFrame:CGRectMake(25, 25,self.width - 50, 20) font:16 text:ADLString(@"酒店设施") texeColor:COLOR_333333];
        [self addSubview:title];
    }
    return self;
}


-(void)setTitleArray:(NSMutableArray *)titleArray {
    _titleArray = titleArray;

    int margin = 10;//间隙
    
    int width = (SCREEN_WIDTH-75)/2;//格子的宽
    
    int height = 20;//格子的高
    UIButton * btn;
    for (int i = 0; i <_titleArray.count; i++) {
        int row = i/2;
        int col = i%2;
        btn = [self createButtonFrame:CGRectMake(25+col*(width+25), 55+row*(height+margin), width,  height) imageName:nil title:_titleArray[i] titleColor:COLOR_666666 font:10 target:self action:nil];
        [btn setImage:[UIImage imageNamed:_imageArray[i]] forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
//
//    UILabel *project = [self createLabelFrame:CGRectMake(25, CGRectGetMaxY(btn.frame)+12,self.width - 50, 20) font:12 text:ADLString(@"服务项目") texeColor:COLOR_333333];
//    [self addSubview:project];
//
//
//    for (int i = 0; i < _imageArray.count; i++) {
//        int row = i/2;
//        int col = i%2;
//        UIButton * btn = [self createButtonFrame:CGRectMake(140+col*(width+margin), CGRectGetMaxY(project.frame)+90+row*(height+margin), width,  height) imageName:nil title:_imageArray[i] titleColor:COLOR_E0212A font:10 target:self action:@selector(tagbtn:)];
//        [btn setImage:[UIImage imageNamed:@"mine_head_bg"] forState:UIControlStateNormal];
//        [self addSubview:btn];
//
//    }
    
}
-(void)setModel:(ADLBookingHotelModel *)model {
    
}
-(NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}
@end
