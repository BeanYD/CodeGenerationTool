//
//  DrawLayer.h
//  CodeGenerationTool
//
//  Created by mac on 2021/1/26.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

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
    CGMutablePathRef _path;
}

// 不间断线
- (void)drawLineFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint;

// 直线(实线虚线由外部定义)
- (void)drawDireLineFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint;


@end

NS_ASSUME_NONNULL_END
