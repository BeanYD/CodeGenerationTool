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
#import "CGTSGFFileReader.h"
#import "CGTSGFNode.h"

#import "CGTWeiQiCTest.h"

@interface CGTWeiQiBoardView () {
    CGTWeiQiModelLayer *_model;
    NSArray *_chessmans;
    BOOL _isWhite;
    CGTChessmanBean *_robBean;  // 记录打劫位置，接下来的对手的一步无法下棋
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
        _isWhite = NO;
        
        [[CGTWeiQiCTest new] testDemo];
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

- (void)clearChessmans {
    NSArray *pressBeans = [_model.pressedDict allValues];
    for (int i = 0; i < pressBeans.count; i++) {
        CGTChessmanBean *bean = pressBeans[i];
        [bean.chessmanView removeFromSuperview];
    }
    
    [_model.pressedDict removeAllObjects];
    
}

- (void)loadSgfFileContent:(NSString *)content {
    
    [self clearChessmans];
    
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    CGTSGFNode *rootNode = [CGTSGFFileReader readGameTree:content];
    
    NSDictionary *basicDict = [CGTSGFFileReader readBasicChessmanContent:rootNode.nodeStr];
    _model.basicDict = basicDict;
    
    NSArray *blackArray = [basicDict valueForKey:@"AB"];
    for (int i = 0; i < blackArray.count; i++) {
        NSPoint point = NSPointFromString(blackArray[i]);
        CGTChessmanBean *currentBean = [CGTChessmanBean chessmanBeanWithPosition:point isWhite:NO];
        
        NSImageView *chessView = [[NSImageView alloc] initWithFrame:[_model getChessViewRectWithChessmanLocation:point]];
        chessView.wantsLayer = YES;
        chessView.image = [NSImage imageNamed:@"black_chess"];
        [self addSubview:chessView];
        currentBean.chessmanView = chessView;
        [_model.pressedDict setValue:currentBean forKey:NSStringFromPoint(point)];
    }
    NSArray *whiteArray = [basicDict valueForKey:@"AW"];
    for (int i = 0; i < whiteArray.count; i++) {
        NSPoint point = NSPointFromString(whiteArray[i]);
        CGTChessmanBean *currentBean = [CGTChessmanBean chessmanBeanWithPosition:point isWhite:YES];
        
        NSImageView *chessView = [[NSImageView alloc] initWithFrame:[_model getChessViewRectWithChessmanLocation:point]];
        chessView.wantsLayer = YES;
        chessView.image = [NSImage imageNamed:@"white_chess"];
        [self addSubview:chessView];
        currentBean.chessmanView = chessView;
        [_model.pressedDict setValue:currentBean forKey:NSStringFromPoint(point)];
    }
    
    // 判断下一手是黑还是白
    if (rootNode.subNodes.count > 0) {
        CGTSGFNode *subNode = [rootNode.subNodes firstObject];
        if ([[subNode.nodeStr substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"W"]) {
            // 白色
            _isWhite = YES;
        } else if ([[subNode.nodeStr substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"B"]) {
            // 黑色
            _isWhite = NO;
        }
    }
    
    // TODO: 添加棋谱下一手路径
    
}

- (void)addAWChessmanWithString:(NSString *)content {
    NSArray *awArray = [self getStrContainDataWithStr:content start:@"AW\\[" end:@"\\]"];
    for (int i = 0; i < awArray.count; i++) {
        NSTextCheckingResult *res = awArray[i];
        NSLog(@"%@, %@", NSStringFromRange(res.range), [content substringWithRange:res.range]);
    }
}

- (void)addABChessmanWithString:(NSString *)content {
    
}

- (void)addWhiteChessmanWithString:(NSString *)content {
    NSArray *array = [self getStrContainDataWithStr:content start:@";W\\[" end:@"\\]"];
    
    for (int i = 0; i < array.count; i++) {
        NSTextCheckingResult *res = array[i];
//        NSLog(@"%@, %@", NSStringFromRange(res.range), [content substringWithRange:res.range]);
        
        NSString *sub = [content substringWithRange:res.range];
        NSString *xStr = [sub substringWithRange:NSMakeRange(3, 1)];
        NSString *yStr = [sub substringWithRange:NSMakeRange(4, 1)];
        
        // 获取白子位置
        NSArray *allLetters = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
        
        NSPoint point = NSMakePoint([allLetters indexOfObject:xStr] + 1, [allLetters indexOfObject:yStr] + 1);
        NSLog(@"point:%@", NSStringFromPoint(point));
        
        CGTChessmanBean *currentBean = [CGTChessmanBean chessmanBeanWithPosition:point isWhite:YES];
        
        NSImageView *chessView = [[NSImageView alloc] initWithFrame:[_model getChessViewRectWithChessmanLocation:point]];
        chessView.wantsLayer = YES;
        chessView.image = [NSImage imageNamed:@"white_chess"];
        [self addSubview:chessView];
        currentBean.chessmanView = chessView;
        [_model.pressedDict setValue:currentBean forKey:NSStringFromPoint(point)];
    }
}

- (NSArray *)getStrContainDataWithStr:(NSString *)str start:(NSString *)start end:(NSString *)end {
    NSString *pattern = [NSString stringWithFormat:@"%@(.*?)%@", start, end];
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regular matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
    return results;
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
    CGTChessmanBean *chessBean = [_model.pressedDict valueForKey:NSStringFromPoint(chessPoint)];
    if (chessBean) {
        return;
    }
    
    BOOL isWhite = NO;
    if (_model.isAuto) {
        isWhite = _isWhite;
    } else {
        isWhite = _model.isWhite;
    }
    
    CGTChessmanBean *currentBean = [CGTChessmanBean chessmanBeanWithPosition:chessPoint isWhite:isWhite];
    NSRect chessRect = [_model getChessmanRectWithPoint:location];
    NSImageView *chessView = [[NSImageView alloc] initWithFrame:chessRect];
    chessView.wantsLayer = YES;
    
    if (_model.isAuto) {
        _isWhite = !_isWhite;
    }
    chessView.image = isWhite ? [NSImage imageNamed:@"white_chess"] : [NSImage imageNamed:@"black_chess"];
    [self addSubview:chessView];
    
    currentBean.chessmanView = chessView;
    
    [_model.pressedDict setValue:currentBean forKey:NSStringFromPoint(chessPoint)];
    
    // 先判断周围是否有异色子可以吃，有，则可以下；无则无法下
    NSSet *areaRemoveSet = [_model areaDifferentColorBreacheWithChessman:currentBean];
    BOOL isRobbed = NO;
    if (areaRemoveSet.count > 0) {
        NSArray *areaRemoveArray = areaRemoveSet.allObjects;

        // 如果符合打劫条件，记录打劫棋子
        NSSet *sameRemoveSet = [_model sameColorBreatheWithChessman:currentBean];
        if (areaRemoveSet.count == 1 && sameRemoveSet.count == 1) {
            // 情况为打劫，判断上一次是否为打劫
            if (_robBean && CGPointEqualToPoint(_robBean.position, currentBean.position)) {
                NSLog(@"形成打劫，先下其他位置棋子");
                [currentBean.chessmanView removeFromSuperview];
                [_model.pressedDict removeObjectForKey:NSStringFromPoint(chessPoint)];
                return;
            } else {
                NSPoint location = NSPointFromString([areaRemoveArray lastObject]);
                _robBean = [CGTChessmanBean chessmanBeanWithPosition:location isWhite:!currentBean.isWhite];
                isRobbed = YES;
            }
        }
        
        for (int i = 0; i < areaRemoveArray.count; i++) {
            NSPoint location = NSPointFromString(areaRemoveArray[i]);
            CGTChessmanBean *removeBean = [_model.pressedDict valueForKey:NSStringFromPoint(location)];
            [removeBean.chessmanView removeFromSuperview];
            [_model.pressedDict removeObjectForKey:NSStringFromPoint(location)];
        }
    }
    
    if (!isRobbed) {
        _robBean = nil;
    }
    
    // 无异色子可吃，无法下
    NSSet *removeSet = [_model sameColorBreatheWithChessman:currentBean];
    if (removeSet.count > 0) {
        NSArray *removeArray = removeSet.allObjects;
        for (int i = 0; i < removeArray.count; i++) {
            NSPoint location = NSPointFromString(removeArray[i]);
            CGTChessmanBean *removeBean = [_model.pressedDict valueForKey:NSStringFromPoint(location)];
            [removeBean.chessmanView removeFromSuperview];
            [_model.pressedDict removeObjectForKey:NSStringFromPoint(location)];
        }
    }
    
//    if (![_model enablePressWithChessman:currentBean]) {
//        NSLog(@"没有气，无法落子");
//        return;
//    }

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
