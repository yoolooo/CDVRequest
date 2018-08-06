//
//  CDVNetworking.m
//  TianShanYunTV
//
//  Created by yan on 2017/11/16.
//  Copyright © 2017年 yanlong. All rights reserved.
//

#import "CDVNetworking.h"
#import <AFNetworking/AFNetworking.h>

@interface CDVNetworking ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;


@end

@implementation CDVNetworking

+ (instancetype)shareInstance{
    static CDVNetworking *cdvNetworking;
    static dispatch_once_t networkToken;
    dispatch_once(&networkToken, ^{
        cdvNetworking = [[CDVNetworking alloc] init];
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
        [NSURLCache setSharedURLCache:cache];
    });
    return cdvNetworking;
}

- (void)defaultManager{
    
    self.manager = [AFHTTPSessionManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"application/xml",nil];
    
    [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    _manager.requestSerializer.timeoutInterval = 20.f;
    [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    _manager.responseSerializer = serializer;
}

- (CDVConnectionType)getConnectionType {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    enum CDVConnectionType type;
    if([manager isReachable]){
        if([manager isReachableViaWiFi]){
            type = CDVConnectionTypeWifi;
        }
        else{
            type = CDVConnectionTypeWWAN;
        }
    }
    else{
        type = CDVConnectionTypeNone;
    }
    return type;
}



- (NSURLSessionDataTask*)sendRequestWithUrl:(NSString*)url method:(NSString *)method parameter:(NSDictionary*)params success:(CDVTypeBlock)success failure:(CDVErrorBlock)failure{
    
    url = [self validURL:url];
    NSURL *fullUrl = [NSURL URLWithString:url];
    if (!fullUrl.host) {
        failure([NSError errorWithDomain:@"Illegal URL" code:-100 userInfo:nil]);
        return nil;
    }
    
    NSURLSessionDataTask *task = nil;
    if (!_manager) {
        [self defaultManager];
    }
    if ([[method uppercaseString] isEqualToString:@"GET"]) {
        task = [_manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    }
    else if ([[method uppercaseString] isEqualToString:@"POST"]) {
        task = [_manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure(error);
        }];
    }
    return task;
}


- (NSURLSessionUploadTask *)uploadTaskByRequest:(NSURLRequest *)request process:(void (^) (NSProgress *uploadProgress))process success:(CDVTypeBlock)success failure:(CDVErrorBlock)failure{
    
    if (!_manager) {
        [self defaultManager];
    }
    NSURLSessionUploadTask *uploadTask = [_manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        !process? : process(uploadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            success(responseObject);
        }
        else {
            failure(error);
        }
    }];
    [uploadTask resume];
    return uploadTask;
}

- (NSURLSessionDownloadTask *)downloadFileByURL:(NSString *)url savePath:(NSString *)path process:(void (^) (NSProgress *downloadProgress))process success:(CDVVoidBlock)success failure:(CDVErrorBlock)failure{
    
    url = [self validURL:url];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.cdv.downloadTask"];
    configuration.allowsCellularAccess = NO;
    configuration.networkServiceType = NSURLNetworkServiceTypeBackground;
    
    if (!_manager) {
        [self defaultManager];
    }
    
    _manager.session.configuration.allowsCellularAccess = NO;
    _manager.session.configuration.networkServiceType = NSURLNetworkServiceTypeBackground;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSData *lastData = [NSData dataWithContentsOfFile:path];
    NSURLSessionDownloadTask *task;
    if (lastData) {
        task = [_manager downloadTaskWithResumeData:lastData progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"%@",downloadProgress);
            process ? process(downloadProgress) : nil;
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL URLWithString:path];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (!error) {
                success();
            }
            else {
                failure(error);
            }
        }];
    }else{
        task = [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"%@",downloadProgress);
            process ? process(downloadProgress) : nil;
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:path];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (!error) {
                success();
            }
            else {
                failure(error);
            }

        }];
        
    }
    
    [task resume];
    return task;
}


- (NSString *)validURL:(NSString *)url {

    if ([url hasPrefix:@"http"]) {
        return url;
    }
    else {
        return [NSString stringWithFormat:@"http://%@",url];
    }
    return nil;
}


@end
