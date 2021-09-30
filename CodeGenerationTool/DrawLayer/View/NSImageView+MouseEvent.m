//
//  NSImageView+MouseEvent.m
//  CodeGenerationTool
//
//  Created by mac on 2021/8/2.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "NSImageView+MouseEvent.h"

@implementation NSImageView (MouseEvent)

- (void)mouseDown:(NSEvent *)event {
    
    [super mouseDown:event];
//    NSLog(@"%s", __func__);
}

- (void)mouseDragged:(NSEvent *)event {
    
    [super mouseDragged:event];
    NSLog(@"%s, %@", __func__, event);
}
//
//- (NSView *)hitTest:(NSPoint)point {
//    NSLog(@"%s %@", __func__, NSStringFromPoint(point));
//
//    return [super hitTest:point];
//}

@end
