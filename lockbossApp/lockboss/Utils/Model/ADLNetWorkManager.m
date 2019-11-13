//
//  ADLNetWorkManager.m
//  lockboss
//
//  Created by adel on 2019/3/26.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLNetWorkManager.h"
#import "ADLLocalizedHelper.h"
#import "ADLGlobalDefine.h"
#import "ADLToast.h"
#import "ADLUtils.h"

#import <AFNetworking.h>

//static NSString *base_url = @"https://shop.adellock.com/";
static NSString *base_url = @"https://testshop.adellock.com/";

@implementation ADLNetWorkManager {
    AFHTTPSessionManager *_secureManager;
    AFHTTPSessionManager *_normalManager;
    AFHTTPSessionManager *_lockManager;
}

+ (instancetype)sharedManager {
    static ADLNetWorkManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ADLNetWorkManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 29;
        
        //商城
        _secureManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:base_url] sessionConfiguration:config];
        _secureManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"text/json",@"application/json",@"text/javascript", nil];
        _secureManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _secureManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_secureManager.requestSerializer setValue:@"ios_0" forHTTPHeaderField:@"login-client-type"];
        [_secureManager setSecurityPolicy:[self httpsCertificate]];
        
        //开锁
        _lockManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
        _lockManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"text/json",@"application/json",@"text/javascript", nil];
        _lockManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _lockManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_lockManager.requestSerializer setValue:ADEL_DEVICEID forHTTPHeaderField:@"appid"];
        [_lockManager.requestSerializer setValue:[ADLUtils sha1Encrypt:ADEL_DEVICEID] forHTTPHeaderField:@"appIDEncrypt"];
        _lockManager.securityPolicy.validatesDomainName = NO;
        
        ///网络请求，不验证证书
        _normalManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
        _normalManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"text/json",@"application/json",@"text/javascript", nil];
        _normalManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _normalManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _normalManager.securityPolicy.validatesDomainName = NO;
        
        ///添加极光IM获取文件真实链接地址授权
        NSData *authData = [[NSString stringWithFormat:@"%@:%@",JG_KEY,JG_SECRET] dataUsingEncoding:NSUTF8StringEncoding];
        NSString *authStr = [NSString stringWithFormat:@"Basic %@",[authData base64EncodedStringWithOptions:0]];
        [_normalManager.requestSerializer setValue:authStr forHTTPHeaderField:@"Authorization"];
        _connent = YES;
    }
    return self;
}

#pragma mark ------ Https 证书 ------
- (AFSecurityPolicy *)httpsCertificate {
    NSString *testPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"cer"];
    NSData *testData = [NSData dataWithContentsOfFile:testPath];
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"shop" ofType:@"cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData,testData, nil];
    securityPolicy.allowInvalidCertificates = YES;
    return securityPolicy;
}

#pragma mark ------ 设置Token ------
- (void)setToken:(NSString *)token {
    _token = token;
    [_secureManager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    [_lockManager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
}

#pragma mark ------ post请求 ------
+ (void)postWithPath:(NSString *)path
          parameters:(NSDictionary *)parameters
           autoToast:(BOOL)autoToast
             success:(void (^)(NSDictionary *responseDict))success
             failure:(void (^)(NSError *error))failure {
    [[self sharedManager] postWithPath:path parameters:parameters autoToast:autoToast success:success failure:failure];
}

- (void)postWithPath:(NSString *)path
          parameters:(NSDictionary *)parameters
           autoToast:(BOOL)autoToast
             success:(void (^)(NSDictionary *responseDict))success
             failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *manager = _secureManager;
    if ([path hasPrefix:@"http"]) manager = _lockManager;
    [manager POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dealwithResponseObject:responseObject autoToast:autoToast success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dealwithError:error autoToast:autoToast failure:failure];
    }];
}

#pragma mark ------ Post 字符串数据 ------
+ (void)postStringPath:(NSString *)path
            stringData:(NSData *)stringData
             autoToast:(BOOL)autoToast
               success:(void (^)(NSDictionary *responseDict))success
               failure:(void (^)(NSError *error))failure {
    [[self sharedManager] postStringPath:path stringData:stringData autoToast:autoToast success:success failure:failure];
}

- (void)postStringPath:(NSString *)path
            stringData:(NSData *)stringData
             autoToast:(BOOL)autoToast
               success:(void (^)(NSDictionary *responseDict))success
               failure:(void (^)(NSError *error))failure {
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager setSecurityPolicy:[self httpsCertificate]];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",base_url,path] parameters:nil error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"ios_0" forHTTPHeaderField:@"login-client-type"];
    [request setValue:self.token forHTTPHeaderField:@"token"];
    [request setHTTPBody:stringData];
    request.timeoutInterval = 29;
    
    [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [self dealwithError:error autoToast:autoToast failure:failure];
        } else {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSInteger responseCode = [responseObject[@"code"] integerValue];
                if (responseCode == 10000) {
                    if (success) success(responseObject);
                } else if (responseCode == 30003 || responseCode == 30002) {
                    [self accountSqueezedOut];
                } else {
                    if (autoToast) [ADLToast showMessage:responseObject[@"msg"]];
                    if (success) success(responseObject);
                }
            } else {
                [self dealwithResponseObject:responseObject autoToast:autoToast success:success];
            }
        }
    }] resume];
}

#pragma mark ------ post 上传图片 ------
+ (void)postImagePath:(NSString *)path
           parameters:(NSDictionary *)parameters
         imageDataArr:(NSArray<NSData *> *)imageDataArr
            imageName:(NSString *)imageName
            autoToast:(BOOL)autoToast
             progress:(void (^)(NSProgress *))progress
              success:(void (^)(NSDictionary *))success
              failure:(void (^)(NSError *))failure {
    [[self sharedManager] postImagePath:path parameters:parameters imageDataArr:imageDataArr imageName:imageName autoToast:autoToast progress:progress success:success failure:failure];
}

- (void)postImagePath:(NSString *)path
           parameters:(NSDictionary *)parameters
         imageDataArr:(NSArray<NSData *> *)imageDataArr
            imageName:(NSString *)imageName
            autoToast:(BOOL)autoToast
             progress:(void (^)(NSProgress *))progress
              success:(void (^)(NSDictionary *))success
              failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = _secureManager;
    if ([path hasPrefix:@"http"]) manager = _lockManager;
    [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmssSSS";
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        
        if (imageDataArr.count == 1) {
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",dateStr];
            [formData appendPartWithFileData:imageDataArr.firstObject name:imageName fileName:fileName mimeType:@"image/jpg"];
            
        } else {
            for (int i = 0; i < imageDataArr.count; i++) {
                NSData *imageData = imageDataArr[i];
                NSString *fileName = [NSString stringWithFormat:@"%@-%02d.jpg",dateStr,i+1];
                [formData appendPartWithFileData:imageData name:imageName fileName:fileName mimeType:@"image/jpg"];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dealwithResponseObject:responseObject autoToast:autoToast success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dealwithError:error autoToast:autoToast failure:failure];
    }];
}

#pragma mark ------ 下载文件 ------
+ (NSURLSessionDownloadTask *)downloadFilePath:(NSString *)path
                                      progress:(void (^)(NSProgress *progress))progress
                                       success:(void (^)(NSString *filePath))success
                                       failure:(void (^)(NSError *error))failure {
    return [[self sharedManager] downloadFilePath:path progress:progress success:success failure:failure];
}

- (NSURLSessionDownloadTask *)downloadFilePath:(NSString *)path
                                      progress:(void (^)(NSProgress *progress))progress
                                       success:(void (^)(NSString *filePath))success
                                       failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *cachePath = [docPath stringByAppendingPathComponent:@"myCache"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *filename = [NSString stringWithFormat:@"%@.%@",[ADLUtils md5Encrypt:path lower:YES],[path componentsSeparatedByString:@"."].lastObject];
        NSString *filePath = [cachePath stringByAppendingPathComponent:filename];
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        } else {
            if (success) {
                success(filePath.path);
            }
        }
    }];
    [task resume];
    return task;
}

#pragma mark ------ post请求，不验证证书 ------
+ (void)postNormalPath:(NSString *)path
            parameters:(NSDictionary *)parameters
               success:(void (^)(NSDictionary *responseDict))success
               failure:(void (^)(NSError *error))failure {
    [[self sharedManager] postNormalPath:path parameters:parameters success:success failure:failure];
}

- (void)postNormalPath:(NSString *)path
            parameters:(NSDictionary *)parameters
               success:(void (^)(NSDictionary *responseDict))success
               failure:(void (^)(NSError *error))failure {
    [_normalManager POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dealwithResponseObject:responseObject autoToast:NO success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dealwithError:error autoToast:NO failure:failure];
    }];
}

#pragma mark ------ get请求，不验证证书 ------
+ (void)getNormalPath:(NSString *)path
           parameters:(NSDictionary *)parameters
              success:(void (^)(NSDictionary *responseDict))success
              failure:(void (^)(NSError *error))failure {
    [[self sharedManager] getNormalPath:path parameters:parameters success:success failure:failure];
}

- (void)getNormalPath:(NSString *)path
           parameters:(NSDictionary *)parameters
              success:(void (^)(NSDictionary *responseDict))success
              failure:(void (^)(NSError *error))failure {
    [_normalManager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dealwithResponseObject:responseObject autoToast:NO success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dealwithError:error autoToast:NO failure:failure];
    }];
}

#pragma mark ------ 处理成功请求 ------
- (void)dealwithResponseObject:(id)responseObject autoToast:(BOOL)autoToast success:(void (^)(NSDictionary *responseDict))success {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    if (dict == nil) {
        NSString *qqCallback = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([qqCallback containsString:@"{"] && [qqCallback containsString:@"}"]) {
            NSRange startR = [qqCallback rangeOfString:@"{\""];
            NSRange endR = [qqCallback rangeOfString:@"\"}"];
            NSRange range = NSMakeRange(startR.location, endR.location+2-startR.location);
            NSString *jsonStr = [qqCallback substringWithRange:range];
            NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            if (data && success) {
                success([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
            }
        } else {
            [ADLToast showMessage:ADLString(@"network_wrong")];
        }
    } else {
        NSInteger code = [dict[@"code"] integerValue];
        if (code == 10000) {
            if (success) success(dict);
        } else if (code == 30003 || code == 30002 || code == 10029) {
            [self accountSqueezedOut];
        } else {
            if (autoToast) [ADLToast showMessage:dict[@"msg"]];
            if (success) success(dict);
        }
    }
}

#pragma mark ------ 处理失败请求 ------
- (void)dealwithError:(NSError *)error autoToast:(BOOL)autoToast failure:(void (^)(NSError *error))failure {
    if (error.code != -999) {
        if (autoToast) {
            if (self.connent) {
                if (error.code == -1001) {
                    if ([ADLToast isShowLoading]) {
                        [ADLToast showMessage:ADLString(@"network_slow")];
                    }
                } else {
                    [ADLToast showMessage:ADLString(@"network_wrong")];
                }
            } else {
                [ADLToast showMessage:ADLString(@"network_unavailable")];
            }
        }
        if (failure) failure(error);
    }
}

#pragma mark ------ 账号被挤出 ------
- (void)accountSqueezedOut {
    [_lockManager.tasks makeObjectsPerformSelector:@selector(cancel)];
    [_secureManager.tasks makeObjectsPerformSelector:@selector(cancel)];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UNREAD_CHANGED object:@"logout" userInfo:nil];
}

@end
