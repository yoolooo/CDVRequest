//
//  CDVNetManager.h
//  TianShanYunTV
//
//  Created by yan on 2017/11/16.
//  Copyright © 2017年 yanlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDVNetAction.h"
#import "CDVUploadAction.h"

@interface CDVNetManager : NSObject

/**
 全局参数 version/platform等
 */
@property (nonatomic, strong) NSDictionary *globleParameter;

+ (instancetype)shareInstance;

- (void)codeKey:(NSString *)key;

- (void)warningReternCodes:(NSArray<NSString *>*)codes withHandler:(void (^) (NSString *code))handler;

- (void)requestAction:(CDVNetAction*)action success:(CDVTypeBlock)success failure:(CDVErrorBlock)failure;

- (NSURLSessionUploadTask *)uploadAction:(CDVUploadAction *)action progress:(void (^) (NSProgress *uploadProgress))progress success:(CDVTypeBlock)success failure:(CDVErrorBlock)failure;

@end
