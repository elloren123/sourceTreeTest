//
//  ADLNetWorkManager.h
//  lockboss
//
//  Created by adel on 2019/3/26.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLNetWorkManager : NSObject

///单例
+ (instancetype)sharedManager;

///用户Token
@property (nonatomic, strong) NSString *token;

///网络状态
@property (nonatomic, assign) BOOL connent;

///是否是WIFI网络
@property (nonatomic, assign) BOOL wifi;

///post请求
+ (void)postWithPath:(NSString *)path
          parameters:(NSDictionary *)parameters
           autoToast:(BOOL)autoToast
             success:(void (^)(NSDictionary *responseDict))success
             failure:(void (^)(NSError *error))failure;

///post请求 字符串
+ (void)postStringPath:(NSString *)path
            stringData:(NSData *)stringData
             autoToast:(BOOL)autoToast
               success:(void (^)(NSDictionary *responseDict))success
               failure:(void (^)(NSError *error))failure;

///post 上传图片
+ (void)postImagePath:(NSString *)path
           parameters:(NSDictionary *)parameters
         imageDataArr:(NSArray <NSData *>*)imageDataArr
            imageName:(NSString *)imageName
            autoToast:(BOOL)autoToast
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(NSDictionary *responseDict))success
              failure:(void (^)(NSError *error))failure;

///下载文件
+ (NSURLSessionDownloadTask *)downloadFilePath:(NSString *)path
                                      progress:(void (^)(NSProgress *progress))progress
                                       success:(void (^)(NSString *filePath))success
                                       failure:(void (^)(NSError *error))failure;

///post请求，不验证证书
+ (void)postNormalPath:(NSString *)path
            parameters:(NSDictionary *)parameters
               success:(void (^)(NSDictionary *responseDict))success
               failure:(void (^)(NSError *error))failure;

///get请求，不验证证书
+ (void)getNormalPath:(NSString *)path
           parameters:(NSDictionary *)parameters
              success:(void (^)(NSDictionary *responseDict))success
              failure:(void (^)(NSError *error))failure;

@end
