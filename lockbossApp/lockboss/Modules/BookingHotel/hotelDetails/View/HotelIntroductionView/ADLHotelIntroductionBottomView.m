//
//  ADLHotelIntroductionBottomView.m
//  lockboss
//
//  Created by adel on 2019/9/25.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelIntroductionBottomView.h"

@interface ADLHotelIntroductionBottomView ()
@property (nonatomic ,strong)UIView *lien;

@end

@implementation ADLHotelIntroductionBottomView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addsubView];
        self.backgroundColor = [UIColor whiteColor];
//        UIView *lien = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 0.5, self.width, 0.5)];
//        lien.backgroundColor = [UIColor grayColor];
//        [self addSubview:lien];
        
        UILabel *title = [self createLabelFrame:CGRectMake(25, 25,self.width - 50, 20) font:16 text:ADLString(@"酒店政策") texeColor:COLOR_333333];
     
         [self addSubview:title];
        UILabel *controll = [self createLabelFrame:CGRectMake(25, 55,SCREEN_WIDTH - 50, 0) font:12 text:nil texeColor:COLOR_666666];
      //  controll.backgroundColor = [UIColor redColor];
        controll.numberOfLines = 0;
        self.controll  = controll;
       [self addSubview:controll];
       
    }
    return self;
}
-(void)addsubView
{
    
    
}
-(void)setPolicyDes:(NSString *)policyDes {
    _policyDes = policyDes;
     self.controll.text  = _policyDes;
      [self.controll sizeToFit];
}
@end
