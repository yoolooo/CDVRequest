//
//  CDVNetworking.h
//  TianShanYunTV
//
//  Created by yan on 2017/11/16.
//  Copyright © 2017年 yanlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDVNetAction.h"

typedef NS_ENUM(NSInteger, CDVConnectionType){
    CDVConnectionTypeWifi = 0,
    CDVConnectionTypeWWAN,
    CDVConnectionTypeNone
};


@interface CDVNetworking : NSObject

@property (nonatomic, strong, readonly) NSURLSessionConfiguration *defaultConfigration;


+ (instancetype)shareInstance;

/**
 *  获取当前网络状态
 *
 *  @return CDVConnectionType
 */
- (CDVConnectionType)getConnectionType;


/**
 发送请求

 @param url url
 @param method get/post/delete/put/head/patch
 @param params 参数
 @param success 成功回调
 @param failure 失败回调
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask*)sendRequestWithUrl:(NSString*)url method:(NSString *)method parameter:(NSDictionary*)params success:(CDVTypeBlock)success failure:(CDVErrorBlock)failure;

- (NSURLSessionUploadTask *)uploadTaskByRequest:(NSURLRequest *)request process:(void (^) (NSProgress *uploadProgress))process success:(CDVTypeBlock)success failure:(CDVErrorBlock)failure;

- (NSURLSessionDownloadTask *)downloadFileByURL:(NSString *)url savePath:(NSString *)path process:(void (^) (NSProgress *downloadProgress))process success:(CDVVoidBlock)success failure:(CDVErrorBlock)failure;

@end
