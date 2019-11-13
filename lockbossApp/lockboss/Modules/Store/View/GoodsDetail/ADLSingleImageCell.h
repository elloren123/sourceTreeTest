//
//  ADLSingleImageCell.h
//  lockboss
//
//  Created by adel on 2019/5/14.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLSingleImageCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imgSize:(CGSize)imgSize;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) NSString *imgUrl;

@end
