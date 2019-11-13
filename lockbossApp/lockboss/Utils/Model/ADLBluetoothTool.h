//
//  ADLBluetoothTool.h
//  ADEL-APP
//
//  Created by bailun91 on 2018/7/26.
//

#import <Foundation/Foundation.h>

@interface ADLBluetoothTool : NSObject

@property (nonatomic, copy) NSString *BLEName;
@property (nonatomic, copy) NSString * mBLEKey;
- (void)BLEOpendoor;
@end
