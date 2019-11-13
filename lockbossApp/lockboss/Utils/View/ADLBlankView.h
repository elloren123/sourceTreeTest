//
//  ADLBlankView.h
//  lockboss
//
//  Created by adel on 2019/5/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLBlankView : UIView

+ (instancetype)blankViewWithFrame:(CGRect)frame imageName:(NSString *)imageName prompt:(NSString *)prompt backgroundColor:(UIColor *)backgroundColor;

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName prompt:(NSString *)prompt backgroundColor:(UIColor *)backgroundColor;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *promptLab;

@property (nonatomic, strong) UIButton *actionBtn;

@property (nonatomic, assign) CGFloat topMargin;

@property (nonatomic, assign) CGFloat centerMargin;

@property (nonatomic, assign) CGFloat bottomMargin;

@property (nonatomic, copy) void (^clickActionBtn) (void);

@end
