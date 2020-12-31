//
//  NSTextField+Tip.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/12/15.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "NSTextField+Tip.h"

@implementation NSTextField (Tip)

- (void)addTips {
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.frame options:NSTrackingMouseEnteredAndExited | NSTrackingActiveWhenFirstResponder owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)event {
    
    NSString *text = self.stringValue;
    CGSize size = [text boundingRectWithSize:NSMakeSize(CGFLOAT_MAX, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font}].size;
    NSTextField *tipLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(NSMinX(self.frame) - (size.width / 2 - NSWidth(self.frame)), NSMaxY(self.frame), size.width, size.height)];
    tipLabel.usesSingleLineMode = YES;
    tipLabel.drawsBackground = YES;
    tipLabel.backgroundColor = [NSColor clearColor];
    tipLabel.textColor = [NSColor whiteColor];
    tipLabel.stringValue = self.stringValue;
    tipLabel.font = self.font;
    
    [self.superview addSubview:tipLabel];
}

- (void)mouseExited:(NSEvent *)event {
    
}

@end
