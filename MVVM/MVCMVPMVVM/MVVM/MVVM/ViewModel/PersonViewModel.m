//
//  PersonViewModel.m
//  MVVM
//
//  Created by 一米阳光 on 2017/11/16.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import "PersonViewModel.h"

@implementation PersonViewModel

- (instancetype)initWithPerson:(Person *)person {
    self = [super init];
    if (self) {
        _person = person;
        if (_person.firstName.length > 0) {
            _nameText = _person.firstName;
        } else {
            _nameText = _person.lastName;
        }
    }
    return self;
}

@end
