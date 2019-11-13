//
//  ADLListsortingView.h
//  lockboss
//
//  Created by adel on 2019/9/20.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ADLListsortingView;
@protocol  ADLListsortingViewDelegate <NSObject>

- (void)ListsortingView :(ADLListsortingView *)ListsortingView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath iphone:(NSString *)iphone;

@end

@interface ADLListsortingView : UIView
-(instancetype)initWithFrame:(CGRect)frame navigheight:(CGFloat)navigheight;
@property (nonatomic, strong) NSArray *array;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, weak) UIView *backView;

@property (nonatomic ,weak)id <ADLListsortingViewDelegate>delegate;

- (void)remove;

@end


