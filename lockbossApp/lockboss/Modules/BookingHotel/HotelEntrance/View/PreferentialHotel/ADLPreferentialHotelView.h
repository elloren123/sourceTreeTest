//
//  ADLPreferentialHotelView.h
//  lockboss
//
//  Created by adel on 2019/9/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADLPreferentialHotelView;

@protocol  ADLPreferentialHotelViewDelegate <NSObject>

- (void)ADLPreferentialHotelVie:(ADLPreferentialHotelView*)ListsortingView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ADLPreferentialHotelView : UIView
@property (nonatomic ,strong)UIView *lienView;

@property (nonatomic ,strong)NSMutableArray *array;

@property (nonatomic, copy) void(^moreBlock)(UIButton*btn);


@property (nonatomic ,weak)id <ADLPreferentialHotelViewDelegate>delegate;
@end

