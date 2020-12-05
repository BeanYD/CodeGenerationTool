//
//  CGTProcessRateTextField.m
//  CodeGenerationTool
//
//  Created by mac on 2020/10/23.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTProcessRateTextField.h"

@implementation CGTProcessRateTextField

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self drawProcess];
    }
    
    return self;
}

- (void)drawProcess {
//    CGContextRef ctx = [[NSGraphicsContext currentContext] CGContext];
//    CGContextAddEllipseInRect(ctx, NSMakeRect(150, 250, 100, 100));
//    CGContextSetRGBFillColor(ctx, 255, 255, 0, 1);
//    CGContextStrokePath(ctx);
//    CGContextRelease(ctx);
    NSBezierPath *path3 = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(150, 50, 100, 100)];
    [[NSColor blackColor] set];
    [path3 fill];
    
}

@end
