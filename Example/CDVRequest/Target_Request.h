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
- (void)requestWithParams:(NSDictionary*)params;

@end
