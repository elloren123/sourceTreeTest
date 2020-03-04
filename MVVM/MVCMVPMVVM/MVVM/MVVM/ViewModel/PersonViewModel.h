//
//  PersonViewModel.h
//  MVVM
//
//  Created by 一米阳光 on 2017/11/16.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface PersonViewModel : NSObject

@property (nonatomic, readonly) Person *person;
@property (nonatomic, readonly) NSString *nameText;

- (instancetype)initWithPerson:(Person *)person;

@end
