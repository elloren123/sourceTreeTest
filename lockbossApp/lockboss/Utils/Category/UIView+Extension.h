//
//  UIView+Extension.h
//  HongXun
//
//  Created by zyc on 2017/3/9.
//  Copyright © 2017年 HX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MKButtonEdgeInsetsStyle) {
    MKButtonEdgeInsetsStyleTop, // image在上，label在下
    MKButtonEdgeInsetsStyleLeft, // image在左，label在右
    MKButtonEdgeInsetsStyleBottom, // image在下，label在上
    MKButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;


@property (assign, nonatomic) CGFloat maxX;
@property (assign, nonatomic) CGFloat maxY;
-(void)setAddX:(CGFloat)addX;
-(void)setAddY:(CGFloat)addY;

- (UILabel *)createLabelFrame:(CGRect)frame font:(NSInteger)font text:(NSString *)text texeColor:(UIColor *)textColor;
- (void)messageAction:(UILabel *)theLab changeString:(NSString *)change andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor andMarkFondSize:(float)fontSize;
-(UIButton *)createButtonFrame:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(NSInteger)font target:(id)target action:(SEL)action;


- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style createButton:(UIButton *)btn
                        imageTitleSpace:(CGFloat)space;
@end
