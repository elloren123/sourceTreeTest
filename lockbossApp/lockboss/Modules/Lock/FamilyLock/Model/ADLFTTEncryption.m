//
//  ADLFTTEncryption.m
//  lockboss
//
//  Created by adel on 2019/10/25.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFTTEncryption.h"
#import <CommonCrypto/CommonCrypto.h>

NSString const *AESkInitVector = @".#@_back05ivkey!";
NSString const *AESKEY = @"._before.#0_back";
size_t const AESkKeySize = kCCKeySizeAES128;

@implementation ADLFTTEncryption

#pragma mark - 32位 小写
+(NSString *)MD5ForLower32Bate:(NSString *)str{
    
    //   NSString *strmd5 = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPasswordAllowedCharacterSet]];
    //    NSString*replacedStr = [strmd5 stringByReplacingOccurrencesOfString:@","withString:@"%2C"];
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}


/**
 *  加密
 *
 *  @param content 需要加密的string
 *
 *  @return 加密后的字符串
 */

+ (NSString *)encryptAES:(NSString *)content{
    
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = contentData.length;
    
    // 为结束符'\0' +1
    char keyPtr[AESkKeySize + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [AESKEY getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // 密文长度 <= 明文长度 + BlockSize
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    
    NSData *initVector = [AESkInitVector dataUsingEncoding:NSUTF8StringEncoding];
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,  // 系统默认使用 CBC，然后指明使用 PKCS7Padding
                                          keyPtr,
                                          AESkKeySize,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          encryptedBytes,
                                          encryptSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        // 对加密后的数据进行 base64 编码
        return [[NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    free(encryptedBytes);
    return nil;
}



@end
