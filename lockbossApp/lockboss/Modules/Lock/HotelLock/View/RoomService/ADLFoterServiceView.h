//
//  ADLFoterServiceView.h
//  lockboss
//
//  Created by adel on 2019/11/5.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLFoterServiceView : UIView
@property (nonatomic , strong)UILabel *leiveLabel;
@property (nonatomic , strong)UILabel *leiveTime;
@property (nonatomic , strong)UILabel *leiveNowLabel;
@property (nonatomic , strong)UIButton *leiveNowTimeBtn;
@property (nonatomic , strong)UILabel *dataLabel;
@property (nonatomic , strong)UILabel *data;
@property (nonatomic , strong)UILabel *priceLabel;
@property (nonatomic , strong)UILabel *price;

@property (nonatomic , strong)UILabel *makeMoneyLabel;
@property (nonatomic , strong)UILabel *makeMoney;

@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic , strong)UILabel *placehoderLabel;
@property (nonatomic , strong)UILabel *number;

@property (nonatomic ,strong)void(^blockBtn)(UIButton *);
@end

NS_ASSUME_NONNULL_END
