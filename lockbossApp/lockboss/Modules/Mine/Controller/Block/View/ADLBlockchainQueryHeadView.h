//
//  ADLBlockchainQueryHeadView.h
//  ADEL-APP
//
//  Created by adel on 2019/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLBlockchainQueryHeadView : UIView
@property (nonatomic ,copy)void(^blockBtn)(UIButton*btn);
@property (nonatomic ,strong)UIButton *lockbtn;
@end

NS_ASSUME_NONNULL_END
