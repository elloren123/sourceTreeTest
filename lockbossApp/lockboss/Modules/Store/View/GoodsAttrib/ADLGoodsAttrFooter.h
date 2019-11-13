//
//  ADLGoodsAttrReuseView.h
//  lockboss
//
//  Created by adel on 2019/4/26.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLGoodsAttrFooter;

@protocol ADLGoodsAttrFooterDelegate <NSObject>

- (void)didBeginEditing:(UITextField *)textField;

- (void)didChangedCount:(NSInteger)count footerView:(ADLGoodsAttrFooter *)footerView;

@end

@interface ADLGoodsAttrFooter : UICollectionReusableView

@property (nonatomic, strong) UILabel *titLab;

@property (nonatomic, strong) UITextField *numTF;

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UIButton *reduceBtn;

@property (nonatomic, weak) id<ADLGoodsAttrFooterDelegate> delegate;

@end
