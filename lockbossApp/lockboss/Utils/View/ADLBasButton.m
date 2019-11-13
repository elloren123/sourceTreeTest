//
//  ADLBasButton.m
//  ADEL-APP
//
//  Created by bailun91 on 2018/7/3.
//

#import "ADLBasButton.h"

#define titleRatio 0.2

@implementation ADLBasButton

+(id)butonWithTyp:(UIButtonType)buttnType frame:(CGRect)frame image:(UIImage *)image handler:(tapHandler)handler title:(NSString *)title{
    ADLBasButton *butn = [super buttonWithType:buttnType];
    butn.frame = frame;
    butn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [butn setTitle:title forState:UIControlStateNormal];
    //[butn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [butn setImage:image forState:UIControlStateNormal];
    butn.handler = handler;
    [butn addTarget:butn action:@selector(addTapped:) forControlEvents:UIControlEventTouchUpInside];
    butn.imageView.contentMode = UIViewContentModeCenter;
    return butn;
}
-(void)addTapped:(UIButton *)sender {
    if (self.handler) {
        self.handler(sender);
    }
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect

{//上下
    
    //    CGFloat titleY = contentRect.size.height *0.6;
    //
    //    CGFloat titleW = contentRect.size.width;
    //
    //    CGFloat titleH = contentRect.size.height - titleY;
    //左右
    CGFloat titleY = 0;
    
    CGFloat titleW = contentRect.size.width-30;
    
    CGFloat titleH = contentRect.size.height;
    //不规则
    //    CGFloat titleY = 0;
    //
    //    CGFloat titleW = contentRect.size.width;
    //
    //    CGFloat titleH = contentRect.size.height;
    return CGRectMake(0, titleY, titleW, titleH);
}


-(CGRect)imageRectForContentRect:(CGRect)contentRect

{
    //上下
    //  CGFloat imageW = CGRectGetWidth(contentRect);
    
    //  CGFloat imageH = contentRect.size.height * 0.6;
    //左右
    CGFloat imageX = contentRect.size.width-30;
    CGFloat imageW = 30;
    CGFloat imageH = contentRect.size.height;
    //不规则
//    CGFloat imageX = contentRect.size.width*0.3;
    //    CGFloat imageW = CGRectGetWidth(contentRect) * 0.4;
    //
    //    CGFloat imageH = contentRect.size.height;
    
    
    return CGRectMake(imageX, 0, imageW, imageH);
    
}

@end
