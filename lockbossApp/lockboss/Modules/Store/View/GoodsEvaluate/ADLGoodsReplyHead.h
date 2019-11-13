//
//  ADLGoodsReplyHead.h
//  lockboss
//
//  Created by adel on 2019/7/1.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLGoodsReplyHeadDelegate <NSObject>

- (void)didClickUserIcon;

- (void)didClickContentLab:(UILabel *)label;

@end

@interface ADLGoodsReplyHead : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (nonatomic, strong) NSString *headShot;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, weak) id<ADLGoodsReplyHeadDelegate> delegate;
@end
