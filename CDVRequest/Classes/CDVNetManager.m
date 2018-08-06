//
//  CDVNetManager.m
//  TianShanYunTV
//
//  Created by yan on 2017/11/16.
//  Copyright © 2017年 yanlong. All rights reserved.
//

#import "CDVNetManager.h"
#import "CDVNetworking.h"
#import <AFNetworking/AFNetworking.h>

@interface CDVNetManager ()

@property (nonatomic, strong) NSString *codeKey;
@property (nonatomic, strong) NSArray <NSString *> *warnningCodes;
@property (nonatomic, copy) CDVWarnningCodesHandler warnningCodesHandler;

@end


@implementation CDVNetManager

+ (instancetype)shareInstance{
    
    static CDVNetManager *manager = nil;
    if (!manager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[CDVNetManager alloc] init];
        });
    }
    return manager;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
    }
    return self;
}

- (void)codeKey:(NSString *)key{
    self.codeKey = key;
}

- (void)warningReternCodes:(NSArray<NSString *>*)codes withHandler:(void (^) (NSString *code))handler{
    
    self.warnningCodes = codes;
    self.warnningCodesHandler = handler;
}

- (void)requestAction:(CDVNetAction*)action success:(CDVTypeBlock)success failure:(CDVErrorBlock)failure{
    
    if (![self availableUrl:action.url]) {
        return;
    }
    
    [action.parameter addEntriesFromDictionary:self.globleParameter];
    [self showLogByAction:action];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        action.actionWillInvokeBlock ? action.actionWillInvokeBlock() : nil;
    });
    
    NSURLSessionDataTask *task;
    __weak typeof(self) weakSelf = self;
    task = [[CDVNetworking shareInstance] sendRequestWithUrl:action.url method:action.method parameter:action.parameter success:^(id object) {
        [weakSelf handleAction:action withResponse:object success:^(id object) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !action.actionDidInvokeBlock ? : action.actionDidInvokeBlock(YES);
                success(object);
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !action.actionDidInvokeBlock ? : action.actionDidInvokeBlock(NO);
                failure(error);
            });
        }];
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !action.actionDidInvokeBlock ? : action.actionDidInvokeBlock(NO);
            failure(error);
        });
    }];
    
}

- (NSURLSessionUploadTask *)uploadAction:(CDVUploadAction *)action progress:(void (^) (NSProgress *uploadProgress))progress success:(CDVTypeBlock)success failure:(CDVErrorBlock)failure{
    
    [action.parameter addEntriesFromDictionary:self.globleParameter];
    [self showLogByAction:action];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        action.actionWillInvokeBlock ? action.actionWillInvokeBlock() : nil;
    });
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:action.url parameters:action.parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (action.data) {
            [formData appendPartWithFileData:action.data name:action.uploadName fileName:action.fileName mimeType:action.mimeType];
        }
    } error:nil];
    
    request.timeoutInterval = action.timeout;
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionUploadTask *uploadTask = [[CDVNetworking shareInstance] uploadTaskByRequest:request process:progress success:^(id object) {
        [weakSelf handleAction:action withResponse:object success:^(id object) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !action.actionDidInvokeBlock ? : action.actionDidInvokeBlock(YES);
            });
            success(object);
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !action.actionDidInvokeBlock ? : action.actionDidInvokeBlock(NO);
            });
            failure(error);
        }];
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !action.actionDidInvokeBlock ? : action.actionDidInvokeBlock(NO);
        });
        failure(error);
    }];
    return uploadTask;
    
}

- (void)showLogByAction:(CDVNetAction *)action {
    if (action.showLog) {
        NSString *fullURL = action.url;
        NSString *urlToLog = fullURL;
        if (action.parameter) {
            urlToLog = [urlToLog stringByAppendingString:@"?"];
            for (NSString *key in [action.parameter allKeys]) {
                urlToLog = [urlToLog stringByAppendingFormat:@"%@=%@&",key,action.parameter[key]];
            }
            urlToLog = [urlToLog substringToIndex:urlToLog.length - 1];
        }
        NSLog(@"url:%@",urlToLog);
        NSLog(@"methods:%@",action.method);
        NSLog(@"params:%@",action.parameter);
    }
}

- (void)handleAction:(CDVNetAction *)action withResponse:(id)object success:(CDVTypeBlock)success failure:(CDVErrorBlock)failure {

    if (![object isKindOfClass:[NSData class]]) {
        if (action.showLog) {
            NSLog(@"Return object is unknown");
        }
        failure([NSError errorWithDomain:@"Return object is not NSData" code:-300 userInfo:nil]);
        return;
    }
    
    id returnObject = [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingMutableContainers error:nil];
    
    if (![returnObject isKindOfClass:[NSArray class]] && ![returnObject isKindOfClass:[NSDictionary class]]) {
        if (action.showLog) {
            NSString *returnStr = [[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding];
            NSLog(@"error return:%@",returnStr);
        }
        failure([NSError errorWithDomain:@"Return object can not converted to JSON" code:-400 userInfo:nil]);
        return;
    }
    
    //如果是NSArray类型,则无需检查code,直接返回即可
    if ([returnObject isKindOfClass:[NSArray class]]) {
        if (action.showLog) {
            NSLog(@"%@",returnObject);
        }
        success(returnObject);
        return;
    }
    
    if (!_codeKey) {
        if (action.showLog) {
            NSLog(@"%@",returnObject);
        }
        success(returnObject);
        return;
    }
    
    NSDictionary *responseDict = returnObject;
    NSString *returnCode = nil;
    id targetCode = responseDict[_codeKey];
    if ([targetCode isKindOfClass:[NSNull class]]) {
        if (action.showLog) {
            NSLog(@"%@",returnObject);
        }
        success(returnObject);
        return;
    }
    if (!targetCode) {
        if (action.showLog) {
            NSLog(@"%@",returnObject);
        }
        success(returnObject);
        return;
    }
    if ([targetCode isKindOfClass:[NSString class]]) {
        returnCode = targetCode;
    }else {
        
        returnCode = [targetCode stringValue];
    }
    BOOL isWarningCode = NO;
    for(NSString *warningCode in _warnningCodes){
        if([returnCode isEqualToString:warningCode]){
            isWarningCode = YES;;
            break;
        }
    }
    if (isWarningCode) {
        if (action.showLog) {
            NSLog(@"%@",returnObject);
            NSLog(@"enter warning code handler process,return code is:%@",returnCode);
            success(returnObject);
            !_warnningCodesHandler ? : _warnningCodesHandler(returnCode);
        }
    }else{
        if (action.showLog) {
            NSLog(@"%@",returnObject);
        }
        success(returnObject);
    }
}

- (BOOL)availableUrl:(NSString*)url{
    
    if (url.length>0) {
        if ([url hasPrefix:@"http"] || [url hasPrefix:@"HTTP"]) {
            return YES;
        }
    }
    
    return NO;
}

@end
