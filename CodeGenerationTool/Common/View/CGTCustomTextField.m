//
//  CustomTextField.m
//  Training
//
//  Created by mac on 2020/10/21.
//  Copyright © 2020 Gensee Inc. All rights reserved.
//

#import "CGTCustomTextField.h"

@interface CGTCustomTextField ()

@property (nonatomic, readonly) NSArray *hyperlinkInfos;
@property (nonatomic, readonly) NSTextView *textView;

- (void)_resetHyperlinkCursorRects;

@end

#define kHyperlinkInfoCharacterRangeKey @"range"
#define kHyperlinkInfoURLKey            @"url"
#define kHyperlinkInfoRectKey           @"rect"

@implementation CGTCustomTextField

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)_hyperlinkTextFieldInit {
    self.editable = NO;
    self.selectable = NO;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self _hyperlinkTextFieldInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self _hyperlinkTextFieldInit];
    }
    
    return self;
}

- (void)resetCursorRects {
    [super resetCursorRects];
    [self _resetHyperlinkCursorRects];
}

- (void)_resetHyperlinkCursorRects {
    for (NSDictionary *info in self.hyperlinkInfos) {
        [self addCursorRect:[[info objectForKey:kHyperlinkInfoRectKey] rectValue] cursor:[NSCursor pointingHandCursor]];
    }
}

#pragma mark - Accessors
- (NSArray *)hyperlinkInfos {
    NSMutableArray *hyperlinkInfos = [[NSMutableArray alloc] init];
    NSRange stringRange = NSMakeRange(0, [self.attributedStringValue length]);
    __block NSTextView *textView = self.textView;
    [self.attributedStringValue enumerateAttribute:NSLinkAttributeName inRange:stringRange options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value) {
            NSUInteger rectCount = 0;
            NSRectArray rectArray = [textView.layoutManager rectArrayForCharacterRange:range withinSelectedCharacterRange:range inTextContainer:textView.textContainer rectCount:&rectCount];
            for (NSUInteger i = 0; i < rectCount; i++) {
                [hyperlinkInfos addObject:@{kHyperlinkInfoCharacterRangeKey : [NSValue valueWithRange:range], kHyperlinkInfoURLKey : value, kHyperlinkInfoRectKey : [NSValue valueWithRect:rectArray[i]]}];
            }
        }
    }];
    
    return hyperlinkInfos;
}

- (NSTextView *)textView {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedStringValue];
    NSFont *font = [attributedString attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    
    if (!font) {
        [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedString.length)];
    }
    
    NSRect textViewFrame = [self.cell titleRectForBounds:self.bounds];
    NSTextView *textView = [[NSTextView alloc] initWithFrame:textViewFrame];
    [textView.textStorage setAttributedString:attributedString];
    
    return textView;
}

#pragma mark - Mouse Events
- (void)mouseUp:(NSEvent *)event {
    NSTextView *textView = self.textView;
    NSPoint localPoint = [self convertPoint:[event locationInWindow] fromView:nil];
    NSUInteger index = [textView.layoutManager characterIndexForPoint:localPoint inTextContainer:textView.textContainer fractionOfDistanceBetweenInsertionPoints:NULL];
    if (index != NSNotFound) {
        for (NSDictionary *info in self.hyperlinkInfos) {
            NSRange range = [[info objectForKey:kHyperlinkInfoCharacterRangeKey] rangeValue];;
            if (NSLocationInRange(index, range)) {
                NSURL *url = [info objectForKey:kHyperlinkInfoURLKey];
                
                if ([self.delegate respondsToSelector:@selector(hyperlinkToUrl:)]) {
                    [self.delegate hyperlinkToUrl:url];
                }
            }
        }
    }
}

@end
