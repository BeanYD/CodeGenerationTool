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
#import "CGTDrawModel.h"

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
    drawLayer.frame = self.bounds;
    drawLayer.fillColor = [NSColor clearColor].CGColor;
    drawLayer.strokeColor = [NSColor blueColor].CGColor;
    drawLayer.lineWidth = 1.f;
    drawLayer.strokeStart = 0;
    drawLayer.strokeEnd = 1;
//    drawLayer.backgroundColor = [NSColor redColor].CGColor;
    
    switch (self.type) {
        case CGTDrawTypeLine:
            break;
        case CGTDrawTypeDirectLine:
            break;
        case CGTDrawTypeDirectDash:
            break;
            
        default:
            break;
    }

    [self.layer addSublayer:drawLayer];

    self.currentIndex = self.drawLayers.count;
    
    CGTDrawModel *model = [[CGTDrawModel alloc] init];
    model.drawLayer = drawLayer;
    model.startPoint = _previousPoint;
    [self.drawLayers addObject:model];
}

- (void)mouseDragged:(NSEvent *)event {
    _currentPoint = [self convertPoint:[event locationInWindow] fromView:nil];

    CGTDrawModel *model = [self.drawLayers objectAtIndex:self.currentIndex];
    
    switch (self.type) {
        case CGTDrawTypeLine:
            [model.drawLayer drawLineFromPoint:_previousPoint toPoint:_currentPoint];
            _previousPoint = _currentPoint;
            // 更新model中的startPoint和endPoint
            CGFloat minX = MIN(model.startPoint.x, _previousPoint.x);
            CGFloat minY = MIN(model.startPoint.y, _previousPoint.y);
            model.startPoint = NSMakePoint(minX, minY);
            CGFloat maxX = MAX(MAX(_currentPoint.x, _previousPoint.x), model.endPoint.x);
            CGFloat maxY = MAX(MAX(_currentPoint.y, _previousPoint.y), model.endPoint.y);
            NSLog(@"minx:%f, miny:%f, maxx:%f, maxy:%f", minX, minY, maxX, maxY);
            model.endPoint = NSMakePoint(maxX, maxY);
            break;
        case CGTDrawTypeDirectLine:
            [model.drawLayer drawDireLineFromPoint:_previousPoint toPoint:_currentPoint];
            break;
        case CGTDrawTypeDirectDash:
            [model.drawLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:2], nil]];
            [model.drawLayer drawDireLineFromPoint:_previousPoint toPoint:_currentPoint];
            break;
        default:
            break;
    }
    

}

- (void)mouseUp:(NSEvent *)event {
    // 更新model内容
    CGTDrawModel *model = [self.drawLayers objectAtIndex:self.currentIndex];
    model.endPoint = [self convertPoint:[event locationInWindow] fromView:nil];
    
    // 更新layer的frame
//    CGFloat width = ABS(model.endPoint.x - model.startPoint.x);
//    CGFloat height = ABS(model.endPoint.y - model.startPoint.y);
//    model.drawLayer.position = NSMakePoint(width / 2, height / 2);
//    model.drawLayer.anchorPoint = NSMakePoint(0.5, 0.5);
//    CGRect frame = model.drawLayer.frame;
//    frame.origin.x = model.startPoint.x;
//    frame.origin.y = model.startPoint.y;
//    frame.size.width = width;
//    frame.size.height = height;
    
    // drawLayer做缩放
//    CGFloat sx = frame.size.width / self.frame.size.width;
//    CGFloat sy = frame.size.height / self.frame.size.height;
//    [model.drawLayer setAffineTransform:CGAffineTransformMakeScale(sx, sy)];
    
//    model.drawLayer.frame = frame;

}

@end
