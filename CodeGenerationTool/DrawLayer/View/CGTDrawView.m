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

@interface CGTDrawView ()<NSTextViewDelegate>

@property (assign) NSPoint previousPoint;
@property (assign) NSPoint currentPoint;
@property (strong) NSMutableArray *drawLayers;
@property (assign) NSInteger currentIndex;

@property (strong) NSTextView *textView;

@end

@implementation CGTDrawView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
    

//    if (self.type == CGTDrawTypeEraser) {
//        CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
//        CGContextSetLineWidth(ctx, 2);
//        CGContextSetFillColorWithColor(ctx, [NSColor clearColor].CGColor);
//        CGContextSetStrokeColorWithColor(ctx, [NSColor blueColor].CGColor);
//        CGContextMoveToPoint(ctx, NSMinX(self.eraserRect), NSMinY(self.eraserRect));
//        CGContextAddLineToPoint(ctx, NSMaxX(self.eraserRect), NSMinY(self.eraserRect));
//        CGContextAddLineToPoint(ctx, NSMaxX(self.eraserRect), NSMaxY(self.eraserRect));
//        CGContextAddLineToPoint(ctx, NSMinX(self.eraserRect), NSMaxY(self.eraserRect));
//        CGContextAddLineToPoint(ctx, NSMinX(self.eraserRect), NSMinY(self.eraserRect));
//        CGContextSetAlpha(ctx, 1.f);
//        CGContextStrokePath(ctx);
//    }
    
    if (self.currentIndex < self.drawLayers.count) {
        CGTDrawModel *model = self.drawLayers[self.currentIndex];
        if (model.type == CGTDrawTypeText) {
            [model.drawLayer drawTextInRect:[model getLayerRect] string:model.textStr];
        }
    }
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        
        self.wantsLayer = YES;
        self.layer.borderColor = [NSColor redColor].CGColor;
        self.layer.borderWidth = 1.f;
        self.drawLayers = [NSMutableArray array];
        NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow owner:self userInfo:@{}];
        [self addTrackingArea:trackingArea];
        
        CGTDrawLayer *layer = [CGTDrawLayer layerWithFrame:self.bounds strokeColor:[NSColor redColor] lineWidth:1.f];
        [self.layer addSublayer:layer];
        [layer drawTextInRect:NSMakeRect(100, 100, 100, 100) string:@"aabb"];

    }
    
    return self;
}

- (void)loadImage:(NSImage *)image {
    CGTDrawLayer *drawLayer = [[CGTDrawLayer alloc] init];
    drawLayer.frame = self.bounds;
    drawLayer.fillColor = [NSColor clearColor].CGColor;
    drawLayer.strokeColor = [NSColor blueColor].CGColor;
    drawLayer.lineWidth = 1.f;
    drawLayer.strokeStart = 0;
    drawLayer.strokeEnd = 1;
    [self.layer addSublayer:drawLayer];
    CGTDrawModel *model = [[CGTDrawModel alloc] init];
    model.drawLayer = drawLayer;
    model.type = self.type;
    model.startPoint = NSMakePoint(10, 10);
    model.endPoint = NSMakePoint(model.startPoint.x + image.size.width, model.startPoint.y  + image.size.height);
    [drawLayer drawImage:image rect:NSMakeRect(model.startPoint.x, model.startPoint.y, image.size.width, image.size.height)];
    [self.drawLayers addObject:model];
    self.currentIndex = self.drawLayers.count;
}

- (void)mouseDown:(NSEvent *)event {
    _previousPoint = [self convertPoint:[event locationInWindow] fromView:nil];

//    drawLayer.backgroundColor = [NSColor redColor].CGColor;
    if (self.type == CGTDrawTypeCurveLine || self.type == CGTDrawTypeDirectDash || self.type == CGTDrawTypeDirectLine || self.type == CGTDrawTypeEraser || self.type == CGTDrawTypeArrowDirectLine || self.type == CGTDrawTypeRect || self.type == CGTDrawTypeEllipse) {
        CGTDrawLayer *drawLayer = [[CGTDrawLayer alloc] init];
        drawLayer.frame = self.bounds;
        drawLayer.fillColor = [NSColor clearColor].CGColor;
    
        if (self.type == CGTDrawTypeEraser) {
            drawLayer.strokeColor = [NSColor redColor].CGColor;
        } else {
            drawLayer.strokeColor = [NSColor blueColor].CGColor;
        }
        
        drawLayer.lineWidth = 1.f;
        drawLayer.strokeStart = 0;
        drawLayer.strokeEnd = 1;
        [self.layer addSublayer:drawLayer];

        self.currentIndex = self.drawLayers.count;
        CGTDrawModel *model = [[CGTDrawModel alloc] init];
        model.drawLayer = drawLayer;
        model.type = self.type;
        model.startPoint = _previousPoint;
        [self.drawLayers addObject:model];
//    } else if (self.type == CGTDrawTypeEraser) {
//        self.eraserRect = NSMakeRect(_previousPoint.x, _previousPoint.y, 0, 0);
    } else if (self.type == CGTDrawTypeNormal) {
        for (NSInteger i = self.drawLayers.count - 1; i >= 0; i--) {
            CGTDrawModel *model = self.drawLayers[i];
            if (model.type == CGTDrawTypeImage) {
                CGRect modelRect = [model getLayerRect];
                if (CGRectContainsPoint(modelRect, _previousPoint)) {
                    [model.drawLayer drawBorderRectLines:[model getLayerRect]];
                    // 更新当前选中的layer下标
                    self.currentIndex = i;
                    break;
                }

            }
        }
        
        // 清空剩下图片的选中状态
        for (NSInteger i = self.drawLayers.count - 1; i >= 0; i--) {
            CGTDrawModel *model = self.drawLayers[i];
            if (model.type == CGTDrawTypeImage) {
                if (i != self.currentIndex) {
                    [model.drawLayer drawBorderRectLines:CGRectZero];
                }
            }
        }
    } else if (self.type == CGTDrawTypeText) {
        // 先将全部已存在的textview全部删除，添加文本layer
        if (self.textView.string.length > 0) {
            NSString *string = self.textView.string;
            CGTDrawLayer *layer = [CGTDrawLayer layerWithFrame:self.bounds strokeColor:[NSColor redColor] lineWidth:1.f];
            [self.layer addSublayer:layer];
            self.currentIndex = self.drawLayers.count;

            CGTDrawModel *model = [[CGTDrawModel alloc] init];
            model.drawLayer = layer;
            model.type = self.type;
            model.startPoint = self.textView.frame.origin;
            model.endPoint = NSMakePoint(NSMinX(self.textView.frame) + NSWidth(self.textView.frame), NSMinY(self.textView.frame) + NSHeight(self.textView.frame));
            model.textStr = string;
            [self.drawLayers addObject:model];
            
            // 在model中保存string字段，文本的绘制暂时需要在drawRect:中执行
//            NSRect rect = [model getLayerRect];
//            [layer drawTextInRect:rect string:string];
            [self setNeedsDisplayInRect:self.frame];
            
            [self.textView removeFromSuperview];
            self.textView.string = @"";
        } else {
            NSTextView *textView = [[NSTextView alloc] initWithFrame:NSMakeRect(_previousPoint.x, _previousPoint.y - 100, 100, 100)];
            [textView setFont:[NSFont systemFontOfSize:12.f]];
            [textView setTextColor:[NSColor redColor]];
            [textView setBackgroundColor:[NSColor blueColor]];
            [self addSubview:textView];
            self.textView = textView;
            
            [self.window makeFirstResponder:textView];
        }
    }
}

- (void)mouseEntered:(NSEvent *)event {
    
}

- (void)mouseExited:(NSEvent *)event {
    
}

- (void)mouseMoved:(NSEvent *)event {
    CGPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
    
    if (self.type == CGTDrawTypeText) {
        return;
    }
    
    CGTDrawModel *model = [self.drawLayers objectAtIndex:self.currentIndex];
    if (CGRectContainsPoint([model getLayerTopRightRect], point) || CGRectContainsPoint([model getLayerBottomLeftRect], point)) {
        NSCursor *cursor = [[NSCursor alloc] initWithImage:[NSImage imageNamed:@"缩放2"] hotSpot:NSMakePoint(16, 16)];
        [cursor set];
    } else if (CGRectContainsPoint([model getLayerTopLeftRect], point) || CGRectContainsPoint([model getLayerBottomRightRect], point)) {
        NSCursor *cursor = [[NSCursor alloc] initWithImage:[NSImage imageNamed:@"缩放"] hotSpot:NSMakePoint(16, 16)];
        [cursor set];
    }
    
}

- (void)mouseDragged:(NSEvent *)event {
    _currentPoint = [self convertPoint:[event locationInWindow] fromView:nil];

    if (self.type == CGTDrawTypeCurveLine || self.type == CGTDrawTypeDirectDash || self.type == CGTDrawTypeDirectLine || self.type == CGTDrawTypeArrowDirectLine || self.type == CGTDrawTypeRect || self.type == CGTDrawTypeEllipse) {
        // 画线
        CGTDrawModel *model = [self.drawLayers objectAtIndex:self.currentIndex];
        if (self.type == CGTDrawTypeCurveLine) {
            [model.drawLayer drawCurveFromPoint:_previousPoint toPoint:_currentPoint];
            // 更新model中的startPoint和endPoint
            CGFloat minX = MIN(model.startPoint.x, _previousPoint.x);
            CGFloat minY = MIN(model.startPoint.y, _previousPoint.y);
            model.startPoint = NSMakePoint(minX, minY);
            CGFloat maxX = MAX(MAX(_currentPoint.x, _previousPoint.x), model.endPoint.x);
            CGFloat maxY = MAX(MAX(_currentPoint.y, _previousPoint.y), model.endPoint.y);
            NSLog(@"maxX:%f, maxY:%f", maxX, maxY);
            model.endPoint = NSMakePoint(maxX, maxY);
            _previousPoint = _currentPoint;
        } else if (self.type == CGTDrawTypeDirectDash) {
            [model.drawLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:10], nil]];
            [model.drawLayer drawDireLineFromPoint:_previousPoint toPoint:_currentPoint];
        } else if (self.type == CGTDrawTypeDirectLine) {
            [model.drawLayer drawDireLineFromPoint:_previousPoint toPoint:_currentPoint];
        } else if (self.type == CGTDrawTypeArrowDirectLine) {
            [model.drawLayer drawArrowDireLineFromPoint:_previousPoint toPoint:_currentPoint];
        } else if (self.type == CGTDrawTypeRect) {
            NSRect rect = NSMakeRect(_previousPoint.x, _previousPoint.y, _currentPoint.x - _previousPoint.x, _currentPoint.y - _previousPoint.y);
            [model.drawLayer drawRectLines:rect];
        } else if (self.type == CGTDrawTypeEllipse) {
            NSRect rect = NSMakeRect(_previousPoint.x, _previousPoint.y, _currentPoint.x - _previousPoint.x, _currentPoint.y - _previousPoint.y);
            [model.drawLayer drawEllipseInRect:rect];
        }
    } else if (self.type == CGTDrawTypeEraser) {
        // 橡皮擦
        CGTDrawModel *eraserModel = [self.drawLayers objectAtIndex:self.currentIndex];
        eraserModel.endPoint = _currentPoint;
        for (int i = 0; i < self.drawLayers.count; i++) {
            CGTDrawModel *model = self.drawLayers[i];
            
            if (model.type == CGTDrawTypeEraser) {
                // 橡皮擦区域排除
                continue;
            }
            
            if (CGRectContainsRect([eraserModel getLayerRect], [model getLayerRect])) {
//                NSLog(@"1111");
                [model.drawLayer drawBorderRectLines:[model getLayerRect]];
            } else {
                [model.drawLayer drawBorderRectLines:CGRectZero];
            }
        }
        [eraserModel.drawLayer drawRectLines:[eraserModel getLayerRect]];
//        [self setNeedsDisplay:YES];
    } else if (self.type == CGTDrawTypeNormal) {
        // 普通状态下
        if (self.drawLayers.count == 0) {
            return;
        }
        CGTDrawModel *model = self.drawLayers[self.currentIndex];
        if (model.type != CGTDrawTypeImage) {
            return;
        }
        if (CGRectContainsPoint([model getLayerTopRightRect], _currentPoint)) {
            CGFloat minOffset = MIN(_currentPoint.x - model.endPoint.x, _currentPoint.y - model.endPoint.y);
            model.endPoint = NSMakePoint(model.endPoint.x + minOffset, model.endPoint.y + minOffset);
        } else if (CGRectContainsPoint([model getLayerBottomRightRect], _currentPoint)) {
            CGFloat minOffset = MIN(_currentPoint.x - model.endPoint.x, _currentPoint.y - model.startPoint.y);
            model.startPoint = NSMakePoint(model.startPoint.x, model.startPoint.y + minOffset);
            model.endPoint = NSMakePoint(model.endPoint.x + minOffset, model.endPoint.y);
        } else if (CGRectContainsPoint([model getLayerBottomLeftRect], _currentPoint)) {
            CGFloat minOffset = MIN(_currentPoint.x - model.startPoint.x, _currentPoint.y - model.startPoint.y);
            model.startPoint = NSMakePoint(model.startPoint.x + minOffset, model.startPoint.y + minOffset);
        } else if (CGRectContainsPoint([model getLayerTopLeftRect], _currentPoint)) {
            CGFloat minOffset = MIN(_currentPoint.x - model.startPoint.x, _currentPoint.y - model.endPoint.y);
            model.startPoint = NSMakePoint(model.startPoint.x + minOffset, model.startPoint.y);
            model.endPoint = NSMakePoint(model.endPoint.x, model.endPoint.y + minOffset);
        } else {
            // 拖动图片
            CGFloat offsetX = _currentPoint.x - _previousPoint.x;
            CGFloat offsetY = _currentPoint.y - _previousPoint.y;
            model.startPoint = NSMakePoint(model.startPoint.x + offsetX, model.startPoint.y + offsetY);
            model.endPoint = NSMakePoint(model.endPoint.x + offsetX, model.endPoint.y + offsetY);
        }
        
        [model.drawLayer resetImageRect:[model getLayerRect]];
        [model.drawLayer drawBorderRectLines:[model getLayerRect]];
        _previousPoint = _currentPoint;

    }
}

- (void)mouseUp:(NSEvent *)event {
    // 更新model内容
    
    if (self.type == CGTDrawTypeDirectDash || self.type == CGTDrawTypeDirectLine || self.type == CGTDrawTypeArrowDirectLine || self.type == CGTDrawTypeRect || self.type == CGTDrawTypeEllipse) {
        CGTDrawModel *model = [self.drawLayers objectAtIndex:self.currentIndex];
        model.endPoint = [self convertPoint:[event locationInWindow] fromView:nil];
    } else if (self.type == CGTDrawTypeEraser) {
        CGTDrawModel *eraserModel = [self.drawLayers objectAtIndex:self.currentIndex];
        NSMutableArray *removeModels = [NSMutableArray array];
        for (int i = 0; i < self.drawLayers.count; i++) {
            CGTDrawModel *model = self.drawLayers[i];
            CGRect modelRect = [model getLayerRect];
            if (CGRectContainsRect([eraserModel getLayerRect], modelRect)) {
                [model.drawLayer removeFromSuperlayer];
                [removeModels addObject:model];
            }
        }
        
        [self.drawLayers removeObjectsInArray:removeModels];
        [eraserModel.drawLayer removeFromSuperlayer];
        [self.drawLayers removeObject:eraserModel];
        self.currentIndex = self.drawLayers.count;
//        [self setNeedsDisplay:YES];
    }
    
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

#pragma mark - Override
- (void)resetCursorRects {
    [super resetCursorRects];
}

@end
