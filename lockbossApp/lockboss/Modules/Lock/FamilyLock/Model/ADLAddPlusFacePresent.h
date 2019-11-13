//
//  ADLAddPlusFacePresent.h
//  lockboss
//
//  Created by adel on 2019/11/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^Success)(id response);
typedef void (^Fail)(void);

@interface ADLAddPlusFacePresent : NSObject

-(void)sendAddFaceAFWithSuccess:(Success)success Fial:(Fail)fail;

@end

NS_ASSUME_NONNULL_END
