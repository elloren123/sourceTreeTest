//
//  ADLRecorderDetailView.h
//  lockboss
//
//  Created by adel on 2019/6/26.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLRecorderDetailViewDelegate <NSObject>

- (void)didClickContactPhoneBtn;

- (void)didClickCompanyAbstractBtn;

@end

@interface ADLRecorderDetailView : UIView

@property (nonatomic, weak) id<ADLRecorderDetailViewDelegate> delegate;

- (void)updateContentWithDict:(NSDictionary *)dict;

@end
