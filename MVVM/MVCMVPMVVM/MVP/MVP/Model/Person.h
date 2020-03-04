//
//  Person.h
//  MVP
//
//  Created by 一米阳光 on 2017/11/16.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;

@end
