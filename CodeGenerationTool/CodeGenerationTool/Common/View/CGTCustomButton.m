//
//  CustomButton.m
//  Training
//
//  Created by mac on 2020/10/16.
//  Copyright © 2020 Gensee Inc. All rights reserved.
//

#import "CGTCustomButton.h"

NSString * const kTextColorKey = @"textColor";
NSString * const kFontKey = @"font";
NSString * const kBackgroundColorKey = @"backgroundColor";
NSString * const kBorderColorKey = @"borderColor";
NSString * const kBorderWidthKey = @"borderWidth";
NSString * const kCornerRadiusKey = @"cornerRadius";
NSString * const kShadowOffsetKey = @"shadowOffset";

@interface CGTCustomButton() {
    NSColor *_textColor;
    NSTextAlignment _alignment;
    NSFont *_font;
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
    _backgroundColor = [NSColor whiteColor];
    _shadowOffset = CGSizeZero;
    _cornerRadius = 0.f;
    _borderColor = [NSColor whiteColor];
    _borderWidth = 0.f;
    _alignment = NSTextAlignmentCenter;
    _textColor = [NSColor blackColor];
    
    [self setTitle:[self attributedTitle] textColor:_textColor font:self.font alignment:_alignment];
}

- (void)setTextString:(NSString *)textString {
    [self setTitle:[[NSAttributedString alloc] initWithString:textString] textColor:_textColor font:self.font alignment:_alignment];
}

- (void)setTextColor:(NSColor *)textColor alignment:(NSTextAlignment)alignment {
    [self setTitle:[self attributedTitle] textColor:textColor font:self.font alignment:alignment];
}

- (void)setTitle:(NSAttributedString *)title
       textColor:(NSColor *)textColor
            font:(NSFont *)font
       alignment:(NSTextAlignment)alignment {
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithAttributedString:title];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = alignment;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:textColor
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:font
                      range:range];
    
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
    attrTitle = nil;
    [self setNeedsDisplay:YES];
}

- (void)addAttributes:(NSDictionary *)attrs {
    if (attrs == nil || attrs.count == 0) {
        return;
    }
    if ([attrs valueForKey:kBorderWidthKey]) {
        _borderWidth = [[attrs valueForKey:kBorderWidthKey] floatValue];
    }
    if ([attrs valueForKey:kBorderColorKey]) {
        _borderColor = [attrs valueForKey:kBorderColorKey];
    }
    if ([attrs valueForKey:kTextColorKey]) {
        _textColor = [attrs valueForKey:kTextColorKey];
    }
    if ([attrs valueForKey:kFontKey]) {
        _font = [attrs valueForKey:kFontKey];
    }
    if ([attrs valueForKey:kBackgroundColorKey]) {
        _backgroundColor = [attrs valueForKey:kBackgroundColorKey];
    }
    if ([attrs valueForKey:kCornerRadiusKey]) {
        _cornerRadius = [[attrs valueForKey:kCornerRadiusKey] floatValue];
    }
    if ([attrs valueForKey:kShadowOffsetKey]) {
        _shadowOffset = [[attrs valueForKey:kShadowOffsetKey] sizeValue];
    }
    
    
}

#pragma mark - Rewrite Method

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
