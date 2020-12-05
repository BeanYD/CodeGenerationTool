//
//  CGTProcessRateView.m
//  CodeGenerationTool
//
//  Created by mac on 2020/10/23.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTProcessRateView.h"
#import <Quartz/Quartz.h>

#define ROUND_WIDTH 4

@interface CGTProcessRateView ()

//@property (strong) NSBezierPath *processPath;

@property (strong) CAShapeLayer *outLayer;
@property (strong) CAShapeLayer *processLayer;
@property (strong) CAShapeLayer *bgLayer;

@end

@implementation CGTProcessRateView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

//- (BOOL)wantsUpdateLayer {
//    return YES;
//}
//
//- (void)updateLayer {
//    NSBezierPath *path1 = [NSBezierPath bezierPathWithRoundedRect:CGRectMake(2, 2, NSWidth(self.bounds) - 4, NSHeight(self.bounds) - 4) xRadius:(NSWidth(self.bounds) - 4) / 2 yRadius:(NSHeight(self.bounds) - 4) / 2];
//    [[NSColor lightGrayColor] set];
//    path1.lineWidth = 2;
//    [path1 stroke];
//}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
//        self.processPath = [NSBezierPath bezierPath];
        self.wantsLayer = YES;
        [self drawLayerProcess];
    }
    
    return self;
}

- (void)updateProcess:(CGFloat)process {
    self.processLayer.strokeEnd = process / 100.0;
    
}

- (void)drawLayerProcess {
        
    CGMutablePathRef multiPath = CGPathCreateMutable();
    CGPathAddEllipseInRect(multiPath, NULL, CGRectMake(ROUND_WIDTH, ROUND_WIDTH, NSWidth(self.bounds) - ROUND_WIDTH * 2, NSHeight(self.bounds) - ROUND_WIDTH * 2));
    CGPathCloseSubpath(multiPath);
    
    self.bgLayer = [CAShapeLayer layer];
    self.bgLayer.fillColor = [NSColor greenColor].CGColor;
    self.bgLayer.strokeColor = [NSColor clearColor].CGColor;
    self.bgLayer.lineWidth = 0;
    self.bgLayer.path = multiPath;
    [self.layer addSublayer:self.bgLayer];
    
    self.outLayer = [CAShapeLayer layer];
    self.outLayer.strokeColor = [NSColor redColor].CGColor;
    self.outLayer.lineWidth = ROUND_WIDTH;
    self.outLayer.fillColor = [NSColor clearColor].CGColor;
    self.outLayer.path = multiPath;
    
    [self.layer addSublayer:self.outLayer];
    
    self.processLayer = [CAShapeLayer layer];
    self.processLayer.fillColor = [NSColor clearColor].CGColor;
    self.processLayer.strokeColor = [NSColor blueColor].CGColor;
    self.processLayer.lineWidth = ROUND_WIDTH;
    self.processLayer.strokeStart = 0;
    self.processLayer.strokeEnd = 0;
    self.processLayer.path = multiPath;
    [self.layer addSublayer:self.processLayer];
}

- (void)drawBezierProcess {
    
//    NSBezierPath *path1 = [NSBezierPath bezierPathWithRoundedRect:CGRectMake(2, 2, NSWidth(self.bounds) - 4, NSHeight(self.bounds) - 4) xRadius:(NSWidth(self.bounds) - 4) / 2 yRadius:(NSHeight(self.bounds) - 4) / 2];
//    [[NSColor lightGrayColor] set];
//    path1.lineWidth = 2;
//    [path1 stroke];
//
    
//    CGRect cfillRect, cborderRect;
//
//    CGRect cellFrame = self.bounds;
//    CGRectDivide(cellFrame, &cborderRect, &cfillRect, 1.0, CGRectMaxYEdge);
//    NSRect fillRect = NSMakeRect(cfillRect.origin.x, cfillRect.origin.y - 1, cfillRect.size.width, cfillRect.size.height);
//    [[NSColor colorWithRed:48./256 green:50./256 blue:56./256 alpha:1.] set];
//    NSRectFill(fillRect);
//    [[NSGraphicsContext currentContext] setShouldAntialias:YES];
//    NSPoint ptStart, ptEnd;
//    NSBezierPath *path = [NSBezierPath bezierPath];
//    ptStart.x = fillRect.origin.x + fillRect.size.width - 1;
//    ptStart.y = fillRect.origin.y;
//
//    ptEnd.x = fillRect.origin.x + fillRect.size.width - 1;
//    ptEnd.y = fillRect.origin.y + fillRect.size.height;
//
//    [path moveToPoint:ptStart];
//    [path lineToPoint:ptEnd];
//
//    ptStart.x = cellFrame.origin.x;
//    ptStart.y = cellFrame.origin.y + cellFrame.size.height;
//    ptEnd.x = cellFrame.origin.x + cellFrame.size.width;
//    ptEnd.y = cellFrame.origin.y + cellFrame.size.height;
//
//    [path moveToPoint:ptStart];
//    [path lineToPoint:ptEnd];
//
//    ptStart.x = fillRect.origin.x;
//    ptStart.y = fillRect.origin.y;
//    ptEnd.x = fillRect.origin.x + fillRect.size.width;
//    ptEnd.y = fillRect.origin.y;
//
//    [path moveToPoint:ptStart];
//    [path lineToPoint:ptEnd];
//
//    [[NSColor whiteColor] set];
//    [path stroke];
}

@end
