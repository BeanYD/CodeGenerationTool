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

+ (CGTDrawLayer *)layerWithFrame:(CGRect)frame strokeColor:(NSColor *)strokeColor lineWidth:(CGFloat)lineWidth {
    CGTDrawLayer *drawLayer = [[CGTDrawLayer alloc] init];
    drawLayer.frame = frame;
    drawLayer.fillColor = [NSColor clearColor].CGColor;
    drawLayer.strokeColor = strokeColor.CGColor;
    drawLayer.lineWidth = lineWidth;
    return drawLayer;
}

- (void)drawCurveFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint {
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

- (void)drawArrowDireLineFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    
    // 加箭头
    double r = sqrt((endPoint.x-startPoint.x)*(endPoint.x-startPoint.x)+(startPoint.y-endPoint.y)*(startPoint.y-endPoint.y));//线条长度

    CGPathMoveToPoint(path, NULL, endPoint.x, endPoint.y);
    CGPathAddLineToPoint(path, NULL, endPoint.x-((startPoint.y-endPoint.y)/r),endPoint.y-((endPoint.x-startPoint.x)/r));
    CGPathAddLineToPoint(path, NULL, endPoint.x+(2*(endPoint.x-startPoint.x)/r), endPoint.y-(2*(startPoint.y-endPoint.y)/r));
    CGPathAddLineToPoint(path, NULL, endPoint.x+((startPoint.y-endPoint.y)/r),endPoint.y+((endPoint.x-startPoint.x)/r));
    
    CGPathCloseSubpath(path);
    self.path = path;
    
    
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

- (void)drawBorderRectLines:(CGRect)rect {
    _borderRect = rect;
    NSLog(@"%f, %f, %f, %f", _borderRect.origin.x, _borderRect.origin.y, _borderRect.size.width, _borderRect.size.height);
    [self setNeedsDisplayInRect:self.frame];
}

- (void)drawRectLines:(CGRect)rect {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y);
    CGPathAddRect(path, NULL, rect);
    CGPathCloseSubpath(path);
    self.path = path;
}

- (void)drawRectLines1:(CGRect)rect {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height);
    CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y);
    CGPathCloseSubpath(path);
    self.path = path;
}

- (void)drawEllipseInRect:(CGRect)rect {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y);
    CGPathAddEllipseInRect(path, NULL, rect);
    CGPathCloseSubpath(path);
    self.path = path;
}

- (void)drawTextInRect:(CGRect)rect string:(NSString *)drawStr {
    NSDictionary* dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSFont systemFontOfSize:12.], [NSColor blackColor], nil] forKeys:[NSArray arrayWithObjects:NSFontAttributeName,NSForegroundColorAttributeName, nil]];
    [drawStr drawAtPoint:NSMakePoint(rect.origin.x, rect.origin.y) withAttributes:dic];
}

- (void)drawInContext:(CGContextRef)ctx {
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetFillColorWithColor(ctx, [NSColor clearColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [NSColor redColor].CGColor);
//    CGContextMoveToPoint(ctx, NSMinX(_borderRect), NSMinY(_borderRect));
//    CGContextAddLineToPoint(ctx, NSMaxX(_borderRect), NSMinY(_borderRect));
//    CGContextAddLineToPoint(ctx, NSMaxX(_borderRect), NSMaxY(_borderRect));
//    CGContextAddLineToPoint(ctx, NSMinX(_borderRect), NSMaxY(_borderRect));
//    CGContextAddLineToPoint(ctx, NSMinX(_borderRect), NSMinY(_borderRect));
//    CGContextStrokePath(ctx);
//    CGContextClosePath(ctx);
    
    // 防止与边界重合
    CGFloat minX;
    CGFloat minY;
    CGFloat width;
    CGFloat height;
    if (NSWidth(_borderRect) > 0) {
        minX = NSMinX(_borderRect) - self.lineWidth;
        width = NSWidth(_borderRect) + self.lineWidth * 2;
    } else {
        minX = NSMinX(_borderRect) + self.lineWidth;
        width = NSWidth(_borderRect) - self.lineWidth * 2;
    }
    
    if (NSHeight(_borderRect) > 0) {
        minY = NSMinY(_borderRect) - self.lineWidth;
        height = NSHeight(_borderRect) + self.lineWidth * 2;
    } else {
        minY = NSMinY(_borderRect) + self.lineWidth;
        height = NSHeight(_borderRect) - self.lineWidth * 2;
    }
    
    CGRect rect = NSMakeRect(minX, minY, width, height);
    
    CGContextFillRect(ctx, rect);
    CGContextSetAlpha(ctx, 1.f);
    CGContextStrokeRect(ctx, rect);
}

@end
