//
//  DrawView.h
//  CodeGenerationTool
//
//  Created by mac on 2021/1/26.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CGTDrawHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGTDrawView : NSView


@property (assign) CGTDrawType type;

@property (assign) int lineWidth;
@property (assign) BOOL isStroke;   // 是否有笔锋效果

- (void)loadImage:(NSImage *)image;

- (void)resetCursor;
@end

NS_ASSUME_NONNULL_END
