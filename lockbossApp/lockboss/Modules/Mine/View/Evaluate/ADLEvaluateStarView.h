//
//  ADLEvaluateStarView.h
//  lockboss
//
//  Created by adel on 2019/6/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLEvaluateStarView : UIView

@property (nonatomic, assign) NSInteger firstStar;

@property (nonatomic, assign) NSInteger secondStar;

@property (nonatomic, assign) NSInteger thirdStar;

@property (weak, nonatomic) IBOutlet UILabel *firstLab;

@property (weak, nonatomic) IBOutlet UILabel *secondLab;

@property (weak, nonatomic) IBOutlet UILabel *thirdLab;

@end
