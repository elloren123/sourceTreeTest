//
//  ADLAnnotationView.m
//  lockboss
//
//  Created by adel on 2019/7/9.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLAnnotationView.h"

@implementation ADLAnnotationView

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected) {
        return;
    }
    if (![self.annotation.title isEqualToString:@"start"]) {
        return;
    }
    if (selected) {
        self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds)/2+self.calloutOffset.x, self.calloutOffset.y-28);
        [self addSubview:self.calloutView];
    } else {
        [self.calloutView removeFromSuperview];
    }
    [super setSelected:selected animated:animated];
}

- (UIView *)calloutView {
    if (_calloutView == nil) {
        _calloutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 56)];
        
        UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
        roundView.backgroundColor = [UIColor whiteColor];
        roundView.layer.cornerRadius = 25;
        [_calloutView addSubview:roundView];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 36, 36)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.layer.cornerRadius = 18;
        imgView.clipsToBounds = YES;
        [roundView addSubview:imgView];
        self.imgView = imgView;
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 3, 90, 25)];
        nameLab.font = [UIFont systemFontOfSize:13];
        nameLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [roundView addSubview:nameLab];
        self.nameLab = nameLab;
        
        UILabel *distanceLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 23, 90, 25)];
        distanceLab.font = [UIFont systemFontOfSize:12];
        distanceLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [roundView addSubview:distanceLab];
        self.distanceLab = distanceLab;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(70, 50)];
        [path addLineToPoint:CGPointMake(75, 55)];
        [path addLineToPoint:CGPointMake(80, 50)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        [_calloutView.layer addSublayer:layer];
    }
    return _calloutView;
}

@end
