//
//  ADLCommetViewCell.m
//  lockboss
//
//  Created by bailun91 on 2019/10/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLCommetViewCell.h"

@implementation ADLCommetViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
        _userHeadImgV = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 60, 60)];
        _userHeadImgV.layer.cornerRadius = 30.0;
        _userHeadImgV.layer.masksToBounds = YES;
        _userHeadImgV.image = [UIImage imageNamed:@"user_head"];
        [self.contentView addSubview:_userHeadImgV];
        
        
        _userNameLab = [[UILabel alloc] initWithFrame:CGRectMake(78, 10, SCREEN_WIDTH/2, 30)];
        _userNameLab.font = [UIFont systemFontOfSize:15];
        _userNameLab.textAlignment = NSTextAlignmentLeft;
        _userNameLab.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_userNameLab];
        
        
        
        _cmtDateLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-10, 10, SCREEN_WIDTH/2, 30)];
        _cmtDateLab.font = [UIFont systemFontOfSize:14.5];
        _cmtDateLab.textAlignment = NSTextAlignmentRight;
        _cmtDateLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_cmtDateLab];
        
        
        //评分'星星'
        for (int i = 0 ; i < 5; i++) {
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(78+17*i, 43, 15, 14)];
            [self.contentView addSubview:imgV];
            
            if (0 == i) {
                _scoreImgV1 = imgV;
            } else if (1 == i) {
                _scoreImgV2 = imgV;
            } else if (2 == i) {
                _scoreImgV3 = imgV;
            } else if (3 == i) {
                _scoreImgV4 = imgV;
            } else if (4 == i) {
                _scoreImgV5 = imgV;
            }
        }
        
        _cmtMsgLab = [[UILabel alloc] init];
        _cmtMsgLab.font = [UIFont systemFontOfSize:12.5];
        _cmtMsgLab.textAlignment = NSTextAlignmentLeft;
        _cmtMsgLab.textColor = [UIColor blackColor];
        _cmtMsgLab.numberOfLines = 0;
        [self.contentView addSubview:_cmtMsgLab];

        
        
        _cmtImgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_cmtImgV];
        
        _cmtImgV2 = [[UIImageView alloc] init];
        [self.contentView addSubview:_cmtImgV2];
        
        _cmtImgV3 = [[UIImageView alloc] init];
        [self.contentView addSubview:_cmtImgV3];
        
        
        _stoMsgLab = [[UILabel alloc] init];
        _stoMsgLab.font = [UIFont systemFontOfSize:12.5];
        _stoMsgLab.textAlignment = NSTextAlignmentLeft;
        _stoMsgLab.textColor = [UIColor lightGrayColor];
        _stoMsgLab.numberOfLines = 0;
        _stoMsgLab.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        [self.contentView addSubview:_stoMsgLab];
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:line];
        _lineV = line;
    }
    
    return self;
}

//子控件布局
- (void)layoutSubviews {
//    self.cmtMsgLab.frame = CGRectMake(78, 59, SCREEN_WIDTH-88, 40);
//    self.cmtImgV.frame   = CGRectMake(78, 100, 60, 60);
//    self.cmtImgV2.frame  = CGRectMake(140, 100, 60, 60);
//    self.cmtImgV3.frame  = CGRectMake(202, 100, 60, 60);
//    self.stoMsgLab.frame = CGRectMake(78, self.frame.size.height-35, SCREEN_WIDTH-88, 30);
    self.lineV.frame = CGRectMake(0, self.frame.size.height-1, SCREEN_WIDTH, 1);
}


- (void)updateSubviewsFrame:(ADLNYCommetViewModel *)model {
    self.cmtMsgLab.frame = CGRectMake(78, 60, SCREEN_WIDTH-88, model.userMsgHeight);
    self.cmtImgV.frame   = CGRectMake(78, model.userMsgHeight+60, 80, model.cmtImgHeight);
    self.cmtImgV2.frame  = CGRectMake(160, model.userMsgHeight+60, 80, model.cmtImgHeight);
    self.cmtImgV3.frame  = CGRectMake(242, model.userMsgHeight+60, 80, model.cmtImgHeight);
    self.stoMsgLab.frame = CGRectMake(78, model.userMsgHeight+60+model.cmtImgHeight, SCREEN_WIDTH-88, model.replyHeight);
}

@end
