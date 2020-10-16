//
//  CustomButton.m
//  Training
//
//  Created by mac on 2020/10/16.
//  Copyright © 2020 Gensee Inc. All rights reserved.
//

#import "CGTCustomButton.h"

@interface CGTCustomButton() {
    NSColor *_textColor;
    NSTextAlignment _alignment;
}

@end

@implementation CGTCustomButton

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _backgroundColor = [NSColor colorWithRed:56.0/256 green:59.0/256 blue:66.0/256 alpha:1.0];
    _shadowOffset = CGSizeZero;
    _cornerRadius = 1.f;
    _borderColor = [NSColor colorWithRed:91./256 green:92./256 blue:99./256 alpha:1.];
    _borderWidth = 1.f;
    
    [self setTextColor:[NSColor whiteColor] alignment:NSTextAlignmentLeft];
}

- (void)setTextString:(NSString *)textString {
    [self setTitle:[[NSAttributedString alloc] initWithString:textString] color:_textColor font:[self font].pointSize alignment:_alignment];
}

- (void)setTextColor:(NSColor *)textColor alignment:(NSTextAlignment)alignment {
    [self setTitle:[self attributedTitle] color:textColor font:[self font].pointSize alignment:alignment];
}

- (void)setTitle:(NSAttributedString *)title color:(NSColor *)textColor font:(CGFloat)fontsize alignment:(NSTextAlignment)alignment {
    _textColor = textColor;
    _alignment = alignment;
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithAttributedString:title];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = alignment;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:textColor
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:fontsize]
                      range:range];
    
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
    attrTitle = nil;
    [self setNeedsDisplay:YES];
}

/**
 绘制方法由updateLayer替换
 */
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
}

- (BOOL)wantsUpdateLayer {
    return YES;
}

- (void)updateLayer {
    //changed to the width or height of a single source pixel centered at the specified location.
    self.layer.contentsCenter = CGRectMake(0.5, 0.5, 0, 0);
    //setImage
    self.layer.backgroundColor = _backgroundColor.CGColor;
    self.layer.cornerRadius = _cornerRadius;
    self.layer.borderWidth = _borderWidth;
    self.layer.borderColor = _borderColor.CGColor;
    self.layer.shadowColor = _backgroundColor.CGColor;
    if (!CGSizeEqualToSize(CGSizeZero, _shadowOffset)) {
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(1, 2);
        self.layer.shadowRadius = 6.f;
        self.layer.shadowOpacity = 1;
    }
}

@end
