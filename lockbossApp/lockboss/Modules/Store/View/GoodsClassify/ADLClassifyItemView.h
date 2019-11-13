//
//  ADLClassifyItemView.h
//  lockboss
//
//  Created by adel on 2019/5/27.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLClassifyItemView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titLab;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic, assign) BOOL check;

@property (nonatomic, assign) BOOL select;

@end
