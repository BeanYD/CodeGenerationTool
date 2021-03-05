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

#pragma mark - Draw Lines
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

#pragma mark - Draw Image
- (void)drawImage:(NSImage *)image rect:(CGRect)rect {
//    CGFloat width = image.size.width;
//    CGFloat height = image.size.height;
//    self.frame = NSMakeRect(20, 20, width, height);
//    self.contents = image;
    
    CGTDrawLayer *imageLayer = [CGTDrawLayer layerWithFrame:rect strokeColor:[NSColor whiteColor] lineWidth:2];
    imageLayer.position = NSMakePoint(rect.size.width / 2 + 50, rect.size.height / 2 + 50);
    imageLayer.contentsGravity = kCAGravityResizeAspect;
    imageLayer.contents = image;
    [self addSublayer:imageLayer];
}

- (void)resetImageRect:(CGRect)rect {
    if (self.sublayers.count == 0) {
        return;
    }
    
//    id contents;
//    for (int i = 0; i < self.sublayers.count; i++) {
//        CALayer *layer = self.sublayers[i];
//        if (layer.contents) {
//            contents = layer.contents;
//        }
//        [layer removeFromSuperlayer];
//    }

    CALayer *layer = self.sublayers.lastObject;
    [layer removeFromSuperlayer];
    
    CALayer *imageLayer = [[CALayer alloc] init];
    imageLayer.bounds = rect;
    imageLayer.position = NSMakePoint(rect.size.width / 2 + rect.origin.x, rect.size.height / 2 + rect.origin.y);
    imageLayer.contentsGravity = kCAGravityResizeAspect;
    imageLayer.contents = layer.contents;
    [self addSublayer:imageLayer];
}

- (void)focusImageRect:(CGRect)rect {
    if (self.sublayers.count == 0) {
        return;
    }
    CALayer *layer = self.sublayers.lastObject;
    if (layer.sublayers.count > 0) {
        CALayer *selectLayer = layer.sublayers.lastObject;
        if (CGRectIsEmpty(rect)) {
            [selectLayer removeFromSuperlayer];
            return;
        }
        if ([selectLayer isMemberOfClass:[CGTDrawLayer class]]) {
            return;
        }
    } else {
        if (CGRectIsEmpty(rect)) {
            return;
        }
    }

    CGTDrawLayer *borderLayer = [CGTDrawLayer layerWithFrame:layer.bounds strokeColor:[NSColor whiteColor] lineWidth:2];
    [borderLayer drawImageBorder:layer.bounds];
    [layer addSublayer:borderLayer];
}

- (void)drawImageBorder:(NSRect)rect {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 4, 0);
    CGPathAddLineToPoint(path, NULL, rect.size.width - 4, 0);
    NSRect drawRect;
    drawRect.size.width = 8;
    drawRect.size.height = 8;
    drawRect.origin.x = rect.size.width - 4;
    drawRect.origin.y = -4;
    CGPathAddRect(path, NULL, drawRect);
    CGPathMoveToPoint(path, NULL, rect.size.width, 4);
    CGPathAddLineToPoint(path, NULL, rect.size.width, rect.size.height - 4);
    drawRect.origin.y = rect.size.height - 4;
    CGPathAddRect(path, NULL, drawRect);
    CGPathMoveToPoint(path, NULL, rect.size.width - 4, rect.size.height);
    CGPathAddLineToPoint(path, NULL, 4, rect.size.height);
    drawRect.origin.x =  -4;
    CGPathAddRect(path, NULL, drawRect);
    CGPathMoveToPoint(path, NULL, 0, rect.size.height - 4);
    CGPathAddLineToPoint(path, NULL, 0, 4);
    drawRect.origin.y = -4;
    CGPathAddRect(path, NULL, drawRect);
    CGPathCloseSubpath(path);
    self.path = path;
}

#pragma mark - Draw Border
- (void)drawBorderRect:(CGRect)rect {
    
    for (NSInteger i = self.sublayers.count - 1; i >= 0; i--) {
        CALayer *layer = self.sublayers[i];
        if ([layer isMemberOfClass:[CGTDrawLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    
    // NSIsEmptyRect()方法在width或者height小于或等于0时会返回YES，认为是空的。不可用
//    NSLog(@"%d", NSIsEmptyRect(NSMakeRect(0, 0, 100, 1)));
    
    if (rect.size.height == 0 || rect.size.width == 0) {
        return;
    }
    
    // 防止与边界重合
    CGFloat minX;
    CGFloat minY;
    CGFloat width;
    CGFloat height;
    if (NSWidth(rect) > 0) {
        minX = NSMinX(rect) - self.lineWidth;
        width = NSWidth(rect) + self.lineWidth * 2;
    } else {
        minX = NSMinX(rect) + self.lineWidth;
        width = NSWidth(rect) - self.lineWidth * 2;
    }
    
    if (NSHeight(rect) > 0) {
        minY = NSMinY(rect) - self.lineWidth;
        height = NSHeight(rect) + self.lineWidth * 2;
    } else {
        minY = NSMinY(rect) + self.lineWidth;
        height = NSHeight(rect) - self.lineWidth * 2;
    }
    CGRect borderRect = NSMakeRect(minX, minY, width, height);
//    NSColor *borderColor = [NSColor colorWithCalibratedRed:135/255.0 green:206/255.0 blue:235/255.0 alpha:1];
    NSColor *borderColor = [NSColor redColor];
    CGTDrawLayer *borderLayer = [CGTDrawLayer layerWithFrame:self.bounds strokeColor:borderColor lineWidth:2.f];
    [borderLayer drawRectLines:borderRect];
    [self addSublayer:borderLayer];
}

- (void)drawBorderRectLines:(CGRect)rect {
    _borderRect = rect;
    NSLog(@"%f, %f, %f, %f", _borderRect.origin.x, _borderRect.origin.y, _borderRect.size.width, _borderRect.size.height);
    [self setNeedsDisplayInRect:self.frame];
}

#pragma mark - Draw Text
- (void)drawTextInRect:(CGRect)rect string:(NSString *)drawStr dict:(NSDictionary *)attrDic {
    NSFont *font = [attrDic objectForKey:NSFontAttributeName];
    NSColor *color = [attrDic objectForKey:NSForegroundColorAttributeName];
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = rect;
    textLayer.position = NSMakePoint(rect.size.width / 2 + rect.origin.x, rect.size.height / 2 + rect.origin.y);
    textLayer.backgroundColor = [NSColor clearColor].CGColor;
    textLayer.string = drawStr;
    textLayer.font = (__bridge CFTypeRef _Nullable)font.fontName;
    textLayer.fontSize = font.pointSize;
    textLayer.alignmentMode = kCAAlignmentLeft;
    textLayer.foregroundColor = color.CGColor;
    [self addSublayer:textLayer];

}

#pragma mark - Draw Rect
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

#pragma mark - Rewrite
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

#pragma mark - Unuse Method
- (void)drawImageLayerWithRect:(CGRect)rect {
    CGSize size = NSMakeSize(100, 100);
    NSImage *image = [[NSImage alloc] initWithSize:size];
    [image lockFocusFlipped:YES];
    // draw method
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 100, 100);
    CGContextSetStrokeColorWithColor(context, [NSColor redColor].CGColor);
    CGContextSetAlpha(context, 1.0f);
    CGContextStrokePath(context);
    [image unlockFocus];
    image.size = size;
    CALayer *textLayer = [CALayer layer];
    [textLayer setContents:[[NSImage alloc] initWithData:[image TIFFRepresentation]]];
    textLayer.frame =  rect;
    [self addSublayer:textLayer];
}

@end
