//
//  ADLTopicCommentCell.h
//  lockboss
//
//  Created by adel on 2019/6/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLTopicCommentCellDelegate <NSObject>

- (void)didClickReplyLabel:(UILabel *)label;

@end

@interface ADLTopicCommentCell : UITableViewCell

@property (nonatomic, strong) UILabel *contentLab;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, weak) id<ADLTopicCommentCellDelegate> delegate;

@end

