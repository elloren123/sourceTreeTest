//
//  ADLDinnerSizeView.h
//  lockboss
//
//  Created by bailun91 on 2019/9/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLDinnerSizeView : UIView

@property (nonatomic, strong) UIButton *sizeBtn1;
@property (nonatomic, strong) UIButton *sizeBtn2;
@property (nonatomic, strong) UIButton *sizeBtn3;
@property (nonatomic, strong) UILabel  *priceLbl;
@property (nonatomic, assign) NSInteger btnTag;  //1:大份; 2:中份; 3:小份;

@property (nonatomic, assign) NSInteger dinnerIndex;    //商品编号, 从vc传过来的, 用来识别得到section, row
@property (nonatomic,   copy) void(^dismissBtnAction) (NSInteger index, NSString *price);
@property (nonatomic,   copy) void(^didSelectedBlock) (NSInteger dinnerIndex, NSInteger btnTag, NSString *price);

- (void)updateButtonUI;

@end

NS_ASSUME_NONNULL_END
