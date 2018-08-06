//
//  YLInterface_NetRequest.h
//  CDVRequest_Example
//
//  Created by yan on 2018/8/6.
//  Copyright © 2018年 yoolooo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDVNetAction.h"

@interface YLInterface_NetRequest : NSObject

- (void)ylInterface_requestUrl:(NSString*)url Params:(NSDictionary*)params timeout:(CGFloat)timeout showlog:(BOOL)showlog WillInvokeBlock:(CDVVoidBlock)willInvokeBlock DidInvokeBlock:(CDVActionComplationBlock)didInvokeBlock Success:(CDVTypeBlock)success failure:(CDVErrorBlock)failure;

//- (void)ylInterface_uploadWithUrl:(NSString*)url;

@end
