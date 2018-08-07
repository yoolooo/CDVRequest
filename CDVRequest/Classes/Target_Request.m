//
//  Target_Request.m
//  CDVRequest_Example
//
//  Created by yan on 2018/8/6.
//  Copyright © 2018年 yoolooo. All rights reserved.
//

#import "Target_Request.h"
#import "CDVNetManager.h"

@implementation Target_Request


- (void)action_setCodeKey:(NSString *)codeKey{
    [[CDVNetManager shareInstance] codeKey:codeKey];
}

- (void)action_setGlobleParameter:(NSDictionary*)globleParames{
    CDVNetManager *manager = [CDVNetManager shareInstance];
    manager.globleParameter = globleParames;
}

- (void)action_setWarningCodesAndHandler:(NSDictionary*)params{
    
    NSArray *codes = params[@"warningCodes"];
    void(^returnHandler)(NSString *code) = params[@"handler"];
    [[CDVNetManager shareInstance] warningReternCodes:codes withHandler:returnHandler];
}


- (void)action_requestWithParams:(NSDictionary*)params{
    
    NSString *url = params[@"url"];
    NSDictionary *requestParams = params[@"params"];
    NSNumber *timeout = params[@"timeout"];
    NSNumber *showlog = params[@"showlog"];
    CDVVoidBlock willInvokeBlock = params[@"willInvokeBlock"];
    CDVActionComplationBlock didInvokeBlock = params[@"didInvokeBlock"];
    CDVTypeBlock success = params[@"successBlock"];
    CDVErrorBlock failure = params[@"failureBlock"];
    [self requestUrl:url Params:requestParams timeout:timeout.floatValue showlog:showlog.boolValue WillInvokeBlock:willInvokeBlock DidInvokeBlock:didInvokeBlock Success:success failure:failure];
}

- (void)action_uploadWithParams:(NSDictionary*)params{
    
    NSString *url = params[@"url"];
    NSDictionary *requestParams = params[@"params"];
    NSData *file = params[@"data"];
    NSString *fileName = params[@"fileName"];
    NSString *uploadName = params[@"uploadName"];
    NSString *mimeType = params[@"mimeType"];
    void (^progress) (NSProgress *uploadProgress) = params[@"progress"];
    CDVTypeBlock success = params[@"successBlock"];
    CDVErrorBlock failure = params[@"failureBlock"];
    [self uploadWithUrl:url params:requestParams file:file uploadName:uploadName fileName:fileName mimeType:mimeType Progress:progress Success:success failure:failure];
}


- (void)requestUrl:(NSString*)url Params:(NSDictionary*)params timeout:(CGFloat)timeout showlog:(BOOL)showlog WillInvokeBlock:(CDVVoidBlock)willInvokeBlock DidInvokeBlock:(CDVActionComplationBlock)didInvokeBlock Success:(CDVTypeBlock)success failure:(CDVErrorBlock)failure{
    
    CDVNetAction *action = [[CDVNetAction alloc] initWithURL:url];
    [action setHttpMethod:CDVHttpPost];
#ifdef DEBUG
    action.showLog = showlog;
#else
    action.showLog = NO;
#endif
    action.timeout = timeout;
    if (params) {
        [action.parameter addEntriesFromDictionary:params];
    }
    
    action.actionWillInvokeBlock = ^(){
        if (willInvokeBlock) {
            willInvokeBlock();
        }
    };
    action.actionDidInvokeBlock = ^(BOOL isSuccess){
        if (didInvokeBlock) {
            didInvokeBlock(isSuccess);
        }
    };
    [[CDVNetManager shareInstance] requestAction:action success:^(id object) {
        success ? success(object) : nil;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        failure ? failure (error) : nil;
    }];
}



- (void)uploadWithUrl:(NSString*)url params:(NSDictionary*)params file:(NSData*)data uploadName:(NSString*)uploadName fileName:(NSString*)fileName mimeType:(NSString*)mimeType Progress:(void (^) (NSProgress *uploadProgress))progress Success:(CDVTypeBlock)success failure:(CDVErrorBlock)failure{
    
    CDVUploadAction *action = [[CDVUploadAction alloc] initWithURL:url];
    action.timeout = 10;
    [action.parameter addEntriesFromDictionary:params];
    [action setHttpMethod:CDVHttpPost];
    action.data = data;
    action.uploadName = uploadName;
    action.fileName = fileName;
    action.mimeType = mimeType;
    [[CDVNetManager shareInstance] uploadAction:action progress:progress success:success failure:failure];
}

@end
