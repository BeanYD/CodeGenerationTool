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
    CGPathCloseSubpath(_path);
    self.path = _path;
}

- (void)drawDireLineFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    CGPathCloseSubpath(path);
    self.path = path;
//    CGPathRelease(path);
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