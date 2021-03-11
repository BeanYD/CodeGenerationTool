//
//  NSBezierPath+CGPath.h
//  CodeGenerationTool
//
//  Created by mac on 2021/3/11.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBezierPath (CGPath)

- (CGPathRef)CGPath;

@end

NS_ASSUME_NONNULL_END
