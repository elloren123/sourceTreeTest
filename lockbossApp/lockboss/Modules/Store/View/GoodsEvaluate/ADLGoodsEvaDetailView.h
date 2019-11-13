//
//  ADLGoodsEvaDetailView.h
//  lockboss
//
//  Created by adel on 2019/6/28.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLGoodsEvaDetailView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nickLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIImageView *starImgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *skuNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UIImageView *imgView4;
@property (weak, nonatomic) IBOutlet UIImageView *imgView5;
@property (weak, nonatomic) IBOutlet UIImageView *imgView6;
@property (weak, nonatomic) IBOutlet UIImageView *imgView7;
@property (weak, nonatomic) IBOutlet UIImageView *imgView8;
@property (weak, nonatomic) IBOutlet UIImageView *imgView9;
@property (weak, nonatomic) IBOutlet UILabel *replyNumLab;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSMutableArray *urlArr;
@property (nonatomic, strong) NSMutableArray *imageViewArr;
@property (nonatomic, copy) void (^clickImageView) (void);
- (void)updateImageViewImage:(NSArray *)urlArr width:(CGFloat)wid;
@end

