//
//  CDVNetAction.h
//  TianShanYunTV
//
//  Created by yan on 2017/11/16.
//  Copyright © 2017年 yanlong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CDVVoidBlock) (void);
typedef void (^CDVArrayBlock) (NSArray *array);
typedef void (^CDVDictronryblock) (NSDictionary *dictronry);
typedef void (^CDVErrorBlock) (NSError *error);
typedef void (^CDVTypeBlock) (id object);
typedef void (^CDVWarnningCodesHandler) (NSString *code);
typedef void (^CDVActionComplationBlock) (BOOL isSuccess);

typedef NS_ENUM(NSInteger, CDVHttpMethod) {
    CDVHttpGet = 1,
    CDVHttpPost,
    
};


@interface CDVNetAction : NSObject


/**
 参数
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *parameter;

/**
 相对url
 */
@property (nonatomic, strong, readonly) NSString *url;

/**
 http method 默认 GET
 */
@property (nonatomic, strong, readonly) NSString *method;

/**
 *  超时时间
 */
@property (nonatomic, assign) NSTimeInterval     timeout;

/**
 *  Http请求log,建议调试的时候打开
 */
@property (nonatomic, assign) BOOL showLog;

/**
 *  请求即将执行时候的回调,可用于启动hud等
 */
@property (nonatomic, copy)   CDVVoidBlock actionWillInvokeBlock;

/**
 *  请求执行完毕的回调,可用于关闭hud等.包含参数isSuccess,表示请求是否执行成功.
 */
@property (nonatomic, copy)   CDVActionComplationBlock actionDidInvokeBlock;


- (instancetype)initWithURL:(NSString *)url;

- (void)setHttpMethod:(CDVHttpMethod)method;

@end
