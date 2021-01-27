//
//  CustomDrawingTools.m
//  Education
//
//  Created by iOS-Dev1 on 14-4-14.
//  Copyright (c) 2014年 iOS-Dev1. All rights reserved.
//

#import "CustomDrawingTools.h"
#define DISBZ    8.0

NSPoint midPoint(NSPoint p1, NSPoint p2)
{
    return NSMakePoint((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

@implementation DrawingPenTools
@synthesize lineColor   = _lineColor;
@synthesize lineAlpha = _lineAlpha;

- (id)init
{
    if ([super init]) {
        path = CGPathCreateMutable();
    }
    return self;
}
- (void)setInitialPoint:(NSPoint)firstPoint
{
    [self moveToPoint:firstPoint];
}
- (void)moveFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint{
    [self curveToPoint:endPoint controlPoint1:startPoint controlPoint2:midPoint(startPoint, endPoint)];

}
- (void)draw{
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext]graphicsPort];
    CGContextAddPath(context, path);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetAlpha(context, self.lineAlpha);
    CGContextStrokePath(context);
    [self stroke];
}
@end

@implementation DrawingWordTool
@synthesize lineColor   = _lineColor;

- (id)init{
    if([super init]){
        
    }
    return self;
}

-(void)draw{
    NSDictionary* dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_font,_lineColor, nil] forKeys:[NSArray arrayWithObjects:NSFontAttributeName,NSForegroundColorAttributeName, nil]];
    [_drawStr drawAtPoint:NSMakePoint(_drawRect.origin.x, _drawRect.origin.y) withAttributes:dic];
}
- (void)setInitialPoint:(NSPoint)firstPoint{
}
- (void)moveFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint{
    
}

@end

@implementation DrawingLineTool
@synthesize lineColor   = _lineColor;
@synthesize lineAlpha = _lineAlpha;
@synthesize lineWidth = _lineWidth;

-(id)init{
    if([super init]){

    }
    return self;
}

-(void)setInitialPoint:(NSPoint)firstPoint{
    _startPoint =firstPoint;
}

-(void)moveFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint{
    _endPoint = endPoint;
}

-(void)draw{
//    NSLog(@"Draw DrawingLineTool : %@",NSStringFromPoint(_startPoint));
    _lineAlpha =1.0;
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext]graphicsPort];
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextMoveToPoint(context, _startPoint.x, _startPoint.y);
    CGContextAddLineToPoint(context, _endPoint.x, _endPoint.y);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetAlpha(context, self.lineAlpha);
    CGContextStrokePath(context);
    
}

@end

@implementation DrawingRectangleTool
@synthesize lineColor   = _lineColor;
@synthesize lineWidth = _lineWidth;
@synthesize lineAlpha = _lineAlpha;

-(id)init{
    if([super init]){
        
    }
    return self;
}

-(void)setInitialPoint:(NSPoint)firstPoint{
}

-(void)moveFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint{
}

-(void)draw{
    _lineAlpha =1.0;
//    NSLog(@"Draw DrawingRectangleTool : %@",NSStringFromPoint(_rectangle.origin));
//    NSLog(@"isFliped : %d",[NSGraphicsContext currentContext].isFlipped);
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetFillColorWithColor(context, [[NSColor clearColor]CGColor]);
    CGContextSetStrokeColorWithColor(context, [self.lineColor CGColor]);
    CGContextFillRect(context, _rectangle);
    CGContextSetAlpha(context, self.lineAlpha);
    CGContextStrokeRect(context, _rectangle);
}

@end

@implementation DrawingArrowLineTool
@synthesize lineColor   = _lineColor;
@synthesize lineAlpha = _lineAlpha;
@synthesize lineWidth = _lineWidth;

-(id)init{
    if([super init]){
        
    }
    return self;
}

-(void)setInitialPoint:(NSPoint)firstPoint{
    _startPoint =firstPoint;
}

-(void)moveFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint{
    _endPoint = endPoint;
}

-(void)draw{
    //带箭头的直线
    _lineAlpha =1.0;
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext]graphicsPort];
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextMoveToPoint(context, _startPoint.x, _startPoint.y);
    CGContextAddLineToPoint(context, _endPoint.x, _endPoint.y);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetAlpha(context, self.lineAlpha);
    CGContextStrokePath(context);

    //添加剪头
    double r = sqrt((_endPoint.x-_startPoint.x)*(_endPoint.x-_startPoint.x)+(_startPoint.y-_endPoint.y)*(_startPoint.y-_endPoint.y));//线条长度
    CGContextMoveToPoint(context,_endPoint.x,_endPoint.y);
    //P1
    CGContextAddLineToPoint(context,_endPoint.x-(_lineWidth*(_startPoint.y-_endPoint.y)/r),_endPoint.y-(_lineWidth*(_endPoint.x-_startPoint.x)/r));
    //P3
    CGContextAddLineToPoint(context,_endPoint.x+(2*_lineWidth*(_endPoint.x-_startPoint.x)/r), _endPoint.y-(_lineWidth *2*(_startPoint.y-_endPoint.y)/r));
    //P2
    CGContextAddLineToPoint(context,_endPoint.x+(_lineWidth*(_startPoint.y-_endPoint.y)/r),_endPoint.y+(_lineWidth*(_endPoint.x-_startPoint.x)/r));
    
    CGContextAddLineToPoint(context, _endPoint.x,_endPoint.y);
    CGContextDrawPath(context,kCGPathFillStroke);
    CGContextStrokePath(context);
}

@end

@implementation DrawingLinedashTool
@synthesize lineColor   = _lineColor;
@synthesize lineAlpha = _lineAlpha;
@synthesize lineWidth = _lineWidth;

-(id)init{
    if([super init]){
        
    }
    return self;
}

-(void)setInitialPoint:(NSPoint)firstPoint{
    _startPoint =firstPoint;
}

-(void)moveFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint{
    _endPoint = endPoint;
}

-(void)draw{
    //画虚线
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext]graphicsPort];
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGFloat lengths[] = {10,10};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, _startPoint.x, _startPoint.y);
    CGContextAddLineToPoint(context, _endPoint.x,_endPoint.y);
    CGContextStrokePath(context);
    //CGContextClosePath(context);
}

@end


@implementation DrawingEllipseInRectangleTool
@synthesize lineColor   = _lineColor;
@synthesize lineWidth = _lineWidth;
@synthesize lineAlpha = _lineAlpha;

-(id)init{
    if([super init]){
        
    }
    return self;
}

-(void)setInitialPoint:(NSPoint)firstPoint{
}

-(void)moveFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint{
}

-(void)draw{
    //圆
    _lineAlpha = 1.0;
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext]graphicsPort];
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetFillColorWithColor(context, [[NSColor clearColor]CGColor]);
    CGContextSetStrokeColorWithColor(context, [self.lineColor CGColor]);
    CGContextSetAlpha(context, self.lineAlpha);
    CGContextAddEllipseInRect(context, _rectangle);
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end

@implementation DrawingImageTool
@synthesize lineWidth = _lineWidth;
@synthesize lineAlpha = _lineAlpha;
@synthesize lineColor = _lineColor;
-(id)init{
    if([super init]){

    }
    return self;
}

-(void)setInitialPoint:(NSPoint)firstPoint{

}

-(void)moveFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint{

}

-(void)draw{
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[_image TIFFRepresentation], NULL);
    if (source) {
        CGImageRef drawImage =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
        CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext]graphicsPort];
        CGContextDrawImage(context, _rectangle, drawImage);
        CGContextConvertRectToDeviceSpace(context, _rectangle);
        CFRelease(source);
        if (_isSelect) {
            NSRect rect;
            rect.size.width = 8;
            rect.size.height = 8;

            rect.origin.x = _rectangle.origin.x - 4;
            rect.origin.y = _rectangle.origin.y + _rectangle.size.height-4;
            [self drawLineframe:rect point:0];

            rect.origin.x = _rectangle.origin.x + _rectangle.size.width-4;
            rect.origin.y = _rectangle.origin.y + _rectangle.size.height-4;
            [self drawLineframe:rect point:1];

            rect.origin.x = _rectangle.origin.x-4;
            rect.origin.y = _rectangle.origin.y-4;
            [self drawLineframe:rect point:2];

            rect.origin.x = _rectangle.origin.x + _rectangle.size.width-4;
            rect.origin.y = _rectangle.origin.y-4;
            [self drawLineframe:rect point:3];


            rect.origin.x = _rectangle.origin.x - 4;
            rect.origin.y = _rectangle.origin.y + (_rectangle.size.height-8)/2;
            [self drawPoint:rect];

            rect.origin.x = _rectangle.origin.x + (_rectangle.size.width - 8)/2;
            rect.origin.y = _rectangle.origin.y + _rectangle.size.height - 4;
            [self drawPoint:rect];

            rect.origin.x = _rectangle.origin.x + _rectangle.size.width - 4;
            rect.origin.y = _rectangle.origin.y + (_rectangle.size.height-8)/2;
            [self drawPoint:rect];

            rect.origin.x = _rectangle.origin.x + (_rectangle.size.width - 8)/2;
            rect.origin.y = _rectangle.origin.y - 4;
            [self drawPoint:rect];
        }
    }
}


- (void)drawLineframe:(NSRect)rect point:(NSInteger)point{
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext]graphicsPort];
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [[NSColor clearColor]CGColor]);
    CGContextSetStrokeColorWithColor(context, [[NSColor whiteColor] CGColor]);
    CGContextFillRect(context, rect);
    CGContextSetAlpha(context, 1.0);
    CGContextStrokeRect(context, rect);

    CGContextSetLineWidth(context, 2.0);
    if (point == 0) {
        CGContextMoveToPoint(context, _rectangle.origin.x - 2, _rectangle.origin.y + _rectangle.size.height);
        CGContextAddLineToPoint(context, _rectangle.origin.x + _rectangle.size.width, _rectangle.origin.y + _rectangle.size.height);
    }else if (point == 1) {
        CGContextMoveToPoint(context, _rectangle.origin.x + _rectangle.size.width, _rectangle.origin.y + _rectangle.size.height);
        CGContextAddLineToPoint(context, _rectangle.origin.x + _rectangle.size.width, _rectangle.origin.y);
    }else if (point == 2) {
        CGContextMoveToPoint(context, _rectangle.origin.x, _rectangle.origin.y);
        CGContextAddLineToPoint(context, _rectangle.origin.x, _rectangle.origin.y + _rectangle.size.height);
    }else {
        CGContextMoveToPoint(context, _rectangle.origin.x, _rectangle.origin.y);
        CGContextAddLineToPoint(context, _rectangle.origin.x + _rectangle.size.width, _rectangle.origin.y);
    }
    CGContextSetStrokeColorWithColor(context, [[NSColor whiteColor] CGColor]);
    CGContextSetAlpha(context, 1.0);
    CGContextStrokePath(context);
}

- (void)drawPoint:(NSRect)rect {
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext]graphicsPort];
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [[NSColor clearColor]CGColor]);
    CGContextSetStrokeColorWithColor(context, [[NSColor whiteColor] CGColor]);
    CGContextFillRect(context, rect);
    CGContextSetAlpha(context, 1.0);
    CGContextStrokeRect(context, rect);
}
@end
