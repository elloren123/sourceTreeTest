//
//  ADLRMQConnection.h
//  lockboss
//
//  Created by Adel on 2019/9/3.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLRMQConnection : NSObject

+ (instancetype)sharedConnect;

- (void)startConnection;

- (void)closeConnection;

@end
