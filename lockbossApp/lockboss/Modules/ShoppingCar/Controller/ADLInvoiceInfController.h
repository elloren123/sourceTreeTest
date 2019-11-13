//
//  ADLInvoiceInfController.h
//  lockboss
//
//  Created by adel on 2019/5/29.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLInvoiceInfController : ADLBaseViewController

@property (nonatomic, copy) void (^finish) (NSString *invoiceId, NSString *invoiceStr);

@end
