//
//  DrawLayer.h
//  CodeGenerationTool
//
//  Created by mac on 2021/1/26.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CGTDrawHeader.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ACEDrawingDelegate <NSObject>

@property (strong) NSColor *lineColor;
@property (assign) CGFloat lineWidth;
@property (assign) CGFloat lineAlpha;

- (void)draw;

@optional
- (void)setInitialPoint:(NSPoint)firstPoint;
- (void)moveFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint;

@end

/**
 * CGContextSetFlatness              设置弯曲的路径中的图形上下文的准确性。
 * CGContextSetInterpolationQuality  设置图形上下文的插值质量水平。
 * CGContextSetLineCap               图形环境中的画线的端点的样式设置。
 * CGContextSetLineDash              设置图形上下文中的虚线的模式。
 * CGContextSetLineJoin              设置图像上下文中的接接线的样式。
 * CGContextSetLineWidth             设置图像上下文中的线的宽度。
 * CGContextSetMiterLimit            设置图像上下文中的连接线的斜接限制。
 * CGContextSetPatternPhase          设置一个上下文的段落模式。
 * CGContextSetFillPattern           在指定的图形上下文设置的填充图案模式。
 * CGContextSetRenderingIntent       在当前图形状态设置渲染意向。
 * CGContextSetShouldAntialias       设置图形上下文的抗锯齿开启或关闭。
 * CGContextSetStrokePattern         在指定的图形上下文设置描边图案。
 */

@interface CGTDrawLayer : CAShapeLayer {
    CGMutablePathRef _path;     // 画连续线条的path
    NSBezierPath *_bezierPath;        // 使用贝塞尔画线
    CGRect _borderRect;         // 显示线条所在区域边框的rect
}

+ (CGTDrawLayer *)layerWithFrame:(CGRect)frame strokeColor:(NSColor *)strokeColor lineWidth:(CGFloat)lineWidth;

// 连续线条
// 方式1-粗线条下，保证曲线弧度完整
- (void)setBezierCurveStartPoint:(NSPoint)startPoint;
- (void)drawBezierCurveFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint;
// 方式2-直线方式绘制，没有弧度，曲线的弧度容易消失
- (void)drawCurveFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint;

// 直线(实线虚线由外部定义)
- (void)drawDireLineFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint;

// 箭头直线
- (void)drawArrowDireLineFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint;

// 画边框(包含橡皮和标注框)
- (void)drawRectLines:(CGRect)rect;

// 画椭圆
- (void)drawEllipseInRect:(CGRect)rect;

// 画文本
- (void)drawTextInRect:(CGRect)rect string:(NSString *)drawStr dict:(NSDictionary *)attrDic;

// 画边框(选中和删除标记框)
- (void)drawBorderRect:(CGRect)rect;
//- (void)drawBorderRectLines:(CGRect)rect;

// 画图
- (void)drawImage:(NSImage *)image rect:(CGRect)rect;
- (void)resetImageRect:(CGRect)rect;
- (void)focusImageRect:(CGRect)rect;


@end

NS_ASSUME_NONNULL_END
