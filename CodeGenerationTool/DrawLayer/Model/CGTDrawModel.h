//
//  CGTDrawModel.h
//  CodeGenerationTool
//
//  Created by mac on 2021/1/29.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CGTDrawLayer;

@interface CGTDrawModel : NSObject

@property (strong) CGTDrawLayer *drawLayer;
@property (assign) CGPoint startPoint;
@property (assign) CGPoint endPoint;

@end

NS_ASSUME_NONNULL_END