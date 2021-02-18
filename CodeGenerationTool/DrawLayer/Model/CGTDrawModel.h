//
//  CGTDrawModel.h
//  CodeGenerationTool
//
//  Created by mac on 2021/1/29.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGTDrawHeader.h"

NS_ASSUME_NONNULL_BEGIN

@class CGTDrawLayer;

@interface CGTDrawModel : NSObject

@property (strong) CGTDrawLayer *drawLayer;
@property (assign) CGPoint startPoint;
@property (assign) CGPoint endPoint;
@property (assign) CGTDrawType type;
@property (copy) NSString *textStr;

- (CGRect)getLayerRect;
- (CGRect)getLayerTopLeftRect;
- (CGRect)getLayerTopRightRect;
- (CGRect)getLayerBottomLeftRect;
- (CGRect)getLayerBottomRightRect;

@end

NS_ASSUME_NONNULL_END
