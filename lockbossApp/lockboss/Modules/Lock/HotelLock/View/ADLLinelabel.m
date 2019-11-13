//
//  ADLLinelabel.m
//  lockboss
//
//  Created by adel on 2019/10/24.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLLinelabel.h"

@implementation ADLLinelabel

//添加中划线或者是下划线或者任意位置的横线（自己调整）
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] set]; //默认 横线颜色
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 0.5);
    CGContextBeginPath(c);
    CGFloat halfWayUp = rect.size.height/2 + rect.origin.y;
    CGContextMoveToPoint(c, rect.origin.x, halfWayUp);//起点
    CGContextAddLineToPoint(c, rect.origin.x + rect.size.width, halfWayUp);//终点
    CGContextStrokePath(c);
}


@end
