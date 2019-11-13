//
//  ADLGoodsEvaluateCell.h
//  lockboss
//
//  Created by adel on 2019/5/13.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLGoodsEvaluateCellDelegate <NSObject>

- (void)didClickLikeBtn:(UIButton *)sender;

- (void)didClickUserIcon:(UIImageView *)imageView;

- (void)didClickImageView:(UIImageView *)imageView;

@end

@interface ADLGoodsEvaluateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nickLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIImageView *starView;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *evaluateBtn;
@property (weak, nonatomic) IBOutlet UILabel *modelLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UIImageView *imgView4;
@property (weak, nonatomic) IBOutlet UIImageView *imgView5;
@property (weak, nonatomic) IBOutlet UIImageView *imgView6;
@property (weak, nonatomic) IBOutlet UIImageView *imgView7;
@property (weak, nonatomic) IBOutlet UIImageView *imgView8;
@property (weak, nonatomic) IBOutlet UIImageView *imgView9;
@property (weak, nonatomic) IBOutlet UIView *spView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgBgH;
@property (nonatomic, strong) NSMutableArray *imageViewArr;
- (void)updateImageViewImage:(NSArray *)urlArr width:(CGFloat)wid;
@property (nonatomic, weak) id<ADLGoodsEvaluateCellDelegate> delegate;

@end

