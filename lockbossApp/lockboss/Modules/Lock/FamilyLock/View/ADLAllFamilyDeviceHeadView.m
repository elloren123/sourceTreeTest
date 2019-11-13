//
//  ADLAllFamilyDeviceHeadView.m
//  lockboss
//
//  Created by adel on 2019/10/10.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLAllFamilyDeviceHeadView.h"

#import "ADLGlobalDefine.h"

@interface NewUILabel : UILabel

@end

@implementation NewUILabel

-(void)drawTextInRect:(CGRect)rect{
    //文字距离左侧10个像素
    CGRect newRect = CGRectMake(rect.origin.x+10, rect.origin.y, rect.size.width-20, rect.size.height);
    [super drawTextInRect:newRect];
}

@end

@implementation ADLAllFamilyDeviceHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubVeiws];
    }
    return self;
}
-(void)createSubVeiws{
//    UIView *backView = [[UIView alloc] initWithFrame:<#(CGRect)#>];
    
    UILabel *hLab = [[NewUILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    hLab.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    hLab.font = [UIFont systemFontOfSize:14];
    self.headeLab = hLab;
    [self addSubview:self.headeLab];
}

@end
