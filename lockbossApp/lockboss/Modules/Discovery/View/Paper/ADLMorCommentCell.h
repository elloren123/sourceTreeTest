//
//  ADLMorCommentCell.h
//  lockboss
//
//  Created by adel on 2019/5/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLMorCommentCellDelegate <NSObject>

- (void)didClickIconImageView:(UIImageView *)imageView;

- (void)didClickLikeButton:(UIButton *)sender;

@end

@interface ADLMorCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nickLab;
@property (weak, nonatomic) IBOutlet UILabel *commentLab;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *likeLab;
@property (nonatomic, weak) id<ADLMorCommentCellDelegate> delegate;
@end
