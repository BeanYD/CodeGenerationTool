//
//  DrawView.m
//  CodeGenerationTool
//
//  Created by mac on 2021/1/26.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTDrawView.h"
#import "CustomDrawingTools.h"
#import "CGTDrawLayer.h"

@interface CGTDrawView ()

@property (assign) NSPoint previousPoint;
@property (assign) NSPoint currentPoint;
@property (strong) NSMutableArray *drawLayers;

@property (assign) NSInteger currentIndex;

@end

@implementation CGTDrawView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
    
//    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
//    CGRect drawRect = NSMakeRect(50, 50, 100, 100);
//
//    CGContextSetLineWidth(ctx, 2);
//    CGContextSetFillColorWithColor(ctx, [NSColor clearColor].CGColor);
//    CGContextSetStrokeColorWithColor(ctx, [NSColor blueColor].CGColor);
//    CGContextMoveToPoint(ctx, NSMinX(drawRect), NSMinY(drawRect));
//    CGContextAddLineToPoint(ctx, NSMaxX(drawRect), NSMinY(drawRect));
//    CGContextAddLineToPoint(ctx, NSMaxX(drawRect), NSMaxY(drawRect));
//    CGContextAddLineToPoint(ctx, NSMinX(drawRect), NSMaxY(drawRect));
//    CGContextAddLineToPoint(ctx, NSMinX(drawRect), NSMinY(drawRect));
//    CGContextSetAlpha(ctx, 1.f);
//    CGContextStrokePath(ctx);
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        
        self.wantsLayer = YES;
        self.layer.borderColor = [NSColor redColor].CGColor;
        self.layer.borderWidth = 1.f;
        self.drawLayers = [NSMutableArray array];
        NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow owner:self userInfo:@{}];
        [self addTrackingArea:trackingArea];
    }
    
    return self;
}

- (void)mouseDown:(NSEvent *)event {
    _previousPoint = [self convertPoint:[event locationInWindow] fromView:nil];
    CGTDrawLayer *drawLayer = [[CGTDrawLayer alloc] init];
    drawLayer.fillColor = [NSColor clearColor].CGColor;
    drawLayer.strokeColor = [NSColor blueColor].CGColor;
    drawLayer.lineWidth = 1.f;
    drawLayer.strokeStart = 0;
    drawLayer.strokeEnd = 1;
    
    switch (self.type) {
        case CGTDrawTypeLine:
            break;
        case CGTDrawTypeDirectLine:
            break;
        case CGTDrawTypeDirectDash:
            [drawLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:2], nil]];
            break;
            
        default:
            break;
    }

    [self.layer addSublayer:drawLayer];

    if (self.drawLayers.count > 0) {
        self.currentIndex = self.drawLayers.count-1;
    } else {
        self.currentIndex = 0;
    }
    [self.drawLayers addObject:drawLayer];
}

- (void)mouseDragged:(NSEvent *)event {
    _currentPoint = [self convertPoint:[event locationInWindow] fromView:nil];

    CGTDrawLayer *drawLayer = [self.drawLayers objectAtIndex:self.currentIndex];
    
    switch (self.type) {
        case CGTDrawTypeLine:
            [drawLayer drawLineFromPoint:_previousPoint toPoint:_currentPoint];
            _previousPoint = _currentPoint;
            break;
        case CGTDrawTypeDirectLine:
            [drawLayer drawDireLineFromPoint:_previousPoint toPoint:_currentPoint];
            break;
        case CGTDrawTypeDirectDash:
            [drawLayer drawDireLineFromPoint:_previousPoint toPoint:_currentPoint];
            break;
        default:
            break;
    }
    

}

- (void)mouseUp:(NSEvent *)event {
}

@end
