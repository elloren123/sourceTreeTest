//
//  ADLOrderAddressView.h
//  lockboss
//
//  Created by adel on 2019/5/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLOrderAddressView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, copy) void (^clickAddress) (BOOL addAddress);

@end
