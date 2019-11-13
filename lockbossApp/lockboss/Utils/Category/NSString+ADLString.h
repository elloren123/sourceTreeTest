//
//  NSString+ADLString.h
//  lockboss
//
//  Created by adel on 2019/4/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ADLString)
/**
 *  设置段落样式
 *
 *  @param lineSpacing 行高
 *  @param textcolor   字体颜色
 *  @param font        字体
 *
 *  @return 富文本
 */
-(NSAttributedString *)stringWithParagraphlineSpeace:(CGFloat)lineSpacing
                                           textColor:(UIColor *)textcolor
                                            textFont:(UIFont *)font;


-(CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width;
@end
