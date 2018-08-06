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

- (void)requestWithParams:(NSDictionary*)params{
    
    NSString *url = params[@"url"];
    NSDictionary *requestParams = params[@"params"];
    NSNumber *timeout = params[@"timeout"];
    NSNumber *showlog = params[@"showlog"];
    CDVVoidBlock willInvokeBlock = params[@"willInvokeBlock"];
    CDVActionComplationBlock didInvokeBlock = params[@"didInvokeBlock"];
    CDVTypeBlock success = params[@"successBlock"];
    CDVErrorBlock failure = params[@"failureBlock"];
    [self ylInterface_requestUrl:url Params:requestParams timeout:timeout.floatValue showlog:showlog.boolValue WillInvokeBlock:willInvokeBlock DidInvokeBlock:didInvokeBlock Success:success failure:failure];
    
}


- (void)ylInterface_requestUrl:(NSString*)url Params:(NSDictionary*)params timeout:(CGFloat)timeout showlog:(BOOL)showlog WillInvokeBlock:(CDVVoidBlock)willInvokeBlock DidInvokeBlock:(CDVActionComplationBlock)didInvokeBlock Success:(CDVTypeBlock)success failure:(CDVErrorBlock)failure{
    
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

@end
