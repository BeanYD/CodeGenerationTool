//
//  CGTDrawModel.m
//  CodeGenerationTool
//
//  Created by mac on 2021/1/29.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTDrawModel.h"

#define BORDER_RECT_WIDTH 10

@implementation CGTDrawModel

- (CGRect)getLayerRect {
    CGRect rect = NSMakeRect(self.startPoint.x, self.startPoint.y, self.endPoint.x - self.startPoint.x, self.endPoint.y - self.startPoint.y);
    
    NSLog(@"oriX:%f, oriY:%f, width:%f, height:%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    return rect;
}

- (CGRect)getSelectRect {
    CGRect rect = NSMakeRect(self.startPoint.x - BORDER_RECT_WIDTH / 2, self.startPoint.y - BORDER_RECT_WIDTH / 2, self.endPoint.x - self.startPoint.x + BORDER_RECT_WIDTH, self.endPoint.y - self.startPoint.y + BORDER_RECT_WIDTH);
    return  rect;
}

- (CGRect)getLayerTopLeftRect {
    CGRect modelRect = [self getLayerRect];
    return NSMakeRect(NSMinX(modelRect) - BORDER_RECT_WIDTH / 2, NSMaxY(modelRect) - BORDER_RECT_WIDTH / 2, BORDER_RECT_WIDTH, BORDER_RECT_WIDTH);
}

- (CGRect)getLayerTopRightRect {
    CGRect modelRect = [self getLayerRect];
    return NSMakeRect(NSMaxX(modelRect) - BORDER_RECT_WIDTH / 2, NSMaxY(modelRect) - BORDER_RECT_WIDTH / 2, BORDER_RECT_WIDTH, BORDER_RECT_WIDTH);
}

- (CGRect)getLayerBottomLeftRect {
    CGRect modelRect = [self getLayerRect];
    return NSMakeRect(NSMinX(modelRect) - BORDER_RECT_WIDTH / 2, NSMinY(modelRect) - BORDER_RECT_WIDTH / 2, BORDER_RECT_WIDTH, BORDER_RECT_WIDTH);
}

- (CGRect)getLayerBottomRightRect {
    CGRect modelRect = [self getLayerRect];
    return NSMakeRect(NSMaxX(modelRect) - BORDER_RECT_WIDTH / 2, NSMinY(modelRect) - BORDER_RECT_WIDTH / 2, BORDER_RECT_WIDTH, BORDER_RECT_WIDTH);
}
@end
