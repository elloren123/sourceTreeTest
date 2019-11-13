//
//  ADLBlockchainLockView.h
//  lockboss
//
//  Created by adel on 2019/11/1.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADLBlockchainLockView,ADLBlockchainLockModel;
@protocol  ADLBlockchainLockViewDelegate <NSObject>

- (void)tameiyLockView:(ADLBlockchainLockView *)tameiyLockView didSelectRowAtIndexPath:(NSIndexPath *)indexPath iphone:(NSString *)iphone;

@end

@interface ADLBlockchainLockView : UIView

@property (nonatomic, strong) NSMutableArray *gouponsArray;

@property (nonatomic, strong) NSArray *honeArray;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, weak) UIView *backView;

@property (nonatomic ,weak)id <ADLBlockchainLockViewDelegate>delegate;

//- (void)addtableHeaderViewWithText:(NSString *)text;

@property (nonatomic ,copy)void(^devictBlock)(ADLBlockchainLockModel *model);

- (void)remove;
-(void)delephoneindePath:(NSString *)typ;

@end

