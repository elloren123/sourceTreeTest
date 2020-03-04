//
//  Presenter.h
//  MVP
//
//  Created by 一米阳光 on 2017/11/16.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonViewProtocol.h"

@interface Presenter : NSObject

- (void)attachView:(id <PersonViewProtocol>)view;

- (void)fetchData;

@end
