//
//  CGTWeiQiBoardView.m
//  CodeGenerationTool
//
//  Created by mac on 2021/9/26.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTWeiQiBoardView.h"
#import <QuartzCore/QuartzCore.h>
#import "CGTWeiQiModelLayer.h"
#import "CGTChessmanBean.h"

@interface CGTWeiQiBoardView () {
    CGTWeiQiModelLayer *_model;
    NSArray *_chessmans;
}

@property (strong) NSCursor *currentCursor;

@end

@implementation CGTWeiQiBoardView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        
        self.wantsLayer = YES;
    }
    
    return self;
}

- (void)loadModelLayer:(id)modelLayer {
    _model = modelLayer;
    
    self.layer.backgroundColor = _model.boardColor.CGColor;
    [self drawBoardWithModel:_model];
}

- (void)drawBoardWithModel:(CGTWeiQiModelLayer *)model {
    
    if (self.layer.sublayers.count > 0) {
        // 更新棋盘样式
        for (int i = 0; i < self.layer.sublayers.count; i++) {
            CALayer *layer = self.layer.sublayers[i];
            if ([[layer class] isMemberOfClass:[CAShapeLayer class]]) {
                [layer removeFromSuperlayer];
            }
        }
    }
    
    int lineNum = model.lineNum;
    CGFloat lineWidth = model.lineWidth;
    
    CAShapeLayer *boardLayer = [[CAShapeLayer alloc] init];
    boardLayer.frame = self.bounds;
    boardLayer.fillColor = [NSColor clearColor].CGColor;
    boardLayer.strokeColor = model.lineColor.CGColor;
    boardLayer.lineWidth = lineWidth;
    boardLayer.strokeStart = 0;
    boardLayer.strokeEnd = 1;
    
    [self.layer addSublayer:boardLayer];
    
    // 计算单元格边长:假设19*19的棋盘，边缘位置留出2个格子大小的位置，即20等分
    // 非正方形取小边
    
    CGFloat boardWidth = model.boardWidth;
    CGFloat minWidth = MIN(NSWidth(self.frame), NSHeight(self.frame));
    if (boardWidth > minWidth) {
        boardWidth = minWidth;
        model.boardWidth = minWidth;
    }
    
    CGFloat cellWidth = (boardWidth - model.spaceWidth * 2) / (lineNum - 1);
    CGFloat horizontalStart = (NSWidth(self.frame) - boardWidth) / 2 + model.spaceWidth;
    CGFloat verticalStart = (NSHeight(self.frame) - boardWidth) / 2 + model.spaceWidth;
    
    model.spaceWidth = cellWidth;
    model.startPoint = NSMakePoint(horizontalStart, verticalStart);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    // 水平方向画线
    for (int i = 0; i < lineNum; i++) {
        CGPathMoveToPoint(path, NULL, horizontalStart, verticalStart + cellWidth * i);
        CGPathAddLineToPoint(path, NULL, NSWidth(self.frame) - horizontalStart, verticalStart + cellWidth * i);
        
        // 行数提示文字layer
        CATextLayer *lineTextLayer = [[CATextLayer alloc] init];
        lineTextLayer.frame = NSMakeRect(horizontalStart - cellWidth, verticalStart - 10 + cellWidth * i, cellWidth - 10, 20);
        lineTextLayer.string = [CGTWeiQiModelLayer getEnglishCharacterIn19WithNum:(19 - i)];
        lineTextLayer.fontSize = 20;
        lineTextLayer.foregroundColor = model.hVTextColor.CGColor;
        lineTextLayer.truncationMode = kCATruncationEnd;
        lineTextLayer.alignmentMode = kCAAlignmentRight;
        
        [boardLayer addSublayer:lineTextLayer];
    }
    
    // 竖直方向画线
    for (int i = 0; i < lineNum; i++) {
        CGPathMoveToPoint(path, NULL, horizontalStart + cellWidth * i, verticalStart);
        CGPathAddLineToPoint(path, NULL, horizontalStart + cellWidth * i, NSHeight(self.frame) - verticalStart);
        
        // 列数提示文字layer
        CATextLayer *lineTextLayer = [[CATextLayer alloc] init];
        lineTextLayer.frame = NSMakeRect(horizontalStart - 15 + cellWidth * i, NSHeight(self.frame) - verticalStart + 10, 30, 20);
        lineTextLayer.string = [NSString stringWithFormat:@"%d", i + 1];
        lineTextLayer.fontSize = 20;
        lineTextLayer.foregroundColor = model.hVTextColor.CGColor;
        lineTextLayer.truncationMode = kCATruncationMiddle;
        lineTextLayer.alignmentMode = kCAAlignmentCenter;
        
        [boardLayer addSublayer:lineTextLayer];
    }
    
    // 天元和星的位置
    if (lineNum == 19) {
        // 位置下标
        NSArray *stars = [CGTWeiQiModelLayer getStarsFrom19x19];
        CGFloat r = lineWidth * 2;
        
        for (int i = 0; i < stars.count; i++) {
            NSPoint star = NSPointFromString(stars[i]);
            CAShapeLayer *starLayer = [self starLayerWithPosition:NSMakePoint(horizontalStart + cellWidth * (star.x - 1), verticalStart + cellWidth * (star.y - 1)) starRadius:r];
            [boardLayer addSublayer:starLayer];
        }
    }
    
    boardLayer.path = path;
    
    // 获取棋盘所有棋子位置信息
    _chessmans = [model chessmansInBoard];
}

- (CAShapeLayer *)starLayerWithPosition:(NSPoint)point starRadius:(CGFloat)r {
    CAShapeLayer *starLayer = [[CAShapeLayer alloc] init];
    starLayer.frame = self.bounds;
    starLayer.fillColor = _model.starColor.CGColor;
    starLayer.strokeStart = 0.f;
    starLayer.strokeEnd = 1.f;
    starLayer.lineWidth = r;
    
    CGMutablePathRef starPath = CGPathCreateMutable();
    CGPathMoveToPoint(starPath, NULL, point.x, point.y);
    CGPathAddEllipseInRect(starPath, NULL, NSMakeRect(point.x - r, point.y - r, r * 2, r * 2));
    starLayer.path = starPath;
    
    return starLayer;
}

- (void)mouseDown:(NSEvent *)event {
    NSPoint location = [self convertPoint:event.locationInWindow fromView:nil];
    
    CGFloat cellWidth = (_model.boardWidth - _model.spaceWidth * 2) / (_model.lineNum - 1);
    CGFloat pressX = (_model.boardWidth - cellWidth * _model.lineNum) / 2;
    NSRect pressRect = NSMakeRect(pressX + (NSWidth(self.frame) - _model.boardWidth) / 2, pressX + (NSHeight(self.frame) - _model.boardWidth) / 2, _model.lineNum * cellWidth, _model.lineNum * cellWidth);
    if (!CGRectContainsPoint(pressRect, location)) {
        return;
    }
    
    NSPoint chessPoint = [_model getChessmanLocationWithPoint:location];
    for (int i = 0; i < _model.pressedArray.count; i++) {
        CGTChessmanBean *chessmanModel = _model.pressedArray[i];
        NSPoint pressedPoint = chessmanModel.position;
        if (NSEqualPoints(chessPoint, pressedPoint)) {
            return;
        }
    }
    
    BOOL isWhite = NO;
    if (_model.isAuto) {
        int tmpStep = _model.step + 1;
        isWhite = tmpStep % 2 != 1;
    } else {
        isWhite = _model.isWhite;
    }
    
    CGTChessmanBean *currentBean = [CGTChessmanBean chessmanBeanWithPosition:chessPoint isWhite:isWhite];
    if (![_model enablePressWithChessman:currentBean]) {
        NSLog(@"没有气，无法落子");
        return;
    }

    NSRect chessRect = [_model getChessmanRectWithPoint:location];
    NSImageView *chessView = [[NSImageView alloc] initWithFrame:chessRect];
    chessView.wantsLayer = YES;
    
    if (_model.isAuto) {
        _model.step++;
    }
    chessView.image = isWhite ? [NSImage imageNamed:@"black_chess"] : [NSImage imageNamed:@"white_chess"];
    [self addSubview:chessView];
    
    [_model.pressedArray addObject:currentBean];

    //    [self resetCursor];
}

- (void)resetCursor {
    [self removeCursorRect:self.bounds cursor:self.currentCursor];
    
    if (_model.step % 2 == 1) {
        self.currentCursor = [[NSCursor alloc] initWithImage:[NSImage imageNamed:@"white_chess"] hotSpot:NSMakePoint(0, 22)];
    } else {
        self.currentCursor = [[NSCursor alloc] initWithImage:[NSImage imageNamed:@"black_chess"] hotSpot:NSMakePoint(0, 22)];
    }
    [self addCursorRect:self.bounds cursor:self.currentCursor];
    [self.currentCursor set];

}

- (void)resetCursorRects {
    [super resetCursorRects];
}



@end
