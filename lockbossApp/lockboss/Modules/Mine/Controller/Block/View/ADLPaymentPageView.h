//
//  ADLPaymentPageView.h
//  lockboss
//
//  Created by adel on 2019/11/6.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLPaymentPageView;
@protocol  ADLPaymentPageViewDelegate <NSObject>

- (void)PaymentPageView:(ADLPaymentPageView *)tameiyLockView didSelectRowAtIndexPath:(NSIndexPath *)indexPath iphone:(NSString *)iphone;

@end

@interface ADLPaymentPageView : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, weak) UIView *backView;

@property (nonatomic ,weak)id <ADLPaymentPageViewDelegate>delegate;

@property (nonatomic ,copy)void(^devictBlock)(NSInteger integer);

- (void)remove;
-(void)delephoneindePath:(NSString *)typ;
@end

