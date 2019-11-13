//
//  ADLTopicCommentHeader.h
//  lockboss
//
//  Created by adel on 2019/6/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLTopicCommentHeaderDelegate <NSObject>

- (void)didClickCommentHeadImage:(UIImageView *)imageView;

- (void)didClickCommentPraiseBtn:(UIButton *)sender;

- (void)didClickCommentReplyBtn:(UIButton *)sender contentLab:(UILabel *)contentLab;

- (void)didClickCommentContentLab:(UILabel *)contentLab;

@end

@interface ADLTopicCommentHeader : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nickLab;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *spView;
@property (nonatomic, assign) NSInteger section;


@property (nonatomic, weak) id<ADLTopicCommentHeaderDelegate> delegate;

@end

