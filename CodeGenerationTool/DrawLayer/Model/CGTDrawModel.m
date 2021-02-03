//
//  CGTDrawModel.m
//  CodeGenerationTool
//
//  Created by mac on 2021/1/29.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTDrawModel.h"

@implementation CGTDrawModel

- (CGRect)getLayerRect {
    return NSMakeRect(self.startPoint.x, self.startPoint.y, self.endPoint.x - self.startPoint.x, self.endPoint.y - self.startPoint.y);
}

- (CGRect)getLayerTopLeftRect {
    CGRect modelRect = [self getLayerRect];
    return NSMakeRect(NSMinX(modelRect) - 1, NSMaxY(modelRect) - 1, 2, 2);
}

- (CGRect)getLayerTopRightRect {
    CGRect modelRect = [self getLayerRect];
    return NSMakeRect(NSMaxX(modelRect) - 1, NSMaxY(modelRect) - 1, 2, 2);
}

- (CGRect)getLayerBottomLeftRect {
    CGRect modelRect = [self getLayerRect];
    return NSMakeRect(NSMinX(modelRect) - 1, NSMinY(modelRect) - 1, 2, 2);
}

- (CGRect)getLayerBottomRightRect {
    CGRect modelRect = [self getLayerRect];
    return NSMakeRect(NSMaxX(modelRect) - 1, NSMinY(modelRect) - 1, 2, 2);
}

@end
