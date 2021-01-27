//
//  CustomDrawingTools.h
//  Education
//
//  Created by iOS-Dev1 on 14-4-14.
//  Copyright (c) 2014年 iOS-Dev1. All rights reserved.
//

@protocol ACEDrawingTool <NSObject>

@property (strong) NSColor *lineColor;
@property (assign) CGFloat lineWidth;
@property (assign) CGFloat lineAlpha;

- (void)draw;
@optional
- (void)setInitialPoint:(NSPoint)firstPoint;
- (void)moveFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint;

@end

#pragma mark - DrawingPenTools
@interface DrawingPenTools : NSBezierPath<ACEDrawingTool>{
    CGMutablePathRef path;
}
@property (assign) NSPoint startPoint;
@property (assign) NSPoint endPoint;
@end

#pragma mark - DrawingWordTool
@interface DrawingWordTool : NSObject<ACEDrawingTool>
@property (copy) NSString* drawStr;
@property (assign) NSRect drawRect;
@property (retain) NSFont* font;

@end

#pragma mark - DrawingLineTool
@interface DrawingLineTool : NSObject<ACEDrawingTool>
@property (assign) NSPoint startPoint;
@property (assign) NSPoint endPoint;

@end

#pragma mark - DrawingRectangleTool
@interface DrawingRectangleTool : NSObject<ACEDrawingTool>

@property (assign) NSRect rectangle;

@end

#pragma mark - DrawingArrowLineTool
@interface DrawingArrowLineTool : NSObject<ACEDrawingTool>
@property (assign) NSPoint startPoint;
@property (assign) NSPoint endPoint;

@end

#pragma mark - DrawingLinedashTool
@interface DrawingLinedashTool : NSObject<ACEDrawingTool>
@property (assign) NSPoint startPoint;
@property (assign) NSPoint endPoint;

@end

#pragma mark - DrawingEllipseInRectangleTool
@interface DrawingEllipseInRectangleTool : NSObject<ACEDrawingTool>

@property (assign) NSRect rectangle;

@end

#pragma mark - DrawingImageTool
@interface DrawingImageTool : NSObject<ACEDrawingTool>
@property (strong) NSImage *image;
@property (assign) NSRect rectangle;
@property (assign) BOOL isSelect;
@property (strong) NSString *downloadURL;
- (void)moveFromPoint:(NSPoint)startPoint toPoint:(NSPoint)endPoint;
@end
