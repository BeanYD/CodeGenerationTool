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

- (void)drawImage:(NSImage *)image rect:(CGRect)rect {
//    CGFloat width = image.size.width;
//    CGFloat height = image.size.height;
//    self.frame = NSMakeRect(20, 20, width, height);
//    self.contents = image;
    
    CALayer *imageLayer = [[CALayer alloc] init];
    imageLayer.frame = rect;
    imageLayer.position = NSMakePoint(rect.size.width / 2 + 10, rect.size.height / 2 + 10);
    imageLayer.contentsGravity = kCAGravityResizeAspect;
    imageLayer.contents = image;
    [self addSublayer:imageLayer];
}

- (void)resetImageRect:(CGRect)rect {
    if (self.sublayers.count == 0) {
        return;
    }
    
    CALayer *layer = [self.sublayers lastObject];
    [layer removeFromSuperlayer];

    CALayer *imageLayer = [[CALayer alloc] init];
    imageLayer.bounds = rect;
    imageLayer.position = NSMakePoint(rect.size.width / 2 + rect.origin.x, rect.size.height / 2 + rect.origin.y);
    imageLayer.contentsGravity = kCAGravityResizeAspect;
    imageLayer.contents = layer.contents;
    [self addSublayer:imageLayer];
}

- (void)drawRectLines:(CGRect)rect {
    _borderRect = rect;
    [self setNeedsDisplayInRect:self.frame];
}

- (void)drawInContext:(CGContextRef)ctx {
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetFillColorWithColor(ctx, [NSColor clearColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [NSColor greenColor].CGColor);
    CGContextMoveToPoint(ctx, NSMinX(_borderRect), NSMinY(_borderRect));
    CGContextAddLineToPoint(ctx, NSMaxX(_borderRect), NSMinY(_borderRect));
    CGContextAddLineToPoint(ctx, NSMaxX(_borderRect), NSMaxY(_borderRect));
    CGContextAddLineToPoint(ctx, NSMinX(_borderRect), NSMaxY(_borderRect));
    CGContextAddLineToPoint(ctx, NSMinX(_borderRect), NSMinY(_borderRect));
    CGContextSetAlpha(ctx, 1.f);
    CGContextStrokePath(ctx);
//    CGContextClosePath(ctx);
}

@end
