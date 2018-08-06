//
//  CDVNetAction.m
//  TianShanYunTV
//
//  Created by yan on 2017/11/16.
//  Copyright © 2017年 yanlong. All rights reserved.
//

#import "CDVNetAction.h"

@interface CDVNetAction ()


@end

@implementation CDVNetAction

- (instancetype)init{
    if (self = [super init]) {
        _method = @"GET";
        _timeout = 180;
        _parameter = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithURL:(NSString *)url{
    
    self = [self init];
    _url = url;
    return self;
}

- (void)setHttpMethod:(CDVHttpMethod)method{
    switch (method) {
        case CDVHttpGet:
            _method = @"GET";
            break;
        case CDVHttpPost:
            _method = @"POST";
            break;
        default:
            break;
    }
}

@end
