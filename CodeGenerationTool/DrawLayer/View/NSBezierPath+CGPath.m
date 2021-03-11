//
//  NSBezierPath+CGPath.m
//  CodeGenerationTool
//
//  Created by mac on 2021/3/11.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "NSBezierPath+CGPath.h"

@implementation NSBezierPath (CGPath)

- (CGPathRef)CGPath {
    // Need to begin a path here.
    CGPathRef immutablePath =NULL;
    // Then draw the path elements.
    NSInteger numElements = [self elementCount];
    if (numElements > 0) {
        CGMutablePathRef path =CGPathCreateMutable();
        NSPoint points[3];
        for (NSInteger i = 0; i < numElements; i++) {
            switch ([self elementAtIndex:i associatedPoints:points]) {
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path,NULL, points[0].x, points[0].y);
                    break;
                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path,NULL, points[0].x, points[0].y);
                    break;
                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path,NULL, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y);
                    break;
                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
                    break;
            }
        }
        immutablePath =CGPathCreateCopy(path);
        CGPathRelease(path);
    }
    return immutablePath;

}

@end
