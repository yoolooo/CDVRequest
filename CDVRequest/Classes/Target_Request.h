//
//  Target_Request.h
//  CDVRequest_Example
//
//  Created by yan on 2018/8/6.
//  Copyright © 2018年 yoolooo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_Request : NSObject


/**
 设置code字段
 @param params
 codekey[@"codeKey"]
 */
- (void)action_setCodeKey:(NSDictionary*)codeKey;

/**
 设置全局请求参数
 */
- (void)action_setGlobleParameter:(NSDictionary*)globleParames;

/**
 设置警告代码
 @param params
 NSArray *codes = params[@"warningCodes"];
 void(^returnHandler)(NSString *code) = params[@"handler"];
 */
- (void)action_setWarningCodesAndHandler:(NSDictionary*)params;

/**
开始请求
 @param params
 NSString *url = params[@"url"];
 NSDictionary *requestParams = params[@"params"];
 NSNumber *timeout = params[@"timeout"];
 NSNumber *showlog = params[@"showlog"];
 CDVVoidBlock willInvokeBlock = params[@"willInvokeBlock"];
 CDVActionComplationBlock didInvokeBlock = params[@"didInvokeBlock"];
 CDVTypeBlock success = params[@"successBlock"];
 CDVErrorBlock failure = params[@"failureBlock"];
 */
- (void)action_requestWithParams:(NSDictionary*)params;


/**
 上传
 @param params
 NSString *url = params[@"url"];
 NSDictionary *requestParams = params[@"params"];
 NSData *file = params[@"data"];
 NSString *fileName = params[@"fileName"];
 NSString *uploadName = params[@"uploadName"];
 NSString *mimeType = params[@"mimeType"];
 void (^progress) (NSProgress *uploadProgress) = params[@"progress"];
 CDVTypeBlock success = params[@"successBlock"];
 CDVErrorBlock failure = params[@"failureBlock"];
 */
- (void)action_uploadWithParams:(NSDictionary*)params;



@end
