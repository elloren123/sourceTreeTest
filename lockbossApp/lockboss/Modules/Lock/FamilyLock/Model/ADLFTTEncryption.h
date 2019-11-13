//
//  ADLFTTEncryption.h
//  lockboss
//
//  Created by adel on 2019/10/25.
//  Copyright © 2019 adel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLFTTEncryption : NSObject
/**
 *  MD5加密, 32位 小写
 *
 *  @param str 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForLower32Bate:(NSString *)str;
/**
 *  加密
 *
 *  @param content 需要加密的content
 *
 *  @return 加密后的字符串
 */
+ (NSString *)encryptAES:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
