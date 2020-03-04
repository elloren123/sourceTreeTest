//
//  Presenter.m
//  MVP
//
//  Created by 一米阳光 on 2017/11/16.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import "Presenter.h"
#import "Person.h"

@interface Presenter()

@property (nonatomic, strong) Person *person;
@property (nonatomic, weak) id<PersonViewProtocol> attachView;

@end

@implementation Presenter

- (void)attachView:(id<PersonViewProtocol>)view {
    self.attachView = view;
}

- (void)fetchData {
    self.person = [[Person alloc] initWithFirstName:@"赵丽颖" lastName:@"胡歌"];
    if (self.person.firstName.length > 0) {
        [self.attachView setNameText:self.person.firstName];
    } else {
        [self.attachView setNameText:self.person.lastName];
    }
}

@end





































