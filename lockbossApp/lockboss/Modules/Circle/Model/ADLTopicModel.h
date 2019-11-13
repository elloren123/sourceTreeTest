//
//  ADLTopicModel.h
//  lockboss
//
//  Created by adel on 2019/6/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLTopicModel : NSObject

@property (nonatomic, strong) NSString *headShot;

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSNumber *fabulousNums;

@property (nonatomic, strong) NSNumber *commentNums;

@property (nonatomic, strong) NSNumber *fabulousFlag;

@property (nonatomic, strong) NSString *commentId;

@property (nonatomic, strong) NSString *createUser;

@property (nonatomic, assign) CGFloat headerH;

@property (nonatomic, strong) NSMutableArray *replys;

@property (nonatomic, strong) NSMutableArray *cellHArr;

@end

