//
//  DrawLayer.m
//  CodeGenerationTool
//
//  Created by mac on 2021/1/26.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTDrawLayer.h"

@implementation CGTDrawLayer

- (instancetype)init {
    if (self = [super init]) {
        _path = CGPathCreateMutable();
    }
    
    return self;
}

- (void)drawLineFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint {
    CGPathMoveToPoint(_path, NULL, startPoint.x, startPoint.y);
    CGPathAddLineToPoint(_path, NULL, endPoint.x, endPoint.y);
//    CGPathCloseSubpath(_path);
    self.path = _path;
}

- (void)setDirectLinePoint:(NSPoint)startPoint {
    CGPathMoveToPoint(_path, NULL, startPoint.x, startPoint.y);
}

- (void)moveDirectLineToPoint:(NSPoint)endPoint {
    CGPathAddLineToPoint(_path, NULL, endPoint.x, endPoint.y);
    self.path = _path;
}

- (void)drawInContext:(CGContextRef)ctx {
//    CGRect drawRect = NSMakeRect(50, 50, 100, 100);
//
//    CGContextSetLineWidth(ctx, self.lineWidth);
//    CGContextSetFillColorWithColor(ctx, [NSColor clearColor].CGColor);
//    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
//    CGContextMoveToPoint(ctx, NSMinX(drawRect), NSMinY(drawRect));
//    CGContextAddLineToPoint(ctx, NSMaxX(drawRect), NSMinY(drawRect));
//    CGContextAddLineToPoint(ctx, NSMaxX(drawRect), NSMaxY(drawRect));
//    CGContextAddLineToPoint(ctx, NSMinX(drawRect), NSMaxY(drawRect));
//    CGContextAddLineToPoint(ctx, NSMinX(drawRect), NSMinY(drawRect));
//    CGContextSetAlpha(ctx, self.lineAlpha);
//    CGContextStrokePath(ctx);
//    CGContextClosePath(ctx);
    
}

@end
