//
//  CDVUploadAction.h
//  TianShanYunTV
//
//  Created by yan on 2017/11/16.
//  Copyright © 2017年 yanlong. All rights reserved.
//

#import "CDVNetAction.h"

@interface CDVUploadAction : CDVNetAction

@property (nonatomic, strong) NSData   *data;
@property (nonatomic, copy)   NSString *uploadName;
@property (nonatomic, copy)   NSString *fileName;
@property (nonatomic, copy)   NSString *mimeType;


@end
