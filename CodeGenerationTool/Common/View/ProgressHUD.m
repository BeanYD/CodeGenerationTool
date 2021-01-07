//
//  OfflineView.m
//  Miniclass
//
//  Created by mac on 2020/12/18.
//  Copyright © 2020 Gensee Inc. All rights reserved.
//

#import "ProgressHUD.h"
#import <QuartzCore/CoreAnimation.h>

@interface ProgressHUD () {
    NSView *_parentView;
}

@end

@implementation ProgressHUD

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithParentView:(NSView *)parentView message:(NSString *)message topTitle:(NSString *)topTitle {
    if (self = [super initWithFrame:parentView.bounds]) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor;
        [self addSubviews];
        [self transformImage];
        self.textLabel.hidden = message.length == 0;
        self.topView.hidden = topTitle.length == 0;
        self.textLabel.stringValue = message;
        
        NSTextField *label = [self.topView subviews][1];
        label.stringValue = NSLocalizedString(@"网络不可用，请检查网络设置", nil);
        [parentView addSubview:self];
        _parentView = parentView;
    }
    
    return self;
}

+ (instancetype)HUDWithParentView:(NSView *)parentView {
    return [[ProgressHUD alloc] initWithParentView:parentView message:@"" topTitle:@""];
}

+ (instancetype)HUDWithParentView:(NSView *)parentView message:(NSString *)message {
    return [[ProgressHUD alloc] initWithParentView:parentView message:message topTitle:@""];
}

+ (instancetype)HUDWithParentView:(NSView *)parentView message:(NSString *)message topTitle:(NSString *)topTitle {
    return [[ProgressHUD alloc] initWithParentView:parentView message:message topTitle:topTitle];
}

- (void)hideProgressHUD {
    [self.imageView.layer removeAllAnimations];
    [self removeFromSuperview];
}

- (void)addSubviews {
    [self addSubview:self.imageView];
    [self addSubview:self.textLabel];
    [self addSubview:self.topView];
}

- (void)mouseDown:(NSEvent *)event {

}

- (void)mouseUp:(NSEvent *)event {
    
}

- (void)mouseMoved:(NSEvent *)event {

}

- (void)mouseEntered:(NSEvent *)event {

}

- (void)mouseExited:(NSEvent *)event {

}

- (void)updateFrame {
    CGRect frame = _parentView.frame;
    self.frame = frame;
    
    frame = self.imageView.frame;
    frame.origin.x = (NSWidth(self.frame) - 40) / 2;
    frame.origin.y = (NSHeight(self.frame) - 40) / 2 + 50;
    self.imageView.frame = frame;
    
    frame = self.textLabel.frame;
    frame.origin.x = (NSWidth(self.frame) - 300) / 2;
    frame.origin.y = NSMidY(self.imageView.frame) - 60;
    self.textLabel.frame = frame;
    
    frame = self.topView.frame;
    frame.origin.x = (NSWidth(self.frame) - 230) / 2;
    frame.origin.y = NSHeight(self.frame) - 40;
    self.topView.frame = frame;
    
    [self.imageView.layer removeAllAnimations];
    [self transformImage];
}

- (void)transformImage{
    NSImageView *transImage = self.imageView;
    // 防止低版本兼容性问题，无论上层是否wantsLayer，需要动画的View都需要添加wantsLayer
    transImage.wantsLayer = YES;
    NSRect oldFrame = transImage.layer.frame;
    transImage.layer.anchorPoint = CGPointMake(0.5, 0.5);
    transImage.layer.frame = oldFrame;
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.removedOnCompletion = FALSE;
    rotate.fillMode = kCAFillModeForwards;

    //Do a series of 5 quarter turns for a total of a 1.25 turns
    //(2PI is a full turn,so pi/2 is a quarter turn)
    [rotate setToValue:[NSNumber numberWithFloat: -M_PI]];
    rotate.repeatCount = CGFLOAT_MAX;
    rotate.duration = 0.5;
    rotate.beginTime = 0;
    rotate.cumulative = TRUE;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [transImage.layer addAnimation:rotate forKey:@"rotateAnimation"];
}

#pragma mark - Getter
- (NSImageView *)imageView {
    if (!_imageView) {
        _imageView = [[NSImageView alloc] initWithFrame:NSMakeRect((NSWidth(self.frame) - 40) / 2, (NSHeight(self.frame) - 40) / 2 + 50, 40, 40)];
        _imageView.image = [NSImage imageNamed:@"加载"];
    }
    
    return _imageView;
}

- (NSTextField *)textLabel {
    if (!_textLabel) {
        _textLabel = [[NSTextField alloc] initWithFrame:NSMakeRect((NSWidth(self.frame) - 300) / 2, NSMidY(self.imageView.frame) - 60, 300, 20)];
        _textLabel.editable = NO;
        _textLabel.bordered = NO;
        _textLabel.drawsBackground = YES;
        _textLabel.backgroundColor = [NSColor clearColor];
        _textLabel.font = [NSFont systemFontOfSize:16.];
        _textLabel.alignment = NSTextAlignmentCenter;
        _textLabel.usesSingleLineMode = YES;
        _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _textLabel.textColor = [NSColor whiteColor];
    }
    
    return _textLabel;
}

- (NSView *)topView {
    if (!_topView) {
        _topView = [[NSView alloc] initWithFrame:NSMakeRect((NSWidth(self.frame) - 230) / 2, NSHeight(self.frame) - 40, 230, 40)];
        _topView.wantsLayer = YES;
        _topView.layer.cornerRadius = 2.f;
        _topView.layer.backgroundColor = [NSColor colorWithRed:255./256 green:89./256 blue:91./256 alpha:1.f].CGColor;
        
        NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(26, (NSHeight(_topView.frame) - 15) / 2, 15, 15)];
        imageView.image = [NSImage imageNamed:@"离线"];
        [_topView addSubview:imageView];
        
        NSTextField *label = [[NSTextField alloc] initWithFrame:NSMakeRect(NSMaxX(imageView.frame) + 5, (NSHeight(_topView.frame) - 16) / 2, NSWidth(_topView.frame) - NSMaxX(imageView.frame) - 10, 16)];
        label.editable = NO;
        label.bordered = NO;
        label.drawsBackground = YES;
        label.backgroundColor = [NSColor clearColor];
        label.font = [NSFont systemFontOfSize:12.];
        label.alignment = NSTextAlignmentLeft;
        label.usesSingleLineMode = YES;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.textColor = [NSColor whiteColor];
        [_topView addSubview:label];
    }
    
    return _topView;
}

@end
