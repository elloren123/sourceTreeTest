//
//  ADLBlankView.m
//  lockboss
//
//  Created by adel on 2019/5/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBlankView.h"
#import "ADLGlobalDefine.h"

@implementation ADLBlankView

+ (instancetype)blankViewWithFrame:(CGRect)frame imageName:(NSString *)imageName prompt:(NSString *)prompt backgroundColor:(UIColor *)backgroundColor {
    return [[self alloc] initWithFrame:frame imageName:imageName prompt:prompt backgroundColor:backgroundColor];
}

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName prompt:(NSString *)prompt backgroundColor:(UIColor *)backgroundColor {
    if (self = [super initWithFrame:frame]) {
        if (backgroundColor == nil) {
            self.backgroundColor = [UIColor whiteColor];
        } else {
            self.backgroundColor = backgroundColor;
        }
        CGFloat wid = frame.size.width;
        _topMargin = 120;
        _centerMargin = 20;
        _bottomMargin = 40;
        
        UIImage *image = [UIImage imageNamed:@"data_blank"];
        if (imageName.length > 0)  image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((wid-image.size.width)/2, _topMargin, image.size.width, image.size.height)];
        imageView.image = image;
        [self addSubview:imageView];
        self.imageView = imageView;
        
        CGFloat promptH = [prompt boundingRectWithSize:CGSizeMake(wid-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} context:nil].size.height+6;
        UILabel *promptLab = [[UILabel alloc] initWithFrame:CGRectMake(16, imageView.frame.origin.y+image.size.height+_centerMargin, wid-32, promptH)];
        promptLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        promptLab.textAlignment = NSTextAlignmentCenter;
        promptLab.textColor = COLOR_999999;
        promptLab.numberOfLines = 0;
        promptLab.text = prompt;
        [self addSubview:promptLab];
        self.promptLab = promptLab;
        
        UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        actionBtn.frame = CGRectMake((wid-128)/2, promptLab.frame.origin.y+promptH+_bottomMargin, 128, 45);
        [actionBtn addTarget:self action:@selector(clickAcBtn) forControlEvents:UIControlEventTouchUpInside];
        [actionBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        actionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        actionBtn.layer.borderColor = COLOR_D3D3D3.CGColor;
        actionBtn.layer.cornerRadius = CORNER_RADIUS;
        actionBtn.layer.borderWidth = 0.5;
        [self addSubview:actionBtn];
        self.actionBtn = actionBtn;
        actionBtn.hidden = YES;
    }
    return self;
}

- (void)setTopMargin:(CGFloat)topMargin {
    _topMargin = topMargin;
    CGFloat wid = self.frame.size.width;
    CGFloat imgW = self.imageView.frame.size.width;
    CGFloat imgH = self.imageView.frame.size.height;
    
    self.imageView.frame = CGRectMake((wid-imgW)/2, topMargin, imgW, imgH);
    self.promptLab.frame = CGRectMake(16, self.imageView.frame.origin.y+imgH+self.centerMargin, wid-32, self.promptLab.frame.size.height);
    self.actionBtn.frame = CGRectMake((wid-128)/2, self.promptLab.frame.origin.y+self.promptLab.frame.size.height+self.bottomMargin, 128, 45);
}

- (void)setCenterMargin:(CGFloat)centerMargin {
    _centerMargin = centerMargin;
    CGFloat wid = self.frame.size.width;
    
    self.promptLab.frame = CGRectMake(16, self.imageView.frame.origin.y+self.imageView.frame.size.height+centerMargin, wid-32, self.promptLab.frame.size.height);
    self.actionBtn.frame = CGRectMake((wid-128)/2, self.promptLab.frame.origin.y+self.promptLab.frame.size.height+self.bottomMargin, 128, 45);
}

- (void)setBottomMargin:(CGFloat)bottomMargin {
    _bottomMargin = bottomMargin;
    CGFloat wid = self.frame.size.width;
    self.actionBtn.frame = CGRectMake((wid-128)/2, self.promptLab.frame.origin.y+self.promptLab.frame.size.height+bottomMargin, 128, 45);
}

- (void)clickAcBtn {
    if (self.clickActionBtn) {
        self.clickActionBtn();
    }
}

@end
