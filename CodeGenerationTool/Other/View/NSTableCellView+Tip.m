//
//  NSTableCellView+Tip.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/12/15.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "NSTableCellView+Tip.h"

@implementation NSTableCellView (Tip)

- (void)addTips {
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.frame options:NSTrackingMouseEnteredAndExited | NSTrackingActiveWhenFirstResponder owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];

}

- (void)mouseEntered:(NSEvent *)event {
    
}

- (void)mouseExited:(NSEvent *)event {
    
}

@end
