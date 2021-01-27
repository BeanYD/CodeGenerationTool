//
//  DrawView.h
//  CodeGenerationTool
//
//  Created by mac on 2021/1/26.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CGTDrawType) {
    CGTDrawTypeLine,
    CGTDrawTypeDirectLine,
    CGTDrawTypeDirectDash,
};

@interface CGTDrawView : NSView


@property (assign) CGTDrawType type;

@end

NS_ASSUME_NONNULL_END
