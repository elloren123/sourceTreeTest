//
//  ADLTopicDetailHeadView.h
//  lockboss
//
//  Created by adel on 2019/6/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLTopicDetailHeadViewDelegate <NSObject>

- (void)didClickTopicContentLab:(UILabel *)contentLab;

- (void)didClickTopicHeaderImageView:(UIImageView *)imageView;

- (void)didClickTopicImageView:(UIImageView *)imageView;

@end

@interface ADLTopicDetailHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nickLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgH;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UIImageView *imgView4;
@property (weak, nonatomic) IBOutlet UIImageView *imgView5;
@property (weak, nonatomic) IBOutlet UIImageView *imgView6;
@property (weak, nonatomic) IBOutlet UIImageView *imgView7;
@property (weak, nonatomic) IBOutlet UIImageView *imgView8;
@property (weak, nonatomic) IBOutlet UIImageView *imgView9;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *praiseLab;
@property (weak, nonatomic) IBOutlet UILabel *evaluateLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgTop;
@property (nonatomic, weak) id<ADLTopicDetailHeadViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *imageViewArr;
- (void)updateImageViewImage:(NSArray *)urlArr content:(BOOL)content width:(CGFloat)wid;

@end
