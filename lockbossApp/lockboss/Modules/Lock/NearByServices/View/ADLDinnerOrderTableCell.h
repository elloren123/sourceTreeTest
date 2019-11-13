//
//  ADLDinnerOrderTableCell.h
//  lockboss
//
//  Created by bailun91 on 2019/9/27.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLDinnerOrderTableCell : UITableViewCell

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UILabel       *orderStatus;   //订单状态label
@property (nonatomic, strong) UILabel       *shopName;      //店家名字label
@property (nonatomic, strong) UIImageView   *shopImgV;      //店家icon
@property (nonatomic, strong) UILabel       *goodLeadLbl;   //商品指引label
@property (nonatomic, strong) UILabel       *priceLbl;      //订单总金额label
@property (nonatomic, strong) UIButton      *deleteBtn;     //删除btn
@property (nonatomic, strong) UIButton      *cancelBtn;     //取消btn
@property (nonatomic, strong) UIButton      *toPayBtn;      //去支付btn
@property (nonatomic, strong) UIButton      *againBtn;      //再来一单btn
@property (nonatomic, strong) UIButton      *refundBtn;     //退款btn
@property (nonatomic, strong) UIButton      *appraiseBtn;   //去评价btn

//点击按钮时
@property (nonatomic, copy) void(^BtnClickedBlock) (NSInteger tag);

- (void)updateCellSubviewFrame:(NSString *)statue;
- (void)createCellGoodLabel:(NSArray *)goods;

@end

NS_ASSUME_NONNULL_END
