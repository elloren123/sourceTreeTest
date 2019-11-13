//
//  ADLCircleDetailHeadView.h
//  lockboss
//
//  Created by Han on 2019/6/2.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLCircleDetailDelegate <NSObject>

- (void)didClickGroupImageView:(UIImageView *)imageView;

- (void)didClickActionBtn:(UIButton *)sender;

@end

@interface ADLCircleDetailHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *authorLab;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (nonatomic, weak) id<ADLCircleDetailDelegate> delegate;
@end
