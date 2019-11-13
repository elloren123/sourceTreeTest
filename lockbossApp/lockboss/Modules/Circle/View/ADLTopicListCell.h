//
//  ADLTopicListCell.h
//  lockboss
//
//  Created by adel on 2019/6/4.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLTopicListCellDelegate <NSObject>

- (void)didClickUserIcon:(UIImageView *)imageView;

- (void)didClickImageView:(UIImageView *)imageView;

- (void)didClickPraiseBtn:(UIButton *)sender;

@end

@interface ADLTopicListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nickLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgH;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *evaluateBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UIImageView *imgView4;
@property (weak, nonatomic) IBOutlet UIImageView *imgView5;
@property (weak, nonatomic) IBOutlet UIImageView *imgView6;
@property (weak, nonatomic) IBOutlet UIImageView *imgView7;
@property (weak, nonatomic) IBOutlet UIImageView *imgView8;
@property (weak, nonatomic) IBOutlet UIImageView *imgView9;
@property (nonatomic, strong) NSMutableArray *imageViewArr;
@property (nonatomic, weak) id<ADLTopicListCellDelegate> delegate;
- (void)updateImageViewImage:(NSArray *)urlArr content:(BOOL)content width:(CGFloat)wid;
@end

