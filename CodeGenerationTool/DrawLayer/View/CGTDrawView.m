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

@property (strong) NSTrackingArea *trackingArea;

@property (strong) NSCursor *currentCursor;

// 拉伸图片
@property (assign) BOOL isScaleRightB;
@property (assign) BOOL isScaleRightT;
@property (assign) BOOL isScaleLeftB;
@property (assign) BOOL isScaleLeftT;
@property (assign) NSPoint lastLocation;
@property (assign) NSRect selectRect;

@property (assign) NSInteger testI;

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

}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        
        self.wantsLayer = YES;
        self.layer.borderColor = [NSColor redColor].CGColor;
        self.layer.borderWidth = 1.f;
        self.drawLayers = [NSMutableArray array];
        NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow | NSTrackingMouseMoved) owner:self userInfo:@{}];
        [self addTrackingArea:trackingArea];
        self.trackingArea = trackingArea;
        
        self.currentIndex = -1;
        
//        CGTDrawLayer *layer = [CGTDrawLayer layerWithFrame:self.bounds strokeColor:[NSColor clearColor] lineWidth:30];
//        [layer setBezierCurveStartPoint:NSMakePoint(100, 100)];
////        [layer drawBezierCurveFromPoint:NSMakePoint(100, 100) toPoint:NSMakePoint(150, 100)];
//        [layer drawBezierCurveStrokeFromPoint:NSMakePoint(100, 100) toPoint:NSMakePoint(150, 100)];
//        [self.layer addSublayer:layer];
    }
    
    return self;
}

// view的bounds发生变动时，需要更新trackingArea的bounds，否则部分事件响应区域有问题
- (void)resetTrackingArea {
    [self removeTrackingArea:self.trackingArea];
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow owner:self userInfo:@{}];
    [self addTrackingArea:trackingArea];
    self.trackingArea = trackingArea;
}

- (void)resetCursor {
    [self removeCursorRect:self.bounds cursor:self.currentCursor];
    if (self.type == CGTDrawTypeCurveLine) {
        NSCursor *cursor =[[NSCursor alloc]initWithImage:[NSImage imageNamed:@"anno_pen_solid"] hotSpot:NSMakePoint(0, 22)];
        self.currentCursor = cursor;
        [self addCursorRect:[self bounds] cursor:cursor];
        [cursor set];
        NSLog(@"=============anno_pen_solid");
    } else if (self.type == CGTDrawTypeEraser) {
        NSCursor *cursor =[[NSCursor alloc]initWithImage:[NSImage imageNamed:@"anno_eraser"] hotSpot:NSMakePoint(0, 22)];
        self.currentCursor = cursor;
        [self addCursorRect:[self bounds] cursor:cursor];
        [cursor set];
        NSLog(@"=============anno_eraser");
    } else {
        NSCursor *cursor = [NSCursor arrowCursor];
        self.currentCursor = cursor;
        [self addCursorRect:[self bounds] cursor:cursor];
        [cursor set];
    }
}

- (void)loadImage:(NSImage *)image {
    CGTDrawLayer *drawLayer = [CGTDrawLayer layerWithFrame:self.bounds strokeColor:[NSColor blueColor] lineWidth:1.f];
    [self.layer addSublayer:drawLayer];
    CGTDrawModel *model = [[CGTDrawModel alloc] init];
    model.drawLayer = drawLayer;
    model.type = self.type;
    model.startPoint = NSMakePoint(10, 10);
    model.endPoint = NSMakePoint(model.startPoint.x + image.size.width, model.startPoint.y  + image.size.height);
    [drawLayer drawImage:image rect:NSMakeRect(model.startPoint.x, model.startPoint.y, image.size.width, image.size.height)];
    self.currentIndex = self.drawLayers.count;

    [self.drawLayers addObject:model];
}

- (void)mouseDown:(NSEvent *)event {
    _previousPoint = [self convertPoint:[event locationInWindow] fromView:nil];

//    drawLayer.backgroundColor = [NSColor redColor].CGColor;
    if (self.type == CGTDrawTypeCurveLine || self.type == CGTDrawTypeDirectDash || self.type == CGTDrawTypeDirectLine || self.type == CGTDrawTypeEraser || self.type == CGTDrawTypeArrowDirectLine || self.type == CGTDrawTypeRect || self.type == CGTDrawTypeEllipse) {
        CGTDrawLayer *drawLayer = [CGTDrawLayer layerWithFrame:self.bounds strokeColor:[NSColor redColor] lineWidth:2.0f];
            if (self.type == CGTDrawTypeEraser) {
            // 有透明度方面修改，修改color的alpha值
            drawLayer.strokeColor = [NSColor redColor].CGColor;
            drawLayer.lineWidth = 2.0f;
        } else {
            drawLayer.strokeColor = [NSColor blueColor].CGColor;
            drawLayer.lineWidth = self.lineWidth;
        }

        [self.layer addSublayer:drawLayer];

        self.currentIndex = self.drawLayers.count;
        CGTDrawModel *model = [[CGTDrawModel alloc] init];
        model.drawLayer = drawLayer;
        model.type = self.type;
        model.startPoint = _previousPoint;
        [self.drawLayers addObject:model];
        if (self.type == CGTDrawTypeCurveLine) {
            [model.drawLayer setBezierCurveStartPoint:_previousPoint];
            model.startPoint = NSMakePoint(_previousPoint.x - self.lineWidth / 2, _previousPoint.y - self.lineWidth / 2);
            model.endPoint = NSMakePoint(_previousPoint.x + self.lineWidth / 2, _previousPoint.y + self.lineWidth / 2);
        } else if (self.type == CGTDrawTypeDirectDash) {
//            [model.drawLayer drawDireLineFromPoint:NSMakePoint(_previousPoint.x, _previousPoint.y) toPoint:NSMakePoint(_previousPoint.x + 100 + _testI, _previousPoint.y)];
            [model.drawLayer setLineDashPattern:@[@(10), @(10)]];
//            _testI++;
        }
//    } else if (self.type == CGTDrawTypeEraser) {
//        self.eraserRect = NSMakeRect(_previousPoint.x, _previousPoint.y, 0, 0);
    } else if (self.type == CGTDrawTypeNormal) {
        CGTDrawModel *drawModel = nil;
        for (NSInteger i = self.drawLayers.count - 1; i >= 0; i--) {
            CGTDrawModel *model = self.drawLayers[i];
            if (model.type == CGTDrawTypeImage) {
                NSRect rect = [model getLayerRect];
                CGRect selectRect = [model getSelectRect];
                if (CGRectContainsPoint(selectRect, _previousPoint)) {
                    [model.drawLayer focusImageRect:rect];
                    // 更新当前选中的layer下标
                    drawModel = model;
                    self.currentIndex = i;
                    break;
                }

            }
        }
        
        if (drawModel) {
            // 清空剩下图片的选中状态
            for (NSInteger i = self.drawLayers.count - 1; i >= 0; i--) {
                CGTDrawModel *model = self.drawLayers[i];
                if (model.type == CGTDrawTypeImage) {
                    if (i != self.currentIndex) {
                        [model.drawLayer focusImageRect:CGRectZero];
                    }
                }
            }
            // 判断是否在图片边框区域
            NSRect leftTopRect = [drawModel getLayerTopLeftRect];
            NSRect rightBottomRect = [drawModel getLayerBottomRightRect];
            NSRect leftBottomRect = [drawModel getLayerBottomLeftRect];
            NSRect rightTopRect = [drawModel getLayerTopRightRect];
            _lastLocation = [self convertPoint:[event locationInWindow] fromView:nil];
            _selectRect = [drawModel getLayerRect];
            if (CGRectContainsPoint(rightTopRect, _previousPoint)) {
                _isScaleRightT = YES;
            }
            if (CGRectContainsPoint(leftTopRect, _previousPoint)) {
                _isScaleLeftT = YES;
            }
            if (CGRectContainsPoint(rightBottomRect, _previousPoint)) {
                _isScaleRightB = YES;
            }
            if (CGRectContainsPoint(leftBottomRect, _previousPoint)) {
                _isScaleLeftB = YES;
            }
            
        } else {
            // 清空所有图片选中状态
            for (NSInteger i = self.drawLayers.count - 1; i >= 0; i--) {
                CGTDrawModel *model = self.drawLayers[i];
                if (model.type == CGTDrawTypeImage) {
                    [model.drawLayer focusImageRect:CGRectZero];
                }
            }
            self.currentIndex = -1;
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
            NSRect rect = [model getLayerRect];
            NSDictionary *attrDict = @{NSFontAttributeName : [NSFont systemFontOfSize:12.f], NSForegroundColorAttributeName : [NSColor redColor]};
            [layer drawTextInRect:rect string:string dict:attrDict];
//            [self setNeedsDisplayInRect:self.frame];

            [self clearTextView];
        } else {
            [self clearTextView];
            
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

- (void)clearTextView {
    if (self.textView) {
        [self.textView removeFromSuperview];
        self.textView = nil;
    }
}

- (void)mouseEntered:(NSEvent *)event {
    
}

- (void)mouseExited:(NSEvent *)event {
    
}

- (void)mouseMoved:(NSEvent *)event {
    CGPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
    
    if (self.drawLayers.count == 0) {
        return;
    }
    
    if (self.currentIndex < 0) {
        return;
    }
    
    if (self.type == CGTDrawTypeNormal) {
        CGTDrawModel *model = [self.drawLayers objectAtIndex:self.currentIndex];
        if (model.type == CGTDrawTypeImage) {
            NSCursor *cursor = [NSCursor arrowCursor];
            if (CGRectContainsPoint([model getLayerTopRightRect], point) || CGRectContainsPoint([model getLayerBottomLeftRect], point)) {
                cursor = [[NSCursor alloc] initWithImage:[NSImage imageNamed:@"缩放2"] hotSpot:NSMakePoint(16, 16)];
            } else if (CGRectContainsPoint([model getLayerTopLeftRect], point) || CGRectContainsPoint([model getLayerBottomRightRect], point)) {
                cursor = [[NSCursor alloc] initWithImage:[NSImage imageNamed:@"缩放"] hotSpot:NSMakePoint(16, 16)];
            }
            [self addCursorRect:self.bounds cursor:cursor];
            [cursor set];

        }
    }
}

- (void)mouseDragged:(NSEvent *)event {
    _currentPoint = [self convertPoint:[event locationInWindow] fromView:nil];
    if (self.type == CGTDrawTypeCurveLine || self.type == CGTDrawTypeDirectDash || self.type == CGTDrawTypeDirectLine || self.type == CGTDrawTypeArrowDirectLine || self.type == CGTDrawTypeRect || self.type == CGTDrawTypeEllipse) {
        // 画线
        CGTDrawModel *model = [self.drawLayers objectAtIndex:self.currentIndex];
        if (self.type == CGTDrawTypeCurveLine) {
//            [model.drawLayer drawCurveFromPoint:_previousPoint toPoint:_currentPoint];
            
            CGFloat length = sqrt((_currentPoint.x - _previousPoint.x) * (_currentPoint.x - _previousPoint.x) + (_currentPoint.y - _previousPoint.y) * (_currentPoint.y - _previousPoint.y));
            if (length < 3.0) {
                // 标注优化，小于3的，不进行绘制
                return;
            }
            [model.drawLayer drawBezierCurveFromPoint:_previousPoint toPoint:_currentPoint];
            // 更新model中的startPoint和endPoint
            CGFloat minX = MIN(model.startPoint.x, _previousPoint.x);
            CGFloat minY = MIN(model.startPoint.y, _previousPoint.y);
            model.startPoint = NSMakePoint(minX, minY);
            CGFloat maxX = MAX(MAX(_currentPoint.x, _previousPoint.x), model.endPoint.x);
            CGFloat maxY = MAX(MAX(_currentPoint.y, _previousPoint.y), model.endPoint.y);
            model.endPoint = NSMakePoint(maxX, maxY);
            model.previousPoint = _previousPoint;
            _previousPoint = _currentPoint;
        } else if (self.type == CGTDrawTypeDirectDash) {
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
                // 通过手动记录startPoint和endPoint获得
                CGRect rect = [model getLayerRect];
                
                // 通过CGPath实现的标注，可以通过以下方法获得边框rect
//                rect = CGPathGetPathBoundingBox(model.drawLayer.path);
                
                [model.drawLayer drawBorderRect:rect];
                
                
            } else {
                [model.drawLayer drawBorderRect:CGRectZero];
            }
        }
        [eraserModel.drawLayer drawRectLines:[eraserModel getLayerRect]];
//        [self setNeedsDisplay:YES];
    } else if (self.type == CGTDrawTypeNormal) {
        // 普通状态下
        if (self.drawLayers.count == 0) {
            return;
        }
        
        if (self.currentIndex < 0) {
            return;
        }
        
        CGTDrawModel *model = self.drawLayers[self.currentIndex];
        if (model.type != CGTDrawTypeImage) {
            return;
        }
        
        
        if (_isScaleRightB || _isScaleRightT) {
            // 计算右侧拖动
            
        } else if (_isScaleLeftB || _isScaleLeftT) {
            // 计算左侧拖动
            
        } else {
            // 拖动
            CGFloat offsetX = _currentPoint.x - _previousPoint.x;
            CGFloat offsetY = _currentPoint.y - _previousPoint.y;
            model.startPoint = NSMakePoint(model.startPoint.x + offsetX, model.startPoint.y + offsetY);
            model.endPoint = NSMakePoint(model.endPoint.x + offsetX, model.endPoint.y + offsetY);
        }
        
        
        [model.drawLayer resetImageRect:[model getLayerRect]];
        [model.drawLayer focusImageRect:[model getLayerRect]];
        _previousPoint = _currentPoint;

    }
}

- (void)mouseUp:(NSEvent *)event {
    _currentPoint = [self convertPoint:[event locationInWindow] fromView:nil];

    // 更新model内容
    if (self.type == CGTDrawTypeCurveLine) {
        if (self.isStroke) {
            CGTDrawModel *model = [self.drawLayers objectAtIndex:self.currentIndex];
            // 尾部添加笔锋
            if (model.previousPoint.x == 0 && model.previousPoint.y == 0) {
                return;
            }
            CGPoint endPoint = NSMakePoint(_currentPoint.x + (_currentPoint.x - model.previousPoint.x), _currentPoint.y + (_currentPoint.y - model.previousPoint.y));
            [model.drawLayer drawBezierCurveStrokeFromPoint:_previousPoint toPoint:endPoint];
            
            CGFloat minX = MIN(model.startPoint.x, endPoint.x);
            CGFloat minY = MIN(model.startPoint.y, endPoint.y);
            model.startPoint = NSMakePoint(minX, minY);
            CGFloat maxX = MAX(endPoint.x, model.endPoint.x);
            CGFloat maxY = MAX(endPoint.y, model.endPoint.y);
            model.endPoint = NSMakePoint(maxX, maxY);
        }
                
    } else if (self.type == CGTDrawTypeDirectDash || self.type == CGTDrawTypeDirectLine || self.type == CGTDrawTypeArrowDirectLine || self.type == CGTDrawTypeRect || self.type == CGTDrawTypeEllipse) {
        CGTDrawModel *model = [self.drawLayers objectAtIndex:self.currentIndex];
        model.endPoint = _currentPoint;
    } else if (self.type == CGTDrawTypeEraser) {
        CGTDrawModel *eraserModel = [self.drawLayers objectAtIndex:self.currentIndex];
        eraserModel.endPoint = _currentPoint;
        NSRect eraserRect = [eraserModel getLayerRect];
        NSMutableArray *removeModels = [NSMutableArray array];
        for (int i = 0; i < self.drawLayers.count; i++) {
            CGTDrawModel *model = self.drawLayers[i];
            CGRect modelRect = [model getLayerRect];
            
            if (model.type == CGTDrawTypeEraser) {
                continue;
            }
            
            if (NSWidth(eraserRect) == 0 && NSHeight(eraserRect) == 0) {
                // 单击删除
//                NSRect rect = CGPathGetBoundingBox(model.drawLayer.path);
//                NSLog(@"rect");
            }
            
            if (CGRectContainsRect([eraserModel getLayerRect], modelRect)) {
                [model.drawLayer removeFromSuperlayer];
                [removeModels addObject:model];
            }
        }
        
        [self.drawLayers removeObjectsInArray:removeModels];
        [eraserModel.drawLayer removeFromSuperlayer];
        [self.drawLayers removeObject:eraserModel];
        self.currentIndex = self.drawLayers.count - 1;
//        [self setNeedsDisplay:YES];
    } else if (self.type == CGTDrawTypeNormal) {
        _isScaleLeftT = NO;
        _isScaleLeftB = NO;
        _isScaleRightT = NO;
        _isScaleRightB = NO;
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

- (void)setFrame:(NSRect)frame {
    [super setFrame:frame];
    
    // 更新tracking内容
    [self resetTrackingArea];
    
    for (int i = 0; i < self.drawLayers.count; i++) {
        CGTDrawModel *model = self.drawLayers[i];
        model.drawLayer.bounds = self.bounds;
    }
}

@end
